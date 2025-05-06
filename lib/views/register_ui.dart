import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_tracking_app/components/custom_button.dart';
import 'package:money_tracking_app/constants/color_constants.dart';
import 'package:money_tracking_app/models/user.dart';
import 'package:money_tracking_app/services/user_api.dart';

class RegisterUI extends StatefulWidget {
  const RegisterUI({super.key});

  @override
  State<RegisterUI> createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  TextEditingController birthdayController = TextEditingController();
  TextEditingController userFullNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  bool isVisible = true;

  DateTime? selectedDate;

  File? userFile;
  Future<void> openCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    //ตรวจสอบว่าได้ถ่ายมั้ย
    if (image == null) return;

    //หากถ่ายให้เอารูปที่ถ่ายไปเก็บในตัวแปรที่สร้างไว้
    //โดยการแปลงรูปที่ถ่ายเป็นไฟล์
    setState(() {
      userFile = File(image.path);
    });
  }

  //เปิด Calendar เพื่อเลือกวันเกิด
  Future<void> selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        birthdayController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  showWarningSnackBar(msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Align(alignment: Alignment.center, child: Text('$msg')),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  showCompleteSnackBar(msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Align(alignment: Alignment.center, child: Text('$msg')),
        backgroundColor: const Color.fromARGB(255, 64, 212, 64),
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
                          'ลงทะเบียน',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 40),
                    // Balance the back button
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
                    Text(
                      'ข้อมูลผู้ใช้งาน',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        await openCamera();
                      },
                      child:
                          userFile == null
                              ? Icon(
                                Icons.person_add_alt_1,
                                size: 150,
                                color: Color(mainColor),
                              )
                              : Image.file(
                                userFile!,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                    ),
                    TextField(
                      controller: userFullNameController,
                      decoration: InputDecoration(
                        labelText: 'ชื่อ-นามสกุล',
                        border: OutlineInputBorder(),
                        hintText: 'YOUR NAME',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 40),
                    TextField(
                      controller: birthdayController,
                      decoration: InputDecoration(
                        labelText: 'วัน-เดือน-ปีเกิด',
                        border: OutlineInputBorder(),
                        hintText: 'YOUR BIRTHDAY',
                        hintStyle: TextStyle(color: Colors.grey),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              selectDate();
                            });
                          },
                          icon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    TextField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        labelText: 'ชื่อผู้ใช้',
                        border: OutlineInputBorder(),
                        hintText: 'USERNAME',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 40),
                    TextField(
                      controller: userPasswordController,
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
                    SizedBox(height: 40),
                    CustomButton(
                      text: 'บันทึกการลงทะเบียน',
                      onPressed: () async {
                        if (userFullNameController.text.isEmpty) {
                          showWarningSnackBar('กรุณากรอกชื่อ-นามสกุล');
                        } else if (birthdayController.text.isEmpty) {
                          showWarningSnackBar('กรุณากรอกวันเกิด');
                        } else if (userNameController.text.isEmpty) {
                          showWarningSnackBar('กรุณากรอกชื่อผู้ใช้');
                        } else if (userPasswordController.text.isEmpty) {
                          showWarningSnackBar('กรุณากรอกรหัสผ่าน');
                        } else {
                          User user = User(
                            userFullName: userFullNameController.text.trim(),
                            userBirthDate: birthdayController.text.trim(),
                            userName: userNameController.text.trim(),
                            userPassword: userPasswordController.text.trim(),
                          );
                          if (await UserApi().registerUser(user, userFile)) {
                            showCompleteSnackBar('ลงทะเบียนเรียบร้อยแล้ว');
                          } else {
                            showCompleteSnackBar('ลงทะเบียนไม่สำเร็จ');
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
