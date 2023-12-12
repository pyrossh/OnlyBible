import "package:atoms_state/atoms_state.dart";
import "package:flutter/material.dart";
import "package:only_bible_app/models.dart";
import "package:only_bible_app/navigation.dart";
import "package:only_bible_app/store/actions.dart";
import "package:only_bible_app/store/state.dart";
import "package:only_bible_app/utils.dart";
import "package:settings_ui/settings_ui.dart";

class SettingsSheet extends StatelessWidget {
  final Bible bible;

  const SettingsSheet({super.key, required this.bible});

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
          title: Text(context.l.settingsTitle, style: context.theme.textTheme.headlineMedium),
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 20),
          tiles: [
            SettingsTile.navigation(
              leading: const Icon(Icons.book_outlined, color: Colors.blueAccent),
              title: Text(context.l.bibleTitle),
              value: Text(bible.name),
              onPressed: changeBible,
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.color_lens_outlined, color: Colors.green),
              title: Text(context.l.themeTitle),
              trailing: ToggleButtons(
                onPressed: (int index) {
                  dispatch(ToggleDarkMode());
                },
                highlightColor: Colors.transparent,
                borderColor: Colors.grey,
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                selectedColor: darkModeAtom.value ? Colors.lightBlue.shade300 : Colors.yellowAccent.shade700,
                selectedBorderColor: Colors.grey,
                color: Colors.grey,
                fillColor: Colors.transparent,
                constraints: const BoxConstraints(
                  minHeight: 36.0,
                  minWidth: 50.0,
                ),
                isSelected: [!darkModeAtom.value, darkModeAtom.value],
                children: const [
                  Icon(Icons.light_mode),
                  Icon(Icons.dark_mode),
                ],
              ),
            ),
            SettingsTile(
              title: Text(context.l.incrementFontTitle),
              leading: Icon(Icons.font_download, color: context.theme.colorScheme.onBackground),
              trailing: IconButton(
                onPressed: () => dispatch(const UpdateTextScale(0.1)),
                icon: const Icon(Icons.add_circle_outline, size: 32, color: Colors.redAccent),
              ),
            ),
            SettingsTile(
              title: Text(context.l.decrementFontTitle),
              leading: Icon(Icons.font_download, color: context.theme.colorScheme.onBackground),
              trailing: IconButton(
                onPressed: () => dispatch(const UpdateTextScale(-0.1)),
                icon: const Icon(Icons.remove_circle_outline, size: 32, color: Colors.blueAccent),
              ),
            ),
            SettingsTile.switchTile(
              initialValue: boldFontAtom.watch(context),
              leading: Icon(Icons.format_bold, color: context.theme.colorScheme.onBackground),
              title: Text(context.l.boldFontTitle),
              onToggle: (value) => dispatch(ToggleBoldFont()),
            ),
            SettingsTile.switchTile(
              initialValue: engTitlesAtom.watch(context),
              leading: Icon(Icons.abc, color: context.theme.colorScheme.onBackground),
              title: Text(context.l.engTitles),
              onToggle: (value) => dispatch(ToggleEngTitles()),
            ),
          ],
        ),
        SettingsSection(
          title: Text(context.l.aboutUsTitle, style: context.theme.textTheme.headlineMedium),
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 20),
          tiles: [
            SettingsTile.navigation(
              leading: const Icon(Icons.policy_outlined, color: Colors.brown),
              title: Text(context.l.privacyPolicyTitle),
              onPressed: showPrivacyPolicy,
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.description_outlined, color: Colors.blueGrey),
              title: Text(context.l.termsAndConditionsTitle),
              onPressed: showTermsAndConditions,
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.share_outlined, color: Colors.blueAccent),
              title: Text(context.l.shareAppTitle),
              onPressed: shareAppLink,
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.star, color: Colors.yellowAccent.shade700),
              title: Text(context.l.rateAppTitle),
              onPressed: rateApp,
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.info_outline, color: context.theme.colorScheme.onBackground),
              title: Text(context.l.aboutUsTitle),
              onPressed: showAboutUs,
            ),
          ],
        ),
      ],
    );
  }
}
