// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:telegram_dark_mode_animation/home/providers/theme_provider.dart';
// import 'package:telegram_dark_mode_animation/widgets/widgets.dart';

// class HomePage extends ConsumerStatefulWidget {
//   const HomePage({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
// }

// class _HomePageState extends ConsumerState<HomePage>
//     with SingleTickerProviderStateMixin {
//   final snapshotController = SnapshotController();
//   bool isDarkMode = false;
//   late final AnimationController _animationController;
//   late final Animation<double> _radiusAnimation;
//   late CustomSnapshotPainter customSnapshotPainter;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );
//     _radiusAnimation = Tween<double>(begin: 0.0, end: 1000.0)
//         .chain(CurveTween(curve: const Cubic(0.208333, 0.82, 0.25, 1.0)))
//         // .chain(CurveTween(curve: const Interval(0.2075, 0.4175)))
//         .animate(
//           CurvedAnimation(
//               parent: _animationController, curve: Curves.easeInOut),
//         );
//     customSnapshotPainter = CustomSnapshotPainter(
//       radius: _radiusAnimation,
//       radiusColor: isDarkMode ? Colors.black : Colors.white,
//       animation: _animationController,
//     );

//     _animationController.addListener(() {
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AdaptiveScaffold(
//       snapshotController: snapshotController,
//       title: 'Dark Mode Animation',
//       radius: _radiusAnimation.value,
//       circleColor: isDarkMode ? Colors.white : Colors.black,
//       customSnapshotPainter: customSnapshotPainter,
//       body: Column(
//         children: [
//           AdaptiveListSection(
//             title: 'TEXT SECTION',
//             children: [
//               AdpativeSwitchTile(
//                 title: "Large Display",
//                 value: true,
//                 onChanged: (value) {},
//               ),
//               AdpativeSwitchTile(
//                 title: "Bold Text",
//                 value: false,
//                 onChanged: (value) {},
//               ),
//             ],
//           ),
//           AdaptiveListSection(
//             title: 'DISPLAY SECTION',
//             footer: 'This is a Simple Footer.',
//             children: [
//               AdpativeSwitchTile(
//                 title: 'Night Light',
//                 value: false,
//                 onChanged: (value) {},
//               ),
//               AdpativeSwitchTile(
//                 title: 'True Tone',
//                 value: true,
//                 onChanged: (value) {},
//               ),
//             ],
//           ),
//         ],
//       ),
//       onThemeIconPressed: () async {
//         print(_radiusAnimation.value);
//         final mode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
//         if (!_animationController.isCompleted) {
//           _animationController.forward();
//         } else {
//           _animationController.reset();
//         }
//         snapshotController.allowSnapshotting = true;
//         ref.read(themeProvider.notifier).changeTheme(mode);
//         setState(() {
//           isDarkMode = !isDarkMode;
//         });
//         setState(() {});
//         await Future.delayed(const Duration(milliseconds: 600));
//         // await Future.delayed(const Duration(milliseconds: 500));
//         if (_animationController.status == AnimationStatus.forward) {
//           _animationController.reset();
//         }
//         setState(() {
//           snapshotController.allowSnapshotting = false;
//           isDarkMode = !isDarkMode;
//         });
//       },
//     );
//   }
// }
