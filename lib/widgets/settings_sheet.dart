import "package:flutter/material.dart";
import "package:only_bible_app/providers/app_model.dart";
import "package:only_bible_app/utils.dart";
import "package:settings_ui/settings_ui.dart";

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppModel.of(context);
    final selectedBible = app.bible;
    // final modeIcon = app.darkMode ? Icons.dark_mode : Icons.light_mode;
    // final modeIconColor = app.darkMode ? const Color(0xFF59EEFF) : Colors.yellowAccent.shade700;
    final iconColor = Theme.of(context).textTheme.bodyMedium!.color;
    return SettingsList(
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
          title: Text("Settings", style: Theme.of(context).textTheme.headlineMedium),
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 20),
          tiles: [
            SettingsTile.navigation(
              leading: const Icon(Icons.language, color: Colors.green),
              title: const Text("App Language"),
              value: const Text("English"),
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.book_outlined, color: Colors.blueAccent),
              title: const Text("Bible"),
              value: Text(selectedBible.name),
              onPressed: app.changeBible,
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.color_lens_outlined, color: Colors.pink),
              title: const Text("Theme"),
              trailing: ToggleButtons(
                onPressed: (int index) {
                  app.toggleMode();
                },
                highlightColor: Colors.transparent,
                borderColor: Colors.grey,
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                selectedColor: app.darkMode ? Colors.lightBlue.shade300 : Colors.yellowAccent.shade700,
                selectedBorderColor: Colors.grey,
                color: Colors.grey,
                fillColor: Colors.transparent,
                constraints: const BoxConstraints(
                  minHeight: 36.0,
                  minWidth: 50.0,
                ),
                isSelected: [!app.darkMode, app.darkMode],
                children: const [
                  Icon(Icons.light_mode),
                  Icon(Icons.dark_mode),
                ],
              ),
            ),
            SettingsTile.switchTile(
              onToggle: (value) {
                app.toggleBold();
              },
              initialValue: app.fontBold,
              leading: Icon(Icons.format_bold, color: iconColor),
              title: const Text("Font Bold"),
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
        SettingsSection(
          // title: Text("About", style: Theme.of(context).textTheme.headlineMedium),
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 20),
          tiles: [
            SettingsTile.navigation(
              leading: const Icon(Icons.policy_outlined, color: Colors.brown),
              title: const Text("Privacy Policy"),
              onPressed: app.showPrivacyPolicy,
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.share_outlined, color: Colors.blueAccent),
              title: const Text("Share the app"),
              onPressed: app.shareAppLink,
            ),
            if (!isDesktop()) // TODO: mabe support OSx if we release in that store
              SettingsTile.navigation(
                leading: Icon(Icons.star, color: Colors.yellowAccent.shade700),
                title: const Text("Rate the app"),
                onPressed: app.rateApp,
              ),
            SettingsTile.navigation(
              leading: const Icon(Icons.info_outline, color: Colors.black),
              title: const Text("About us"),
              onPressed: app.showAboutUs,
            ),
          ],
        ),
      ],
    );
  }
}
