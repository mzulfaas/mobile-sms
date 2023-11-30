import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'ApiConstant.dart';
part 'User.g.dart';

@HiveType(typeId: 0) // Update typeId with an appropriate unique integer
class User {
  @HiveField(0)
  late int? id;
  @HiveField(1)
  late String? username;
  @HiveField(2)
  late String? password;
  @HiveField(3)
  late String? fullname;
  @HiveField(4)
  late String? level;
  @HiveField(5)
  late String? roles;
  @HiveField(6)
  late String? approvalRoles;
  @HiveField(7)
  late String? brand;
  @HiveField(8)
  late String? custSegment;
  @HiveField(9)
  late String? businessUnit;
  @HiveField(10)
  late String? token;
  @HiveField(11)
  late String? message;
  @HiveField(12)
  late int? code;
  @HiveField(13)
  late User? user;
  @HiveField(14)
  late dynamic so;

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
      this.so,
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
    so = json['so'];
  }

  // User();

  static Future<User> getUsers(
      String username, String password, int code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // http://localhost:65123/api/LoginSMS?playerId=d297d465-bba2-4dbb-9e16-8f9e72727f05
    String url = ApiConstant(code).urlApi + "api/LoginSMS?playerId=${prefs.getString("getPlayerID")}";
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
    print("apiResultLogin :${apiResult.statusCode}\n${apiResult.body}");
    User? _user;
    if(apiResult.statusCode==200){
      print("ini api result login : ${apiResult.statusCode}");
      print("ini api result login : ${apiResult.body}");
      print("ini data login : $dataLogin");
      dynamic jsonObject = apiResult.body;
      print("ini isi login $jsonObject");
      var data = jsonObject;
      // var data = jsonObject as Map<String, dynamic>;
       _user = User.fromJson(jsonDecode(data));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("username", _user.username!);
      prefs.setString("token", _user.token!);
      prefs.setInt("userid", _user.id!);
      prefs.setString("so", _user.so);
      print("ini username login : ${_user.username}");
      print("ini userid : ${_user.id}");
      return _user;
    }else{
      GetSnackBar(
        title: "Error",
        message: apiResult.body,
        backgroundColor: Colors.red,
      );
      // Exception('Failed to login');
    }
    return _user!;
  }
}
