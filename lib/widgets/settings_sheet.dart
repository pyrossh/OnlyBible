import "package:flutter/material.dart";
import "package:only_bible_app/state.dart";
import "package:settings_ui/settings_ui.dart";

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppModel.of(context);
    final selectedBible = app.bible;
    final modeIcon = app.darkMode ? Icons.dark_mode : Icons.light_mode;
    final modeIconColor = app.darkMode ? const Color(0xFF59EEFF) : const Color(0xFFE5B347);
    final iconColor = Theme.of(context).textTheme.bodyMedium!.color;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(
            "Settings",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Expanded(
          child: SettingsList(
            contentPadding: EdgeInsets.zero,
            platform: DevicePlatform.iOS,
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
                      app.changeBible(c);
                      return null;
                    },
                  ),
                  SettingsTile.switchTile(
                    onToggle: (value) {
                      app.toggleMode();
                    },
                    initialValue: app.darkMode,
                    leading: Icon(modeIcon, color: modeIconColor),
                    title: const Text("Dark mode"),
                  ),
                  SettingsTile.switchTile(
                    onToggle: (value) {
                      app.toggleBold();
                    },
                    initialValue: app.fontBold,
                    leading: Icon(Icons.format_bold, color: iconColor),
                    title: const Text("Bold font"),
                  ),
                  SettingsTile(
                    title: const Text("Increase font size"),
                    leading: Icon(Icons.font_download, color: iconColor),
                    trailing: IconButton(
                      onPressed: app.increaseFont,
                      icon: const Icon(Icons.add_circle_outline, size: 32, color: Colors.redAccent),
                    ),
                  ),
                  SettingsTile(
                    title: const Text("Decrease font size"),
                    leading: Icon(Icons.font_download, color: iconColor),
                    trailing: IconButton(
                      onPressed: app.decreaseFont,
                      icon: const Icon(Icons.remove_circle_outline, size: 32, color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
