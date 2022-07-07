import 'package:flutter/cupertino.dart';

import '../view/input-page/input-page-dropdown-state.dart';
import 'IdAndValue.dart';

class PromotionProgramInputState {
  InputPageDropdownState<String> customerGroupInputPageDropdownState;
  InputPageDropdownState<IdAndValue<String>> customerNameOrDiscountGroupInputPageDropdownState;
  InputPageDropdownState<String> itemGroupInputPageDropdownState;
  InputPageDropdownState<IdAndValue<String>> selectProductPageDropdownState;
  InputPageDropdownState<IdAndValue<String>> wareHousePageDropdownState;
  TextEditingController qtyFrom;
  TextEditingController qtyTo;
  InputPageDropdownState<String> currencyInputPageDropdownState;
  InputPageDropdownState<String> percentValueInputPageDropdownState;
  InputPageDropdownState<IdAndValue<String>> unitPageDropdownState;
  InputPageDropdownState<String> multiplyInputPageDropdownState;
  TextEditingController fromDate;
  TextEditingController toDate;
  TextEditingController percent1;
  TextEditingController percent2;
  TextEditingController percent3;
  TextEditingController percent4;
  TextEditingController salesPrice;
  TextEditingController priceToCustomer;
  TextEditingController value1;
  TextEditingController value2;
  InputPageDropdownState<IdAndValue<String>> supplyItem;
  TextEditingController qtyItem;
  InputPageDropdownState<IdAndValue<String>> unitSupplyItem;

  PromotionProgramInputState({
    this.customerGroupInputPageDropdownState,
    this.customerNameOrDiscountGroupInputPageDropdownState,
    this.itemGroupInputPageDropdownState,
    this.selectProductPageDropdownState,
    this.wareHousePageDropdownState,
    this.qtyFrom,
    this.qtyTo,
    this.currencyInputPageDropdownState,
    this.percentValueInputPageDropdownState,
    this.unitPageDropdownState,
    this.multiplyInputPageDropdownState,
    this.fromDate,
    this.toDate,
    this.percent1,
    this.percent2,
    this.percent3,
    this.percent4,
    this.salesPrice,
    this.priceToCustomer,
    this.value1,
    this.value2,
    this.supplyItem,
    this.qtyItem,
    this.unitSupplyItem
  });
}