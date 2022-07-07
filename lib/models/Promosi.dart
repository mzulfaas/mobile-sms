import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

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
  String disc;
  String salesOffice;
  String businessUnit;
  String price;
  String totalAmount;
  bool status;
  String unitId;
  int codeError;
  String message;

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
      this.disc,
      this.salesOffice,
      this.businessUnit,
      this.price,
      this.totalAmount,
      this.status,
      this.unitId,
      this.codeError,
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
    disc = json['disc'];
    salesOffice = json['salesOffice'];
    businessUnit = json['businessUnit'];
    price = json['price'];
    totalAmount = json['totalAmount'];
    status = json['status'];
    unitId = json['unitId'];
    codeError = json['codeError'];
    message = json['message'];
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
    data['disc'] = this.disc;
    data['salesOffice'] = this.salesOffice;
    data['businessUnit'] = this.businessUnit;
    data['price'] = this.price;
    data['totalAmount'] = this.totalAmount;
    data['status'] = this.status;
    data['unitId'] = this.unitId;
    data['codeError'] = this.codeError;
    data['message'] = this.message;
    return data;
  }

  static Future<List<Promosi>> getListPromosi(
      int id, int code, String token, String username) async {
    String url = ApiConstant(code).urlApi +
        "api/PromosiHeader/" +
        id.toString() +
        "?username=" +
        username;
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

  static Future<List<Promosi>> getListLines(
      String nomorPP, int code, String token, String username) async {
    String url = ApiConstant(code).urlApi +
        "api/PromosiLines/" +
        nomorPP +
        "?username=" +
        username;
    print("ini url listLines :$url");

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
      headers: {'content-type': 'application/json'},
    );

    dynamic jsonObject = json.decode(apiResult.body);
    var data = jsonObject as Map<String, dynamic>;
    Promosi _promosi = Promosi.fromJson(data);
    return _promosi;
  }
}
