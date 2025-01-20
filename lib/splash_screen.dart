import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, loginRoute);
  }

  loginRoute() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return initWidget();
  }

  Widget initWidget() {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
            Color.fromARGB(255, 5, 5, 172), // Deep Orange
            Color.fromARGB(255, 46, 65, 210), // Light Orange
            Color.fromARGB(255, 98, 155, 221), // Soft Peach
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
          Center(
            child: Image.asset("assets/app_logo.png"),
          )
        ],
      ),
    );
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:page_transition/page_transition.dart';
// import 'login_screen.dart';
// import 'shape_image_positioned.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {
//   final double _buttonWidth = 100;

//   late AnimationController _buttonScaleController;
//   late Animation<double> _buttonScaleAnimation;
//   void _initButtonScale() {
//     _buttonScaleController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 200),
//     );
//     _buttonScaleAnimation =
//         Tween<double>(begin: 1, end: .9).animate(_buttonScaleController)
//           ..addStatusListener((status) {
//             if (status == AnimationStatus.completed) {
//               _buttonWidthController.forward();
//             }
//           });
//   }

//   late AnimationController _buttonWidthController;
//   late Animation<double> _buttonWidthAnimation;
//   void _initButtonWidth(double screenWidth) {
//     _buttonWidthController = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 200));
//     _buttonWidthAnimation = Tween<double>(begin: _buttonWidth, end: screenWidth)
//         .animate(_buttonWidthController)
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           _positionedController.forward();
//         }
//       });
//   }

//   late AnimationController _positionedController;
//   late Animation<double> _positionedAnimation;
//   void _initPositioned(double screenWidth) {
//     _positionedController = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 400));
//     // 160 = 20 left padding + 20 right padding + 10 left positioned + 10 right positioned + 100 button width
//     _positionedAnimation = Tween<double>(begin: 10, end: screenWidth - 160)
//         .animate(_positionedController)
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           _screenScaleController.forward();
//         }
//       });
//   }

//   late AnimationController _screenScaleController;
//   late Animation<double> _screenScaleAnimation;
//   void _initScreenScale() {
//     _screenScaleController = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 400));
//     _screenScaleAnimation =
//         Tween<double>(begin: 1, end: 24).animate(_screenScaleController)
//           ..addStatusListener((status) {
//             if (status == AnimationStatus.completed) {
//               Navigator.pushReplacement(
//                   context,
//                   PageTransition(
//                       child: const LoginScreen(),
//                       type: PageTransitionType.fade));
//             }
//           });
//   }

//   @override
//   void initState() {
//     _initButtonScale();
//     _initScreenScale();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _buttonScaleController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     _initButtonWidth(screenWidth);
//     _initPositioned(screenWidth);

//     return CupertinoPageScaffold(
//       backgroundColor: CupertinoColors.secondarySystemFill,
//       child: Stack(
//         children: [
//           const ShapeImagePositioned(),
//           const ShapeImagePositioned(top: -100),
//           const ShapeImagePositioned(top: -150),
//           const ShapeImagePositioned(top: -200),
//           Container(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 const Text(
//                   'Welcome ',
//                   style: TextStyle(
//                     color: CupertinoColors.white,
//                     fontSize: 50,
//                     fontWeight: FontWeight.bold,
//                     decoration: TextDecoration.none,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Text(
//                   'Fentons Medical Bill Claim System',
//                   style: TextStyle(
//                     color: CupertinoColors.white.withOpacity(.8),
//                     fontSize: 30,
//                     height: 1.5,
//                     decoration: TextDecoration.none,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 100,
//                 ),
//                 AnimatedBuilder(
//                   animation: _buttonScaleController,
//                   builder: (_, child) => Transform.scale(
//                     scale: _buttonScaleAnimation.value,
//                     child: CupertinoButton(
//                       onPressed: () {
//                         _buttonScaleController.forward();
//                       },
//                       child: Stack(
//                         children: [
//                           AnimatedBuilder(
//                             animation: _buttonWidthController,
//                             builder: (_, child) => Container(
//                               height: _buttonWidth,
//                               width: _buttonWidthAnimation.value,
//                               decoration: BoxDecoration(
//                                 color: const Color.fromARGB(255, 65, 84, 193)
//                                     .withOpacity(.7),
//                                 borderRadius: BorderRadius.circular(50),
//                               ),
//                             ),
//                           ),
//                           AnimatedBuilder(
//                             animation: _positionedController,
//                             builder: (_, child) => Positioned(
//                               top: 10,
//                               left: _positionedAnimation.value,
//                               child: AnimatedBuilder(
//                                 animation: _screenScaleController,
//                                 builder: (_, child) => Transform.scale(
//                                   scale: _screenScaleAnimation.value,
//                                   child: Container(
//                                     height: _buttonWidth - 20,
//                                     width: _buttonWidth - 20,
//                                     decoration: const BoxDecoration(
//                                       color: Color.fromARGB(255, 197, 115,
//                                           15), // comment if not wanted
//                                       shape: BoxShape.circle,
//                                     ),
//                                     alignment: Alignment.center,
//                                     child: _screenScaleController.isDismissed
//                                         ? const Icon(
//                                             CupertinoIcons.chevron_forward,
//                                             color: CupertinoColors.white,
//                                             size: 35,
//                                           )
//                                         : null,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: MediaQuery.of(context).padding.bottom + 20,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
