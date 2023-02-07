import 'dart:developer';

import 'package:caro_game/core/constrant.dart';
import 'package:caro_game/core/global_value.dart';
import 'package:caro_game/src/domain/model/device_model.dart';
import 'package:caro_game/src/domain/model/game_argument.dart';
import 'package:caro_game/src/presentation/view/game/game_view.dart';
import 'package:caro_game/src/presentation/view/home/child_widget/invite_play_dialog.dart';
import 'package:caro_game/src/presentation/view/home/child_widget/receive_connect_req_widget.dart';
import 'package:caro_game/src/presentation/view/home/home_view.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nearby_connections/nearby_connections.dart';

class HomeController extends GetxController {
  final String username = Get.arguments;
  final Strategy strategy = Strategy.P2P_CLUSTER;
  final RxList<DeviceModel> deviceFound = <DeviceModel>[].obs;
  final Nearby nearby = Nearby();
  @override
  void onInit() {
    super.onInit();
    _startAdvertising();
    _discovery();
  }

  @override
  void onClose() {
    stopAdvertising();
    stopDiscovery();
    disConnectAll();
    super.onClose();
  }

  Future<void> _startAdvertising() async {
    await nearby.startAdvertising(
      username,
      strategy,
      onConnectionInitiated: _onConnectionInitiated,
      onConnectionResult: (endpointId, status) {
        for (int i = 0; i < deviceFound.length; ++i) {
          if (deviceFound[i].id == endpointId) {
            deviceFound[i].status = status;
            deviceFound[i].connecting = false;

            if (status != Status.CONNECTED && Get.isBottomSheetOpen == true) {
              Get.back(result: false);
              Get.snackbar(
                'Disconnect',
                '${deviceFound[i].name} rejected connect with you',
                backgroundColor: Get.theme.colorScheme.error,
                colorText: Get.theme.colorScheme.onError,
              );
            }
            deviceFound.refresh();
            break;
          }
        }
      },
      onDisconnected: (endpointId) {
        if (GlobalValue.partnerDisconnect.value == endpointId) {
          GlobalValue.partnerDisconnect.refresh();
        } else {
          GlobalValue.partnerDisconnect.value = endpointId;
        }
        for (int i = 0; i < deviceFound.length; ++i) {
          if (deviceFound[i].id == endpointId) {
            deviceFound[i].connectionInfo = null;
            deviceFound.refresh();
            break;
          }
        }
      },
      serviceId: Constant.packageName,
    );
  }

  void stopAdvertising() => nearby.stopAdvertising();

  void _onConnectionInitiated(endpointId, connectionInfo) {
    Get.bottomSheet(
      ReceiveConnectReqWidget(
        id: endpointId,
        info: connectionInfo,
        onAccept: () {
          _acceptConnection(endpointId);
          for (int i = 0; i < deviceFound.length; ++i) {
            if (deviceFound[i].id == endpointId) {
              deviceFound[i].connectionInfo = connectionInfo;
              deviceFound.refresh();
              break;
            }
          }
        },
        onReject: () => _rejectConnection(endpointId),
      ),
      backgroundColor: Get.theme.colorScheme.background,
    ).then((value) {
      if (value == null) _rejectConnection(endpointId);
    });
  }

  void _discovery() {
    nearby.startDiscovery(
      username,
      strategy,
      onEndpointFound: (endpointId, endpointName, serviceId) {
        DeviceModel device = DeviceModel(endpointId, endpointName, serviceId, null);
        // deviceFound.removeWhere((element) => element.id == endpointId);
        deviceFound.add(device);
      },
      onEndpointLost: (endpointId) {
        deviceFound.removeWhere((element) => element.id == endpointId);
      },
      serviceId: Constant.packageName,
    );
  }

  void stopDiscovery() {
    nearby.stopDiscovery();
  }

  void _acceptConnection(String endpointId) => nearby.acceptConnection(
        endpointId,
        onPayLoadRecieved: (endpointId, payload) {
          if (payload.type == PayloadType.BYTES) {
            String data = String.fromCharCodes(payload.bytes!);
            log('[Receive message] $endpointId - $data');
            _handleMessage(endpointId, data);
          }
        },
        onPayloadTransferUpdate: (endpointId, payloadTransferUpdate) {
          switch (payloadTransferUpdate.status) {
            case PayloadStatus.SUCCESS:
              log('[onPayloadTransferUpdate] $endpointId - PayloadStatus SUCCESS');
              break;
            case PayloadStatus.FAILURE:
              log('[onPayloadTransferUpdate] $endpointId - PayloadStatus FAILURE');
              break;
            case PayloadStatus.IN_PROGRESS:
              log('[onPayloadTransferUpdate] $endpointId - PayloadStatus IN_PROGRESS');
              break;
            default:
              break;
          }
        },
      );

  void _handleMessage(String endpointId, String message) {
    switch (message) {
      case Constant.acceptPlayGameCode:
        if (GlobalValue.acceptInvitation.isTrue) {
          GlobalValue.acceptInvitation.refresh();
        } else {
          GlobalValue.acceptInvitation.call(true);
        }
        break;
      case Constant.denicePlayGameCode:
        if (GlobalValue.acceptInvitation.isFalse) {
          GlobalValue.acceptInvitation.refresh();
        } else {
          GlobalValue.acceptInvitation.call(false);
        }
        break;
      case Constant.exitRoom:
        GlobalValue.partnerExitRoomAction.refresh();
        break;
      case Constant.rematch:
        GlobalValue.partnerRequestRematch.refresh();
        break;
      default:
        if (message.contains(':')) {
          GlobalValue.messageReceive.call(message);
        }

        if (message.contains(Constant.startGameCode)) {
          int size = int.parse(message.split(Constant.startGameCode).last);
          Get.dialog(
            InvitePlayDialog(
              device: deviceFound.where((p0) => p0.id == endpointId).first,
              mapSize: size,
              onPlay: (device) {
                sendMessage(device, Constant.acceptPlayGameCode);
                Get.until((route) => Get.currentRoute == HomeView.routeName);
                Get.toNamed(
                  GameView.routeName,
                  arguments: GameArgument(device, true, size),
                );
              },
              onDenice: (device) {
                sendMessage(device, Constant.denicePlayGameCode);
              },
            ),
          );
        }
    }
  }

  void _rejectConnection(String endpointId) => nearby.rejectConnection(endpointId);

  void disConnectAll() => nearby.stopAllEndpoints();

  void requestConnection(DeviceModel device) {
    for (int i = 0; i < deviceFound.length; ++i) {
      if (deviceFound[i].id == device.id) {
        deviceFound[i].connecting = true;
        deviceFound.refresh();
        break;
      }
    }
    nearby.requestConnection(
      username,
      device.id,
      onConnectionInitiated: _onConnectionInitiated,
      onConnectionResult: (endpointId, status) {
        for (int i = 0; i < deviceFound.length; ++i) {
          if (deviceFound[i].id == endpointId) {
            deviceFound[i].status = status;
            deviceFound[i].connecting = false;

            if (status != Status.CONNECTED && Get.isBottomSheetOpen == true) {
              Get.back(result: false);
              Get.snackbar(
                'Disconnect',
                '${deviceFound[i].name} rejected connect with you',
                backgroundColor: Get.theme.colorScheme.error,
                colorText: Get.theme.colorScheme.onError,
              );
            }
            deviceFound.refresh();
            break;
          }
        }
      },
      onDisconnected: (endpointId) {
        if (GlobalValue.partnerDisconnect.value == endpointId) {
          GlobalValue.partnerDisconnect.refresh();
        } else {
          GlobalValue.partnerDisconnect.value = endpointId;
        }
        for (int i = 0; i < deviceFound.length; ++i) {
          if (deviceFound[i].id == endpointId) {
            deviceFound[i].connectionInfo = null;
            deviceFound.refresh();
            break;
          }
        }
      },
    );
  }

  void stopEndpoint(DeviceModel device) {
    nearby.disconnectFromEndpoint(device.id);
    for (int i = 0; i < deviceFound.length; ++i) {
      if (deviceFound[i] == device) {
        deviceFound[i].connectionInfo = null;
        deviceFound.refresh();
        break;
      }
    }
  }

  void sendMessage(DeviceModel device, String message) {
    Uint8List bytes = Uint8List.fromList(message.codeUnits);
    nearby.sendBytesPayload(device.id, bytes);
  }
}
