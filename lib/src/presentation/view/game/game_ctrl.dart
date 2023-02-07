import 'dart:async';
import 'dart:typed_data';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:caro_game/core/assets.dart';
import 'package:caro_game/core/constrant.dart';
import 'package:caro_game/core/enum_value.dart';
import 'package:caro_game/core/global_value.dart';
import 'package:caro_game/src/domain/model/device_model.dart';
import 'package:caro_game/src/domain/model/game_argument.dart';
import 'package:caro_game/src/domain/model/point.dart';
import 'package:caro_game/src/infrastructure/get_storage/local_database.dart';
import 'package:caro_game/src/presentation/view/game/child_widget/opponent_disconnect_dialog.dart';
import 'package:caro_game/src/presentation/view/game/child_widget/opponent_exit_dialog.dart';
import 'package:caro_game/src/presentation/view/game/child_widget/reject_invitation_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nearby_connections/nearby_connections.dart';

class GameController extends GetxController {
  final ScrollController verticalController = ScrollController();
  final ScrollController horizontalController = ScrollController();
  final assetsAudioPlayer = AssetsAudioPlayer();
  final RxDouble musicVolume = 0.5.obs;
  final RxDouble soundEffect = 0.5.obs;
  final RxBool enableScroller = true.obs;

  late final DeviceModel device;
  bool isFromInvitation = false;
  final Nearby nearby = Nearby();

  final RxBool isWaitingInvitation = false.obs;
  late final int mapSize;
  late final int _maxStep;
  int _countStep = 0;
  final RxBool isWaitingOpponentStep = false.obs;

  bool partnerReadyForRematch = false;
  bool readyForRematch = false;
  late final RxList<List<CellValue>> mapData =
      List.generate(mapSize, (x) => List.generate(mapSize, (y) => CellValue.none)).obs;

  Rxn<Point> lastOpportunityMove = Rxn<Point>(null);

  Winner? winner;
  final RxBool showResult = false.obs;

  final RxInt yourScore = 0.obs;
  final RxInt partnerScore = 0.obs;

  StreamSubscription? _subscriptionExitRoomAction;
  StreamSubscription? _subscriptionDisconnect;
  StreamSubscription? _subscriptionMessageReceive;
  StreamSubscription? _subscriptionRequestRematch;
  StreamSubscription? _subscriptionAcceptInvitation;
  @override
  void onInit() {
    super.onInit();
    _handleArgument();
    _listenGlobalStream();
    _initGameSetting();
  }

  void _handleArgument() {
    final GameArgument gameArgument = Get.arguments;
    device = gameArgument.device;
    isFromInvitation = gameArgument.fromInvitation;

    mapSize = gameArgument.mapSize;
    _maxStep = mapSize * mapSize;

    if (!isFromInvitation) {
      _waitingAcceptInvitation();
    } else {
      isWaitingOpponentStep.call(true);
    }
  }

  void _listenGlobalStream() {
    _subscriptionExitRoomAction = GlobalValue.partnerExitRoomAction.stream.listen((event) {
      Get.dialog(
        OpponentExitDialog(opponentName: device.name),
        barrierDismissible: false,
      );
    });
    _subscriptionDisconnect = GlobalValue.partnerDisconnect.stream.listen((event) {
      if (event == device.id) {
        Get.dialog(
          OpponentDisconnectDialog(opponentName: device.name),
          barrierDismissible: false,
        );
      }
    });
    _subscriptionMessageReceive = GlobalValue.messageReceive.stream.listen((event) {
      ++_countStep;
      int coordinateX = int.parse(event.split(':')[0]);
      int coordinateY = int.parse(event.split(':')[1]);
      lastOpportunityMove.call(Point(coordinateX, coordinateY));
      mapData[coordinateX][coordinateY] = CellValue.oChar;
      mapData.refresh();
      _checkWinner(coordinateX, coordinateY, false);
      isWaitingOpponentStep.call(false);
      if (enableScroller.isTrue) {
        verticalController.animateTo(50.0 * (coordinateX) - Get.height / 3,
            duration: const Duration(milliseconds: 410), curve: Curves.ease);
        horizontalController.animateTo(50.0 * (coordinateY) - Get.width / 3,
            duration: const Duration(milliseconds: 410), curve: Curves.ease);
      }
      AssetsAudioPlayer.playAndForget(Audio(AudioAssets.tap01), volume: soundEffect.value);
    });
    _subscriptionRequestRematch = GlobalValue.partnerRequestRematch.listen((event) {
      Get.snackbar(
        'Rematch',
        '${device.name} is ready for the new game!',
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );
      if (!readyForRematch) {
        partnerReadyForRematch = true;
      } else {
        partnerReadyForRematch = false;
        readyForRematch = false;
      }
      isWaitingInvitation.call(false);
    });
  }

  void _initGameSetting() {
    musicVolume.call(Storage.instance.readDouble(Constant.stoMusicVolume) ?? 1);
    soundEffect.call(Storage.instance.readDouble(Constant.stoSoundEffect) ?? 1);
    enableScroller.call(Storage.instance.readBool(Constant.stoScrollMap) ?? true);
    assetsAudioPlayer.open(Audio(AudioAssets.background),
        volume: musicVolume.value, loopMode: LoopMode.single);
  }

  @override
  void onClose() {
    _subscriptionExitRoomAction?.cancel();
    _subscriptionExitRoomAction = null;
    _subscriptionDisconnect?.cancel();
    _subscriptionDisconnect = null;
    _subscriptionMessageReceive?.cancel();
    _subscriptionMessageReceive = null;
    _subscriptionRequestRematch?.cancel();
    _subscriptionRequestRematch = null;
    _subscriptionAcceptInvitation?.cancel();
    _subscriptionAcceptInvitation = null;
    assetsAudioPlayer.stop();
    assetsAudioPlayer.dispose();
    super.onClose();
  }

  void _waitingAcceptInvitation() {
    isWaitingInvitation.call(true);
    _subscriptionAcceptInvitation = GlobalValue.acceptInvitation.stream.listen((event) {
      isWaitingInvitation.call(false);
      if (!event) {
        Get.dialog(
          OpponentRejectInvitationDialog(opponentName: device.name),
          barrierDismissible: false,
        );
      }
    });
  }

  void sendData(String data) {
    final Uint8List bytes = Uint8List.fromList(data.codeUnits);
    nearby.sendBytesPayload(device.id, bytes);
  }

  void tickPosition(int coordinateX, coordinateY) {
    if (isWaitingOpponentStep.isTrue) return;
    if (winner != null) return;
    if (mapData[coordinateX][coordinateY] != CellValue.none) return;
    lastOpportunityMove.value = null;
    AssetsAudioPlayer.playAndForget(Audio(AudioAssets.tap02), volume: soundEffect.value);
    ++_countStep;
    mapData[coordinateX][coordinateY] = CellValue.xChar;
    mapData.refresh();

    sendData('$coordinateX:$coordinateY');
    isWaitingOpponentStep.call(true);
    _checkWinner(coordinateX, coordinateY, true);
  }

  void _checkWinner(int coordinateX, int coordinateY, bool isMyStep) {
    if (_countStep == _maxStep) {
      winner = Winner.draw;
      showResult.call(true);
    }
    bool result = false;
    result = _checkWinnerTLtoBR(coordinateX, coordinateY, isMyStep);
    if (result) _handleWinner(isMyStep);
    result = _checkWinnerBLtoTR(coordinateX, coordinateY, isMyStep);
    if (result) _handleWinner(isMyStep);
    result = _checkWinnerLtoR(coordinateX, coordinateY, isMyStep);
    if (result) _handleWinner(isMyStep);
    result = _checkWinnerTtoB(coordinateX, coordinateY, isMyStep);
    if (result) _handleWinner(isMyStep);
  }

  void _handleWinner(bool isMe) {
    isWaitingOpponentStep.call(false);
    winner = (isMe ? Winner.me : Winner.opponent);
    isMe ? ++yourScore.value : ++partnerScore.value;
    showResult.call(true);

    AssetsAudioPlayer.playAndForget(Audio(isMe ? AudioAssets.win : AudioAssets.lose),
        volume: soundEffect.value);
  }

  /// check đường chéo từ trái trên sang phải dưới
  bool _checkWinnerTLtoBR(int coordinateX, int coordinateY, bool isMyStep) {
    List<CellValue> data = [mapData[coordinateX][coordinateY]];

    int startX = coordinateX, startY = coordinateY;
    int endX = coordinateX, endY = coordinateY;

    for (int i = 0; i < 4; ++i) {
      if (!(startX - 1).isNegative && !(startY - 1).isNegative) {
        data.insert(0, mapData[--startX][--startY]);
      }
      if ((endX + 1) < mapSize && (endY + 1) < mapSize) {
        data.add(mapData[++endX][++endY]);
      }
    }
    int result = _compare(data, isMyStep ? CellValue.xChar : CellValue.oChar);
    if (!result.isNegative) {
      for (int i = 0; i < 5; ++i) {
        mapData[startX + result - i][startY + result - i] =
            isMyStep ? CellValue.xWinner : CellValue.oWinner;
      }
      mapData.refresh();
      return true;
    }
    return false;
  }

  /// check đường chéo từ trái dưới sang phải trên
  bool _checkWinnerBLtoTR(int coordinateX, int coordinateY, bool isMyStep) {
    List<CellValue> data = [mapData[coordinateX][coordinateY]];

    int startX = coordinateX, startY = coordinateY;
    int endX = coordinateX, endY = coordinateY;
    for (int i = 0; i < 4; ++i) {
      if (!(startX - 1).isNegative && (startY + 1) < mapSize) {
        data.insert(0, mapData[--startX][++startY]);
      }
      if ((endX + 1) < mapSize && !(endY - 1).isNegative) {
        data.add(mapData[++endX][--endY]);
      }
    }
    int result = _compare(data, isMyStep ? CellValue.xChar : CellValue.oChar);
    if (!result.isNegative) {
      for (int i = 0; i < 5; ++i) {
        mapData[startX + result - i][startY - result + i] =
            isMyStep ? CellValue.xWinner : CellValue.oWinner;
      }
      mapData.refresh();
      return true;
    }
    return false;
  }

  /// check đường thẳng từ trái sang phải
  bool _checkWinnerLtoR(int coordinateX, int coordinateY, bool isMyStep) {
    List<CellValue> data = [mapData[coordinateX][coordinateY]];

    int startY = coordinateY;
    int endY = coordinateY;
    for (int i = 0; i < 4; ++i) {
      if (!(startY - 1).isNegative) {
        data.insert(0, mapData[coordinateX][--startY]);
      }
      if ((endY + 1) < mapSize) {
        data.add(mapData[coordinateX][++endY]);
      }
    }
    int result = _compare(data, isMyStep ? CellValue.xChar : CellValue.oChar);
    if (!result.isNegative) {
      for (int i = 0; i < 5; ++i) {
        mapData[coordinateX][startY + result - i] =
            isMyStep ? CellValue.xWinner : CellValue.oWinner;
      }
      mapData.refresh();
      return true;
    }
    return false;
  }

  /// check đường thẳng từ trên xuống dưới
  bool _checkWinnerTtoB(int coordinateX, int coordinateY, bool isMyStep) {
    List<CellValue> data = [mapData[coordinateX][coordinateY]];

    int startX = coordinateX;
    int endX = coordinateX;
    for (int i = 0; i < 4; ++i) {
      if (!(startX - 1).isNegative) {
        data.insert(0, mapData[--startX][coordinateY]);
      }
      if ((endX + 1) < mapSize) {
        data.add(mapData[++endX][coordinateY]);
      }
    }
    int result = _compare(data, isMyStep ? CellValue.xChar : CellValue.oChar);
    if (!result.isNegative) {
      for (int i = 0; i < 5; ++i) {
        mapData[startX + result - i][coordinateY] =
            isMyStep ? CellValue.xWinner : CellValue.oWinner;
      }
      mapData.refresh();
      return true;
    }
    return false;
  }

  int _compare(List<CellValue> data, CellValue target) {
    int count = 0;
    for (int index = 0; index < data.length; ++index) {
      if (data[index] == target) {
        count++;
        if (count == 5) return index;
      } else {
        count = 0;
      }
    }
    return -1;
  }

  void rematch() {
    winner = null;
    _countStep = 0;
    showResult.call(false);
    mapData.call(List.generate(mapSize, (x) => List.generate(mapSize, (y) => CellValue.none)));
    sendData(Constant.rematch);
    if (!partnerReadyForRematch) {
      readyForRematch = true;
      isWaitingInvitation.call(true);
    } else {
      partnerReadyForRematch = false;
    }
    if (isFromInvitation) isWaitingOpponentStep.call(true);
  }
}
