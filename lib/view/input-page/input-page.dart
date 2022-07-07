import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_sms/view/input-page/input-page-presenter.dart';
import 'package:search_choices/search_choices.dart';

class InputPage extends StatefulWidget {
  const InputPage({Key key}) : super(key: key);

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {

  TextEditingController programNumberController = TextEditingController();
  TextEditingController programNameController = TextEditingController();
  TextEditingController qtyFromController = TextEditingController();
  TextEditingController qtyToController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController percent1Controller = TextEditingController();
  TextEditingController percent2Controller = TextEditingController();
  TextEditingController percent3Controller = TextEditingController();
  TextEditingController percent4Controller = TextEditingController();
  TextEditingController qtyItemController = TextEditingController();
  TextEditingController salesPriceController = TextEditingController();
  TextEditingController priceToController = TextEditingController();
  TextEditingController value1Controller = TextEditingController();
  TextEditingController value2Controller = TextEditingController();

  final inputPagePresenter = Get.put(InputPagePresenter());

  // bool isSelectedCustomer = false;
  // bool isSelectedDiscGroup = false;

  // List<Widget> cardsItem = [
  //
  // ];

  // void addCardsItem(){
  //     cardsItem.add(customCard(cardsItem.length));
  //     inputPagePresenter.valCustomer.add(Rx<String>(null));
  //     inputPagePresenter.valCustomerChoice.add(Rx<String>(null));
  // }
  //
  // void removeCardsItem(int index){
  //     cardsItem.remove(cardsItem[index]);
  //     inputPagePresenter.valCustomer.remove(inputPagePresenter.valCustomer[index]);
  // }

  Widget customCard(int index){
    return Container(
      margin:
      EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)),
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
                        inputPagePresenter.addCardsItem(customCard(inputPagePresenter.cardsItem.length));
                      }, icon: Icon(Icons.add,)),
                  IconButton(
                      onPressed: (){
                        // removeCardsItem(index);
                        inputPagePresenter.removeCardsItem(index);
                      }, icon: Icon(Icons.delete,)),
                ],
              ),
              SizedBox(
                height: 20,
              ),

              //customer
              Container(
                // width: 150,
                  child: Obx(() =>
                      DropdownButtonFormField(
                        isExpanded: true,
                        isDense: true,
                        value: inputPagePresenter.valCustomer[index].value,
                        hint: Text(
                          "Customer/Group",
                          style: TextStyle(fontSize: 12),
                        ),
                        items: inputPagePresenter.dataCustomer.map((item) {
                          return DropdownMenuItem(
                            child: Text(item['name'],
                              style: TextStyle(fontSize: 12),
                              overflow: TextOverflow.fade,),
                            value: item['name'],
                          );
                        }).toList(),
                        onChanged: (value) {
                          inputPagePresenter.valCustomer[index].value = value;
                          print(
                              "ini isi dropdown customer : $value");
                          inputPagePresenter.getChoice(value);
                          inputPagePresenter.update();
                        },
                      ),)
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                // width: 150,
                child: Obx(() =>
                    SearchChoices.single(
                      items: inputPagePresenter.dataChoice.map((
                          item) {
                        return DropdownMenuItem(
                          child: Text(item["CUSTNAME"] == null
                              ? item["NAME"]
                              : item["CUSTNAME"],
                            overflow: TextOverflow.fade,),
                          value: item["CUSTNAME"] == null
                              ? item["NAME"]
                              : item["ACCOUNTNUM"].toString() + " " + item["CUSTNAME"].toString(),
                        );
                      }).toList(),
                      value: inputPagePresenter.valCustomerChoice[index],
                      hint: Text(
                        "Customer Name",
                        style: TextStyle(fontSize: 12),
                      ),
                      // searchHint: "Select one",
                      onChanged: (value) {
                        inputPagePresenter.valCustomerChoice[index] = value;
                        print("cek 1 :${inputPagePresenter.valCustomerChoice[index].value}");
                        inputPagePresenter.update();
                      },
                      // onTap: (value){
                      //   inputPagePresenter.valCustomerChoice[index] = value;
                      //   // print("cek 1 :${inputPagePresenter.valCustomerChoice[index].value}");
                      //   inputPagePresenter.update();
                      // },
                      isExpanded: true,
                    )),
              ),
              SizedBox(height: 10,),
              //ite, group
              Container(
                // width: 150,
                child: Obx(()=>DropdownButtonFormField(
                  value: inputPagePresenter.valItemGroup[index].value,
                  hint: Text(
                    "Item/Group",
                    style: TextStyle(fontSize: 12),
                  ),
                  items: inputPagePresenter.dataItemGroup.map((
                      item) {
                    return DropdownMenuItem<String>(
                      value: item["name"],
                      child: Text(item['name'],
                        style: TextStyle(fontSize: 12),
                        overflow: TextOverflow.fade,),
                    );
                  }).toList(),
                  onChanged: (value) {
                    inputPagePresenter.valItemGroup[index] =
                        value;
                    inputPagePresenter.update();
                    print("ini isi dropdown item/group : $value");
                    inputPagePresenter.getChoiceItemGroup(value, inputPagePresenter.valItemGroup[index]);
                    inputPagePresenter.getSupplyItem(value, inputPagePresenter.valCustomerChoice[index].value);
                  },
                )),
              ),
              SizedBox(height: 10,),
              //item group
              Container(
                // width: 150,
                child: Obx(() =>
                    SearchChoices.single(
                      isExpanded: true,
                      items: inputPagePresenter
                          .dataChoiceItemGroup.map((item) {
                        return DropdownMenuItem(
                          child: Text(item["nameProduct"] == null
                              ? item["NAME"]
                              : item["nameProduct"],
                            overflow: TextOverflow.fade,),
                          value: item["idProduct"] == null
                              ? item["NAME"]
                              : item["idProduct"].toString() + " " + item['nameProduct'].toString(),
                        );
                      }).toList(),
                      // value: inputPagePresenter.valChoiceItemGroup.value,
                      hint: Text(
                        "Select Product",
                        style: TextStyle(fontSize: 12),
                      ),
                      // searchHint: "Select product",
                      onChanged: (value) {
                        inputPagePresenter.valChoiceItemGroup[index].value = value;
                        print("ini dropdown item: $value");
                        // inputPagePresenter.update();
                        inputPagePresenter.getUnit(value);
                        inputPagePresenter.update();
                      },
                      // isExpanded: true,
                    )),
              ),

              //warehouse qyt
              Row(
                children: [
                  //customer/group
                  Container(
                      width: 150,
                      child: Obx(() =>
                          SearchChoices.single(
                            isExpanded: true,
                            value: inputPagePresenter.valWarehouse
                                .value,
                            hint: Text(
                              "Warehouse",
                              style: TextStyle(fontSize: 12),
                            ),
                            items: inputPagePresenter.dataWarehouse
                                .map((item) {
                              return DropdownMenuItem<String>(
                                child: Text(item['NAME'],
                                  style: TextStyle(fontSize: 12),
                                  overflow: TextOverflow.fade,),
                                value: item["NAME"],
                              );
                            }).toList(),
                            onChanged: (value) {
                              inputPagePresenter.valWarehouse.value =
                                  value;
                              inputPagePresenter.update();
                              print(
                                  "ini isi dropdown warehouse : $value");
                            },
                          ),)
                  ),
                  Spacer(),
                  //product
                  Container(
                    width: 60,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: qtyFromController,
                      decoration: InputDecoration(
                        labelText: 'Qty From',
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
                  Container(
                    width: 60,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: qtyToController,
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
                      child: Obx(() =>
                          DropdownButtonFormField(
                            value: inputPagePresenter.valUnit.value,
                            hint: Text(
                              "Unit",
                              style: TextStyle(fontSize: 12),
                            ),
                            items: inputPagePresenter.dataUnit.map((
                                item) {
                              return DropdownMenuItem(
                                child: Text(item ?? "Loading",
                                  style: TextStyle(fontSize: 12),
                                  overflow: TextOverflow.fade,),
                                value: item,
                              );
                            }).toList(),
                            onChanged: (value) {
                              inputPagePresenter.valUnit.value =
                                  value;
                              inputPagePresenter.update();
                            },
                          ),)
                  ),
                  Spacer(),
                  //multiply
                  Container(
                    width: 150,
                    child: Obx(()=>DropdownButtonFormField(
                      value: inputPagePresenter.valMultiply.value,
                      hint: Text(
                        "Multiply",
                        style: TextStyle(fontSize: 12),
                      ),
                      items: inputPagePresenter.dataMultiply.map((
                          item) {
                        return DropdownMenuItem<String>(
                          child: Text(item["name"],
                            style: TextStyle(fontSize: 12),
                            overflow: TextOverflow.fade,),
                          value: item["id"],
                        );
                      }).toList(),
                      onChanged: (value) {
                        inputPagePresenter.valMultiply.value = value;
                        inputPagePresenter.update();
                      },
                    )),
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
                            controller: fromDateController,
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
                            controller: toDateController,
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
                      child: Obx(() =>
                          DropdownButtonFormField(
                            value: inputPagePresenter.valCurrency
                                .value,
                            hint: Text(
                              "Currency",
                              style: TextStyle(fontSize: 12),
                            ),
                            items: inputPagePresenter.dataCurrency
                                .map((item) {
                              return DropdownMenuItem<String>(
                                value: item["name"],
                                child: Text(item["name"],
                                  style: TextStyle(fontSize: 12),
                                  overflow: TextOverflow.fade,),
                              );
                            }).toList(),
                            onChanged: (value) {
                              inputPagePresenter.valCurrency.value =
                                  value;
                              inputPagePresenter.update();
                            },
                          ),)
                  ),
                  Spacer(),
                  //multiply
                  Container(
                    width: 150,
                    child: Obx(()=>DropdownButtonFormField(
                      value: inputPagePresenter.valPercentValue.value,
                      hint: Text(
                        "Percent/Value",
                        style: TextStyle(fontSize: 12),
                      ),
                      items: inputPagePresenter.dataPercentValue.map((
                          item) {
                        return DropdownMenuItem<String>(
                          child: Text(item["name"],
                            style: TextStyle(fontSize: 12),
                            overflow: TextOverflow.fade,),
                          value: item["id"],
                        );
                      }).toList(),
                      onChanged: (value) {
                        inputPagePresenter.valPercentValue.value =
                            value;
                        inputPagePresenter.update();
                      },
                    )),
                  ),
                ],
              ),

              //percent
              Obx(()=>inputPagePresenter.valPercentValue.value == '2'?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //sales price
                  Container(
                    width: 60,
                    child: TextFormField(
                      controller: salesPriceController,
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
                      controller: priceToController,
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
                      controller: value1Controller,
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
                      controller: value2Controller,
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
                      controller: percent1Controller,
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
                      controller: percent2Controller,
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
                      controller: percent3Controller,
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
                      controller: percent4Controller,
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
              ),),

              Container(
                // width: 100,
                child: Obx(() =>
                    SearchChoices.single(
                      isExpanded: true,
                      items: inputPagePresenter
                          .dataSupplyItem.map((item) {
                        return DropdownMenuItem(
                          child: Text(item["nameProduct"] == null
                              ? item["NAME"]
                              : item["nameProduct"],
                            overflow: TextOverflow.fade,),
                          value: item["idProduct"] == null
                              ? item["NAME"]
                              : item["idProduct"],
                        );
                      }).toList(),
                      // value: inputPagePresenter.valChoiceItemGroup.value,
                      hint: Text(
                        "Supply Item",
                        style: TextStyle(fontSize: 12),
                      ),
                      onChanged: (value) {
                        inputPagePresenter.valSupplyItem = value;
                        print("ini dropdown item: $value");
                        inputPagePresenter.update();
                        // inputPagePresenter.getUnit(value);
                        inputPagePresenter.update();
                      },
                      // isExpanded: true,
                    )),
              ),

              //unit multiply
              Row(
                children: [
                  //unit
                  Container(
                    width: 50,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: qtyItemController,
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
                    child: Obx(() =>
                        DropdownButtonFormField(
                          value: inputPagePresenter.valUnit.value,
                          hint: Text(
                            "Unit Supply Item",
                            style: TextStyle(fontSize: 12),
                          ),
                          items: inputPagePresenter.dataUnit.map((
                              item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            inputPagePresenter.valUnit.value = value;
                            inputPagePresenter.update();
                          },
                        )),
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
  void initState() {
    // TODO: implement initState
    super.initState();
    // inputPagePresenter.getCustomer();
    inputPagePresenter.getWarehouse();
    inputPagePresenter.getLocation();
    inputPagePresenter.getVendor();
    value1Controller.text = 0.0.toString();
    value2Controller.text = 0.0.toString();
    qtyItemController.text = 0.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .primaryColorDark,
        title: Text("New Promotion Program"),
      ),
      body: SafeArea(
        child: Obx(()=>SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              //card1
              Container(
                margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                child: Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  borderOnForeground: true,
                  semanticContainer: true,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Create"),
                        SizedBox(
                          height: 5,
                        ),
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
                              child: TextFormField(
                                controller: programNumberController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: 'Program Number',
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
                              ),
                            ),
                            Spacer(),
                            //Program name
                            Container(
                              width: 150,
                              child: TextFormField(
                                controller: programNameController,
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
                              ),
                            ),
                          ],
                        ),

                        //dropdown
                        Row(
                          children: [
                            Container(
                              width: 150,
                              child: Obx(()=>DropdownButtonFormField(
                                value: inputPagePresenter.valType.value,
                                hint: Text(
                                  "Type",
                                  style: TextStyle(fontSize: 12),
                                ),
                                items: inputPagePresenter.dataType.map((item) {
                                  return DropdownMenuItem<String>(
                                    value: item["id"].toString(),
                                    child: Text(item["name"],
                                      style: TextStyle(fontSize: 12),),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  inputPagePresenter.valType.value = value;
                                  inputPagePresenter.update();
                                },
                              )),
                            ),
                            Spacer(),

                            //xx
                            Container(
                              width: 150,
                              child: Obx(() =>
                                  SearchChoices.single(
                                    isExpanded: true,
                                    value: inputPagePresenter.valVendor.value,
                                    hint: Text(''
                                        "Vendor",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    items: inputPagePresenter.dataVendor.map((
                                        item) {
                                      return DropdownMenuItem<String>(
                                        child: Text(item["VENDNAME"],
                                          style: TextStyle(fontSize: 12),),
                                        // item["idProduct"].toString() + " " + item['nameProduct'].toString()
                                        value: item["ACCOUNTNUM"].toString() + " " + item['VENDNAME'].toString(),//xx
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      inputPagePresenter.valVendor.value =
                                          value;
                                      inputPagePresenter.update();
                                    },
                                  ),),
                            ),
                          ],
                        ),


                        Row(
                          children: [
                            Container(
                              width: 150,
                              child: Obx(() =>
                                  DropdownButtonFormField(
                                    value: inputPagePresenter.valLocation.value,
                                    hint: Text(
                                      "Location",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    items: inputPagePresenter.dataLocation.map((
                                        item) {
                                      return DropdownMenuItem<String>(
                                        child: Text(item["NameSO"],
                                          style: TextStyle(fontSize: 12),),
                                        value: item["CodeSO"],
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      inputPagePresenter.valLocation.value =
                                          value;
                                      inputPagePresenter.update();
                                    },
                                  ),),
                            ),
                            Spacer(),
                            Container(
                                width: 150,
                                child: Obx(() =>
                                    DropdownButtonFormField(
                                      value: inputPagePresenter.valStatusTesting
                                          .value,
                                      hint: Text(
                                        "Status Testing",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      items: inputPagePresenter
                                          .dataStatusTesting.map((item) {
                                        return DropdownMenuItem<String>(
                                          value: item["name"],
                                          child: Text(item["name"],
                                            style: TextStyle(fontSize: 12),
                                            overflow: TextOverflow.fade,),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        inputPagePresenter.valStatusTesting
                                            .value = value;
                                        inputPagePresenter.update();
                                      },
                                    ),)
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

              //card2
              inputPagePresenter.cardsItem.length==0?RaisedButton(
                  color: Colors.green,
                  child: Text("Add Item"),
                  onPressed: () {
                    inputPagePresenter.addCardsItem(customCard(inputPagePresenter.cardsItem.length));
                  }):
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: inputPagePresenter.cardsItem.length,
                  itemBuilder: (context, index){
                    return Column(
                      children: [
                        inputPagePresenter.cardsItem[index],
                        index == inputPagePresenter.cardsItem.length -1 ?RaisedButton(
                            color: Colors.green,
                            child: Text("Submit"),
                            onPressed: () {
                              print("dropdown customergroup : ${inputPagePresenter.valCustomer}");
                              print("dropdown customerName : ${inputPagePresenter.valCustomerChoice}");
                              print("dropdown itemGroup : ${inputPagePresenter.valItemGroup}");
                              print("dropdown selectProduct : ${inputPagePresenter.valChoiceItemGroup}");
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
                            }):SizedBox()
                        // customButton(index),
                      ],
                    );
                  }
              ),
              // listCard(),

              //button xx
              // cardsItem.length==0?RaisedButton(
              //     color: Colors.green,
              //     child: Text("Add item"),
              //     onPressed: () { addCardsItem();}):SizedBox()
            ],
          ),
        )),
      ),
    );
  }
}
