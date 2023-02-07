import 'package:nearby_connections/nearby_connections.dart';

class DeviceModel {
  String id;
  String name;
  String serviceId;
  ConnectionInfo? connectionInfo;
  Status? status;
  bool? connecting;
  DeviceModel(this.id, this.name, this.serviceId, this.status);
}
