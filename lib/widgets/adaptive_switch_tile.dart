import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdpativeSwitchTile extends StatelessWidget {
  const AdpativeSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      return CupertinoListTile(
        title: Text(title),
        trailing: CupertinoSwitch(
          value: value,
          onChanged: onChanged,
        ),
      );
    } else {
      return ListTile(
        title: Text(title),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
        ),
      );
    }
  }
}
