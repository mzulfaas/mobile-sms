import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_input_formatter/money_input_formatter.dart';
import 'package:search_choices/search_choices.dart';
import 'package:signature/signature.dart';

import '../../models/input-page-wrapper.dart';
import '../../models/promotion-program-input-state.dart';
import 'input-page-presenter-new.dart';

class InputPageNew extends StatelessWidget {
  InputPageNew({Key key}) : super(key: key);

  Widget customCard(int index, InputPagePresenterNew inputPagePresenter){
    PromotionProgramInputState promotionProgramInputState = inputPagePresenter.promotionProgramInputStateRx.value.promotionProgramInputState[index];
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
                  Text("Add Lines"),
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
                      promotionProgramInputState.customerGroupInputPageDropdownState.selectedChoice=="Customer"?"Select Customer": "Select Discount Group",
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
                value: promotionProgramInputState.selectProductPageDropdownState.selectedChoice,
                items: promotionProgramInputState.selectProductPageDropdownState.choiceList.map((item) {
                  return DropdownMenuItem(
                    child: Text(item.value),
                    value: item
                  );
                }).toList(),
                hint: Text(
                  promotionProgramInputState.itemGroupInputPageDropdownState.selectedChoice=="Item"?"Select Product": "Select Discount Group",
                  style: TextStyle(fontSize: 12),
                ),
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
                      value: promotionProgramInputState.wareHousePageDropdownState.selectedChoiceWrapper.value,
                      hint: Text(
                        "Warehouse",
                        style: TextStyle(fontSize: 12),
                      ),
                      items: promotionProgramInputState.wareHousePageDropdownState.choiceListWrapper.value.map((item) {
                        return DropdownMenuItem(
                          child: Text(
                            item.value,
                            style: TextStyle(fontSize: 12),
                            overflow: TextOverflow.fade,
                          ),
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
                    child: SearchChoices.single(
                      isExpanded: true,
                      value: promotionProgramInputState.unitPageDropdownState.selectedChoice,
                      hint: Text(
                        "Unit",
                        style: TextStyle(fontSize: 12),
                      ),
                      items: promotionProgramInputState.unitPageDropdownState.choiceList.map((item) {
                        return DropdownMenuItem(
                          child: Text(item),
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
                          child: Text(item.value),
                          value: item,
                        );
                      }).toList(),
                      onChanged: (value) => inputPagePresenter.changeMultiply(index, value),
                    ),
                  ),
                ],
              ),

              //datetime
              Row(
                children: [
                  //from date
                  Container(
                    width: 150,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DateTimeField(
                            decoration: InputDecoration(
                              label: Text("From Date"),
                              suffixIcon: Icon(Icons.arrow_drop_down)
                            ),
                            controller: promotionProgramInputState.fromDate,
                            initialValue: DateTime.now(),
                            style: TextStyle(fontSize: 12),
                            format: DateFormat('dd-MM-yyyy'),
                            //xx
                            // format: DateFormat('yyyy-MM-dd'),
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
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DateTimeField(
                            decoration: InputDecoration(
                                label: Text("To Date"),
                                suffixIcon: Icon(Icons.arrow_drop_down)
                            ),
                            controller: promotionProgramInputState.toDate,
                            initialValue: DateTime.now(),
                            style: TextStyle(fontSize: 12),
                            format: DateFormat('dd-MM-yyyy'),
                            // format: DateFormat('yyyy-MM-dd'),
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
              inputPagePresenter.promotionTypeInputPageDropdownStateRx.value.selectedChoice.value=="Bonus"?SizedBox():Row(
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
                          child: Text(item.value),
                          value: item,
                        );
                      }).toList(),
                      onChanged: (value) => inputPagePresenter.changePercentValue(index, value),
                    ),
                  ),
                ],
              ),

              //percent
              inputPagePresenter.promotionTypeInputPageDropdownStateRx.value.selectedChoice.value=="Bonus"?SizedBox():promotionProgramInputState.percentValueInputPageDropdownState.selectedChoice == promotionProgramInputState.percentValueInputPageDropdownState.choiceList[1] ?
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //sales price
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: promotionProgramInputState.salesPrice,
                          inputFormatters: [
                            MoneyInputFormatter(thousandSeparator: ".", decimalSeparator: ",")
                          ],
                          decoration: InputDecoration(
                            labelText: 'Sales Price',
                            prefixText: "Rp",
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
                      SizedBox(width: 20,),
                      //price to customer
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            MoneyInputFormatter(thousandSeparator: ".", decimalSeparator: ",")
                          ],
                          controller: promotionProgramInputState.priceToCustomer,
                          decoration: InputDecoration(
                            labelText: 'Price to Customer',
                            prefixText: "Rp",
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
                  Row(
                    children: [
                      //value 1
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            MoneyInputFormatter(thousandSeparator: ".", decimalSeparator: ",")
                          ],
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
                      SizedBox(width: 20,),
                      //value 2
                      Expanded(
                        child: TextFormField(
                          inputFormatters: [
                            MoneyInputFormatter(thousandSeparator: ".", decimalSeparator: ",")
                          ],
                          keyboardType: TextInputType.number,
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
                  )
                ],
              ): Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //percent1
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: promotionProgramInputState.percent1,
                          decoration: InputDecoration(
                            suffixText: "%",
                            labelText: 'Disc-1 (%) PRB',
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
                      SizedBox(width: 20,),
                      //percent2
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: promotionProgramInputState.percent2,
                          decoration: InputDecoration(
                            labelText: 'Disc-2 (%) COD',
                            suffixText: "%",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //percent3
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: promotionProgramInputState.percent3,
                          decoration: InputDecoration(
                            labelText: 'Disc-3 (%) Principal1',
                            suffixText: "%",
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
                      SizedBox(width: 20,),
                      //percent4
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: promotionProgramInputState.percent4,
                          decoration: InputDecoration(
                            labelText: 'Disc-4 (%) Principal2',
                            suffixText: "%",
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
                ],
              ),


              inputPagePresenter.promotionTypeInputPageDropdownStateRx.value.selectedChoice.value=="Diskon"?SizedBox():SearchChoices.single(
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
              inputPagePresenter.promotionTypeInputPageDropdownStateRx.value.selectedChoice.value=="Diskon"?SizedBox():Row(
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
                    child: SearchChoices.single(
                      isExpanded: true,
                      value: promotionProgramInputState.unitSupplyItem.selectedChoice,
                      hint: Text(
                        "Unit Supply Item",
                        style: TextStyle(fontSize: 12),
                      ),
                      items: promotionProgramInputState.unitSupplyItem.choiceList.map((item) {
                        return DropdownMenuItem(
                          child: Text(item),
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

  final SignatureController _signaturecontrollersales = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    print("Build lahh");
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
                                onChanged: (value) => inputPagePresenter.checkAddItemStatus(),
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
                                onChanged: (value) => inputPagePresenter.checkAddItemStatus(),
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
                                    child: Text(item.value),
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
                                isExpanded: true,
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
                                onChanged: (value) => inputPagePresenter.changeLocation(value),
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
                                onChanged: (value) => inputPagePresenter.changeStatusTesting(value),
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
                InputPageWrapper inputPageWrapper = inputPagePresenter.promotionProgramInputStateRx.value;
                List<PromotionProgramInputState> promotionProgramInputStateList = inputPageWrapper.promotionProgramInputState;
                bool isAddItem = inputPageWrapper.isAddItem;
                return promotionProgramInputStateList.length == 0 ? RaisedButton(
                  color: Colors.green,
                  child: Text("Add Lines"),
                  onPressed: isAddItem ? () => inputPagePresenter.addItem() : null
                ) : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: promotionProgramInputStateList.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      customCard(index, inputPagePresenter),
                      SizedBox(
                        height: 10,
                      ),

                      index == promotionProgramInputStateList.length -1 ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Card(
                              child: Signature(
                                controller: _signaturecontrollersales,
                                height: 200,
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.black,
                            ),
                            child: Container(
                              width: 355,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  //Clear Canvass
                                  // ignore: deprecated_member_use
                                  RaisedButton(
                                    color: Colors.blue,
                                    child: Text(
                                      "Clear",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                          _signaturecontrollersales.clear();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ) : SizedBox(),
                      index == promotionProgramInputStateList.length -1 ? RaisedButton(
                        color: Colors.green,
                        child: Text("Submit"),
                        onPressed: (){
                          inputPagePresenter.submitPromotionProgram();
                        }
                      ) : SizedBox()
                    ],
                  )
                );
              }),
            ],
          ),
        )
      ),
    );
  }
}
