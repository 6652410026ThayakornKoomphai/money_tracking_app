import 'package:flutter/material.dart';
import 'package:money_tracking_app/constants/color_constants.dart';
import 'package:money_tracking_app/views/welcome_ui.dart';

class SplashScreenUI extends StatefulWidget {
  const SplashScreenUI({super.key});

  @override
  State<SplashScreenUI> createState() => _SplashScreenUIState();
}

class _SplashScreenUIState extends State<SplashScreenUI> {
  void initState() {
    Future.delayed(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeUI()),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(mainColor),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 300),
            Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                text: 'Money Tracking \n',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
                children: [
                  TextSpan(
                    text: 'รายรับ-รายจ่ายของฉัน',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 186, 186, 186),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
            Text(
              'Created by Thayakorn Koomphai \n DTI-SAU',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.yellowAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
