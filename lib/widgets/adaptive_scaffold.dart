import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    this.title,
    required this.body,
  });

  final String? title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      return CupertinoPageScaffold(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              if (title != null)
                CupertinoSliverNavigationBar(
                  largeTitle: Text(title!),
                )
            ];
          },
          body: body,
        ),
      );
    } else {
      return Scaffold(
        appBar: title != null
            ? AppBar(
                title: Text(title!),
              )
            : null,
        body: body,
      );
    }
  }
}
