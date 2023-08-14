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
    final modeIcon = model.darkMode ? Icons.dark_mode : Icons.light_mode;
    final modeIconColor = model.darkMode ? const Color(0xFF59EEFF) : const Color(0xFFE5B347);
    final iconColor = Theme.of(context).textTheme.bodyMedium!.color;
    return ColoredBox(
      color: model.darkMode ? const Color(0xFF141415) : const Color(0xFFF2F2F7),
      child: SettingsList(
        contentPadding: const EdgeInsets.only(top: 20),
        lightTheme: const SettingsThemeData(
          settingsListBackground: Color(0xFFF2F2F7),
        ),
        darkTheme: const SettingsThemeData(
          settingsListBackground: Color(0xFF141415),
        ),
        sections: [
          SettingsSection(
            margin: const EdgeInsetsDirectional.symmetric(horizontal: 20),
            tiles: [
              SettingsTile(
                title: const Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                trailing: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.close, color: iconColor),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
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
                onPressed: (c) {
                  Navigator.of(c).pushReplacement(
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
                leading: Icon(modeIcon, color: modeIconColor),
                title: const Text("Dark mode"),
              ),
              SettingsTile.switchTile(
                onToggle: (value) {
                  model.toggleBold();
                },
                initialValue: model.fontBold,
                leading: Icon(Icons.format_bold, color: iconColor),
                title: const Text("Bold font"),
              ),
              SettingsTile(
                title: const Text("Increase font size"),
                leading: Icon(Icons.font_download, color: iconColor),
                trailing: IconButton(
                  onPressed: model.increaseFont,
                  icon: const Icon(Icons.add_circle_outline, size: 32, color: Colors.redAccent),
                ),
              ),
              SettingsTile(
                title: const Text("Decrease font size"),
                leading: Icon(Icons.font_download, color: iconColor),
                trailing: IconButton(
                  onPressed: model.decreaseFont,
                  icon: const Icon(Icons.remove_circle_outline, size: 32, color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
