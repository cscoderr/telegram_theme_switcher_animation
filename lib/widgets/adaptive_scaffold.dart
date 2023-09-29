import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/object.dart';

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    this.title,
    required this.body,
    required this.snapshotController,
    this.onThemeIconPressed,
  });

  final String? title;
  final Widget body;
  final SnapshotController snapshotController;
  final VoidCallback? onThemeIconPressed;

  @override
  Widget build(BuildContext context) {
    Widget? widget;
    if (Platform.isIOS || Platform.isMacOS) {
      widget = CupertinoPageScaffold(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              if (title != null)
                CupertinoSliverNavigationBar(
                  largeTitle: Text(title!),
                  trailing: IconButton(
                    icon: const Icon(Icons.light_mode),
                    onPressed: onThemeIconPressed,
                  ),
                )
            ];
          },
          body: body,
        ),
      );
    } else {
      widget = Scaffold(
        appBar: title != null
            ? AppBar(
                title: Text(title!),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.light_mode),
                    onPressed: onThemeIconPressed,
                  ),
                ],
              )
            : null,
        body: body,
      );
    }
    return SnapshotWidget(
      controller: snapshotController,
      painter: CustomSnapshotPainter(),
      child: widget,
    );
  }
}

class CustomSnapshotPainter extends SnapshotPainter {
  CustomSnapshotPainter();
  @override
  void paint(PaintingContext context, Offset offset, Size size,
      PaintingContextCallback painter) {
    painter(context, offset);
  }

  @override
  bool shouldRepaint(covariant SnapshotPainter oldPainter) => true;

  @override
  void paintSnapshot(PaintingContext context, ui.Offset offset, ui.Size size,
      ui.Image image, ui.Size sourceSize, double pixelRatio) {
    final Rect src = Rect.fromLTWH(0, 0, sourceSize.width, sourceSize.height);
    final Rect dst =
        Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
    final Paint paint = Paint()..filterQuality = FilterQuality.low;
    context.canvas.drawImageRect(image, src, dst, paint);
  }
}
