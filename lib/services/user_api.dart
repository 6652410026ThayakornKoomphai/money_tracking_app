// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:money_tracking_app/constants/baseurl.dart';
import 'package:money_tracking_app/models/user.dart';

class UserApi {
  final Dio dio = Dio();

  Future<bool> registerUser(User user, File? userFile) async {
    try {
      //เอาข้อมูลใส่ FormData
      final formData = FormData.fromMap({
        'userFullName': user.userFullName,
        'userBirthDate': user.userBirthDate,
        'userName': user.userName,
        'userPassword': user.userPassword,
        if (userFile != null)
          'userImage': await MultipartFile.fromFile(
            userFile.path,
            filename: userFile.path.split('/').last,
            contentType: DioMediaType('image', userFile.path.split('.').last),
          ),
      });

      //เอาข้อมูลใน FormData ส่งผ่าน API ตาม Endpoint ที่ได้กำหนดไว้
      final responseData = await dio.post(
        '${baseUrl}/user/',
        data: formData,
        options: Options(headers: {'Content-type': 'multipart/from-data'}),
      );
      //หลังจากทำงานเสร็จ ณ ทีนี้ตรวจสอบผลการทำงานจาก responseData
      if (responseData.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  Future<User> checkLogin(User user) async {
    try {
      final responseData = await dio.get(
        '${baseUrl}/user/${user.userName}/${user.userPassword}',
      );
      //หลังจากทำงานเสร็จ ณ ที่นี้ตรวจสอบผลการทำงานจาก responseData
      if (responseData.statusCode == 200) {
        return User.fromJson(responseData.data['info']);
      } else {
        return User();
      }
    } catch (e) {
      print('Exception: $e');
      return User();
    }
  }
}
