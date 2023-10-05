import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Uint8List? image1;
  ui.Image? image2;
  final screenshotController = ScreenshotController();
  Brightness? systemNavigationBarBrighness;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _radiusAnimation = Tween<double>(begin: 0.0, end: 1000.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.addListener(() {
      setState(() {});
    });
  }

  void _handelThemeIconPressed() async {
    final theme = ref.watch(themeProvider);
    final currentBrightness =
        theme == ThemeMode.light ? Brightness.dark : Brightness.light;
    setState(() {
      systemNavigationBarBrighness = currentBrightness;
    });
    image1 = await screenshotController.capture();
    setState(() {});
    //Wait for 40MS before changing the theme
    //to avoid Jank issue
    await Future.delayed(const Duration(milliseconds: 40));
    ref.read(themeProvider.notifier).changeTheme(
        theme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
    // Tried 200 but the the theme is still switching
    // So i think 250 works well
    await Future.delayed(const Duration(milliseconds: 250));
    setState(() {
      systemNavigationBarBrighness = currentBrightness == Brightness.light
          ? Brightness.dark
          : Brightness.light;
    });

    image2 = await screenshotController.captureAsUiImage();
    _animationController.forward();
    //Delay for the radius/circle animation
    await Future.delayed(const Duration(milliseconds: 600));

    //This clears the images and animation
    setState(() {
      image1 = null;
      image2 = null;
    });
    _animationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final size = MediaQuery.sizeOf(context);
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
                    icon: theme == ThemeMode.dark
                        ? const Icon(Icons.light_mode)
                        : const Icon(
                            Icons.dark_mode,
                          ),
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
                    icon: theme == ThemeMode.dark
                        ? const Icon(Icons.light_mode)
                        : const Icon(
                            Icons.dark_mode,
                          ),
                    onPressed: _handelThemeIconPressed,
                  ),
                ],
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarIconBrightness: systemNavigationBarBrighness,
                ),
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
        if (image1 != null) Image.memory(image1!),
        if (image2 != null)
          Align(
            alignment: Alignment.topRight,
            child: ClipOval(
              clipper: CircleClipper(_radiusAnimation.value),
              child: ShaderMask(
                blendMode: BlendMode.dstATop,
                shaderCallback: (bounds) {
                  return ImageShader(
                    image2!,
                    TileMode.clamp,
                    TileMode.clamp,
                    Matrix4.identity().storage,
                  );
                },
                child: Container(
                  width: size.width,
                  height: size.height,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class CircleClipper extends CustomClipper<Rect> {
  CircleClipper(this.radius);
  final double radius;
  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => true;

  @override
  ui.Rect getClip(ui.Size size) {
    return Rect.fromCircle(center: Offset(size.width - 20, 80), radius: radius);
  }
}
