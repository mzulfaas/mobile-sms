import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:mobile_sms/models/activity.dart';
import 'package:mobile_sms/models/create-promosi.dart';
import 'package:mobile_sms/models/promotion-program-input-state.dart';
import 'package:mobile_sms/view/HistoryNomorPP.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputPagePresenter extends GetxController {

  List<PromotionProgramInputState> controllerLinesinput;

  RxList cardsItem = [].obs;

  void addCardsItem(Widget widget){
    cardsItem.add(widget);
    valCustomer.add(Rx<String>(null));
    valCustomerChoice.add(Rx<String>(null));
    valItemGroup.add(Rx<String>(null));
    valChoiceItemGroup.add(Rx<String>(null));

    update();
  }

  void removeCardsItem(int index){
    cardsItem.remove(cardsItem[index]);
    valCustomer.remove(valCustomer[index]);
    valCustomerChoice.remove(valCustomerChoice[index]);
    valItemGroup.remove(valItemGroup[index]);
    valChoiceItemGroup.remove(valChoiceItemGroup[index]);
    update();
  }

  List valCustomer = [].obs;
  // var valCustomer = Rx<String>(null);
  RxList dataCustomer = [
    {
      "id": "1",
      "name": "Customer",
    },
    {"id": "2", "name": "Disc Group"}
  ].obs;

  void getCustomer() async {
    var listData = [];
    print("ini url getCustomer");
    dataCustomer.value = listData;
    update();
    if (!customerContains(valCustomer)) {
      valCustomer = null;
    }
    update();
  }

  bool customerContains(var customer) {
    for (int i = 0; i < dataCustomer.length; i++) {
      if (customer == dataCustomer[i]["name"]) return true;
    }
    update();
    return false;
  }


  var valCurrency = Rx<String>(null);
  RxList dataCurrency = [
    {
      "id": "1",
      "name": "IDR",
    },
    {"id": "2", "name": "Dollar"}
  ].obs;

  void getCurrency() async {
    var listData = [];
    dataCurrency.value = listData;
    update();
    if (!currencyContains(valCurrency)) {
      valCurrency.value = null;
    }
    update();
  }

  bool currencyContains(Rx<String> currency) {
    for (int i = 0; i < dataCurrency.length; i++) {
      if (currency == dataCurrency[i]["name"]) return true;
    }
    update();
    return false;
  }

  var valStatusTesting = Rx<String>(null);
  RxList dataStatusTesting = [
    {
      "id": "1",
      "name": "Live",
    },
    {"id": "2", "name": "Testing"}
  ].obs;

  void getStatusTesting() async {
    var listData = [];
    dataStatusTesting.value = listData;
    update();
    if (!statusTestingContains(valStatusTesting)) {
      valStatusTesting.value = null;
    }
    update();
  }

  bool statusTestingContains(Rx<String> statustesting) {
    for (int i = 0; i < dataStatusTesting.length; i++) {
      if (statustesting == dataStatusTesting[i]["name"]) return true;
    }
    update();
    return false;
  }

  var valType = Rx<dynamic>(null);
  RxList dataType = [

  ].obs;

  void getType() async {
    var listData = [];
    dataType.value = listData;
    update();
    if (!typeContains(valType)) {
      valType.value = null;
    }
    update();
  }

  bool typeContains(Rx<String> type) {
    for (int i = 0; i < dataType.length; i++) {
      if (type == dataType[i]["name"]) return true;
    }
    update();
    return false;
  }

  List valItemGroup = [];
  RxList dataItemGroup = [
    {
      "id": "1",
      "name": "Item",
    },
    {"id": "2", "name": "Disc Group"}
  ].obs;

  void getItemGroup() async {
    var listData = [];
    print("ini url getItemGroup");
    dataItemGroup.value = listData;
    update();
    if (!itemGroupContains(valItemGroup)) {
      valItemGroup = null;
    }
    update();
  }

  bool itemGroupContains(List itemGroup) {
    for (int i = 0; i < dataItemGroup.length; i++) {
      if (itemGroup == dataItemGroup[i]["name"]) return true;
    }
    update();
    return false;
  }

  List valCustomerChoice = [].obs;
  RxList dataCustomerChoice = [].obs;

  void getCustomerChoice() async {
    var urlGetCustomerChoice =
        "http://119.18.157.236:8869/api/custtables?salesOffice=${valLocation.value}";
    final response = await get(Uri.parse(urlGetCustomerChoice));
    var listData = jsonDecode(response.body);
    print("ini url getCustomerChoice : $urlGetCustomerChoice");
    dataCustomerChoice.value = listData;
    update();
    if (!customerChoiceContains(valCustomerChoice)) {
      valCustomerChoice = null;
    }
    update();
    print("Data CustomerChoice : $listData");
  }

  bool customerChoiceContains(var choice) {
    for (int i = 0; i < dataCustomerChoice.length; i++) {
      if (choice == dataCustomerChoice[i]["nameCust"]) return true;
    }
    update();
    return false;
  }

  var valChoice = Rx<String>(null);
  RxList dataChoice = [].obs;

  void getChoice(String selected) async {
    if (selected == "Customer") {
      var urlGetCustomerChoice =
          "http://119.18.157.236:8869/api/custtables?salesOffice=${valLocation.value}";
      final response = await get(Uri.parse(urlGetCustomerChoice));
      var listData = jsonDecode(response.body);
      print("ini url getCustomerChoice : $urlGetCustomerChoice");
      dataChoice.value = listData;
      update();
      bool choiceContains(Rx<String> choice) {
        for (int i = 0; i < dataChoice.length; i++) {
          if (choice == dataChoice[i]["nameCust"]) return true;
        }
        update();
        return false;
      }

      if (!choiceContains(valChoice)) {
        valChoice.value = null;
      }
      update();
      print("Data CustomerChoice : $listData");
    } else if (selected == "Disc Group") {
      var urlGetDiscGroup = "http://119.18.157.236:8869/api/CustPriceDiscGroup";
      final response = await get(Uri.parse(urlGetDiscGroup));
      var listData = jsonDecode(response.body);
      print("ini url getDiscGroup : $urlGetDiscGroup");
      dataChoice.value = listData;
      update();
      bool discGroupContains(Rx<String> choice) {
        for (int i = 0; i < dataChoice.length; i++) {
          if (choice == dataChoice[i]["NAME"]) return true;
        }
        update();
        return false;
      }

      if (!discGroupContains(valChoice)) {
        valChoice.value = null;
      }
      update();
      print("Data DiscGroup : $listData");
    }
  }

  List valChoiceItemGroup = [].obs;
  RxList dataChoiceItemGroup = [].obs;

  void getChoiceItemGroup(String selected, String idCustomer) async {
    if (selected == "Item") {
      var urlGetChoiceItemGroup =
          "http://119.18.157.236:8878/api/product?idSales=rp004&idCustomer=${idCustomer.split(' ')[0]}&condition=1";
      print("ini url getCustomerChoiceItemGroup : $urlGetChoiceItemGroup");
      final response = await get(Uri.parse(urlGetChoiceItemGroup));
      var listData = jsonDecode(response.body);
      dataChoiceItemGroup.value = listData;
      update();
      bool choiceItemGroupContains(List choiceItemGroup) {
        for (int i = 0; i < dataChoiceItemGroup.length; i++) {
          if (choiceItemGroup == dataChoiceItemGroup[i]["idProduct"])
            return true;
        }
        update();
        return false;
      }

      if (!choiceItemGroupContains(valChoiceItemGroup)) {
        valChoiceItemGroup = null;
      }
      update();
      print("Data CustomerChoiceItemGroup : $listData");
    } else if (selected == "Disc Group") {
      var urlGetDiscGroup = "http://119.18.157.236:8869/api/CustPriceDiscGroup";
      final response = await get(Uri.parse(urlGetDiscGroup));
      var listData = jsonDecode(response.body);
      print("ini url getDiscGroup ItemGroup");
      dataChoiceItemGroup.value = listData;
      update();
      bool discGroupContains(List choice) {
        for (int i = 0; i < dataChoiceItemGroup.length; i++) {
          if (choice == dataChoiceItemGroup[i]["NAME"]) return true;
        }
        update();
        return false;
      }

      if (!discGroupContains(valChoiceItemGroup)) {
        valChoiceItemGroup = null;
      }
      update();
      print("Data DiscGroup ItemGroup : $listData");
    }
  }

  List valSupplyItem = [].obs;
  RxList dataSupplyItem = [].obs;

  void getSupplyItem(String selected, String idCustomer) async {
    if (selected == "Item") {
      var urlGetSupplyItem =
          "http://119.18.157.236:8878/api/product?idSales=rp004&idCustomer=${idCustomer.split(' ')[0]}&condition=1";
      print("ini url getSupplyItem : $urlGetSupplyItem");
      final response = await get(Uri.parse(urlGetSupplyItem));
      var listData = jsonDecode(response.body);
      dataSupplyItem.value = listData;
      update();
      bool supplyItemContains(List supplyItem) {
        for (int i = 0; i < dataSupplyItem.length; i++) {
          if (supplyItem == dataSupplyItem[i]["idProduct"]) return true;
        }
        update();
        return false;
      }

      if (!supplyItemContains(valSupplyItem)) {
        valSupplyItem = null;
      }
      update();
      print("Data CustomerChoiceItemGroup : $listData");
    } else if (selected == "Disc Group") {
      var urlGetDiscGroup = "http://119.18.157.236:8869/api/CustPriceDiscGroup";
      final response = await get(Uri.parse(urlGetDiscGroup));
      var listData = jsonDecode(response.body);
      print("ini url getDiscGroup ItemGroup");
      dataSupplyItem.value = listData;
      update();
      bool discGroupContains(List choice) {
        for (int i = 0; i < dataSupplyItem.length; i++) {
          if (choice == dataSupplyItem[i]["NAME"]) return true;
        }
        update();
        return false;
      }

      if (!discGroupContains(valSupplyItem)) {
        valSupplyItem = null;
      }
      update();
      print("Data DiscGroup ItemGroup : $listData");
    }
  }

  var valDiscGroup = Rx<String>(null);
  RxList dataDiscGroup = [].obs;

  void getDiscGroup() async {
    var urlGetDiscGroup = "http://119.18.157.236:8869/api/CustPriceDiscGroup";
    final response = await get(Uri.parse(urlGetDiscGroup));
    var listData = jsonDecode(response.body);
    print("ini url getDiscGroup");
    dataDiscGroup.value = listData;
    update();
    if (!discGroupContains(valDiscGroup)) {
      valDiscGroup.value = null;
    }
    update();
    print("Data DiscGroup : $listData");
  }

  bool discGroupContains(Rx<String> choice) {
    for (int i = 0; i < dataDiscGroup.length; i++) {
      if (choice == dataDiscGroup[i]["NAME"]) return true;
    }
    update();
    return false;
  }

  var valWarehouse = Rx<String>(null);
  RxList dataWarehouse = [].obs;

  void getWarehouse() async {
    var urlGetWarehouse = "http://119.18.157.236:8869/api/Warehouse";
    final response = await get(Uri.parse(urlGetWarehouse));
    var listData = jsonDecode(response.body);
    print("ini url getWarehouse :$urlGetWarehouse");
    dataWarehouse.value = listData;
    update();
    if (!warehouseContains(valWarehouse)) {
      valWarehouse.value = null;
    }
    update();
    print("Data Warehouse : $listData");
  }

  bool warehouseContains(Rx<String> warehouse) {
    for (int i = 0; i < dataWarehouse.length; i++) {
      if (warehouse == dataWarehouse[i]["NAME"]) return true;
    }
    update();
    return false;
  }

  var valUnit = Rx<String>(null);
  RxList dataUnit = [].obs;

  void getUnit(String item) async {
    print("item getUnit :$item");
    var urlGetUnit = "http://119.18.157.236:8878/api/Unit?item=${item.split(' ')[0]}";
    final response = await get(Uri.parse(urlGetUnit));
    var listData = jsonDecode(response.body);
    print("ini url getUnit :$urlGetUnit");
    dataUnit.value = listData;
    update();
    if (!unitContains(valUnit)) {
      valUnit.value = null;
    }
    update();
    print("Data Unit : $listData");
  }

  bool unitContains(Rx<String> unit) {
    for (int i = 0; i < dataUnit.length; i++) {
      if (unit == dataUnit[i]) return true;
    }
    update();
    return false;
  }

  var valLocation = Rx<String>(null);
  RxList dataLocation = [].obs;

  void getLocation() async {
    var urlGetLocation = "http://119.18.157.236:8869/api/SalesOffices";
    final response = await get(Uri.parse(urlGetLocation));
    var listData = jsonDecode(response.body);
    print("ini url getLocation");
    dataLocation.value = listData;
    update();
    if (!locationContains(valLocation)) {
      valLocation.value = null;
    }
    update();
    print("Data Location : $listData");
  }

  bool locationContains(Rx<String> location) {
    for (int i = 0; i < dataLocation.length; i++) {
      if (location == dataLocation[i]["NameSO"]) return true;
    }
    update();
    return false;
  }

  var valVendor = Rx<String>(null);
  RxList dataVendor = [].obs;

  void getVendor() async {
    var urlGetVendor = "http://119.18.157.236:8869/api/Vendors";
    final response = await get(Uri.parse(urlGetVendor));
    var listData = jsonDecode(response.body);
    print("ini url getVendor : $urlGetVendor");
    dataVendor.value = listData;
    update();
    if (!vendorContains(valVendor)) {
      valVendor.value = null;
    }
    update();
    print("Data Vendor : $listData");
  }

  bool vendorContains(Rx<String> vendor) {
    for (int i = 0; i < dataVendor.length; i++) {
      if (vendor == dataVendor[i]["VENDNAME"]) return true;
    }
    update();
    return false;
  }

  var valPercentValue = Rx<String>(null);
  RxList dataPercentValue = [
    {
      "id": "1",
      "name": "Percent",
    },
    {"id": "2", "name": "Value"}
  ].obs;

  void getPercentValue() async {
    var listData = [];
    dataPercentValue.value = listData;
    update();
    if (!percentValueContains(valPercentValue)) {
      valPercentValue.value = null;
    }
    update();
  }

  bool percentValueContains(Rx<String> percentvalue) {
    for (int i = 0; i < dataPercentValue.length; i++) {
      if (percentvalue == dataPercentValue[i]["name"]) return true;
    }
    update();
    return false;
  }

  var valMultiply = Rx<String>(null);
  RxList dataMultiply = [
    {
      "id": "1",
      "name": "No",
    },
    {"id": "2", "name": "Yes"}
  ].obs;

  void getMultiply() async {
    var listData = [];
    dataMultiply.value = listData;
    update();
    if (!multiplyContains(valMultiply)) {
      valMultiply.value = null;
    }
    update();
  }

  bool multiplyContains(Rx<String> multiply) {
    for (int i = 0; i < dataMultiply.length; i++) {
      if (multiply == dataMultiply[i]["name"]) return true;
    }
    update();
    return false;
  }

  successDialog(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(
              child: Text(
                "Success",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            content: Container(
              height: 250,
              child: Column(
                children: [
                  // Text("Distance Meter from Office   : $distanceInMeters"),
                  // Text("Meter : $meter"),
                  Text(
                    "Sukses",
                    style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          alignment: Alignment.bottomRight,
                          height: 100,
                          child: Column(
                            children: [
                              IconButton(
                                  icon: const Icon(
                                    Icons.map_outlined,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () async {
                                  }),
                              const Text(
                                "Track Gps\nLocation",
                                textAlign: TextAlign.center,
                              )
                            ],
                          )),
                      Container(
                        alignment: Alignment.bottomRight,
                        height: 30,
                        child: RaisedButton(
                            child: const Text("Submit\nAbsent"),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Activity activity = Activity();


  Future<Activity> submitProcess(
    int ppType,
    String ppName,
    String ppNum,
    String location,
    String vendor,
    String customer,
    String itemId,
    int qtyForm,
    int qtyTo,
    String unit,
    int multiply,
    String fromDate,
    String toDate,
    String currency,
    int type,
    double pct1,
    double pct2,
    double pct3,
    double pct4,
    String salesPrice,
    String priceTo,
    double value1,
    double value2,
    String supplyItem,
    int qtySupply,
    String unitSupply,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("username");
    String token = prefs.getString("token");
    final isiBody = jsonEncode(<String, dynamic>{
      "PPtype": ppType,
      "PPname": "$ppName",
      "PPnum": ppNum,
      "Location": "$location",
      "Vendor": "$vendor",
      "Lines": [
        {
          "Customer": "$customer",
          "ItemId": "$itemId",
          "QtyFrom": qtyForm,
          "QtyTo": qtyTo,
          "Unit": "$unit",
          "Multiply": multiply,
          "FromDate": "$fromDate",
          "ToDate": "$toDate",
          "Currency": "$currency",
          "type": type,
          "Pct1": pct1,
          "Pct2": pct2,
          "Pct3": pct3,
          "Pct4": pct4,
          "SupplyItem": "$supplyItem",
          "QtySupply": qtySupply,
          "UnitSupply": "$unitSupply",
          "SalesPrice": "$salesPrice",
          "PriceTo": "$priceTo",
          "Value1": value1.toDouble(),
          "Value2": value2,
        },
      ]
    });
    // final response = await post(
    //     Uri.parse('http://119.18.157.236:8869/api/activity?username=$username'),
    //     headers: {
    //       "Content-Type": "application/json",
    //       'Authorization': '$token',
    //     },
    //     body: isiBody
    // );
    print("ini token : $token");
    print("isi body: $isiBody");
    // print("status body : ${response.body}");
    // print("status submit : ${response.statusCode}");

    // Future.delayed(Duration(seconds: 2),(){
    //   if (response.statusCode == 201) {
    //     // If the server did return a 201 CREATED response,
    //     // then parse the JSON.
    //     Get.dialog(SimpleDialog(
    //       title: Text("Success"),
    //       children: [
    //         Center(
    //           child: CircularProgressIndicator(),
    //         )
    //       ],
    //     ));
    //     Get.offAll(HistoryNomorPP());
    //     return activity = Activity.fromJson(jsonDecode(response.body));
    //   } else {
    //     Get.dialog(SimpleDialog(
    //       title: Text("Error"),
    //       children: [
    //         Center(
    //           child: Text("${response.statusCode}\n${response.body.replaceAll(r"\'", "'")}",style: TextStyle(color: Colors.red),textAlign: TextAlign.center),
    //         ),
    //         Center(
    //           child: Icon(Icons.error),
    //         )
    //       ],
    //     ));
    //     Future.delayed(Duration(seconds: 2),(){
    //
    //     });
    //     // If the server did not return a 201 CREATED response,
    //     // then throw an exception.
    //     throw Exception('Failed to create Activity.');
    //   }
    // });
  }
}
