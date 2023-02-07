import 'package:get_storage/get_storage.dart';

class Storage {
  Storage._();
  static late final Storage instance;
  static late final GetStorage _box;

  static Future getInstance({required String storeName}) async {
    await GetStorage.init(storeName);
    _box = GetStorage(storeName);
    instance = Storage._();
    return instance;
  }

  Future<void> writeString(String key, String? value) async {
    await _box.write(key, value ?? '');
  }

  Future<void> writeInt(String key, int? value) async {
    await _box.write(key, value ?? 0);
  }

  Future<void> writeDouble(String key, double? value) async {
    await _box.write(key, value ?? 0.0);
  }

  Future<void> writeBool(String key, bool? value) async {
    await _box.write(key, value?.toString().toLowerCase() ?? 'false');
  }

  Future<void> writeMap(String key, Map? value) async {
    await _box.write(key, value ?? {});
  }

  Future<void> writeList(String key, List? value) async {
    await _box.write(key, value ?? []);
  }

  String readString(String key) {
    return _box.read(key) ?? '';
  }

  int readInt(String key) {
    return _box.read(key) ?? 0;
  }

  double? readDouble(String key) {
    return _box.read(key);
  }

  bool? readBool(String key) {
    final String? data = _box.read(key);
    return data == null ? null : data == 'true';
  }

  Map readMap(String key) {
    return _box.read(key) ?? {};
  }

  List readList(String key) {
    return _box.read(key) ?? [];
  }

  Future<void> removeKey(String key) {
    return _box.remove(key);
  }
}
