import 'dart:io';

import 'package:caro_game/core/utility.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginController extends GetxController {
  final TextEditingController nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _requestPermission();
  }

  _requestPermission() async {
    Nearby().askBluetoothPermission();
    Nearby().askLocationPermission();
  }

  Future<bool> checkAndRequestPermission() async {
    bool locationReq = await Nearby().checkLocationPermission();
    bool bluetoothReq = await Nearby().checkBluetoothPermission();
    bool nearbyWifiReq = true;
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final build = await deviceInfoPlugin.androidInfo;
      if (build.version.sdkInt >= 32) {
        nearbyWifiReq = await PermissionRequest.requestPermission(Permission.nearbyWifiDevices);
      }
    }
    if (!locationReq || !bluetoothReq || !nearbyWifiReq) {
      _requestPermission();
      return checkAndRequestPermission();
    }
    return true;
  }
}
