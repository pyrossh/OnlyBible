import "package:flutter/material.dart";
import "package:only_bible_app/utils.dart";
import "package:settings_ui/settings_ui.dart";

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
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
          title: Text(context.l10n.settingsTitle, style: context.theme.textTheme.headlineMedium),
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 20),
          tiles: [
            SettingsTile.navigation(
              leading: const Icon(Icons.book_outlined, color: Colors.blueAccent),
              title: Text(context.l10n.bibleTitle),
              value: Text(context.app.bible.name),
              onPressed: context.app.changeBible,
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.color_lens_outlined, color: Colors.pink),
              title: Text(context.l10n.themeTitle),
              trailing: ToggleButtons(
                onPressed: (int index) {
                  context.appEvent.toggleDarkMode();
                },
                highlightColor: Colors.transparent,
                borderColor: Colors.grey,
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                selectedColor: context.app.darkMode ? Colors.lightBlue.shade300 : Colors.yellowAccent.shade700,
                selectedBorderColor: Colors.grey,
                color: Colors.grey,
                fillColor: Colors.transparent,
                constraints: const BoxConstraints(
                  minHeight: 36.0,
                  minWidth: 50.0,
                ),
                isSelected: [!context.app.darkMode, context.app.darkMode],
                children: const [
                  Icon(Icons.light_mode),
                  Icon(Icons.dark_mode),
                ],
              ),
            ),
            SettingsTile(
              title: Text(context.l10n.incrementFontTitle),
              leading: Icon(Icons.font_download, color: context.theme.colorScheme.onBackground),
              trailing: IconButton(
                onPressed: context.appEvent.increaseFont,
                icon: const Icon(Icons.add_circle_outline, size: 32, color: Colors.redAccent),
              ),
            ),
            SettingsTile(
              title: Text(context.l10n.decrementFontTitle),
              leading: Icon(Icons.font_download, color: context.theme.colorScheme.onBackground),
              trailing: IconButton(
                onPressed: context.appEvent.decreaseFont,
                icon: const Icon(Icons.remove_circle_outline, size: 32, color: Colors.blueAccent),
              ),
            ),
            SettingsTile.switchTile(
              initialValue: context.app.fontBold,
              leading: Icon(Icons.format_bold, color: context.theme.colorScheme.onBackground),
              title: Text(context.l10n.boldFontTitle),
              onToggle: (value) => context.appEvent.toggleBold(),
            ),
            SettingsTile.switchTile(
              initialValue: context.app.engTitles,
              leading: Icon(Icons.abc, color: context.theme.colorScheme.onBackground),
              title: Text(context.l10n.engTitles),
              onToggle: (value) => context.appEvent.toggleEngBookNames(),
            ),
          ],
        ),
        SettingsSection(
          title: Text(context.l10n.aboutUsTitle, style: context.theme.textTheme.headlineMedium),
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 20),
          tiles: [
            SettingsTile.navigation(
              leading: const Icon(Icons.policy_outlined, color: Colors.brown),
              title: Text(context.l10n.privacyPolicyTitle),
              onPressed: context.appEvent.showPrivacyPolicy,
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.share_outlined, color: Colors.blueAccent),
              title: Text(context.l10n.shareAppTitle),
              onPressed: context.appEvent.shareAppLink,
            ),
            if (!isDesktop()) // TODO: mabe support OSx if we release in that store
              SettingsTile.navigation(
                leading: Icon(Icons.star, color: Colors.yellowAccent.shade700),
                title: Text(context.l10n.rateAppTitle),
                onPressed: context.appEvent.rateApp,
              ),
            SettingsTile.navigation(
              leading: Icon(Icons.info_outline, color: context.theme.colorScheme.onBackground),
              title: Text(context.l10n.aboutUsTitle),
              onPressed: context.appEvent.showAboutUs,
            ),
          ],
        ),
      ],
    );
  }
}
