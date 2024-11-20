import 'package:flutter/material.dart';
import 'package:sap_avicola/utils/config/router_config.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  final int splashDuration = 1500;

  @override
  void initState() {
    Future.delayed(
      Duration(milliseconds: splashDuration),
      () => router.go("/"),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(children: [
        // * background
        Container(
          alignment: Alignment.bottomCenter,
          decoration: const BoxDecoration(
            color: Color(0xFF000042),
            gradient: LinearGradient(colors: [
              Color(0xFF000042),
              Color(0xFF00003E),
            ]),
          ),
          child: Image.asset(
            "assets/images/bg_splash.png",
            fit: BoxFit.cover,
            width: size.width,
          ),
        ),

        // * logo
        Positioned(
          top: size.height * 0.33,
          left: 0,
          right: 0,
          child: Hero(
            tag: "logo demo",
            child: Image.asset(
              'assets/logos/logo.png',
              height: 150,
            ),
          ),
        ),
      ]),
    );
  }
}
