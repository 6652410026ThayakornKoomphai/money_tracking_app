import 'package:flutter/material.dart';
import 'package:money_tracking_app/constants/color_constants.dart';
import 'package:money_tracking_app/views/login_ui.dart';
import 'package:money_tracking_app/views/register_ui.dart';

class WelcomeUI extends StatefulWidget {
  const WelcomeUI({super.key});

  @override
  State<WelcomeUI> createState() => _WelcomeUIState();
}

class _WelcomeUIState extends State<WelcomeUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Image.asset('assets/images/man.png', width: 300, height: 400),
            SizedBox(height: 40),
            Text(
              '      บันทึก'
              '\nรายรับรายจ่าย',
              style: TextStyle(
                color: Color(mainColor),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginUI()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(mainColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text(
                'เริ่มต้นใช้งานแอปพลิเคชัน',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ยังไม่ได้ลงทะเบียน?',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterUI()),
                    );
                  },
                  child: Text(
                    'ลงทะเบียน',
                    style: TextStyle(color: Color(mainColor), fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
