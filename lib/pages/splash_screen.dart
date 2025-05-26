import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/pages/navigation_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset(
        'assets/images/imgWithLogo.png',
        width: 0,
        height: 0,
      ),
      backgroundImage: AssetImage('assets/images/imgWithLogo.png'),
      gradientBackground: LinearGradient(
        colors: [Color(0xFFA8DEFF), Color.fromARGB(255, 56, 179, 255)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      showLoader: false,
      // loadingText: Text("Loading..."),
      navigator: DefaultNavPage(),
      durationInSeconds: 4,
    );
  }
}
