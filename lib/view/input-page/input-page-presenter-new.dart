import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:mobile_sms/ext/rx_ext.dart';

import '../../models/IdAndValue.dart';
import '../../models/Wrapper.dart';
import '../../models/promotion-program-input-state.dart';
import 'input-page-dropdown-state.dart';

class InputPagePresenterNew extends GetxController {
  Rx<Wrapper<List<PromotionProgramInputState>>> promotionProgramInputStateRx = Wrapper<List<PromotionProgramInputState>>(value: []).obs;
  Rx<TextEditingController> programNumberTextEditingControllerRx = TextEditingController().obs;
  Rx<TextEditingController> programTestTextEditingControllerRx = TextEditingController().obs;
  Rx<TextEditingController> programNameTextEditingControllerRx = TextEditingController().obs;
  Rx<InputPageDropdownState<String>> promotionTypeInputPageDropdownStateRx = InputPageDropdownState<String>().obs;
  Rx<InputPageDropdownState<IdAndValue<String>>> locationInputPageDropdownStateRx = InputPageDropdownState<IdAndValue<String>>().obs;
  Rx<InputPageDropdownState<IdAndValue<String>>> vendorInputPageDropdownStateRx = InputPageDropdownState<IdAndValue<String>>().obs;
  Rx<InputPageDropdownState<String>> statusTestingInputPageDropdownStateRx = InputPageDropdownState<String>().obs;
  InputPageDropdownState<String> customerGroupInputPageDropdownState = InputPageDropdownState<String>(
    choiceList: <String>[
      "Customer",
      "Disc Group"
    ],
    loadingState: 2
  );
  InputPageDropdownState<String> _itemGroupInputPageDropdownState = InputPageDropdownState<String>(
    choiceList: <String>[
      "Item",
      "Disc Group"
    ],
    loadingState: 0
  );
  InputPageDropdownState<String> _multiplyInputPageDropdownState = InputPageDropdownState<String>(
    choiceList: <String>[
      "No",
      "Yes"
    ],
    loadingState: 0
  );
  InputPageDropdownState<String> _currencyInputPageDropdownState = InputPageDropdownState<String>(
    choiceList: <String>[
      "IDR",
      "Dollar"
    ],
    loadingState: 0
  );
  InputPageDropdownState<String> _percentValueInputPageDropdownState = InputPageDropdownState<String>(
    choiceList: <String>[
      "IDR",
      "Dollar"
    ],
    loadingState: 0
  );

  @override
  void onInit() {
    super.onInit();
    promotionTypeInputPageDropdownStateRx.valueFromLast((value) => value.copy(
      choiceList: <String>[
        "Diskon",
        "Bonus",
        "Diskon & Bonus",
        "Sample",
        "Listing",
        "Rebate",
        "Rafraksi",
        "Gimmick",
        "Trading Term",
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
    _loadLocation();
    _loadVendor();
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
      locationInputPageDropdownStateRx.value.choiceList = listData.map<IdAndValue<String>>((element) => IdAndValue(id: element["CodeSO"], value: element["NameSO"]));
    } catch (e) {
      locationInputPageDropdownStateRx.value.loadingState = -1;
      _updateState();
    }
  }

  void _loadCustomerOrGroup() async {

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
      vendorInputPageDropdownStateRx.value.choiceList = listData.map<IdAndValue<String>>((element) => IdAndValue(id: element["ACCOUNTNUM"], value: element["VENDNAME"]));
    } catch (e) {
      vendorInputPageDropdownStateRx.value.loadingState = -1;
      _updateState();
    }
  }

  void changePromotionType(String selectedChoice) {
    promotionTypeInputPageDropdownStateRx.value.selectedChoice = selectedChoice;
    _updateState();
  }

  void changeVendor(IdAndValue<String> selectedChoice) {
    vendorInputPageDropdownStateRx.value.selectedChoice = selectedChoice;
    _updateState();
  }

  void changeLocation(IdAndValue<String> selectedChoice) {
    locationInputPageDropdownStateRx.value.selectedChoice = selectedChoice;
    _updateState();
  }

  void changeStatusTesting(String selectedChoice) {
    statusTestingInputPageDropdownStateRx.value.selectedChoice = selectedChoice;
    _updateState();
  }

  void addItem() {
    List<PromotionProgramInputState> promotionProgramInputState = promotionProgramInputStateRx.value.value;
    promotionProgramInputState.add(
      PromotionProgramInputState(
        customerGroupInputPageDropdownState: customerGroupInputPageDropdownState,
        customerNameOrDiscountGroupInputPageDropdownState: InputPageDropdownState<IdAndValue<String>>(
          choiceList: [],
          loadingState: 0
        ),
        itemGroupInputPageDropdownState: _itemGroupInputPageDropdownState,
        selectProductPageDropdownState: InputPageDropdownState<IdAndValue<String>>(
          choiceList: [],
          loadingState: 0
        ),
        wareHousePageDropdownState: InputPageDropdownState<IdAndValue<String>>(
          choiceList: [],
          loadingState: 0
        ),
        qtyFrom: TextEditingController(),
        qtyTo: TextEditingController(),
        unitPageDropdownState: InputPageDropdownState<IdAndValue<String>>(
          choiceList: [],
          loadingState: 0
        ),
        multiplyInputPageDropdownState: _multiplyInputPageDropdownState,
        currencyInputPageDropdownState: _currencyInputPageDropdownState,
        percentValueInputPageDropdownState: _percentValueInputPageDropdownState,
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
        unitSupplyItem: InputPageDropdownState<IdAndValue<String>>(
          choiceList: [],
          loadingState: 0
        ),
      )
    );
    _updateState();
  }

  void removeItem(int index) {
    promotionProgramInputStateRx.value.value.removeAt(index);
    _updateState();
  }

  void changeCustomerGroup(int index, String selectedChoice) {
    promotionProgramInputStateRx.value.value[index]
      .customerGroupInputPageDropdownState.selectedChoice = selectedChoice;
    _updateState();
  }

  void changeCustomerNameOrDiscountGroup(int index, IdAndValue<String> selectedChoice) {
    PromotionProgramInputState promotionProgramInputState = promotionProgramInputStateRx.value.value[index];
    InputPageDropdownState<IdAndValue<String>> customerNameOrDiscountGroupInputPageDropdownState = promotionProgramInputState.customerNameOrDiscountGroupInputPageDropdownState;
    customerNameOrDiscountGroupInputPageDropdownState.selectedChoice = selectedChoice;
    _updateState();
  }

  void changeItemGroup(int index, String selectedChoice) {
    promotionProgramInputStateRx.value.value[index]
      .itemGroupInputPageDropdownState.selectedChoice = selectedChoice;
    _updateState();
  }

  void changeProduct(int index, IdAndValue<String> selectedChoice) {
    promotionProgramInputStateRx.value.value[index]
      .selectProductPageDropdownState.selectedChoice = selectedChoice;
    _updateState();
  }

  void changeWarehouse(int index, IdAndValue<String> selectedChoice) {
    promotionProgramInputStateRx.value.value[index]
      .wareHousePageDropdownState.selectedChoice = selectedChoice;
    _updateState();
  }

  void changeUnit(int index, IdAndValue<String> selectedChoice) {
    promotionProgramInputStateRx.value.value[index]
      .unitPageDropdownState.selectedChoice = selectedChoice;
    _updateState();
  }

  void changeMultiply(int index, String selectedChoice) {
    promotionProgramInputStateRx.value.value[index]
      .multiplyInputPageDropdownState.selectedChoice = selectedChoice;
    _updateState();
  }

  void changeCurrency(int index, String selectedChoice) {
    promotionProgramInputStateRx.value.value[index]
      .currencyInputPageDropdownState.selectedChoice = selectedChoice;
    _updateState();
  }

  void changePercentValue(int index, String selectedChoice) {
    promotionProgramInputStateRx.value.value[index]
      .percentValueInputPageDropdownState.selectedChoice = selectedChoice;
    _updateState();
  }

  void changeSupplyItem(int index, IdAndValue<String> selectedChoice) {
    promotionProgramInputStateRx.value.value[index]
      .supplyItem.selectedChoice = selectedChoice;
    _updateState();
  }

  void changeUnitSupplyItem(int index, IdAndValue<String> selectedChoice) {
    promotionProgramInputStateRx.value.value[index]
      .unitSupplyItem.selectedChoice = selectedChoice;
    _updateState();
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