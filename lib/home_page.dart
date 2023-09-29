import 'package:flutter/cupertino.dart';
import 'package:telegram_dark_mode_animation/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
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
    );
  }
}
