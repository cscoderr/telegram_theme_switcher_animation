import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import 'package:telegram_dark_mode_animation/home/providers/theme_provider.dart';

class AdaptiveScaffold extends ConsumerStatefulWidget {
  const AdaptiveScaffold({
    super.key,
    this.title,
    required this.body,
    this.circleColor = Colors.white,
  });

  final String? title;
  final Widget body;
  final Color circleColor;

  @override
  ConsumerState<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends ConsumerState<AdaptiveScaffold>
    with SingleTickerProviderStateMixin {
  bool isDarkMode = false;
  late final AnimationController _animationController;
  late final Animation<double> _radiusAnimation;
  final _globalKey = GlobalKey();
  // Uint8List? image1;
  ui.Image? image1;
  ui.Image? image2;
  final screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _radiusAnimation = Tween<double>(begin: 0.0, end: 1000.0)
        // .chain(CurveTween(curve: const Cubic(0.208333, 0.82, 0.25, 1.0)))
        // .chain(CurveTween(curve: const Interval(0.2075, 0.4175)))
        .animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.addListener(() {
      setState(() {});
    });
  }

  void _handelThemeIconPressed() async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    // image1 = await screenshotController.capture();
    image1 = await screenshotController.captureAsUiImage(
      pixelRatio: pixelRatio,
    );
    setState(() {});
    final theme = ref.watch(themeProvider);
    ref.read(themeProvider.notifier).changeTheme(
        theme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
    await Future.delayed(const Duration(milliseconds: 10));
    image2 = await screenshotController.captureAsUiImage();
    if (!_animationController.isCompleted) {
      _animationController.forward();
    } else {
      _animationController.reset();
    }
    // await Future.delayed(const Duration(milliseconds: 600));
    // setState(() {
    //   image1 = null;
    //   image2 = null;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    Widget? page;
    if (Platform.isIOS || Platform.isMacOS) {
      page = CupertinoPageScaffold(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              if (widget.title != null)
                CupertinoSliverNavigationBar(
                  largeTitle: Text(widget.title!),
                  trailing: IconButton(
                    icon: const Icon(Icons.light_mode),
                    onPressed: _handelThemeIconPressed,
                  ),
                )
            ];
          },
          body: widget.body,
        ),
      );
    } else {
      // PageTransitionsTheme()
      page = Scaffold(
        appBar: widget.title != null
            ? AppBar(
                title: Text(widget.title!),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.light_mode),
                    onPressed: _handelThemeIconPressed,
                  ),
                ],
              )
            : null,
        body: widget.body,
      );
    }
    return Stack(
      children: [
        Screenshot(
          controller: screenshotController,
          child: page,
        ),
        // if (image1 != null) Image.memory(image1!),
        Positioned.fill(
          child: ShaderMask(
            blendMode: BlendMode.dstOut,
            shaderCallback: (bounds) {
              return ImageShader(
                image2!,
                TileMode.clamp,
                TileMode.clamp,
                Matrix4.identity().storage,
              );
            },
          ),
        ),
      ],
    );
  }
}
