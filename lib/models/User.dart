import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ApiConstant.dart';

part 'User.g.dart';

@HiveType()
class User {
  @HiveField(0)
  int id;
  @HiveField(1)
  String username;
  @HiveField(2)
  String password;
  @HiveField(3)
  String fullname;
  @HiveField(4)
  String level;
  @HiveField(5)
  String roles;
  @HiveField(6)
  String approvalRoles;
  @HiveField(7)
  String brand;
  @HiveField(8)
  String custSegment;
  @HiveField(9)
  String businessUnit;
  @HiveField(10)
  String token;
  @HiveField(11)
  String message;
  @HiveField(12)
  int code;
  @HiveField(13)
  User user;

  User(
      {this.id,
      this.username,
      this.password,
      this.fullname,
      this.level,
      this.roles,
      this.approvalRoles,
      this.brand,
      this.custSegment,
      this.businessUnit,
      this.token,
      this.message,
      this.code,
      this.user});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
    fullname = json['fullname'];
    level = json['level'];
    roles = json['roles'];
    approvalRoles = json['approvalRoles'];
    brand = json['brand'];
    custSegment = json['custSegment'];
    businessUnit = json['businessUnit'];
    token = json['token'];
    message = json['message'];
    code = json['code'];
    user = json['user'];
  }

  // User();

  static Future<User> getUsers(
      String username, String password, int code) async {
    String url = ApiConstant(code).urlApi + "api/LoginSMS";
    print("ini url login $url");
    dynamic dataLogin = {
      "username": username,
      "password": password
    };
    final apiResult = await post(
      Uri.parse(url),
      headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',},
      body: jsonEncode(dataLogin),
    );
    if(apiResult.statusCode==200){
      print("ini api result login : ${apiResult.statusCode}");
      print("ini api result login : ${apiResult.body}");
      print("ini data login : $dataLogin");
      dynamic jsonObject = apiResult.body;
      print("ini isi login $jsonObject");
      var data = jsonObject;
      // var data = jsonObject as Map<String, dynamic>;
      User _user = User.fromJson(jsonDecode(data));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("username", _user.username);
      prefs.setString("token", _user.token);
      print("ini username login : ${_user.username}");
      return _user;
    }else{
      Exception('Failed to login');
    }
  }

  // static Future<User> getUsers(
  //     String username, String password, int code) async {
  //   Response apiResult;
  //   String url = ApiConstant(code).urlApi + "api/LoginSMS";
  //   print("ini url login $url");
  //
  //   try {
  //     var dio = Dio();
  //     dio.options.headers['content-type'] = 'application/json';
  //     dynamic dataLogin = {
  //       "username": username,
  //       "password": password
  //     },
  //     apiResult = await dio.post(url, data: dataLogin,).timeout(Duration(minutes: 5));
  //     print("ini api result login : ${apiResult.statusCode}");
  //     print("ini api result login : ${apiResult.body}");
  //     print("ini data login : $dataLogin");
  //   }
  //   on TimeoutException catch (_) {
  //     throw "Time out. Please reload.";
  //   } on SocketException catch (_) {
  //     throw "No Connection. Please connect to Internet.";
  //   } on HttpException catch (_) {
  //     throw "No Connection. Please connect to Internet.";
  //   } catch (_) {
  //     throw "Username and Password invalid.";
  //   }
  //
  //   dynamic jsonObject = apiResult.data;
  //   print("ini isi login $jsonObject");
  //   var data = jsonObject as Map<String, dynamic>;
  //   User _user = User.fromJson(data);
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString("username", _user.username);
  //   prefs.setString("token", _user.token);
  //   print("ini username login : ${_user.username}");
  //   return _user;
  // }

  // static Future<User> getUserNOTPassword(String username, int code) async {
  //   var apiResult;

  //   String url =
  //       ApiConstant(code).urlApi + "api/hujanlogin?username=" + username;
  //   try {
  //     apiResult = await http.get(url).timeout(Duration(minutes: 5));
  //   } on TimeoutException catch (_) {
  //     throw "Time out. Please reload.";
  //   } on HttpException catch (_) {
  //     throw "No Connection. Please connect to Internet.";
  //   }
  //   var jsonObject = json.decode(apiResult.body);
  //   var data = jsonObject as Map<String, dynamic>;
  //   return User.convertUser(data);
  // }
}
