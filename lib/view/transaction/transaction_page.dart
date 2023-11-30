import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_sms/assets/global.dart';
import 'package:mobile_sms/view/transaction/transaction_presenter.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:money_input_formatter/money_input_formatter.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import 'dart:collection';
import '../../models/input-page-wrapper.dart';
import '../../models/promotion-program-input-state.dart';

class TransactionPage extends StatefulWidget {
  TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  Widget customCard(int index, TransactionPresenter inputPagePresenter){
    PromotionProgramInputState promotionProgramInputState = inputPagePresenter.promotionProgramInputStateRx.value.promotionProgramInputState![index];

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
                        // Future.delayed(Duration(milliseconds: ),(){
                          inputPagePresenter.removeItem(index);
                        // });
                        // Future.delayed(Duration(milliseconds: 500),(){
                        //   setState(() {
                        //   });
                        // });
                      },
                      icon: Icon(Icons.delete,)
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(height: 10,),
              SearchChoices.single(
                  isExpanded: true,
                  value: promotionProgramInputState.productTransactionPageDropdownState!.selectedChoiceWrapper!.value,
                  items: promotionProgramInputState.productTransactionPageDropdownState!.choiceListWrapper!.value!.map((item) {
                    return DropdownMenuItem(
                        child: Text(item.value!),
                        value: item
                    );
                  }).toList(),
                  hint: Text(
                    "Select Product",
                    style: TextStyle(fontSize: 12),
                  ),
                  onChanged: (value){
                    inputPagePresenter.changeProduct(index, value);
                    Future.delayed(Duration(seconds: 1, milliseconds: 500),(){
                      setState(() {
                      });
                    });
                  }
                // isExpanded: true,
              ),
              SearchChoices.single(
                  isExpanded: true,
                  value: promotionProgramInputState.unitPageDropdownState!.selectedChoice,
                  items: promotionProgramInputState.unitPageDropdownState!.choiceList!.map((item) {
                    return DropdownMenuItem(
                        child: Text(item),
                        value: item
                    );
                  }).toList(),
                  hint: Text(
                    "Select Unit",
                    style: TextStyle(fontSize: 12),
                  ),
                  onChanged: (value){
                    inputPagePresenter.changeUnit(index, value);
                    Future.delayed(Duration(seconds: 1),(){
                      setState(() {

                      });
                    });
                  }
                // isExpanded: true,
              ),
              Container(
                width: Get.width,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: promotionProgramInputState.qtyTransaction,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Qty',
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
                  onTap: (){
                    Get.defaultDialog(
                        title: "",
                        barrierDismissible: false,
                        onWillPop: () {
                          return Future.value(false);
                        },
                        content: TextFormField(
                          controller: promotionProgramInputState.qtyTransaction,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          decoration: InputDecoration(
                              labelText: "Set Qty : ",
                              suffixText: ""
                          ),
                        ),
                        confirm: TextButton(
                            style: TextButton.styleFrom(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: colorSecondary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                            ),
                            child: Text(
                              "Ok",
                              style:
                              TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              inputPagePresenter.changeQty(index, promotionProgramInputState.qtyTransaction!.text);
                              Get.back();
                            }),
                    );
                  },
                ),
              ),
              Container(
                width: Get.width,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: promotionProgramInputState.priceTransaction,
                  inputFormatters: [
                    MoneyInputFormatter(thousandSeparator: ".", decimalSeparator: ",")
                  ],
                  decoration: InputDecoration(
                    prefixText: "Rp ",
                    labelText: 'Price',
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
                  readOnly: true,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 17,
                      fontFamily: 'AvenirLight'),
                  // onChanged: (value){
                  //   inputPagePresenter.changePrice(index, promotionProgramInputState.priceTransaction.text);
                  // },
                  onTap: (){
                    Get.defaultDialog(
                        title: "",
                        barrierDismissible: false,
                        onWillPop: () {
                          return Future.value(false);
                        },
                        content: TextFormField(
                          controller: promotionProgramInputState.priceTransaction,
                          keyboardType: TextInputType.number,
                          // onChanged: (value){
                          //   textFormField.inputFormatters.removeWhere((formatter) => formatter is MoneyInputFormatter);
                          // },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            MoneyInputFormatter(thousandSeparator: ".", decimalSeparator: ",")
                          ],
                          decoration: InputDecoration(
                              labelText: "Set Price : ",
                              suffixText: ""
                          ),
                        ),
                        confirm: TextButton(
                            style: TextButton.styleFrom(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: colorSecondary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                            ),
                            child: Text(
                              "Ok",
                              style:
                              TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                                inputPagePresenter.changePrice(index, promotionProgramInputState.priceTransaction!.text);
                              Get.back();
                            }),
                    );
                  },
                  //  controller: _passwordController,
                ),
              ),
              Container(
                width: Get.width,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: promotionProgramInputState.discTransaction,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Disc',
                    suffixText: "(%)",
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
                  // onChanged: (value){
                  //   inputPagePresenter.changeDisc(index, promotionProgramInputState.discTransaction.text);
                  // },
                  onTap: (){
                    Get.defaultDialog(
                        title: "",
                        barrierDismissible: false,
                        onWillPop: () {
                          return Future.value(false);
                        },
                        content: TextFormField(
                          controller: promotionProgramInputState.discTransaction,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          decoration: InputDecoration(
                              labelText: "Set Discount : ",
                              suffixText: "%"
                          ),
                        ),
                        confirm: TextButton(
                            style: TextButton.styleFrom(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: colorSecondary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                            ),
                            child: Text(
                              "Ok",
                              style:
                              TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              inputPagePresenter.changeDisc(index, promotionProgramInputState.discTransaction!.text);
                              Get.back();
                            }),
                    );
                  },
                ),
              ),
              SizedBox(height: 8,),
              Text("Total",style: TextStyle(fontSize: 11),),
              SizedBox(height: 3,),
              Text(promotionProgramInputState.totalTransaction!.value.text.isEmpty?"0":"Rp "+MoneyFormatter(amount: double.parse(promotionProgramInputState.totalTransaction!.value.text.replaceAll(",", ""))).output.withoutFractionDigits),
              Divider(
                thickness: 1,
                color: Colors.black54,
              )
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
    final inputPagePresenter = Get.put(TransactionPresenter());
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).primaryColorDark,
      //   title: Text("New Transaction"),
      // ),
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
                          Container(
                            width: Get.width,
                            child: Obx(() => SearchChoices.single(
                              isExpanded: true,
                              value: inputPagePresenter.customerNameInputPageDropdownStateRx.value.selectedChoice,
                              hint: Text(
                                "Customer Name",
                                style: TextStyle(fontSize: 12),
                              ),
                              items: inputPagePresenter.customerNameInputPageDropdownStateRx.value.choiceList?.map((item) {
                                return DropdownMenuItem(
                                  child: Text(
                                      item.value!,
                                      style: TextStyle(fontSize: 12)
                                  ),
                                  value: item,
                                );
                              }).toList(),
                              onChanged: (value) => inputPagePresenter.changeSelectCustomer(value),
                            )),
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
                  List<PromotionProgramInputState>? promotionProgramInputStateList = inputPageWrapper.promotionProgramInputState;
                  bool? isAddItem = inputPageWrapper.isAddItem;
                  return promotionProgramInputStateList?.length == 0 ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text("Add Data Transaction"),
                      onPressed: isAddItem! ? () => inputPagePresenter.addItem() : null
                  ) : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: promotionProgramInputStateList?.length,
                      itemBuilder: (context, index) => Column(
                        children: [
                          customCard(index, inputPagePresenter),
                          SizedBox(
                            height: 10,
                          ),

                          index == promotionProgramInputStateList!.length - promotionProgramInputStateList.length ? Column(
                            children: [

                            ],
                          ) : SizedBox(),
                          index == promotionProgramInputStateList.length - promotionProgramInputStateList.length ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: Text("Submit"),
                              onPressed: (){
                                List<PromotionProgramInputState>? promotionProgramInputState = inputPagePresenter.promotionProgramInputStateRx.value.promotionProgramInputState?.toList();
                                List<String?>? disc = promotionProgramInputState?.map((e) => e.discTransaction?.text).toList();
                                List<String?>? price = promotionProgramInputState?.map((e) => e.priceTransaction?.text).toList();
                                print(disc);
                                print("originalPrice ${inputPagePresenter.originalPrice.toString()}");
                                print("Editing price :${price}");
                                bool isEqual = listEquals(inputPagePresenter.originalPrice, price);
                                if(isEqual){
                                  print("x");
                                  inputPagePresenter.submitPromotionProgram();
                                }else{
                                  print("y");

                                  Future.delayed(Duration(seconds: 1, milliseconds: 500),(){
                                    inputPagePresenter.submitPromotionProgram();
                                  });
                                  Future.delayed(Duration(seconds: 1, milliseconds: 500),(){
                                    inputPagePresenter.submitPromotionProgramAll();
                                  });
                                }
                                // inputPagePresenter.submitPromotionProgram();
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


















// import 'dart:convert';
//
// import 'package:dropdown_date_picker/dropdown_date_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart';
// import 'package:search_choices/search_choices.dart';
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
//
// class TransactionPage extends StatefulWidget {
//   const TransactionPage({Key key}) : super(key: key);
//
//   @override
//   State<TransactionPage> createState() => _TransactionPageState();
// }
//
// class _TransactionPageState extends State<TransactionPage> {
//
//   String valCustomer;
//   List<dynamic> _dataCustomer = [];
//   TextEditingController dateController = TextEditingController();
//   void getCustomer() async {
//     var urlGetCustomer = "http://119.18.157.236:8869/api/custtables";
//     final response = await get(Uri.parse(urlGetCustomer));
//     var listData = jsonDecode(response.body);
//     print(urlGetCustomer);
//     setState(() {
//       _dataCustomer = listData;
//       if (!categoryContains(valCustomer)) {
//         valCustomer = null;
//       }
//     });
//     print("Data Customer : $listData");
//   }
//
//   bool categoryContains(String customer) {
//     for (int i = 0; i < _dataCustomer.length; i++) {
//       if (customer == _dataCustomer[i]["CUSTNAME"]) return true;
//     }
//     return false;
//   }
//
//   final timeNow = DateTime.now();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getCustomer();
//     getProduct();
//     dateController.text = timeNow.toString();
//     print(dataItemTransaction.length);
//   }
//
//   List dataItemTransaction = [];
//
//   String valProduct = "";
//   List valProductList;
//   List<dynamic> _dataProduct = [];
//
//   void getProduct() async {
//     var urlGetProduct = "http://119.18.157.236:8869/api/PrbItemTables";
//     final response = await get(Uri.parse(urlGetProduct));
//     var listData = jsonDecode(response.body);
//     print(urlGetProduct);
//     setState(() {
//       _dataProduct = listData;
//       // if (!categoryContains(valCustomer)) {
//       //   valProduct = null;
//       // }
//     });
//     print("Data Customer : $listData");
//   }
//
//   bool productContains(String product) {
//     for (int i = 0; i < _dataProduct.length; i++) {
//       if (product == _dataProduct[i]["ITEMNAME"]) return true;
//     }
//     return false;
//   }
//
//   Widget cardDataTransaction(int index){
//
//     return Container(
//       margin: EdgeInsets.only(top: 10, left: 20, right: 20),
//       child: Card(
//         elevation: 20,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         borderOnForeground: true,
//         semanticContainer: true,
//         child: Container(
//           padding: EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Text("Data Transaction"),
//                   Spacer(),
//                   InkWell(
//                       onTap: (){
//                         addDataItemTransaction();
//                       },
//                       child: Icon(Icons.add,size: 16,)),
//                   SizedBox(width: 12,),
//                   InkWell(
//                       onTap: (){
//                         setState(() {
//                           dataItemTransaction.removeAt(index);
//                           print("dataItemTransaction :${dataItemTransaction.length}");
//                         });
//                       },
//                       child: Icon(Icons.delete,size: 16,)),
//                 ],
//               ),
//               SizedBox(height: 4,),
//               Divider(
//                 thickness: 1,
//                 color: Colors.black54,
//               ),
//               SizedBox(height: 12),
//               Row(
//                 children: [
//                   Text("Product Name  : "),
//                   Expanded(child: SearchChoices.single(
//                     // autovalidateMode: AutovalidateMode.onUserInteraction,
//                     isExpanded: true,
//                     hint: Text("Select Product"),
//                     value: valProduct,
//                     items: _dataProduct.map((item) {
//                       return DropdownMenuItem(
//                         child: Text(item['ITEMNAME'] ?? "loading.."),
//                         value: item['ITEMNAME']??"",
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         valProductList[index] = value;
//                         valProduct = valProductList[index];
//                       });
//                     },
//                   ))
//                 ],
//               ),
//               SizedBox(height: 12),
//               Row(
//                 children: [
//                   Text("Qty  : "),
//                   Text("1"),
//                 ],
//               ),
//               SizedBox(height: 12),
//               Row(
//                 children: [
//                   Text("Harga  : "),
//                   Text("Rp 1000"),
//                 ],
//               ),
//               SizedBox(height: 12),
//               Row(
//                 children: [
//                   Text("Disc  : "),
//                   Text("1%"),
//                 ],
//               ),
//               SizedBox(height: 12),
//               Row(
//                 children: [
//                   Text("Total  : "),
//                   Text("Rp 10000"),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   addDataItemTransaction(){
//     setState(() {
//       int i=0;
//       dataItemTransaction.add(cardDataTransaction(i));
//       print("dataItemTransaction :${dataItemTransaction.length}");
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).primaryColorDark,
//         title: Text("Transaction Program"),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 margin: EdgeInsets.only(top: 30, left: 20, right: 20),
//                 child: Card(
//                   elevation: 20,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   borderOnForeground: true,
//                   semanticContainer: true,
//                   child: Container(
//                     padding: EdgeInsets.all(10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Create"),
//                         SizedBox(height: 5),
//                         Text(
//                           "Setup a trade agreement",
//                           style: TextStyle(fontSize: 10, color: Colors.black54),
//                         ),
//                         Container(
//                           width: Get.width,
//                           child: SearchChoices.single(
//                             // autovalidateMode: AutovalidateMode.onUserInteraction,
//                             isExpanded: true,
//                             hint: Text("Select Customer"),
//                             value: valCustomer,
//                             items: _dataCustomer.map((item) {
//                               return DropdownMenuItem(
//                                 child: Text(item['CUSTNAME'] ?? "loading.."),
//                                 value: item['CUSTNAME'],
//                               );
//                             }).toList(),
//                             onChanged: (value) {
//                               setState(() {
//                                 valCustomer = value;
//                               });
//                             },
//                           ),
//                         ),
//                         Container(
//                           width: Get.width,
//                           child: TextFormField(
//                             keyboardType: TextInputType.text,
//                             decoration: InputDecoration(
//                               labelText: 'Customer Id',
//                               labelStyle: TextStyle(
//                                   color: Colors.black87,
//                                   fontSize: 12,
//                                   fontFamily: 'AvenirLight'
//                               ),
//                               focusedBorder: UnderlineInputBorder(
//                                 borderSide:
//                                 BorderSide(color: Colors.purple),
//                               ),
//                               enabledBorder: new UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Colors.grey, width: 1.0
//                                   )
//                               ),
//                             ),
//                             style: TextStyle(
//                                 color: Colors.black87,
//                                 fontSize: 17,
//                                 fontFamily: 'AvenirLight'
//                             ),
//                           ),
//                         ),
//                         Container(
//                           width: Get.width,
//                           child: TextFormField(
//                             keyboardType: TextInputType.text,
//                             readOnly: true,
//                             controller: dateController,
//                             decoration: InputDecoration(
//                               labelText: 'Date',
//                               labelStyle: TextStyle(
//                                   color: Colors.black87,
//                                   fontSize: 12,
//                                   fontFamily: 'AvenirLight'
//                               ),
//                               focusedBorder: UnderlineInputBorder(
//                                 borderSide:
//                                 BorderSide(color: Colors.purple),
//                               ),
//                               enabledBorder: new UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Colors.grey, width: 1.0
//                                   )
//                               ),
//                             ),
//                             style: TextStyle(
//                                 color: Colors.black87,
//                                 fontSize: 17,
//                                 fontFamily: 'AvenirLight'
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               dataItemTransaction.length==0?Center(
//                 child: ElevatedButton(
//                   child: Text("Add"),
//                   onPressed: (){
//                     addDataItemTransaction();
//                   },
//                 ),
//               ):ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: dataItemTransaction.length,
//                   padding: EdgeInsets.only(bottom: 30),
//                   itemBuilder: (context, index){
//                     return cardDataTransaction(index);
//                   })
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
