import 'package:get/get.dart';
import 'package:transmirror/core/utils/constants/enums.dart';
import 'package:transmirror/core/utils/local_storage/storage_utility.dart';

class HomeModeController extends GetxController {
  static const _storageKey = 'app_mode';

  final Rx<AppMode> mode = AppMode.solo.obs;

  @override
  void onInit() {
    super.onInit();
    final stored = MyLocalStorage.instance().readData<String>(_storageKey);
    if (stored == AppMode.duo.name) {
      mode.value = AppMode.duo;
    } else {
      mode.value = AppMode.solo;
    }
  }

  Future<void> setMode(AppMode value) async {
    mode.value = value;
    await MyLocalStorage.instance().writeData(_storageKey, value.name);
  }
}
