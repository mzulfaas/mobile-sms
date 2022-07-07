import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:search_choices/search_choices.dart';

import '../../models/promotion-program-input-state.dart';
import 'input-page-presenter-new.dart';

class InputPage extends StatelessWidget {
  InputPage({Key key}) : super(key: key);

  Widget customCard(int index, InputPagePresenterNew inputPagePresenter){
    PromotionProgramInputState promotionProgramInputState = inputPagePresenter.promotionProgramInputStateRx.value.value[index];
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        borderOnForeground: true,
        semanticContainer: true,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Add Item"),
                  Spacer(),
                  IconButton(
                    onPressed: (){
                      inputPagePresenter.addItem();
                    },
                    icon: Icon(Icons.add)
                  ),
                  IconButton(
                    onPressed: (){
                      inputPagePresenter.removeItem(index);
                    },
                    icon: Icon(Icons.delete,)
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<String>(
                isExpanded: true,
                isDense: true,
                value: promotionProgramInputState.customerGroupInputPageDropdownState.selectedChoice,
                hint: Text(
                  "Customer/Group",
                  style: TextStyle(fontSize: 12),
                ),
                items: promotionProgramInputState.customerGroupInputPageDropdownState.choiceList.map((item) {
                  return DropdownMenuItem(
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 12),
                      overflow: TextOverflow.fade,
                    ),
                    value: item,
                  );
                }).toList(),
                onChanged: (value) => inputPagePresenter.changeCustomerGroup(index, value)
              ),
              SizedBox(
                height: 20,
              ),
              SearchChoices.single(
                items: promotionProgramInputState.customerNameOrDiscountGroupInputPageDropdownState.choiceList.map((item) {
                  return DropdownMenuItem(
                    child: Text(
                      item.value,
                      style: TextStyle(fontSize: 12),
                      overflow: TextOverflow.fade,
                    ),
                    value: item,
                  );
                }).toList(),
                value: promotionProgramInputState.customerNameOrDiscountGroupInputPageDropdownState.selectedChoice,
                hint: Builder(
                  builder: (context) {
                    String text = (promotionProgramInputState.customerGroupInputPageDropdownState.selectedChoice ?? "").toLowerCase() == "Customer"
                        ? "Customer Name" : "Discount Group Name";
                    return Text(
                      text,
                      style: TextStyle(fontSize: 12),
                    );
                  }
                ),
                onChanged: (value) => inputPagePresenter.changeCustomerNameOrDiscountGroup(index, value),
                isExpanded: true,
              ),
              SizedBox(height: 10,),
              //ite, group
              DropdownButtonFormField(
                value: promotionProgramInputState.itemGroupInputPageDropdownState.selectedChoice,
                hint: Text(
                  "Item/Group",
                  style: TextStyle(fontSize: 12),
                ),
                items: promotionProgramInputState.itemGroupInputPageDropdownState.choiceList.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 12),
                      overflow: TextOverflow.fade,
                    ),
                  );
                }).toList(),
                onChanged: (value) => inputPagePresenter.changeItemGroup(index, value),
              ),
              SearchChoices.single(
                isExpanded: true,
                items: promotionProgramInputState.selectProductPageDropdownState.choiceList.map((item) {
                  return DropdownMenuItem(
                    child: Text(item.value),
                    value: item
                  );
                }).toList(),
                // value: inputPagePresenter.valChoiceItemGroup.value,
                hint: Text(
                  "Select Product",
                  style: TextStyle(fontSize: 12),
                ),
                // searchHint: "Select product",
                onChanged: (value) => inputPagePresenter.changeProduct(index, value)
                // isExpanded: true,
              ),

              //warehouse qyt
              Row(
                children: [
                  Container(
                    width: 150,
                    child: SearchChoices.single(
                      isExpanded: true,
                      value: promotionProgramInputState.wareHousePageDropdownState.selectedChoice,
                      hint: Text(
                        "Warehouse",
                        style: TextStyle(fontSize: 12),
                      ),
                      items: promotionProgramInputState.wareHousePageDropdownState.choiceList.map((item) {
                        return DropdownMenuItem(
                          child: Text(item.value,
                            style: TextStyle(fontSize: 12),
                            overflow: TextOverflow.fade,),
                          value: item,
                        );
                      }).toList(),
                      onChanged: (value) => inputPagePresenter.changeWarehouse(index, value),
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 60,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: promotionProgramInputState.qtyFrom,
                      decoration: InputDecoration(
                        labelText: 'Qty From',
                        labelStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontFamily: 'AvenirLight'
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.purple),
                        ),
                        enabledBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey, width: 1.0)),
                      ),
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      //  controller: _passwordController,
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 60,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: promotionProgramInputState.qtyTo,
                      decoration: InputDecoration(
                        labelText: 'Qty To',
                        labelStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontFamily: 'AvenirLight'),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.purple),
                        ),
                        enabledBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey, width: 1.0)),
                      ),
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      //  controller: _passwordController,
                    ),
                  ),
                ],
              ),

              //unit multiply
              Row(
                children: [
                  //unit
                  Container(
                    width: 150,
                    child: DropdownButtonFormField(
                      value: promotionProgramInputState.unitPageDropdownState.selectedChoice,
                      hint: Text(
                        "Unit",
                        style: TextStyle(fontSize: 12),
                      ),
                      items: promotionProgramInputState.unitPageDropdownState.choiceList.map((item) {
                        return DropdownMenuItem(
                          child: Text(item.value),
                          value: item,
                        );
                      }).toList(),
                      onChanged: (value) => inputPagePresenter.changeUnit(index, value),
                    ),
                  ),
                  Spacer(),
                  //multiply
                  Container(
                    width: 150,
                    child: DropdownButtonFormField(
                      value: promotionProgramInputState.multiplyInputPageDropdownState.selectedChoice,
                      hint: Text(
                        "Multiply",
                        style: TextStyle(fontSize: 12),
                      ),
                      items: promotionProgramInputState.multiplyInputPageDropdownState.choiceList.map((item) {
                        return DropdownMenuItem(
                          child: Text(item),
                          value: item,
                        );
                      }).toList(),
                      onChanged: (value) => inputPagePresenter.changeMultiply(index, value),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              //datetime
              Row(
                children: [
                  //from date
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black)),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "From Date",
                            style: TextStyle(fontSize: 12),
                          ),
                          Divider(
                            color: Colors.black54,
                            thickness: 1,
                          ),
                          DateTimeField(
                            controller: promotionProgramInputState.fromDate,
                            initialValue: DateTime.now(),
                            style: TextStyle(fontSize: 12),
                            format: DateFormat('dd/MMM/yyyy'),
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                  context: context,
                                  firstDate: DateTime(
                                      DateTime
                                          .now()
                                          .year - 1),
                                  initialDate: DateTime.now(),
                                  lastDate: DateTime(
                                      DateTime
                                          .now()
                                          .year + 1),
                                  builder: (BuildContext context,
                                      Widget child) {
                                    return Theme(
                                      data: ThemeData.light(),
                                      child: child,
                                    );
                                  });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),

                  //todate
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black)),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "To Date",
                            style: TextStyle(fontSize: 12),
                          ),
                          Divider(
                            color: Colors.black54,
                            thickness: 1,
                          ),
                          DateTimeField(
                            controller: promotionProgramInputState.toDate,
                            initialValue: DateTime.now(),
                            style: TextStyle(fontSize: 12),
                            format: DateFormat('dd/MMM/yyyy'),
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                  context: context,
                                  firstDate: DateTime(
                                      DateTime
                                          .now()
                                          .year - 1),
                                  initialDate: DateTime.now(),
                                  lastDate: DateTime(
                                      DateTime
                                          .now()
                                          .year + 1),
                                  builder: (BuildContext context,
                                      Widget child) {
                                    return Theme(
                                      data: ThemeData.light(),
                                      child: child,
                                    );
                                  });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              //curency percent
              Row(
                children: [
                  //unit
                  Container(
                    width: 150,
                    child: DropdownButtonFormField(
                      value: promotionProgramInputState.currencyInputPageDropdownState.selectedChoice,
                      hint: Text(
                        "Currency",
                        style: TextStyle(fontSize: 12),
                      ),
                      items: promotionProgramInputState.currencyInputPageDropdownState.choiceList.map((item) {
                        return DropdownMenuItem(
                          child: Text(item),
                          value: item,
                        );
                      }).toList(),
                      onChanged: (value) => inputPagePresenter.changeCurrency(index, value),
                    ),
                  ),
                  Spacer(),
                  //multiply
                  Container(
                    width: 150,
                    child: DropdownButtonFormField(
                      value: promotionProgramInputState.percentValueInputPageDropdownState.selectedChoice,
                      hint: Text(
                        "Percent/Value",
                        style: TextStyle(fontSize: 12),
                      ),
                      items: promotionProgramInputState.percentValueInputPageDropdownState.choiceList.map((item) {
                        return DropdownMenuItem(
                          child: Text(item),
                          value: item,
                        );
                      }).toList(),
                      onChanged: (value) => inputPagePresenter.changePercentValue(index, value),
                    ),
                  ),
                ],
              ),

              //percent
              promotionProgramInputState.percentValueInputPageDropdownState.selectedChoice == promotionProgramInputState.percentValueInputPageDropdownState.choiceList[1]?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //sales price
                  Container(
                    width: 60,
                    child: TextFormField(
                      controller: promotionProgramInputState.salesPrice,
                      decoration: InputDecoration(
                        labelText: 'Sales Price',
                        labelStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontFamily: 'AvenirLight'),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.purple),
                        ),
                        enabledBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey, width: 1.0)),
                      ),
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      //  controller: _passwordController,

                    ),
                  ),
                  //price to customer
                  Container(
                    width: 60,
                    child: TextFormField(
                      controller: promotionProgramInputState.priceToCustomer,
                      decoration: InputDecoration(
                        labelText: 'Price to Customer',
                        labelStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontFamily: 'AvenirLight'),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.purple),
                        ),
                        enabledBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey, width: 1.0)),
                      ),
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      //  controller: _passwordController,
                    ),
                  ),
                  //value 1
                  Container(
                    width: 60,
                    child: TextFormField(
                      controller: promotionProgramInputState.value1,
                      decoration: InputDecoration(
                        labelText: 'Value 1',
                        labelStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontFamily: 'AvenirLight'),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.purple),
                        ),
                        enabledBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey, width: 1.0)),
                      ),
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      //  controller: _passwordController,
                    ),
                  ),

                  //value 2
                  Container(
                    width: 60,
                    child: TextFormField(
                      controller: promotionProgramInputState.value2,
                      decoration: InputDecoration(
                        labelText: 'Value 2',
                        labelStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontFamily: 'AvenirLight'),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.purple),
                        ),
                        enabledBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey, width: 1.0)),
                      ),
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      //  controller: _passwordController,

                    ),
                  ),
                ],
              ):
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //percent1
                  Container(
                    width: 60,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: promotionProgramInputState.percent1,
                      decoration: InputDecoration(
                        labelText: 'Percent 1',
                        labelStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontFamily: 'AvenirLight'),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.purple),
                        ),
                        enabledBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey, width: 1.0)),
                      ),
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      //  controller: _passwordController,

                    ),
                  ),
                  //percent2
                  Container(
                    width: 60,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: promotionProgramInputState.percent2,
                      decoration: InputDecoration(
                        labelText: 'Percent 2',
                        labelStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontFamily: 'AvenirLight'),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.purple),
                        ),
                        enabledBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey, width: 1.0)),
                      ),
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      //  controller: _passwordController,
                    ),
                  ),
                  //percent3
                  Container(
                    width: 60,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: promotionProgramInputState.percent3,
                      decoration: InputDecoration(
                        labelText: 'Percent 3',
                        labelStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontFamily: 'AvenirLight'),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.purple),
                        ),
                        enabledBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey, width: 1.0)),
                      ),
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      //  controller: _passwordController,
                    ),
                  ),

                  //percent4
                  Container(
                    width: 60,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: promotionProgramInputState.percent4,
                      decoration: InputDecoration(
                        labelText: 'Percent 4',
                        labelStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontFamily: 'AvenirLight'),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.purple),
                        ),
                        enabledBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey, width: 1.0)),
                      ),
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      //  controller: _passwordController,

                    ),
                  ),
                ],
              ),

              SearchChoices.single(
                isExpanded: true,
                value: promotionProgramInputState.supplyItem.selectedChoice,
                hint: Text(
                  "Supply Item",
                  style: TextStyle(fontSize: 12),
                ),
                items: promotionProgramInputState.supplyItem.choiceList.map((item) {
                  return DropdownMenuItem(
                    child: Text(
                      item.value,
                      style: TextStyle(fontSize: 12),
                      overflow: TextOverflow.fade,
                    ),
                    value: item,
                  );
                }).toList(),
                onChanged: (value) => inputPagePresenter.changeSupplyItem(index, value)
              ),

              //unit multiply
              Row(
                children: [
                  //unit
                  Container(
                    width: 50,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: promotionProgramInputState.qtyItem,
                      decoration: InputDecoration(
                        labelText: 'Qty Item',
                        labelStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontFamily: 'AvenirLight'),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.purple),
                        ),
                        enabledBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey, width: 1.0)),
                      ),
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      //  controller: _passwordController,

                    ),
                  ),
                  Spacer(),
                  //unit supply item
                  Container(
                    width: 120,
                    child: DropdownButtonFormField(
                      value: promotionProgramInputState.unitSupplyItem.selectedChoice,
                      hint: Text(
                        "Unit Supply Item",
                        style: TextStyle(fontSize: 12),
                      ),
                      items: promotionProgramInputState.unitSupplyItem.choiceList.map((item) {
                        return DropdownMenuItem(
                          child: Text(item.value),
                          value: item,
                        );
                      }).toList(),
                      onChanged: (value) => inputPagePresenter.changeUnitSupplyItem(index, value),
                    ),
                  ),

                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inputPagePresenter = Get.put(InputPagePresenterNew());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text("New Promotion Program"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                child: Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  borderOnForeground: true,
                  semanticContainer: true,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Create"),
                        SizedBox(height: 5),
                        Text(
                          "Setup a trade agreement",
                          style: TextStyle(fontSize: 10, color: Colors.black54),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            //Program number
                            Container(
                              width: 150,
                              child: Obx(() => TextFormField(
                                controller: inputPagePresenter.programNumberTextEditingControllerRx.value,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: 'Program Number',
                                  labelStyle: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 12,
                                    fontFamily: 'AvenirLight'
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.purple),
                                  ),
                                  enabledBorder: new UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0
                                    )
                                  ),
                                ),
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 17,
                                  fontFamily: 'AvenirLight'
                                ),
                              )),
                            ),
                            Spacer(),
                            //Program name
                            Container(
                              width: 150,
                              child: Obx(() => TextFormField(
                                controller: inputPagePresenter.programNameTextEditingControllerRx.value,
                                decoration: InputDecoration(
                                  labelText: 'Program Name',
                                  labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 12,
                                      fontFamily: 'AvenirLight'),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.purple),
                                  ),
                                  enabledBorder: new UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.0)),
                                ),
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 17,
                                    fontFamily: 'AvenirLight'),
                                //  controller: _passwordController,
                                // obscureText: true,
                              )),
                            ),
                          ],
                        ),

                        //dropdown
                        Row(
                          children: [
                            Container(
                              width: 150,
                              child: Obx(() => DropdownButtonFormField(
                                value: inputPagePresenter.promotionTypeInputPageDropdownStateRx.value.selectedChoice,
                                hint: Text(
                                  "Type",
                                  style: TextStyle(fontSize: 12),
                                ),
                                items: inputPagePresenter.promotionTypeInputPageDropdownStateRx.value.choiceList.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(item),
                                    value: item,
                                  );
                                }).toList(),
                                onChanged: (value) => inputPagePresenter.changePromotionType(value),
                              )),
                            ),
                            Spacer(),

                            //xx
                            Container(
                              width: 150,
                              child: Obx(() => SearchChoices.single(
                                isExpanded: true,
                                value: inputPagePresenter.vendorInputPageDropdownStateRx.value.selectedChoice,
                                hint: Text(
                                    "Vendor",
                                  style: TextStyle(fontSize: 12),
                                ),
                                items: inputPagePresenter.vendorInputPageDropdownStateRx.value.choiceList.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      item.value,
                                      style: TextStyle(fontSize: 12)
                                    ),
                                    value: item,
                                  );
                                }).toList(),
                                onChanged: (value) => inputPagePresenter.changeVendor(value),
                              )),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 150,
                              child: Obx(() => DropdownButtonFormField(
                                value: inputPagePresenter.locationInputPageDropdownStateRx.value.selectedChoice,
                                hint: Text(
                                  "Location",
                                  style: TextStyle(fontSize: 12),
                                ),
                                items: inputPagePresenter.locationInputPageDropdownStateRx.value.choiceList.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(item.value),
                                    value: item,
                                  );
                                }).toList(),
                                onChanged: (value) => inputPagePresenter.changePromotionType(value),
                              )),
                            ),
                            Spacer(),
                            Container(
                              width: 150,
                              child: Obx(() => DropdownButtonFormField(
                                value: inputPagePresenter.statusTestingInputPageDropdownStateRx.value.selectedChoice,
                                hint: Text(
                                  "Status Testing",
                                  style: TextStyle(fontSize: 12),
                                ),
                                items: inputPagePresenter.statusTestingInputPageDropdownStateRx.value.choiceList.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(item),
                                    value: item,
                                  );
                                }).toList(),
                                onChanged: (value) => inputPagePresenter.changePromotionType(value),
                              ))
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),
              Obx(() {
                List<PromotionProgramInputState> promotionProgramInputStateList = inputPagePresenter.promotionProgramInputStateRx.value.value;
                return promotionProgramInputStateList.length == 0 ? RaisedButton(
                  color: Colors.green,
                  child: Text("Add Item"),
                  onPressed: () => inputPagePresenter.addItem()
                ) : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: promotionProgramInputStateList.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      customCard(index, inputPagePresenter),
                      index == promotionProgramInputStateList.length -1 ? RaisedButton(
                        color: Colors.green,
                        child: Text("Submit"),
                        onPressed: () {
                          // inputPagePresenter.submitProcess(
                          //     int.parse(inputPagePresenter.valType.value),
                          //     programNameController.text,
                          //     programNumberController.text,
                          //     inputPagePresenter.valLocation.value,
                          //     inputPagePresenter.valVendor.value.toString().split(' ')[0],
                          //     inputPagePresenter.valCustomerChoice.value.toString().split(' ')[0],
                          //     inputPagePresenter.valChoiceItemGroup.value.split(' ')[0],
                          //     int.parse(qtyFromController.text),
                          //     int.parse(qtyToController.text),
                          //     inputPagePresenter.valUnit.value,
                          //     int.parse(inputPagePresenter.valMultiply.value),
                          //     fromDateController.text,
                          //     toDateController.text,
                          //     inputPagePresenter.valCurrency.value,
                          //     int.parse(inputPagePresenter.valPercentValue.value,),
                          //     double.parse(percent1Controller.text),
                          //     double.parse(percent2Controller.text),
                          //     double.parse(percent3Controller.text),
                          //     double.parse(percent4Controller.text),
                          //     salesPriceController.text,
                          //     priceToController.text,
                          //     double.parse(value1Controller.text),
                          //     double.parse(value2Controller.text),
                          //     inputPagePresenter.valSupplyItem.value,
                          //     int.parse(qtyItemController.text),
                          //     inputPagePresenter.valUnit.value);
                        }
                      ):SizedBox()
                    ],
                  )
                );
              })
            ],
          ),
        )
      ),
    );
  }
}
