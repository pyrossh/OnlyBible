import "package:flutter/material.dart";
import "package:only_bible_app/state.dart";
import "package:settings_ui/settings_ui.dart";
import "package:only_bible_app/screens/bible_select_screen.dart";

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final model = AppModel.of(context);
    final selectedBible = model.bible;
    // Navigator.pop(context);
    // Scaffold.of(context).showBodyScrim(false, 0.0);
    return SettingsList(
      // lightTheme: SettingsThemeData(
      //   settingsListBackground: Colors.white,
      // ),
      sections: [
        SettingsSection(
          // margin: EdgeInsetsDirectional.symmetric(horizontal: 5),
          tiles: [
            SettingsTile(
              title: const Text("Settings"),
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.language, color: Colors.green),
              title: const Text("Language"),
              value: const Text("English"),
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.book_outlined, color: Colors.blueAccent),
              title: const Text("Bible"),
              value: Text(selectedBible.name),
              onPressed: (_) {
                Navigator.of(context).push(
                  createNoTransitionPageRoute(
                    const BibleSelectScreen(),
                  ),
                );
                return null;
              },
            ),
            SettingsTile.switchTile(
              onToggle: (value) {
                model.toggleMode();
              },
              initialValue: model.darkMode,
              leading: const Icon(Icons.dark_mode_outlined),
              title: const Text("Dark mode"),
            ),
            SettingsTile.switchTile(
              onToggle: (value) {
                model.toggleBold();
              },
              initialValue: model.fontBold,
              leading: const Icon(Icons.format_bold_outlined),
              title: const Text("Bold font"),
            ),
            SettingsTile(
              title: const Text("Increase font size"),
              leading: const Icon(Icons.font_download),
              trailing: IconButton(
                onPressed: model.increaseFont,
                icon: const Icon(Icons.add_circle_outline, size: 32, color: Colors.redAccent),
              ),
            ),
            SettingsTile(
              title: const Text("Decrease font size"),
              leading: const Icon(Icons.font_download),
              trailing: IconButton(
                onPressed: model.decreaseFont,
                icon: const Icon(Icons.remove_circle_outline, size: 32, color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
