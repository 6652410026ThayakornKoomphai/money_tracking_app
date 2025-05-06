import 'package:flutter/material.dart';
import 'package:money_tracking_app/components/custom_button.dart';
import 'package:money_tracking_app/constants/color_constants.dart';
import 'package:money_tracking_app/models/user.dart';
import 'package:money_tracking_app/services/user_api.dart';
import 'package:money_tracking_app/views/home_ui.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  TextEditingController userNameCtrl = TextEditingController();
  TextEditingController userPasswordCtrl = TextEditingController();

  bool isVisible = true;

  showWarningSnackBar(msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Align(alignment: Alignment.center, child: Text('$msg')),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Color(mainColor),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'เข้าใช้งาน Money Tracking',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 40),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/man.png',
                      height: 300,
                      width: 300,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: userNameCtrl,
                      decoration: InputDecoration(
                        labelText: 'ชื่อผู้ใช้งาน',
                        border: OutlineInputBorder(),
                        hintText: 'USERNAME',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: userPasswordCtrl,
                      decoration: InputDecoration(
                        labelText: 'รหัสผ่าน',
                        border: OutlineInputBorder(),
                        hintText: 'PASSWORD',
                        hintStyle: TextStyle(color: Colors.grey),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                          icon: Icon(
                            isVisible == true
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      obscureText: isVisible,
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      text: 'เข้าใช้งาน',
                      onPressed: () async {
                        if (userNameCtrl.text.trim().isEmpty) {
                          showWarningSnackBar('กรุณากรอกชื่อผู้ใช้งาน');
                        } else if (userPasswordCtrl.text.trim().isEmpty) {
                          showWarningSnackBar('กรุณากรอกรหัสผ่าน');
                        } else {
                          User user = User(
                            userName: userNameCtrl.text.trim(),
                            userPassword: userPasswordCtrl.text.trim(),
                          );
                          user = await UserApi().checkLogin(user);
                          if (user.userID != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => (HomeUI(
                                      userName: user.userFullName,
                                      userImage: user.userImage,
                                      userID: int.parse(user.userID.toString()),
                                    )),
                              ),
                            );
                          } else {
                            showWarningSnackBar(
                              'ชื่อผู้ใช้งานหรือรหัสผ่านไม่ถูกต้อง',
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
