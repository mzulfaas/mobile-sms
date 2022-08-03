import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ApiConstant.dart';
import 'Lines.dart';

class Promosi {
  int id;
  String nomorPP;
  String namePP;
  String date;
  String group;
  String idProduct;
  String product;
  String idCustomer;
  String customer;
  String fromDate;
  String toDate;
  // DateTime fromDates;

  double qty;
  double qtyTo;
  String disc1;
  String disc2;
  String disc3;
  String disc4;
  String value1;
  String value2;
  String suppQty;
  String suppItem;
  String salesOffice;
  String businessUnit;
  String price;
  String totalAmount;
  bool status;
  String unitId;
  int codeError;
  String message;
  String suppUnit;
  String ppType;

  Promosi(
      {this.id,
      this.nomorPP,
      this.namePP,
      this.date,
      this.group,
      this.idProduct,
      this.product,
      this.idCustomer,
      this.customer,
      this.fromDate,
      this.toDate,
      // this.fromDates,
      this.qty,
      this.qtyTo,
      this.disc1,
      this.disc2,
      this.disc3,
      this.disc4,
      this.value1,
      this.value2,
      this.suppQty,
      this.suppUnit,
      this.suppItem,
      this.salesOffice,
      this.businessUnit,
      this.price,
      this.totalAmount,
      this.status,
      this.unitId,
      this.codeError,
      this.ppType,
      this.message});

  Promosi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nomorPP = json['nomorPP'];
    namePP = json['namePP'];
    date = json['date'];
    group = json['group'];
    idProduct = json['idProduct'];
    product = json['product'];
    idCustomer = json['idCustomer'];
    customer = json['customer'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    // fromDates = DateTime.parse(json['fromDate']);
    qty = json['qty'];
    qtyTo = json['qtyTo'];
    disc1 = json['disc1'];
    disc2 = json['disc2'];
    disc3 = json['disc3'];
    disc4 = json['disc4'];
    value1 = json['value1'];
    value2 = json['value2'];
    suppQty = json['suppQty'];
    suppItem = json['suppItem'];
    suppUnit = json['suppUnit'];
    salesOffice = json['salesOffice'];
    businessUnit = json['businessUnit'];
    price = json['price'];
    totalAmount = json['totalAmount'];
    status = json['status'];
    unitId = json['unitId'];
    codeError = json['codeError'];
    message = json['message'];
    ppType = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nomorPP'] = this.nomorPP;
    data['namePP'] = this.namePP;
    data['date'] = this.date;
    data['group'] = this.group;
    data['idProduct'] = this.idProduct;
    data['product'] = this.product;
    data['idCustomer'] = this.idCustomer;
    data['customer'] = this.customer;
    data['qty'] = this.qty;
    data['qtyTo'] = this.qtyTo;
    data['disc1'] = this.disc1;
    data['disc2'] = this.disc2;
    data['disc3'] = this.disc3;
    data['disc4'] = this.disc4;
    data['value1'] = this.value1;
    data['value2'] = this.value2;
    data['salesOffice'] = this.salesOffice;
    data['businessUnit'] = this.businessUnit;
    data['price'] = this.price;
    data['totalAmount'] = this.totalAmount;
    data['status'] = this.status;
    data['unitId'] = this.unitId;
    data['codeError'] = this.codeError;
    data['message'] = this.message;
    data['suppQty'] = this.suppQty;
    data['qtyTo'] = this.qtyTo;
    data['suppItem'] = this.suppItem;
    data['suppUnit'] = this.suppUnit;
    data['type'] = this.ppType;
    return data;
  }



  //http://119.18.157.236:8869/api/PromosiHeader?username=rp004&userId=9
  static Future<List<Promosi>> getListPromosi(
      int id, int code, String token, String username) async {
    print(token);
    dynamic userId;
    // String url = ApiConstant(code).urlApi + "api/PromosiHeader/" + id.toString() + "?username=" + username;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = ApiConstant(code).urlApi + "api/PromosiHeader?username=${prefs.getString("username")}&userId=${prefs.getInt('userid')}";
    print("ini url getListPromosi: $url");

    var dio = Dio();
    dio.options.headers['Authorization'] = token;
    Response response = await dio.get(url);
    var jsonObject = response.data;
    List<Promosi> models = [];
    for (var promosi in jsonObject) {
      var objects = Promosi.fromJson(promosi as Map<String, dynamic>);
      models.add(objects);
    }
    return models;
  }

  static Future<List<Promosi>> getAllListPromosi(
      int id, int code, String token, String username) async {
    print(token);
    dynamic userId;
    // String url = ApiConstant(code).urlApi + "api/PromosiHeader/" + id.toString() + "?username=" + username;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = ApiConstant(code).urlApi + "api/Promosi?username=$username&userId=${prefs.getInt('userid')}";
    print("ini url getAllListPromosi: $url");

    var dio = Dio();
    dio.options.headers['Authorization'] = token;
    Response response = await dio.get(url);
    var jsonObject = response.data;
    List<Promosi> models = [];
    for (var promosi in jsonObject) {
      var objects = Promosi.fromJson(promosi as Map<String, dynamic>);
      models.add(objects);
    }
    return models;
  }

  var promosiLength;

  static Future<List<Promosi>> getListLines(
      String nomorPP, int code, String token, String username) async {
    String url = ApiConstant(code).urlApi +
        "api/PromosiLines/" +
        nomorPP +
        "?username=" +
        username;
    print(token);
    print("ini url listLines :$url");

    var dio = Dio();
    dio.options.headers['Authorization'] = token;
    Response response = await dio.get(url);
    var jsonObject = response.data;
    var promosiLength = response.data;
    print(jsonObject);
    List<Promosi> models = [];
    for (var salesOrder in jsonObject) {
      var objects = Promosi.fromJson(salesOrder as Map<String, dynamic>);
      models.add(objects);
    }
    return models;
  }

  // api/SalesOrder?idProduct={idProduct}&idCustomer={idCustomer}
  static Future<List<Promosi>> getListSalesOrder(String idProduct,
      String idCustomer, int code, String token, String username) async {
    String url = ApiConstant(code).urlApi +
        "api/SalesOrder?idProduct=" +
        idProduct +
        "&idCustomer=" +
        idCustomer +
        "&username=" +
        username;
    print("ini url listSalesOrder :$url");

    var dio = Dio();
    dio.options.headers['Authorization'] = token;
    Response response = await dio.get(url);
    var jsonObject = response.data;
    List<Promosi> models = [];
    for (var salesOrder in jsonObject) {
      var objects = Promosi.fromJson(salesOrder as Map<String, dynamic>);
      models.add(objects);
    }
    return models;
  }

  // static Future<Promosi> approveSalesOrder(String nomorPP, int code) async {
  static Future<Promosi> approveSalesOrder(
      List<Lines> listLines, int code) async {
    String url = ApiConstant(code).urlApi + "api/PromosiHeader/";
    var dio = Dio();
    dio.options.headers['content-type'] = 'application/json';
    var jsonData = jsonEncode(
        {"listLines": listLines.map((f) => f.toJsonDisc()).toList()});

    var apiResult = await http.post(
      Uri.parse(url),
      body: jsonData,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    dynamic jsonObject = json.decode(apiResult.body);
    var data = jsonObject as Map<String, dynamic>;
    Promosi _promosi = Promosi.fromJson(data);
    return _promosi;
  }
}
