import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_tracking_app/views/login_ui.dart';
import 'package:money_tracking_app/views/splash_screen_ui.dart';

void main() {
  runApp(MoneyTrackingApp());
}

class MoneyTrackingApp extends StatefulWidget {
  const MoneyTrackingApp({super.key});

  @override
  State<MoneyTrackingApp> createState() => _MoneyTrackingAppState();
}

class _MoneyTrackingAppState extends State<MoneyTrackingApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenUI(),
      theme: ThemeData(
        textTheme: GoogleFonts.notoSansTextTheme(Theme.of(context).textTheme),
      ),
    );
  }
}
