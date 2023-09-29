import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveListSection extends StatelessWidget {
  const AdaptiveListSection({
    super.key,
    required this.children,
    this.title,
    this.footer,
  });

  final List<Widget> children;
  final String? footer;
  final String? title;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      return CupertinoListSection(
        header: title != null ? Text(title!) : null,
        footer: footer != null ? Text(footer!) : null,
        children: children,
      );
    } else {
      return ListTile(
        title: title != null ? Text(title!) : null,
        subtitle: Card(
          child: Column(
            children: children,
          ),
        ),
      );
    }
  }
}
