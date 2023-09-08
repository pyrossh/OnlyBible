import "package:atoms_state/atoms_state.dart";
import "package:get_storage/get_storage.dart";

class FileStorage<T> implements Storage {
  GetStorage box;

  FileStorage({required this.box});

  @override
  T? get<T>(String key) {
    return box.read(key);
  }

  @override
  Future<void> delete(String key) async {
    await box.remove(key);
    await box.save();
  }

  @override
  Future<void> set(String key, value) async {
    await box.write(key, value);
    await box.save();
  }
}
