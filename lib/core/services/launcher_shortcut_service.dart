
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
      ShortcutItem(
        type: 'show_overlay',
        localizedTitle: 'Show Overlay',
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
    if (!areShortcutsEnabled) return;

    if (isOverlayShowing) {
      // User requested: "clear overlay shortcut and show a icon at the start and a text"
      // Assuming this means clearing the "Show Overlay" shortcut.
      // If a "Hide Overlay" shortcut or notification is needed, implement here.
      await clearShortcuts();
    } else {
      await createShortcuts();
    }
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
