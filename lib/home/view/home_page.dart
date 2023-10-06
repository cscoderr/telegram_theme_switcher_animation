import 'package:flutter/material.dart';
import 'package:telegram_dark_mode_animation/home/home.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return ThemeSwitcherScaffold(
      title: const Text('Telegram Theme Animation'),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(
                isDarkTheme ? Icons.light_mode : Icons.dark_mode,
              ),
              title: Text(
                isDarkTheme ? 'Dark Mode' : 'Light Mode',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: const Text('Subtitle'),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            const ListTile(
              title: Text('Title'),
              subtitle: Text('Subtitle'),
            )
          ],
        ),
      ),
    );
  }
}
