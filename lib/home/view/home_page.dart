import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_dark_mode_animation/home/providers/theme_provider.dart';
import 'package:telegram_dark_mode_animation/widgets/widgets.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final snapshotController = SnapshotController();
  bool isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      snapshotController: snapshotController,
      title: 'Dark Mode Animation',
      body: Column(
        children: [
          AdaptiveListSection(
            title: 'TEXT SECTION',
            children: [
              AdpativeSwitchTile(
                title: "Large Display",
                value: true,
                onChanged: (value) {},
              ),
              AdpativeSwitchTile(
                title: "Bold Text",
                value: false,
                onChanged: (value) {},
              ),
            ],
          ),
          AdaptiveListSection(
            title: 'DISPLAY SECTION',
            footer: 'This is a Simple Footer.',
            children: [
              AdpativeSwitchTile(
                title: 'Night Light',
                value: false,
                onChanged: (value) {},
              ),
              AdpativeSwitchTile(
                title: 'True Tone',
                value: true,
                onChanged: (value) {},
              ),
            ],
          ),
        ],
      ),
      onThemeIconPressed: () {
        final mode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
        ref.read(themeProvider.notifier).changeTheme(mode);
        setState(() {
          isDarkMode = !isDarkMode;
        });
      },
    );
  }
}
