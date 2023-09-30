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
    this.radius = 0.0,
    this.circleColor = Colors.white,
    required this.customSnapshotPainter,
  });

  final String? title;
  final Widget body;
  final SnapshotController snapshotController;
  final VoidCallback? onThemeIconPressed;
  final double radius;
  final Color circleColor;
  final CustomSnapshotPainter customSnapshotPainter;
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
      // PageTransitionsTheme()
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
    return IgnorePointer(
      ignoring: false,
      child: SnapshotWidget(
        controller: snapshotController,
        mode: SnapshotMode.permissive,
        painter: customSnapshotPainter,
        autoresize: true,
        child: widget,
      ),
      // Stack(
      //   children: [
      //     SnapshotWidget(
      //       controller: snapshotController,
      //       mode: SnapshotMode.permissive,
      //       painter: customSnapshotPainter,
      //       autoresize: true,
      //       child: widget,
      //     ),
      //     // Align(
      //     //   alignment: Alignment.topRight,
      //     //   child: Transform.scale(
      //     //     scale: radius,
      //     //     child: Container(
      //     //       height: 70,
      //     //       width: 70,
      //     //       decoration: BoxDecoration(
      //     //         color: circleColor,
      //     //         shape: BoxShape.circle,
      //     //       ),
      //     //     ),
      //     //   ),
      //     // ),
      //   ],
      // ),
    );
  }
}

class CustomSnapshotPainter extends SnapshotPainter {
  CustomSnapshotPainter({
    required this.reverse,
    required this.scale,
    required this.fade,
    required this.animation,
    required this.radius,
    required this.radiusColor,
  }) {
    animation.addListener(notifyListeners);
    animation.addStatusListener(_onStatusChange);
    scale.addListener(notifyListeners);
    fade.addListener(notifyListeners);
    radius.addListener(notifyListeners);
  }

  void _onStatusChange(_) {
    notifyListeners();
  }

  final bool reverse;
  final Animation<double> animation;
  final Animation<double> scale;
  final Animation<double> fade;
  final Animation<double> radius;
  final Color radiusColor;
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
    context.canvas.drawCircle(
      Offset(size.width, 0),
      radius.value,
      Paint()..color = Colors.white,
    );
    final Rect src = Rect.fromLTWH(0, 0, sourceSize.width, sourceSize.height);
    final Rect dst =
        Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
    final Paint paint = Paint()
      ..filterQuality = FilterQuality.low
      ..color = const ui.Color.fromARGB(228, 255, 255, 250);
    context.canvas.drawImageRect(image, src, dst, paint);
    // _drawImageScaledAndCentered(context, image, 1, 0.5, pixelRatio);
  }
}
