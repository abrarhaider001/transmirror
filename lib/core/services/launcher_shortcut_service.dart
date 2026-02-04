
import 'package:launcher_shortcuts/launcher_shortcuts.dart';
import 'package:transmirror/core/utils/local_storage/storage_utility.dart';

class LauncherShortcutService {
  LauncherShortcutService._();
  static final LauncherShortcutService instance = LauncherShortcutService._();

  // LauncherShortcuts seems to use static methods
  // final LauncherShortcuts _shortcuts = LauncherShortcuts();

  Future<void> toggleShortcuts(bool enable) async {
    if (enable) {
      await createShortcuts();
    } else {
      await clearShortcuts();
    }
    await MyLocalStorage.instance().writeData(
      'launcherShortcutsEnabled',
      enable,
    );
  }

  Future<void> createShortcuts() async {
    await LauncherShortcuts.setShortcuts([
      ShortcutItem(
        type: 'start_recording',
        localizedTitle: 'Start Recording',
        androidConfig: AndroidConfig(icon: "assets/launcher/logo.png"),
        iosConfig: IosConfig(
          icon: 'logo',
          localizedSubtitle: 'Localized Subtitle',
        ),
      ),
    ]);
  }

  // Call this when overlay state changes
  Future<void> updateOverlayShortcut({required bool isOverlayShowing}) async {
    // Overlay functionality removed, no need to update shortcuts dynamically for it
    if (!areShortcutsEnabled) return;
    await createShortcuts();
  }

  Future<void> clearShortcuts() async {
    await LauncherShortcuts.clearShortcuts();
  }

  bool get areShortcutsEnabled {
    return MyLocalStorage.instance().readData<bool>(
          'launcherShortcutsEnabled',
        ) ??
        false;
  }
}
