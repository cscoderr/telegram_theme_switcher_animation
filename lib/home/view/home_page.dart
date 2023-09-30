import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telegram_dark_mode_animation/home/providers/theme_provider.dart';
import 'package:telegram_dark_mode_animation/widgets/widgets.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  final snapshotController = SnapshotController();
  bool isDarkMode = false;
  double radius = 0.0;
  late final AnimationController _animationController;
  late final Animation<double> _radiusAnimation;
  // late final Animation<double> _animation;

  late Animation<double> fadeTransition;
  late Animation<double> scaleTransition;

  late CustomSnapshotPainter customSnapshotPainter;

  static final Animatable<double> _fadeInTransition = Tween<double>(
    begin: 0.0,
    end: 1.00,
  ).chain(CurveTween(curve: const Interval(0.125, 0.250)));

  static final Animatable<double> _scaleDownTransition = Tween<double>(
    begin: 1.10,
    end: 1.00,
  ).chain(TweenSequence<double>([
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 0.0, end: 0.4)
          .chain(CurveTween(curve: const Cubic(0.05, 0.0, 0.133333, 0.06))),
      weight: 0.166666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 0.4, end: 1.0)
          .chain(CurveTween(curve: const Cubic(0.208333, 0.82, 0.25, 1.0))),
      weight: 1.0 - 0.166666,
    ),
  ]));

  static final Animatable<double> _scaleUpTransition = Tween<double>(
    begin: 0.85,
    end: 1.00,
  ).chain(TweenSequence<double>([
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 0.0, end: 0.4)
          .chain(CurveTween(curve: const Cubic(0.05, 0.0, 0.133333, 0.06))),
      weight: 0.166666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 0.4, end: 1.0)
          .chain(CurveTween(curve: const Cubic(0.208333, 0.82, 0.25, 1.0))),
      weight: 1.0 - 0.166666,
    ),
  ]));

  static final Animatable<double?> _scrimOpacityTween = Tween<double?>(
    begin: 0.0,
    end: 0.60,
  ).chain(CurveTween(curve: const Interval(0.2075, 0.4175)));

  void _updateAnimations() {
    // _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
    //   CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    // );
    fadeTransition = 1 == 2
        ? kAlwaysCompleteAnimation
        : _fadeInTransition.animate(Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: _animationController, curve: Curves.easeInOut),
          ));

    scaleTransition = (1 == 2 ? _scaleDownTransition : _scaleUpTransition)
        .animate(Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    ));

    // _animation.addListener(() {});
    // _animation.addStatusListener((status) {});
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    scaleTransition = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    fadeTransition = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _radiusAnimation = Tween<double>(begin: 0.0, end: 1000.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _updateAnimations();
    customSnapshotPainter = CustomSnapshotPainter(
      reverse: false,
      fade: fadeTransition,
      scale: scaleTransition,
      radius: _radiusAnimation,
      radiusColor: isDarkMode ? Colors.black : Colors.white,
      animation: _animationController,
    );

    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      snapshotController: snapshotController,
      title: 'Dark Mode Animation',
      radius: _radiusAnimation.value,
      circleColor: isDarkMode ? Colors.white : Colors.black,
      customSnapshotPainter: customSnapshotPainter,
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
      onThemeIconPressed: () async {
        print(_radiusAnimation.value);
        final mode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
        if (!_animationController.isCompleted) {
          _animationController.forward();
        } else {
          _animationController.reset();
        }
        snapshotController.allowSnapshotting = true;
        setState(() {});
        await Future.delayed(const Duration(
            milliseconds:
                600)); // await Future.delayed(const Duration(milliseconds: 500));
        if (_animationController.status == AnimationStatus.forward) {
          _animationController.reset();
        }
        setState(() {
          snapshotController.allowSnapshotting = false;
          isDarkMode = !isDarkMode;
        });
        ref.read(themeProvider.notifier).changeTheme(mode);
      },
    );
  }
}
