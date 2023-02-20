import 'dart:io';

import 'package:caro_game/core/constrant.dart';
import 'package:caro_game/core/utility.dart';
import 'package:caro_game/src/infrastructure/get_storage/local_database.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginController extends GetxController {
  final TextEditingController nameController = TextEditingController();

  final RxBool enLang = true.obs;
  @override
  void onInit() {
    super.onInit();
    _requestPermission();
    _handleSavedData();
  }

  _handleSavedData() {
    String lang = Storage.instance.readString(Constant.stoLang);
    if (lang.isEmpty) return;
    enLang.call(lang == 'en');
  }

  _requestPermission() async {
    Nearby().askBluetoothPermission();
    Nearby().askLocationPermission();
  }

  changeLanguage(bool isEng) {
    enLang.call(isEng);
    String locateCode = isEng ? 'en' : 'vi';
    Get.updateLocale(Locale.fromSubtags(languageCode: locateCode));
    Storage.instance.writeString(Constant.stoLang, locateCode);
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
