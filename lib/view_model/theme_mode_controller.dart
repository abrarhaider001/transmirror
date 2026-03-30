import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transmirror/core/utils/local_storage/storage_utility.dart';

/// Persists app [ThemeMode] (light / dark / system) for [GetMaterialApp].
class ThemeModeController extends GetxController {
  static const _storageKey = 'theme_mode';

  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    final stored = MyLocalStorage.instance().readData<String>(_storageKey);
    switch (stored) {
      case 'light':
        themeMode.value = ThemeMode.light;
      case 'dark':
        themeMode.value = ThemeMode.dark;
      case 'system':
        themeMode.value = ThemeMode.system;
      default:
        themeMode.value = ThemeMode.light;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await MyLocalStorage.instance().writeData(_storageKey, value);
  }
}
