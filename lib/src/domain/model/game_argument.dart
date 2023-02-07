import 'package:caro_game/src/domain/model/device_model.dart';

class GameArgument {
  final DeviceModel device;
  final bool fromInvitation;
  final int mapSize;

  GameArgument(this.device, this.fromInvitation, this.mapSize);
}
