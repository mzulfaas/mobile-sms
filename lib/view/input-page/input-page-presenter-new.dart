import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:mobile_sms/ext/rx_ext.dart';
import 'package:mobile_sms/view/dashboard/DashboardPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/IdAndValue.dart';
import '../../models/Wrapper.dart';
import '../../models/input-page-wrapper.dart';
import '../../models/promotion-program-input-state.dart';
import '../HistoryNomorPP.dart';
import '../dashboard/dashboard_pp.dart';
import 'input-page-dropdown-state.dart';

class InputPagePresenterNew extends GetxController {
  Rx<InputPageWrapper> promotionProgramInputStateRx = InputPageWrapper(
    promotionProgramInputState: [],
    isAddItem: false
  ).obs;
  Rx<TextEditingController> programNumberTextEditingControllerRx = TextEditingController().obs;
  Rx<TextEditingController> programTestTextEditingControllerRx = TextEditingController().obs;
  Rx<TextEditingController> programNameTextEditingControllerRx = TextEditingController().obs;
  Rx<InputPageDropdownState<IdAndValue<String>>> promotionTypeInputPageDropdownStateRx = InputPageDropdownState<IdAndValue<String>>().obs;
  Rx<InputPageDropdownState<IdAndValue<String>>> locationInputPageDropdownStateRx = InputPageDropdownState<IdAndValue<String>>().obs;
  Rx<InputPageDropdownState<IdAndValue<String>>> vendorInputPageDropdownStateRx = InputPageDropdownState<IdAndValue<String>>().obs;
  Rx<InputPageDropdownState<String>> statusTestingInputPageDropdownStateRx = InputPageDropdownState<String>().obs;
  Rx<InputPageDropdownState<String>> customerGroupInputPageDropdownState = InputPageDropdownState<String>(
    choiceList: <String>[
      "Customer",
      /*"Disc Group"*/
    ],
    loadingState: 2
  ).obs;
  Rx<InputPageDropdownState<IdAndValue<String>>> custNameHeaderValueDropdownStateRx = InputPageDropdownState<IdAndValue<String>>().obs;
  InputPageDropdownState<String> _itemGroupInputPageDropdownState = InputPageDropdownState<String>(
    choiceList: <String>[
      "Item",
      "Disc Group"
    ],
    loadingState: 0
  );

  WrappedInputPageDropdownState<IdAndValue<String>> _warehouseInputPageDropdownState = WrappedInputPageDropdownState<IdAndValue<String>>(
    choiceListWrapper: Wrapper(value: <IdAndValue<String>>[]),
    loadingStateWrapper: Wrapper(value: 0),
    selectedChoiceWrapper: Wrapper(value: null)
  );
  InputPageDropdownState<IdAndValue<String>> _unitInputPageDropdownState = InputPageDropdownState<IdAndValue<String>>(
    choiceList: <IdAndValue<String>>[],
    loadingState: 0
  );
  InputPageDropdownState<IdAndValue<String>> _multiplyInputPageDropdownState = InputPageDropdownState<IdAndValue<String>>(
    choiceList: <IdAndValue<String>>[
      IdAndValue<String>(id: "0", value: "No"),
      IdAndValue<String>(id: "1", value: "Yes"),
    ],
    loadingState: 0,
  );
  InputPageDropdownState<String> _currencyInputPageDropdownState = InputPageDropdownState<String>(
    choiceList: <String>[
      "IDR",
      "Dollar"
    ],
    loadingState: 0
  );
  InputPageDropdownState<IdAndValue<String>> _percentValueInputPageDropdownState = InputPageDropdownState<IdAndValue<String>>(
    choiceList: <IdAndValue<String>>[
      IdAndValue<String>(id: "1", value: "Percent"),
      IdAndValue<String>(id: "2", value: "Value"),

      // "Percent",
      // "Value"
    ],
    loadingState: 0
  );

  @override
  void onInit() {
    super.onInit();
    promotionTypeInputPageDropdownStateRx.valueFromLast((value) => value.copy(
      choiceList: <IdAndValue<String>>[
        IdAndValue<String>(id: "1", value: "Diskon"),
        IdAndValue<String>(id: "2", value: "Bonus"),
        IdAndValue<String>(id: "3", value: "Sample"),
        IdAndValue<String>(id: "4", value: "Listing"),
        IdAndValue<String>(id: "5", value: "Rebate"),
        IdAndValue<String>(id: "6", value: "Rafraksi"),
        IdAndValue<String>(id: "7", value: "Gimmick"),
        IdAndValue<String>(id: "8", value: "Trading Term"),
        IdAndValue<String>(id: "9", value: "Diskon & Bonus"),
      ],
      loadingState: 2
    ));
    statusTestingInputPageDropdownStateRx.valueFromLast((value) => value.copy(
      choiceList: <String>[
        "Live",
        "Testing",
      ],
      loadingState: 2
    ));
    _multiplyInputPageDropdownState.selectedChoice = _multiplyInputPageDropdownState.choiceList[1];
    _currencyInputPageDropdownState.selectedChoice = _currencyInputPageDropdownState.choiceList[0];
    _loadLocation();
    _loadVendor();
    _loadWarehouse();
  }

  void _loadLocation() async {
    locationInputPageDropdownStateRx.value.loadingState = 1;
    _updateState();
    try {
      var urlGetLocation = "http://119.18.157.236:8869/api/SalesOffices";
      final response = await get(Uri.parse(urlGetLocation));
      var listData = jsonDecode(response.body);
      print("ini url getLocation : $urlGetLocation");
      locationInputPageDropdownStateRx.value.loadingState = 2;
      locationInputPageDropdownStateRx.value.choiceList = listData.map<IdAndValue<String>>((element) => IdAndValue<String>(id: element["CodeSO"], value: element["NameSO"])).toList();
    } catch (e) {
      locationInputPageDropdownStateRx.value.loadingState = -1;
      _updateState();
    }
  }

  void _loadVendor() async {
    vendorInputPageDropdownStateRx.value.loadingState = 1;
    _updateState();
    try {
      var urlGetVendor = "http://119.18.157.236:8869/api/Vendors";
      final response = await get(Uri.parse(urlGetVendor));
      var listData = jsonDecode(response.body);
      print("ini url getVendor : $urlGetVendor");
      print("status getVendor : ${response.statusCode}");
      vendorInputPageDropdownStateRx.value.loadingState = 2;
      vendorInputPageDropdownStateRx.value.choiceList = listData.map<IdAndValue<String>>((element) => IdAndValue<String>(id: element["ACCOUNTNUM"], value: element["VENDNAME"])).toList();
      _updateState();
    } catch (e) {
      vendorInputPageDropdownStateRx.value.loadingState = -1;
      _updateState();
    }
  }

  void checkAddItemStatus() {
    promotionProgramInputStateRx.value.isAddItem =
        // programNumberTextEditingControllerRx.value.text.isBlank == false
      /*&&*/ programNameTextEditingControllerRx.value.text.isBlank == false
      && promotionTypeInputPageDropdownStateRx.value.selectedChoice != null;
      // && vendorInputPageDropdownStateRx.value.selectedChoice != null;
      // && locationInputPageDropdownStateRx.value.selectedChoice != null
      // && statusTestingInputPageDropdownStateRx.value.selectedChoice != null;
    _updateState();
  }

  void _loadCustomerOrGroup(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    PromotionProgramInputState promotionProgramInputState = promotionProgramInputStateRx.value.promotionProgramInputState[index];
    InputPageDropdownState<IdAndValue<String>> locationGroupInputPageDropdownState = locationInputPageDropdownStateRx.value;
    InputPageDropdownState<String> customerGroupInputPageDropdownState = promotionProgramInputState.customerGroupInputPageDropdownState;
    InputPageDropdownState<IdAndValue<String>> customerNameOrDiscountGroupInputPageDropdownState = promotionProgramInputState.customerNameOrDiscountGroupInputPageDropdownState;
    String selectedChoice = customerGroupInputPageDropdownState.selectedChoice;
    if (selectedChoice == customerGroupInputPageDropdownState.choiceList[0]) {
      var urlGetCustomerChoice = "http://119.18.157.236:8869/api/custtables?salesOffice=${prefs.getString("so")/*locationGroupInputPageDropdownState.selectedChoice.id*/}";
      print("urlGetCustomerChoice :$urlGetCustomerChoice}");
      final response = await get(Uri.parse(urlGetCustomerChoice));
      var listData = jsonDecode(response.body);
      print("value urlGetCustomerChoice : $listData");
      customerNameOrDiscountGroupInputPageDropdownState.loadingState = 2;
      customerNameOrDiscountGroupInputPageDropdownState.choiceList = listData.map<IdAndValue<String>>(
        (element) => IdAndValue<String>(id: element["ACCOUNTNUM"], value: "${element["CUSTNAME"]}-${element["ACCOUNTNUM"]}-${element["CUSTNAME_ALIAS"]}")
      ).toList();
      _updateState();
    } else if (selectedChoice == customerGroupInputPageDropdownState.choiceList[1]) {
      var urlGetDiscGroup = "http://119.18.157.236:8869/api/CustPriceDiscGroup";
      final response = await get(Uri.parse(urlGetDiscGroup));
      var listData = jsonDecode(response.body);
      customerNameOrDiscountGroupInputPageDropdownState.loadingState = 2;
      customerNameOrDiscountGroupInputPageDropdownState.choiceList = listData.map<IdAndValue<String>>(
        (element) => IdAndValue<String>(id: element["GROUPID"].toString(), value: element["NAME"])
      ).toList();
      _updateState();
    }
  }

  void _loadCustomerOrGroupHeader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    InputPageDropdownState<IdAndValue<String>> locationGroupInputPageDropdownState = locationInputPageDropdownStateRx.value;
    print(customerGroupInputPageDropdownState.value.selectedChoice);
    String selectedChoice = customerGroupInputPageDropdownState.value.selectedChoice;
    if (selectedChoice == customerGroupInputPageDropdownState.value.choiceList[0]) {
      var urlGetCustomerChoice = "http://119.18.157.236:8869/api/custtables?salesOffice=${prefs.getString("so")/*locationGroupInputPageDropdownState.selectedChoice.id*/}";
      print("urlGetCustomerChoice :$urlGetCustomerChoice");
      final response = await get(Uri.parse(urlGetCustomerChoice));
      var listData = jsonDecode(response.body);
      custNameHeaderValueDropdownStateRx.value.loadingState = 2;
      custNameHeaderValueDropdownStateRx.value.choiceList = listData.map<IdAndValue<String>>(
              (element) => IdAndValue<String>(id: element["ACCOUNTNUM"], value: "${element["CUSTNAME"]}-${element["ACCOUNTNUM"]}-${element["CUSTNAME_ALIAS"]}")
      ).toList();
      _updateState();
    } else if (selectedChoice == customerGroupInputPageDropdownState.value.choiceList[1]) {
      print("object");
      var urlGetDiscGroup = "http://119.18.157.236:8869/api/CustPriceDiscGroup";
      final response = await get(Uri.parse(urlGetDiscGroup));
      var listData = jsonDecode(response.body);
      custNameHeaderValueDropdownStateRx.value.loadingState = 2;
      custNameHeaderValueDropdownStateRx.value.choiceList = listData.map<IdAndValue<String>>(
              (element) => IdAndValue<String>(id: element["GROUPID"].toString(), value: element["NAME"])
      ).toList();
      _updateState();
    }
  }

  void _loadProduct(int index) async {
    PromotionProgramInputState promotionProgramInputState = promotionProgramInputStateRx.value.promotionProgramInputState[index];
    InputPageDropdownState<IdAndValue<String>> customerNameOrDiscountGroupInputPageDropdownState = promotionProgramInputState.customerNameOrDiscountGroupInputPageDropdownState;
    InputPageDropdownState<String> itemGroupInputPageDropdownState = promotionProgramInputState.itemGroupInputPageDropdownState;
    InputPageDropdownState<IdAndValue<String>> selectProductPageDropdownState = promotionProgramInputState.selectProductPageDropdownState;
    String selectedChoice = itemGroupInputPageDropdownState.selectedChoice;
    if (selectedChoice == itemGroupInputPageDropdownState.choiceList[0]) {
      var urlGetProduct = "http://119.18.157.236:8869/api/PrbItemTables";
      // var urlGetProduct = "http://119.18.157.236:8878/api/product?idSales=rp004&idCustomer=${customerNameOrDiscountGroupInputPageDropdownState.selectedChoice.id}&condition=1";
      print("urlGetProduct : $urlGetProduct");
      final response = await get(Uri.parse(urlGetProduct));
      var listData = jsonDecode(response.body);
      selectProductPageDropdownState.loadingState = 2;
      selectProductPageDropdownState.choiceList = listData.map<IdAndValue<String>>(
        (element) => IdAndValue<String>(id: element["ITEMID"], value: "${element["ITEMID"]}-${element["ITEMNAME"]}-${element["PK_BRAND"]}-${element["PK_PACKING"]}")
      ).toList();
      _updateState();
    } else if (selectedChoice == itemGroupInputPageDropdownState.choiceList[1]) {
      var urlGetDiscGroup = "http://119.18.157.236:8869/api/ItemGroup";
      final response = await get(Uri.parse(urlGetDiscGroup));
      var listData = jsonDecode(response.body);
      selectProductPageDropdownState.loadingState = 2;
      selectProductPageDropdownState.choiceList = listData.map<IdAndValue<String>>(
        (element) => IdAndValue<String>(id: element["GROUPID"].toString(), value: element["NAME"])
      ).toList();
      _updateState();
    }
  }

  void _loadWarehouse() async {
    _warehouseInputPageDropdownState.loadingStateWrapper.value = 1;
    _updateState();
    var urlGetWarehouse = "http://119.18.157.236:8869/api/Warehouse";
    final response = await get(Uri.parse(urlGetWarehouse));
    var listData = jsonDecode(response.body);
    _warehouseInputPageDropdownState.loadingStateWrapper.value = 2;
    _warehouseInputPageDropdownState.choiceListWrapper.value = listData.map<IdAndValue<String>>(
      (element) => IdAndValue<String>(id: element["INVENTLOCATIONID"].toString(), value: element["NAME"])
    ).toList();
    _updateState();
  }

  void _loadUnit(int index) async {
    PromotionProgramInputState promotionProgramInputState = promotionProgramInputStateRx.value.promotionProgramInputState[index];
    InputPageDropdownState<IdAndValue<String>> selectProductPageDropdownState = promotionProgramInputState.selectProductPageDropdownState;
    InputPageDropdownState<String> unitPageDropdownState = promotionProgramInputState.unitPageDropdownState;
    unitPageDropdownState.loadingState = 1;
    _updateState();
    var urlGetUnit = "http://119.18.157.236:8878/api/Unit?item=${selectProductPageDropdownState.selectedChoice.id}";
    final response = await get(Uri.parse(urlGetUnit));
    var listData = jsonDecode(response.body);
    unitPageDropdownState.loadingState = 2;
    unitPageDropdownState.choiceList = listData.map<String>((element) {
      return element.toString();
    }).toList();
    _updateState();
  }

  void _loadSupplyItem(int index) async {
    PromotionProgramInputState promotionProgramInputState = promotionProgramInputStateRx.value.promotionProgramInputState[index];
    InputPageDropdownState<IdAndValue<String>> customerNameOrDiscountGroupInputPageDropdownState = promotionProgramInputState.customerNameOrDiscountGroupInputPageDropdownState;
    InputPageDropdownState<IdAndValue<String>> supplyItemPageDropdownState = promotionProgramInputState.supplyItem;
    // var urlGetSupplyItem = "http://119.18.157.236:8878/api/product?idSales=rp004&idCustomer=${custNameHeaderValueDropdownStateRx.value.selectedChoice.id}&condition=1";
    var urlGetSupplyItem = "http://119.18.157.236:8869/api/PrbItemTables";
    print("url supply item : ${urlGetSupplyItem}");
    final response = await get(Uri.parse(urlGetSupplyItem));
    var listData = jsonDecode(response.body);
    print(response.body);
    supplyItemPageDropdownState.loadingState = 2;
    supplyItemPageDropdownState.choiceList = listData.map<IdAndValue<String>>((element) => IdAndValue<String>(id: element["ITEMID"], value: element["ITEMNAME"])).toList();
    _updateState();
  }

  void _loadSupplyItemProductUnit(int index) async {
    PromotionProgramInputState promotionProgramInputState = promotionProgramInputStateRx.value.promotionProgramInputState[index];
    InputPageDropdownState<IdAndValue<String>> supplyItemInputPageDropdownState = promotionProgramInputState.supplyItem;
    InputPageDropdownState<String> unitSupplyItemInputPageDropdownState = promotionProgramInputState.unitSupplyItem;
    unitSupplyItemInputPageDropdownState.loadingState = 1;
    _updateState();
    var urlGetUnit = "http://119.18.157.236:8878/api/Unit?item=${supplyItemInputPageDropdownState.selectedChoice.id}";
    final response = await get(Uri.parse(urlGetUnit));
    var listData = jsonDecode(response.body);
    print("Response: ${jsonEncode(listData)}");
    unitSupplyItemInputPageDropdownState.loadingState = 2;
    unitSupplyItemInputPageDropdownState.choiceList = listData.map<String>((element) {
      return element.toString();
    }).toList();
    _updateState();
  }

  void changePromotionType(IdAndValue<String> selectedChoice) {
    print("promotionType :${selectedChoice.id}");
    promotionTypeInputPageDropdownStateRx.value.selectedChoice = selectedChoice;
    checkAddItemStatus();
  }

  void changeVendor(IdAndValue<String> selectedChoice) {
    vendorInputPageDropdownStateRx.value.selectedChoice = selectedChoice;
    checkAddItemStatus();

  }

  void changeLocation(IdAndValue<String> selectedChoice) {
    locationInputPageDropdownStateRx.value.selectedChoice = selectedChoice;
    print(locationInputPageDropdownStateRx.value.selectedChoice.value);
    checkAddItemStatus();
  }

  void changeStatusTesting(String selectedChoice) {
    statusTestingInputPageDropdownStateRx.value.selectedChoice = selectedChoice;
    checkAddItemStatus();
  }

  void addItem() {
    List<PromotionProgramInputState> promotionProgramInputState = promotionProgramInputStateRx.value.promotionProgramInputState;
    promotionProgramInputState.add(
      PromotionProgramInputState(
        customerGroupInputPageDropdownState: customerGroupInputPageDropdownState.value.copy(),
        customerNameOrDiscountGroupInputPageDropdownState: InputPageDropdownState<IdAndValue<String>>(),
        itemGroupInputPageDropdownState: _itemGroupInputPageDropdownState.copy(),
        selectProductPageDropdownState: InputPageDropdownState<IdAndValue<String>>(
          choiceList: [],
          loadingState: 0
        ),
        wareHousePageDropdownState: _warehouseInputPageDropdownState.copy(
          choiceListWrapper: _warehouseInputPageDropdownState.choiceListWrapper,
          loadingStateWrapper: _warehouseInputPageDropdownState.loadingStateWrapper,
          selectedChoiceWrapper: Wrapper<IdAndValue<String>>(value: null)
        ),
        qtyFrom: TextEditingController(),
        qtyTo: TextEditingController(),
        unitPageDropdownState: InputPageDropdownState<String>(
          choiceList: [],
          loadingState: 0
        ),
        multiplyInputPageDropdownState: _multiplyInputPageDropdownState.copy(),
        currencyInputPageDropdownState: _currencyInputPageDropdownState.copy(),
        percentValueInputPageDropdownState: _percentValueInputPageDropdownState.copy(),
        fromDate: TextEditingController(),
        toDate: TextEditingController(),
        percent1: TextEditingController(),
        percent2: TextEditingController(),
        percent3: TextEditingController(),
        percent4: TextEditingController(),
        salesPrice: TextEditingController(),
        priceToCustomer: TextEditingController(),
        value1: TextEditingController(),
        value2: TextEditingController(),
        supplyItem: InputPageDropdownState<IdAndValue<String>>(
          choiceList: [],
          loadingState: 0
        ),
        qtyItem: TextEditingController(),
        unitSupplyItem: InputPageDropdownState<String>(
          choiceList: [],
          loadingState: 0
        ),
      )
    );
    _updateState();
  }

  void removeItem(int index) {
    promotionProgramInputStateRx.value.promotionProgramInputState.removeAt(index);
    _updateState();
  }

  void changeCustomerGroup(int index, String selectedChoice) {
    promotionProgramInputStateRx.value.promotionProgramInputState[index]
      .customerGroupInputPageDropdownState.selectedChoice = selectedChoice;
    _updateState();
    _loadCustomerOrGroup(index);
  }

  void changeCustomerGroupHeader(String selectedChoice) {
    print("selectedChoice : $selectedChoice");
    customerGroupInputPageDropdownState.value.selectedChoice = selectedChoice;
    _loadCustomerOrGroupHeader();
    _updateState();
  }

  void changeCustomerNameOrDiscountGroup(int index, IdAndValue<String> selectedChoice) {
    PromotionProgramInputState promotionProgramInputState = promotionProgramInputStateRx.value.promotionProgramInputState[index];
    InputPageDropdownState<IdAndValue<String>> customerNameOrDiscountGroupInputPageDropdownState = promotionProgramInputState.customerNameOrDiscountGroupInputPageDropdownState;
    customerNameOrDiscountGroupInputPageDropdownState.selectedChoice = selectedChoice;
    _updateState();
    _loadSupplyItem(index);
  }

  void changeCustomerNameOrDiscountGroupHeader(IdAndValue<String> selectedChoice) {
    // PromotionProgramInputState promotionProgramInputState = promotionProgramInputStateRx.value.promotionProgramInputState[index];
    // custNameHeaderValueDropdownStateRx.value.selectedChoice = selectedChoice;
    custNameHeaderValueDropdownStateRx.value.selectedChoice = selectedChoice;
    _updateState();
  }

  void changeItemGroup(int index, String selectedChoice) {
    promotionProgramInputStateRx.value.promotionProgramInputState[index]
      .itemGroupInputPageDropdownState.selectedChoice = selectedChoice;
    _updateState();
    _loadProduct(index);
  }

  void changeProduct(int index, IdAndValue<String> selectedChoice) {
    promotionProgramInputStateRx.value.promotionProgramInputState[index]
      .selectProductPageDropdownState.selectedChoice = selectedChoice;
    _loadUnit(index);
    _loadSupplyItem(index);
    _updateState();
  }

  void changeWarehouse(int index, IdAndValue<String> selectedChoice) {
    promotionProgramInputStateRx.value.promotionProgramInputState[index]
      .wareHousePageDropdownState.selectedChoiceWrapper.value = selectedChoice;
    _updateState();
  }

  void changeUnit(int index, String selectedChoice) {
    promotionProgramInputStateRx.value.promotionProgramInputState[index]
      .unitPageDropdownState.selectedChoice = selectedChoice;
    _updateState();
  }

  void changeMultiply(int index, IdAndValue<String> selectedChoice) {
    promotionProgramInputStateRx.value.promotionProgramInputState[index]
      .multiplyInputPageDropdownState.selectedChoice = selectedChoice;
    _updateState();
  }

  void changeCurrency(int index, String selectedChoice) {
    promotionProgramInputStateRx.value.promotionProgramInputState[index]
      .currencyInputPageDropdownState.selectedChoice = selectedChoice;
    _updateState();
  }

  void changePercentValue(int index, IdAndValue<String> selectedChoice) {
    promotionProgramInputStateRx.value.promotionProgramInputState[index]
      .percentValueInputPageDropdownState.selectedChoice = selectedChoice;
    _updateState();
  }

  void changeSupplyItem(int index, IdAndValue<String> selectedChoice) {
    promotionProgramInputStateRx.value.promotionProgramInputState[index]
      .supplyItem.selectedChoice = selectedChoice;
    _updateState();
    _loadSupplyItemProductUnit(index);
  }

  void changeUnitSupplyItem(int index, String selectedChoice) {
    promotionProgramInputStateRx.value.promotionProgramInputState[index]
      .unitSupplyItem.selectedChoice = selectedChoice;
    _updateState();
  }

  bool promotionProgramInputValidation() {
    return true;
  }

  void submitPromotionProgram() async {
    if (!promotionProgramInputValidation()) {
      return;
    }
    print(
        "test :${
            promotionProgramInputStateRx.value.promotionProgramInputState.map<Map<String, dynamic>>((element) => <String, dynamic>{
              // "FromDate": DateTime.parse(element.fromDate.text),
              "FromDate": element.fromDate.text.replaceAll(element.fromDate.text, "${element.fromDate.text.split('-')[2]}-${element.fromDate.text.split('-')[1]}-${element.fromDate.text.split('-')[0]}"),
              // "FromDate": element.fromDate.text.split('-')[0],
            })}"
    );

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String username = preferences.getString("username");
    String token = preferences.getString("token");
    int ppTypeConvert = int.parse(promotionTypeInputPageDropdownStateRx.value.selectedChoice.id);
    // int multiplyConvert = int.parse(element.multiplyInputPageDropdownState.selectedChoice.id);
    int typeConvert = int.parse(promotionTypeInputPageDropdownStateRx.value.selectedChoice.id);
    final isiBody = jsonEncode(<String, dynamic>{
      "PPtype": ppTypeConvert,
      "PPname": programNameTextEditingControllerRx.value.text,
      // "PPnum": programNumberTextEditingControllerRx.value.text,
      "Location": preferences.getString("so"),
      // "Vendor": vendorInputPageDropdownStateRx.value.selectedChoice.id,
      "customerId": custNameHeaderValueDropdownStateRx.value.selectedChoice.id,
      "Lines": promotionProgramInputStateRx.value.promotionProgramInputState.map<Map<String, dynamic>>((element) => <String, dynamic>{
        "Customer": custNameHeaderValueDropdownStateRx.value.selectedChoice.id,//element.customerNameOrDiscountGroupInputPageDropdownState.selectedChoice.id,
        "ItemId": element.selectProductPageDropdownState.selectedChoice.id,
        "QtyFrom": element.qtyFrom.text.isEmpty ? 0 : element.qtyFrom.text,
        "QtyTo": element.qtyTo.text.isEmpty ? 0 : element.qtyTo.text,
        "Unit": element.unitPageDropdownState.selectedChoice,
        "Multiply": element.multiplyInputPageDropdownState.selectedChoice.id, //
        "FromDate": element.fromDate.text.replaceAll(element.fromDate.text, "${element.fromDate.text.split('-')[2]}-${element.fromDate.text.split('-')[1]}-${element.fromDate.text.split('-')[0]}"),
        "ToDate": element.toDate.text.replaceAll(element.toDate.text, "${element.toDate.text.split('-')[2]}-${element.toDate.text.split('-')[1]}-${element.toDate.text.split('-')[0]}"),
        "Currency": element.currencyInputPageDropdownState.selectedChoice,
        "type": element.percentValueInputPageDropdownState.selectedChoice.isNull? 0 : element.percentValueInputPageDropdownState.selectedChoice.id, //
        "Pct1": element.percent1.text.isEmpty ? 0.0 : element.percent1.text,
        "Pct2": element.percent2.text.isEmpty ? 0.0 : element.percent2.text,
        "Pct3": element.percent3.text.isEmpty ? 0.0 : element.percent3.text,
        "Pct4": element.percent4.text.isEmpty ? 0.0 : element.percent4.text,
        "Value1": element.value1.text.isEmpty ? 0.0 : element.value1.text.replaceAll('.', ''),
        "Value2": element.value2.text.isEmpty ? 0.0 : element.value2.text.replaceAll('.', ''),
        //"SupplyItemOnlyOnce": "",
        "SupplyItem": element.supplyItem.selectedChoice.isNull ? "" : element.supplyItem.selectedChoice.id,
        "QtySupply": element.qtyItem.text.isEmpty ? 0 : element.qtyItem.text,
        "UnitSupply": element.unitSupplyItem.selectedChoice,
        "SalesPrice": element.salesPrice.text.replaceAll(RegExp(r"[.,]"), ""),
        "PriceTo": element.priceToCustomer.text.replaceAll(RegExp(r"[.,]"), "")
      }).toList()
    });
    print(isiBody);
    print("token :$token");
    print("url :${'http://119.18.157.236:8869/api/activity?username=$username'}");
    final response = await post(
      Uri.parse('http://119.18.157.236:8869/api/activity?username=$username'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': '$token',
      },
      body: isiBody
    );
    print("status submit : ${response.statusCode}");
    final tabController = Get.put(DashboardPPTabController());
    Future.delayed(Duration(seconds: 2),(){
      if (response.statusCode == 201) {
        Future.delayed(Duration(seconds: 2),(){
          tabController.initialIndex = 1;
          Get.offAll(
              DashboardPage(),
          );
          Get.to(DashboardPP(initialIndexs: 1,));
          update();
          // Get.offAll(HistoryNomorPP());
        });
        Get.dialog(
            SimpleDialog(
              title: Text("Success"),
              children: [
                Center(
                  child: CircularProgressIndicator(),
                )
              ],
        ),barrierDismissible: false);
      } else {
        print("token : $token");
        Get.dialog(SimpleDialog(
          title: Text("Error"),
          children: [
            Center(
              child: Text("${response.statusCode}\n${response.body.replaceAll(r"\'", "'")}",style: TextStyle(color: Colors.red),textAlign: TextAlign.center),
            ),
            Center(
              child: Icon(Icons.error),
            )
          ],
        ));
        print(response.body);
      }
    }
    );
  }

  void _updateState() {
    promotionTypeInputPageDropdownStateRx.valueFromLast((value) => value.copy());
    locationInputPageDropdownStateRx.valueFromLast((value) => value.copy());
    vendorInputPageDropdownStateRx.valueFromLast((value) => value.copy());
    statusTestingInputPageDropdownStateRx.valueFromLast((value) => value.copy());
    promotionProgramInputStateRx.valueFromLast((value) => value.copy());
    update();
  }
}