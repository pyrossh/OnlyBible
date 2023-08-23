import "package:flutter/material.dart";
import "package:only_bible_app/providers/app_model.dart";
import "package:only_bible_app/utils.dart";
import "package:settings_ui/settings_ui.dart";
// import "package:toggle_switch/toggle_switch.dart";

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppModel.of(context);
    final selectedBible = app.bible;
    final modeIcon = app.darkMode ? Icons.dark_mode : Icons.light_mode;
    final modeIconColor = app.darkMode ? const Color(0xFF59EEFF) : const Color(0xFFE5B347);
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
            SettingsTile.switchTile(
              onToggle: (value) {
                app.toggleMode();
              },
              initialValue: app.darkMode,
              leading: Icon(modeIcon, color: modeIconColor),
              title: const Text("Dark mode"),
            ),
            // SettingsTile.navigation(
            //   leading: Icon(Icons.color_lens_outlined, color: Colors.pink),
            //   title: const Text("Theme"),
            //   trailing: ToggleSwitch(
            //     // minWidth: 50.0,
            //     // minHeight: 50.0,
            //     initialLabelIndex: app.darkMode ? 1 : 0,
            //     cornerRadius: 20.0,
            //     borderWidth: 1,
            //     dividerColor: Colors.black,
            //     dividerMargin: 1,
            //     borderColor: [Color(0xFFE9E9EA), Color(0xFFE9E9EA)],
            //     activeFgColor: modeIconColor,
            //     inactiveBgColor: Color(0xFFEAEAEB),
            //     inactiveFgColor: Colors.grey,
            //     activeBgColors: [[Colors.white, Colors.white], [Color(0xFF39393D), Color(0xFF39393D)]],
            //     totalSwitches: 2,
            //     icons: const [
            //       Icons.light_mode,
            //       Icons.dark_mode,
            //     ],
            //     iconSize: 50.0,
            //     animate: true,
            //     onToggle: (index) {
            //       app.toggleMode();
            //     },
            //   ),
            // ),
            SettingsTile.switchTile(
              onToggle: (value) {
                app.toggleBold();
              },
              initialValue: app.fontBold,
              leading: Icon(Icons.format_bold, color: iconColor),
              title: const Text("Font Weight"),
              // trailing: ToggleSwitch(
              //   minHeight: 35,
              //   minWidth: 70,
              //   cornerRadius: 20.0,
              //   initialLabelIndex: 0,
              //   totalSwitches: 2,
              //   labels: const ["Normal", "Bold"],
              //   onToggle: (index) {
              //     print('switched to: $index');
              //   },
              // ),
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
              leading: const Icon(Icons.policy_outlined, color: Colors.grey),
              title: const Text("Privacy Policy"),
              onPressed: app.showPrivacyPolicy,
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.share_outlined, color: Colors.grey),
              title: const Text("Share the app"),
              onPressed: app.shareAppLink,
            ),
            if (!isDesktop()) // TODO: mabe support OSx if we release in that store
              SettingsTile.navigation(
                leading: const Icon(Icons.star_border_outlined, color: Colors.grey),
                title: const Text("Rate the app"),
                onPressed: app.rateApp,
              ),
            SettingsTile.navigation(
              leading: const Icon(Icons.info_outline, color: Colors.grey),
              title: const Text("About us"),
              onPressed: app.showAboutUs,
            ),
          ],
        ),
      ],
    );
  }
}
