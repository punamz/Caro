import 'package:get/get.dart';

class GlobalValue {
  static final RxBool acceptInvitation = false.obs;
  static final RxBool partnerExitRoomAction = true.obs;
  static final RxString partnerDisconnect = ''.obs;
  static final RxString messageReceive = ''.obs;
  static final RxBool partnerRequestRematch = true.obs;
}
