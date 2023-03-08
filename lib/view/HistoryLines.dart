import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:mobile_sms/assets/widgets/ConditionNull.dart';
import 'package:mobile_sms/assets/widgets/TextResultCard.dart';
import 'package:mobile_sms/models/Lines.dart';
import 'package:mobile_sms/models/Promosi.dart';
import 'package:mobile_sms/models/User.dart';
import 'package:mobile_sms/providers/LinesProvider.dart';
import 'package:mobile_sms/view/HistoryNomorPP_Pending.dart';
import 'package:mobile_sms/view/dashboard/dashboard_approvalpp.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:money_input_formatter/money_input_formatter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ApiConstant.dart';
import 'HistoryNomorPP.dart';
import 'HistorySO.dart';
import 'dashboard/DashboardPage.dart';

class HistoryLines extends StatefulWidget {
  @override
  _HistoryLinesState createState() => _HistoryLinesState();
  String numberPP;
  int idEmp;

  HistoryLines({this.numberPP, this.idEmp});
}

class _HistoryLinesState extends State<HistoryLines> {
  List _listHistorySO;
  dynamic _listHistorySOEncode;
  bool _statusDisable = true;
  GlobalKey<RefreshIndicatorState> refreshKey;
  List<int> _listid = new List<int>();
  List<Lines> listDisc = new List<Lines>();
  DateTime selectedDate = DateTime.now();
  DateTime fromDate, toDate = null;
  DateTime dateFrom, dateTo;
  double discount = null;
  User _user;
  int code;

  bool valueSelectAll = false;
  bool startApp = false;

  var dataHeader;

  Future<Null> listHistorySO() async {
    await Future.delayed(Duration(seconds: 1));
    Promosi.getListLines(widget.numberPP, code, _user.token, _user.username)
        .then((value) {
      setState(() {
        _listHistorySO = value;
        _listHistorySOEncode = value;
        _listHistorySOEncode = jsonEncode(_listHistorySO);
        dataHeader = jsonDecode(_listHistorySOEncode);
      });
    });
    return null;
  }

  List dataSupplyItem = [];

  getSupplyItem() async {
    var url = "http://119.18.157.236:8869/api/PrbItemTables";
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      final listData = jsonDecode(response.body);
      setState(() {
        dataSupplyItem = listData;
      });
      print("dataSupplyItem :$dataSupplyItem");
    }
  }

  List dataSupplyUnit = [];

  getSupplyUnit(String itemId) async {
    var url = "http://119.18.157.236:8878/api/Unit?item=${itemId}";
    print("urlGetSupplyUnit : $url");
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      final listData = jsonDecode(response.body);
      setState(() {
        dataSupplyUnit = listData;
      });
      print("dataSupplyUnit :$dataSupplyUnit");
    }
  }

  List dataWarehouse = [];

  getWarehouse() async {
    var url = "http://119.18.157.236:8869/api/Warehouse";
    print("urlGetWarehouse : $url");
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      final listData = jsonDecode(response.body);
      setState(() {
        dataWarehouse = listData;
      });
      print("dataWarehouse :$dataWarehouse");
    }
  }

  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    getSharedPreference();
    getSupplyItem();
    Future.delayed(const Duration(seconds: 2), () {
      startApp = true;
      listHistorySO();
      // setState(() {
      List<Promosi> data = _listHistorySO;
      print(_listHistorySO);
      List disc1 =
          data.map((element) => element.disc1.split(".").first).toList();
      List disc2 =
          data.map((element) => element.disc2.split(".").first).toList();
      List disc3 =
          data.map((element) => element.disc3.split(".").first).toList();
      List disc4 =
          data.map((element) => element.disc4.split(".").first).toList();
      List value1 = data
          .map((element) => MoneyFormatter(amount: double.parse(element.value1))
              .output
              .withoutFractionDigits)
          .toList();
      List value2 = data
          .map((element) => MoneyFormatter(amount: double.parse(element.value2))
              .output
              .withoutFractionDigits)
          .toList();
      List suppQty = data.map((element) => element.suppQty).toList();
      List suppItem = data.map((element) => element.suppItem).toList();
      List suppUnit = data.map((element) => element.suppUnit).toList();
      List warehouse = data.map((element) => element.warehouse).toList();
      List fromDate =
          data.map((element) => element.fromDate.split(" ").first).toList();
      List toDate =
          data.map((element) => element.toDate.split(" ").first).toList();
      for (int i = 0; i < disc1.length; i++) {
        disc1Controller.add(TextEditingController()..text = disc1[i]);
        // disc1Controller[i]..text = disc1[i];
      }
      for (int i = 0; i < disc2.length; i++) {
        disc2Controller.add(TextEditingController()..text = disc2[i]);
        // disc2Controller[i]..text = disc2[i];
      }
      for (int i = 0; i < disc3.length; i++) {
        disc3Controller.add(TextEditingController()..text = disc3[i]);
        // disc3Controller[i]..text = disc3[i];
      }
      for (int i = 0; i < disc4.length; i++) {
        disc4Controller.add(TextEditingController()..text = disc4[i]);
        // disc4Controller[i]..text = disc4[i];
      }
      for (int i = 0; i < value1.length; i++) {
        value1Controller.add(TextEditingController()..text = value1[i]);
        // value1Controller[i]..text = value1[i];
      }
      for (int i = 0; i < value2.length; i++) {
        value2Controller.add(TextEditingController()..text = value2[i]);
        // value2Controller[i]..text = value2[i];
      }
      for (int i = 0; i < suppQty.length; i++) {
        suppQtyController.add(TextEditingController()..text = suppQty[i]);
        // suppQtyController[i]..text = suppQty[i];
      }
      for (int i = 0; i < suppItem.length; i++) {
        suppItemController.add(suppItem[i]);
        // suppQtyController[i]..text = suppQty[i];
      }
      for (int i = 0; i < suppUnit.length; i++) {
        suppUnitController.add(suppUnit[i]);
        // suppQtyController[i]..text = suppQty[i];
      }
      for (int i = 0; i < warehouse.length; i++) {
        warehouseController.add(warehouse[i]);
        // suppQtyController[i]..text = suppQty[i];
      }
      for (int i = 0; i < fromDate.length; i++) {
        fromDateController.add(TextEditingController()..text = fromDate[i]);
        // suppQtyController[i]..text = suppQty[i];
      }
      for (int i = 0; i < toDate.length; i++) {
        toDateController.add(TextEditingController()..text = toDate[i]);
        // suppQtyController[i]..text = suppQty[i];
      }
    });
    // });
  }

  Promosi promosi;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressLines,
      child: MaterialApp(
        theme: Theme.of(context),
        home: ChangeNotifierProvider<LinesProvider>(
          create: (ctx) => LinesProvider(),
          child: Scaffold(
            floatingActionButton: startApp == false
                ? null
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton.extended(
                        label: Text("Select All"),
                        onPressed: () {
                          setState(() {
                            valueSelectAll = !valueSelectAll;
                            List<Promosi> data = _listHistorySO;
                            print(_listHistorySO);
                            List<bool> status =
                                data.map((element) => element.status).toList();
                            if (valueSelectAll == true) {
                              _listHistorySO
                                  .map((e) => e.status = true)
                                  .toList();
                              // status = status.map<bool>((e) => true).toList();
                            } else {
                              _listHistorySO
                                  .map((e) => e.status = false)
                                  .toList();
                            }
                            print("status 1 : $status");
                            print("status 2 : ${jsonEncode(_listHistorySO)}");
                          });
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      startApp == false
                          ? null
                          : Padding(
                              padding:
                                  const EdgeInsets.only(left: 60, right: 20),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Consumer<LinesProvider>(
                                  builder: (context, linesProv, _) => Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.all(
                                                ScreenUtil().setWidth(13)),
                                            backgroundColor: Colors.red,
                                          ),
                                          child: Text(
                                            'Reject',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(25),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed: () {
                                            print(
                                                "valueSelectAll :$valueSelectAll");
                                            // print("promosi.status :${promosi.status}");
                                            List checkBox = _listHistorySO
                                                .map(
                                                    (element) => element.status)
                                                .toList();
                                            // log("valcheck :${jsonEncode(_listHistorySO)}");
                                            log("check0 :${checkBox}");
                                            if (checkBox.contains(false)) {
                                              // GetSnackBar();
                                              Get.snackbar("Error",
                                                  "Checklist all for reject!!",
                                                  backgroundColor: Colors.red,
                                                  icon: Icon(Icons.error));
                                            } else {
                                              approveNew("Reject");
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.all(
                                                ScreenUtil().setWidth(13)),
                                            backgroundColor: Theme.of(context)
                                                .primaryColorDark,
                                          ),
                                          child: Text(
                                            'Approve',
                                            style: TextStyle(
                                              color:
                                                  Theme.of(context).accentColor,
                                              fontSize: ScreenUtil().setSp(25),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed: () {
                                            // valueSelectAll?valueSelectAll:promosi.status;
                                            print(
                                                "valueSelectAll :$valueSelectAll");
                                            // print("promosi.status :${promosi.status}");
                                            List checkBox = _listHistorySO
                                                .map(
                                                    (element) => element.status)
                                                .toList();
                                            // log("valcheck :${jsonEncode(_listHistorySO)}");
                                            log("check0 :${checkBox}");
                                            if (checkBox.contains(false)) {
                                              // GetSnackBar();
                                              Get.snackbar("Error",
                                                  "Checklist all for approve!!",
                                                  backgroundColor: Colors.red,
                                                  icon: Icon(Icons.error));
                                            } else {
                                              approveNew("Approve");
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColorDark,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: onBackPressLines,
              ),
              title: Text(
                "List Lines",
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(20),
                    color: Theme.of(context).accentColor),
              ),
            ),
            body: /*startApp==false?Center(child: CircularProgressIndicator()):*/
                Scaffold(
              body: RefreshIndicator(
                onRefresh: listHistorySO,
                child: FutureBuilder(
                  future: Promosi.getListLines(
                      widget.numberPP, code, _user?.token, _user?.username),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    _listHistorySO == null
                        ? _listHistorySO = snapshot.data
                        : _listHistorySO = _listHistorySO;
                    if (_listHistorySO == null) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(
                            semanticsLabel: "Loading...",
                          ),
                        ),
                      );
                    } else {
                      if (_listHistorySO[0].codeError == 404 ||
                          _listHistorySO[0].codeError == 303) {
                        return ConditionNull(
                            message: _listHistorySO[0].message);
                      } else {
                        return startApp == false
                            ? Center(child: CircularProgressIndicator())
                            : SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          TextResultCard(
                                            context: context,
                                            title: "No. PP",
                                            value: RegExp(r"\d{2}-\d{2}-\d{4} \d{2}:\d{2}:\d{2}")
                                                            .hasMatch(dataHeader[
                                                                    0]
                                                                ["nomorPP"]) ==
                                                        true
                                                    ? dataHeader[0]["nomorPP"]
                                                        .replaceRange(
                                                            34, null, "")
                                                    : dataHeader[0]["nomorPP"],
                                          ),
                                          TextResultCard(
                                            context: context,
                                            title: "PP. Type",
                                            value: "${dataHeader[0]["type"]}",
                                          ),
                                          TextResultCard(
                                            context: context,
                                            title: "Customer",
                                            value: "${dataHeader[0]["customer"]}",
                                          ),
                                          TextResultCard(
                                            context: context,
                                            title: "Note",
                                            value: "${dataHeader[0]["note"]}",
                                          ),
                                          Container(
                                              width: ScreenUtil().setHeight(
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              child: Consumer<LinesProvider>(
                                                  builder:
                                                      (context, linesProv, _) {
                                                fromDateHeaderController.text =
                                                    dataHeader[0]['fromDate']
                                                        .split(" ")
                                                        .first;
                                                return TextFormField(
                                                  readOnly: true,
                                                  controller:
                                                      fromDateHeaderController,
                                                  keyboardType:
                                                      TextInputType.datetime,
                                                  onTap: () async {
                                                    final selectedDate =
                                                        await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime.now()
                                                          .subtract(Duration(
                                                              days: 365)),
                                                      lastDate: DateTime.now()
                                                          .add(Duration(
                                                              days: 365)),
                                                    );
                                                    if (selectedDate != null) {
                                                      fromDateHeaderController
                                                          .text = DateFormat(
                                                              'dd/MMM/yyyy')
                                                          .format(selectedDate);
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      filled: true,
                                                      labelText: 'From Date',
                                                      hintStyle: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontSize: 15),
                                                      errorStyle: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .errorColor,
                                                          fontSize: 15)),
                                                );
                                              })),
                                          Container(
                                              width: ScreenUtil().setHeight(
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              child: Consumer<LinesProvider>(
                                                  builder:
                                                      (context, linesProv, _) {
                                                toDateHeaderController.text =
                                                    dataHeader[0]['toDate']
                                                        .split(" ")
                                                        .first;
                                                return TextFormField(
                                                  readOnly: true,
                                                  controller:
                                                      toDateHeaderController,
                                                  keyboardType:
                                                      TextInputType.datetime,
                                                  onTap: () async {
                                                    final selectedDate =
                                                        await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime.now()
                                                          .subtract(Duration(
                                                              days: 365)),
                                                      lastDate: DateTime.now()
                                                          .add(Duration(
                                                              days: 365)),
                                                    );
                                                    if (selectedDate != null) {
                                                      toDateHeaderController
                                                          .text = DateFormat(
                                                              'dd/MMM/yyyy')
                                                          .format(selectedDate);
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      filled: true,
                                                      labelText: 'To Date',
                                                      hintStyle: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontSize: 15),
                                                      errorStyle: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .errorColor,
                                                          fontSize: 15)),
                                                );
                                              })),
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                      itemCount: _listHistorySO?.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.only(
                                          bottom: Get.height - 655),
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return CardLinesAdapter(widget.numberPP,
                                            _listHistorySO[index], index);
                                      },
                                    ),
                                  ],
                                ),
                              );
                      }
                    }
                  },
                ),
              ),
            ),
            // bottomNavigationBar: startApp==false?null:Container(
            //   width: MediaQuery.of(context).size.width,
            //   child: Consumer<LinesProvider>(
            //     builder: (context, linesProv, _) => Row(
            //       children: [
            //         Expanded(
            //           child: ElevatedButton(
            //             style: ElevatedButton.styleFrom(
            //               padding: EdgeInsets.all(ScreenUtil().setWidth(13)),
            //               backgroundColor: Colors.red,
            //             ),
            //             child: Text(
            //               'Reject',
            //               style: TextStyle(
            //                 color: Colors.white,
            //                 fontSize: ScreenUtil().setSp(25),
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //             onPressed: () {
            //               print("valueSelectAll :$valueSelectAll");
            //               // print("promosi.status :${promosi.status}");
            //               List checkBox = _listHistorySO.map((element) => element.status).toList();
            //               log("valcheck :${jsonEncode(_listHistorySO)}");
            //               log("check0 :${checkBox}");
            //               if(checkBox.contains(false)){
            //                 // GetSnackBar();
            //                 Get.snackbar("Error", "Checklist all for reject!!",backgroundColor: Colors.red,icon: Icon(Icons.error));
            //               }else{
            //                 approveNew("Reject");
            //               }
            //             },
            //           ),
            //         ),
            //         Expanded(
            //           child: ElevatedButton(
            //             style: ElevatedButton.styleFrom(
            //               padding: EdgeInsets.all(ScreenUtil().setWidth(13)),
            //               backgroundColor: Theme.of(context).primaryColorDark,
            //             ),
            //             child: Text(
            //               'Approve',
            //               style: TextStyle(
            //                 color: Theme.of(context).accentColor,
            //                 fontSize: ScreenUtil().setSp(25),
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //             onPressed: () {
            //               // valueSelectAll?valueSelectAll:promosi.status;
            //               print("valueSelectAll :$valueSelectAll");
            //               // print("promosi.status :${promosi.status}");
            //               List checkBox = _listHistorySO.map((element) => element.status).toList();
            //               log("valcheck :${jsonEncode(_listHistorySO)}");
            //               log("check0 :${checkBox}");
            //               if(checkBox.contains(false)){
            //                 // GetSnackBar();
            //                 Get.snackbar("Error", "Checklist all for approve!!",backgroundColor: Colors.red,icon: Icon(Icons.error));
            //               }else{
            //                 approveNew("Approve");
            //               }
            //             },
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ),
        ),
      ),
    );
  }

  List<TextEditingController> disc1Controller = [];
  List<TextEditingController> disc2Controller = [];
  List disc2Value = [];
  List<TextEditingController> disc3Controller = [];
  List<TextEditingController> disc4Controller = [];
  List<TextEditingController> value1Controller = [];
  List<TextEditingController> value2Controller = [];
  List<TextEditingController> fromDateController = [];
  List<TextEditingController> toDateController = [];
  TextEditingController fromDateHeaderController = TextEditingController();
  TextEditingController toDateHeaderController = TextEditingController();
  List suppItemController = [];
  List suppUnitController = [];
  List warehouseController = [];
  List<TextEditingController> suppQtyController = [];

  Container CardLinesAdapter(String namePP, Promosi promosi, int index) {
    List<Promosi> data = _listHistorySO;
    print(_listHistorySO);
    double price = double.parse(
        promosi.price.replaceAll(RegExp("Rp"), "").replaceAll(".", ""));
    double disc1 = double.parse(promosi.disc1);
    double disc2 = double.parse(promosi.disc2);
    double disc3 = double.parse(promosi.disc3);
    double disc4 = double.parse(promosi.disc4);
    double discValue1 = double.parse(promosi.value1);
    double discValue2 = double.parse(promosi.value2);
    double totalPriceDiscOnly =
        price - (price * ((disc1 + disc2 + disc3 + disc4) / 100));
    double totalPriceDiscValue = price - (discValue1 + discValue2);

    List qtyFrom = data.map((element) => element.qty).toList();
    List fromDate = data.map((element) => element.toDate).toList();
    print("qty fromCard :$qtyFrom");
    List qtyTo = data.map((element) => element.qtyTo).toList();
    print("qty toCard :$qtyTo");
    return Container(
        margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
        padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColorDark),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                startApp == false
                    ? SizedBox()
                    : Container(
                        alignment: Alignment.topLeft,
                        child: CheckboxListTile(
                          value:
                              valueSelectAll ? valueSelectAll : promosi.status,
                          onChanged: (bool value) {
                            setState(() {
                              promosi.status = value;
                              // _statusDisable = value;
                              value == true
                                  ? _statusDisable =
                                      false //_listid.add(promosi.id)
                                  : _statusDisable =
                                      true; //_listid.remove(promosi.id);
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: Colors.red,
                        ),
                      ),
              ],
            ),

            TextResultCard(
              context: context,
              title: "Product",
              value: promosi.product,
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  child: TextResultCard(
                    context: context,
                    title: "Qty From",
                    value: qtyFrom[index].toString(),
                  ),
                ),
                Container(
                  width: 150,
                  child: TextResultCard(
                    context: context,
                    title: "Qty To",
                    value: qtyTo[index].toString(),
                  ),
                ),
              ],
            ),
            TextResultCard(
              context: context,
              title: 'Unit',
              value: promosi.unitId,
            ),
            TextResultCard(
              context: context,
              title: "Price",
              value: promosi.price,
            ),
            //Discount
            promosi.ppType == "Bonus"
                ? SizedBox()
                : Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
                        width: MediaQuery.of(context).size.width / 5,
                        child: Text(
                          "Disc1(%) PRB",
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Consumer<LinesProvider>(
                          builder: (context, linesProv, _) {
                            return TextFormField(
                              keyboardType: TextInputType.number,
                              controller: disc1Controller.isEmpty
                                  ? TextEditingController()
                                  : disc1Controller[index],
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  promosi.disc1 = "0.0";
                                  double disc1 = double.parse(promosi.disc1);
                                  double disc2 = double.parse(promosi.disc2);
                                  double disc3 = double.parse(promosi.disc3);
                                  double disc4 = double.parse(promosi.disc4);
                                  setState(() {
                                    totalPriceDiscOnly = price -
                                        (price *
                                            ((disc1 + disc2 + disc3 + disc4) /
                                                100));
                                  });
                                } else {
                                  promosi.disc1 = value.replaceAll(".", "");
                                  double disc1 = double.parse(promosi.disc1);
                                  double disc2 = double.parse(promosi.disc2);
                                  double disc3 = double.parse(promosi.disc3);
                                  double disc4 = double.parse(promosi.disc4);
                                  setState(() {
                                    totalPriceDiscOnly = price -
                                        (price *
                                            ((disc1 + disc2 + disc3 + disc4) /
                                                100));
                                  });
                                }
                              },
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
                        width: MediaQuery.of(context).size.width / 5,
                        child: Text(
                          "Disc2(%) COD",
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Consumer<LinesProvider>(
                          builder: (context, linesProv, _) => TextFormField(
                            keyboardType: TextInputType.number,
                            controller: disc2Controller.isEmpty
                                ? TextEditingController()
                                : disc2Controller[index],
                            onChanged: (value) {
                              if (value.isEmpty) {
                                promosi.disc2 = "0.0";
                                double disc1 = double.parse(promosi.disc1);
                                double disc2 = double.parse(promosi.disc2);
                                double disc3 = double.parse(promosi.disc3);
                                double disc4 = double.parse(promosi.disc4);
                                setState(() {
                                  totalPriceDiscOnly = price -
                                      (price *
                                          ((disc1 + disc2 + disc3 + disc4) /
                                              100));
                                });
                              } else {
                                promosi.disc2 = value.replaceAll(".", "");
                                double disc1 = double.parse(promosi.disc1);
                                double disc2 = double.parse(promosi.disc2);
                                double disc3 = double.parse(promosi.disc3);
                                double disc4 = double.parse(promosi.disc4);
                                setState(() {
                                  totalPriceDiscOnly = price -
                                      (price *
                                          ((disc1 + disc2 + disc3 + disc4) /
                                              100));
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
            promosi.ppType == "Bonus"
                ? SizedBox()
                : Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
                        width: MediaQuery.of(context).size.width / 5,
                        child: Text(
                          "Disc3(%) Principal1",
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Consumer<LinesProvider>(
                          builder: (context, linesProv, _) => TextFormField(
                            // readOnly: _statusDisable,
                            keyboardType: TextInputType.number,
                            controller: disc3Controller.isEmpty
                                ? TextEditingController()
                                : disc3Controller[index],
                            onChanged: (value) {
                              if (value.isEmpty) {
                                promosi.disc3 = "0.0";
                                double disc1 = double.parse(promosi.disc1);
                                double disc2 = double.parse(promosi.disc2);
                                double disc3 = double.parse(promosi.disc3);
                                double disc4 = double.parse(promosi.disc4);
                                setState(() {
                                  totalPriceDiscOnly = price -
                                      (price *
                                          ((disc1 + disc2 + disc3 + disc4) /
                                              100));
                                });
                              } else {
                                promosi.disc3 = value.replaceAll(".", "");
                                double disc1 = double.parse(promosi.disc1);
                                double disc2 = double.parse(promosi.disc2);
                                double disc3 = double.parse(promosi.disc3);
                                double disc4 = double.parse(promosi.disc4);
                                setState(() {
                                  totalPriceDiscOnly = price -
                                      (price *
                                          ((disc1 + disc2 + disc3 + disc4) /
                                              100));
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
                        width: MediaQuery.of(context).size.width / 5,
                        child: Text(
                          "Disc4(%) Principal2",
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Consumer<LinesProvider>(
                          builder: (context, linesProv, _) => TextFormField(
                            keyboardType: TextInputType.number,
                            controller: disc4Controller.isEmpty
                                ? TextEditingController()
                                : disc4Controller[index],
                            onChanged: (value) {
                              if (value.isEmpty) {
                                promosi.disc4 = "0.0";
                                double disc1 = double.parse(promosi.disc1);
                                double disc2 = double.parse(promosi.disc2);
                                double disc3 = double.parse(promosi.disc3);
                                double disc4 = double.parse(promosi.disc4);
                                setState(() {
                                  totalPriceDiscOnly = price -
                                      (price *
                                          ((disc1 + disc2 + disc3 + disc4) /
                                              100));
                                });
                              } else {
                                promosi.disc4 = value.replaceAll(".", "");
                                double disc1 = double.parse(promosi.disc1);
                                double disc2 = double.parse(promosi.disc2);
                                double disc3 = double.parse(promosi.disc3);
                                double disc4 = double.parse(promosi.disc4);
                                setState(() {
                                  totalPriceDiscOnly = price -
                                      (price *
                                          ((disc1 + disc2 + disc3 + disc4) /
                                              100));
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
            promosi.ppType == "Bonus"
                ? SizedBox()
                : Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
                        width: MediaQuery.of(context).size.width / 5,
                        child: Text(
                          "Disc Value1 ",
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Consumer<LinesProvider>(
                          builder: (context, linesProv, _) => TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              MoneyInputFormatter(
                                  thousandSeparator: ".", decimalSeparator: ",")
                            ],
                            controller: value1Controller.isEmpty
                                ? TextEditingController()
                                : value1Controller[index],
                            onChanged: (value) {
                              if (value.isEmpty) {
                                promosi.value1 = "0.0";
                                double discValue1 =
                                    double.parse(promosi.value1);
                                double discValue2 =
                                    double.parse(promosi.value2);
                                setState(() {
                                  totalPriceDiscValue =
                                      price - (discValue1 + discValue2);
                                });
                              } else {
                                promosi.value1 = value.replaceAll(".", "");
                                double discValue1 =
                                    double.parse(promosi.value1);
                                double discValue2 =
                                    double.parse(promosi.value2);
                                setState(() {
                                  totalPriceDiscValue =
                                      price - (discValue1 + discValue2);
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
                        width: MediaQuery.of(context).size.width / 5,
                        child: Text(
                          "Value2 ",
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Consumer<LinesProvider>(
                          builder: (context, linesProv, _) => TextFormField(
                            keyboardType: TextInputType.number,
                            controller: value2Controller.isEmpty
                                ? TextEditingController()
                                : value2Controller[index],
                            inputFormatters: [
                              MoneyInputFormatter(
                                  thousandSeparator: ".", decimalSeparator: ",")
                            ],
                            onChanged: (value) {
                              if (value.isEmpty) {
                                promosi.value2 = "0.0";
                                double discValue1 =
                                    double.parse(promosi.value1);
                                double discValue2 =
                                    double.parse(promosi.value2);
                                setState(() {
                                  totalPriceDiscValue =
                                      price - (discValue1 + discValue2);
                                });
                              } else {
                                promosi.value2 = value.replaceAll(".", "");
                                double discValue1 =
                                    double.parse(promosi.value1);
                                double discValue2 =
                                    double.parse(promosi.value2);
                                setState(() {
                                  totalPriceDiscValue =
                                      price - (discValue1 + discValue2);
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

            promosi.ppType == "Diskon"
                ? SizedBox()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
                        width: MediaQuery.of(context).size.width / 5,
                        child: Text(
                          "Bonus Item",
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 100,
                        child: Consumer<LinesProvider>(
                            builder: (context, linesProv, _) {
                          return InkWell(
                            onTap: () {
                              Get.defaultDialog(
                                  title: "",
                                  content: SearchChoices.single(
                                    isExpanded: true,
                                    value: suppItemController[index],
                                    items: dataSupplyItem.map((item) {
                                      return DropdownMenuItem(
                                        child: Text(
                                            "${item["ITEMID"]}-${item["ITEMNAME"]}-${item["PK_BRAND"]}-${item["PK_PACKING"]}"),
                                        value:
                                            "${item["ITEMID"]} ${item["ITEMNAME"]} ${item["PK_BRAND"]} ${item["PK_PACKING"]}",
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        suppItemController[index] = value;
                                      });
                                    },
                                  ),
                                  onConfirm: () {
                                    Get.back();
                                  });
                            },
                            child: Padding(
                              padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
                              child: Text(suppItemController[index] ?? "Empty"),
                            ),
                          );
                        }),
                      ),
                      Container(
                        margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
                        width: MediaQuery.of(context).size.width / 5,
                        child: Text(
                          "",
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Consumer<LinesProvider>(
                          builder: (context, linesProv, _) => Container(),
                        ),
                      ),
                    ],
                  ),
            promosi.ppType == "Diskon"
                ? SizedBox()
                : Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
                        width: MediaQuery.of(context).size.width / 5,
                        child: Text(
                          "Bonus Qty",
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Consumer<LinesProvider>(
                          builder: (context, linesProv, _) => TextFormField(
                            // readOnly: _statusDisable,
                            keyboardType: TextInputType.number,
                            controller: suppQtyController.isEmpty
                                ? TextEditingController()
                                : suppQtyController[index],
                            // initialValue: promosi.value1,
                            // onFieldSubmitted: (value) {
                            //   setBundleLines(
                            //       promosi.id, double.parse(value), null, null);
                            // },
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
                        width: MediaQuery.of(context).size.width / 5,
                        child: Text(
                          "",
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Consumer<LinesProvider>(
                          builder: (context, linesProv, _) => Container(),
                        ),
                      ),
                    ],
                  ),
            promosi.ppType == "Diskon"
                ? SizedBox()
                : InkWell(
                    onTap: () {
                      String itemId = suppItemController[index]
                          .split("-")
                          .first
                          .toString()
                          .split(" ")
                          .first;
                      setState(() {
                        getSupplyUnit(itemId);
                      });
                      Future.delayed(Duration(seconds: 1), () {
                        Get.defaultDialog(
                            title: "",
                            barrierDismissible: false,
                            content: SearchChoices.single(
                              isExpanded: true,
                              value: suppUnitController[index],
                              items: dataSupplyUnit.map((item) {
                                return DropdownMenuItem(
                                  child: Text(item),
                                  value: item,
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  suppUnitController[index] = value;
                                });
                              },
                            ),
                            onConfirm: () {
                              Get.back();
                            });
                      });
                    },
                    child: TextResultCard(
                      context: context,
                      title: "Bonus Unit",
                      value: suppUnitController[index] ?? "Empty",
                    ),
                  ),
            InkWell(
              onTap: () {
                setState(() {
                  getWarehouse();
                });
                Future.delayed(Duration(seconds: 1), () {
                  Get.defaultDialog(
                      title: "",
                      barrierDismissible: false,
                      content: SearchChoices.single(
                        isExpanded: true,
                        value: warehouseController[index],
                        items: dataWarehouse.map((item) {
                          return DropdownMenuItem(
                            child: Text(item['NAME']),
                            value: item['INVENTLOCATIONID'],
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            warehouseController[index] = value;
                          });
                        },
                      ),
                      onConfirm: () {
                        Get.back();
                      });
                });
              },
              child: TextResultCard(
                context: context,
                title: "Warehouse",
                value: warehouseController[index] ?? "Empty",
              ),
            ),
            TextResultCard(
                context: context,
                title: "Total",
                value:
                    "Rp${MoneyFormatter(amount: promosi.disc1 == "0.00" && promosi.disc2 == "0.00" && promosi.disc3 == "0.00" && promosi.disc4 == "0.00" ? totalPriceDiscValue : totalPriceDiscOnly).output.withoutFractionDigits.replaceAll(",", ".")}"),
            TextButton(
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(ScreenUtil().setWidth(7)),
                padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
                child: Center(
                  child: Text(
                    "VIEW SALES HISTORY",
                    style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: ScreenUtil().setSp(13),
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return HistorySO(
                      namePP: namePP,
                      idCustomer: promosi.idCustomer,
                      idProduct: promosi.idProduct,
                      idEmp: widget.idEmp);
                }));
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                      color: Theme.of(context).primaryColor,
                      style: BorderStyle.solid,
                      width: 2),
                ),
                padding: EdgeInsets.all(ScreenUtil().setWidth(7)),
              ),
            )
          ],
        ));
  }

  void setBundleLines(
      int id, double disc, DateTime fromDate, DateTime toDate) async {
    Lines model = new Lines();
    List<Lines> listDisc = new List<Lines>();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String result = preferences.getString("result");
    if (result != "") {
      var listStringResult = json.decode(result);
      for (var objectResult in listStringResult) {
        var objects = Lines.fromJson(objectResult as Map<String, dynamic>);
        listDisc.add(objects);
      }
    }
    model.id = id;
    model.disc = disc;
    model.fromDate = fromDate == null
        ? null
        : DateFormat('MM-dd-yyyy').format(fromDate).toString();
    model.toDate = toDate == null
        ? null
        : DateFormat('MM-dd-yyyy').format(toDate).toString();
    listDisc.add(model);
    List<Map> listResult = listDisc.map((f) => f.toJson()).toList();
    result = jsonEncode(listResult);
    preferences.setString("result", result);
  }

  approveNew(String apprroveOrReject) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic id = prefs.getInt("userid");
    String url = ApiConstant(code).urlApi +
        "api/Approve/$id?userId=${prefs.getInt("userid")}";
    print("url Approve:$url");
    List<Promosi> data = _listHistorySO;
    print(_listHistorySO);
    List idLines = data.map((element) => element.id).toList();
    List disc1lines = data.map((element) => element.disc1).toList();
    List disc2lines = data.map((element) => element.disc2).toList();
    List disc3lines = data.map((element) => element.disc3).toList();
    List disc4lines = data.map((element) => element.disc4).toList();
    List value1lines = data.map((element) => element.value1).toList();
    List value2lines = data.map((element) => element.value2).toList();
    List suppQtylines = data.map((element) => element.qty).toList();
    List suppItemlines = data
        .map((element) => element.suppItem.toString().split(" ").first)
        .toList();
    List suppUnitlines = data.map((element) => element.suppUnit).toList();
    List warehouselines = data.map((element) => element.warehouse).toList();
    List fromDatelines = data.map((element) => element.fromDate).toList();
    List toDatelines = data.map((element) => element.toDate).toList();
    List lines = [];
    for (int i = 0; i < idLines.length; i++) {
      print("pleee :${suppItemlines[i]} ${suppItemController[i]}");
      var suppItemLinesAlt = suppItemlines[i];
      lines.add({
        "id": idLines[i],
        "disc1":
            disc1Controller[i].text == null || disc1Controller[i].text == ""
                ? disc1lines[i]
                : double.parse(disc1Controller[i].text),
        "disc2":
            disc2Controller[i].text == null || disc2Controller[i].text == ""
                ? disc2lines[i]
                : double.parse(disc2Controller[i].text),
        "disc3":
            disc3Controller[i].text == null || disc3Controller[i].text == ""
                ? disc3lines[i]
                : double.parse(disc3Controller[i].text),
        "disc4":
            disc4Controller[i].text == null || disc4Controller[i].text == ""
                ? disc4lines[i]
                : double.parse(disc4Controller[i].text),
        "value1":
            value1Controller[i].text == null || value1Controller[i].text == ""
                ? value1lines[i]
                : double.parse(value1Controller[i]
                    .text
                    .replaceAll(",", "")
                    .replaceAll(".", "")
                    .toString()),
        "value2":
            value2Controller[i].text == null || value2Controller[i].text == ""
                ? value2lines[i]
                : double.parse(value2Controller[i]
                    .text
                    .replaceAll(",", "")
                    .replaceAll(".", "")
                    .toString()),
        "suppQty": suppQtyController[i].text == null
            ? suppQtylines[i]
            : double.parse(suppQtyController[i].text),
        "suppItem": suppItemController[i] == null
            ? suppItemLinesAlt
            : suppItemController[i].split(" ").first,
        "suppUnit": suppUnitController[i] == null
            ? suppUnitlines[i]
            : suppUnitController[i],
        "warehouse": warehouseController[i] == null
            ? warehouselines[i]
            : warehouseController[i],
        'fromDate': fromDateHeaderController.text == null
            ? dataHeader[0]['fromDate'].split(" ").first
            : fromDateHeaderController.text,
        'toDate': fromDateHeaderController.text == null
            ? dataHeader[0]['toDate'].split(" ").first
            : toDateHeaderController.text,
      });
    }
    dynamic isiBody = jsonEncode(<String, dynamic>{
      "status": apprroveOrReject == "Approve" ? 1 : 2,
      'lines': lines
    });
    print("isi BodyApprove: $isiBody");
    print("idLines: ${idLines}");
    print("url: ${url}");
    final response = await put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: isiBody,
    );
    print(id);
    print(url);
    print("isi approve or reject : $isiBody");
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      Get.off(DashboardApprovalPP(
        initialIndexs: 0,
      ));
    } else {
      Get.dialog(Center(
        child: Text("${response.statusCode}"),
      ));
    }
  }

  void getUpdateData(
      BuildContext context, List<Lines> listDisc, int idEmp, int code) async {
    List<Lines> listDisc = new List<Lines>();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Future.delayed(Duration(seconds: 1));
    String result = preferences.getString("result");
    var listStringResult = json.decode(result);
    for (var objectResult in listStringResult) {
      var objects = Lines.fromJson(objectResult as Map<String, dynamic>);
      listDisc.add(objects);
    }
    preferences.setString("result", "");
    _approvePP(context, listDisc, widget.idEmp, code);
  }

  DateTime convertDate(String date) {
    final dateTime = DateTime.parse(date ?? "");
    return dateTime;
  }

  // Future<bool> _approvePP(
  //     BuildContext context, String nomorPP, int idEmp, int code) {
  Future<bool> _approvePP(
      BuildContext context, List<Lines> listDisc, int idEmp, int code) {
    Promosi.approveSalesOrder(listDisc, code).then((value) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HistoryNomorPP();
      }));
    }).catchError((onError) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: 'Error : ' + onError.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red[500],
          textColor: Colors.black,
          fontSize: ScreenUtil().setSp(16));
    });
  }

  void getSharedPreference() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Box _userBox = await Hive.openBox('users');
    List<User> listUser = _userBox.values.map((e) => e as User).toList();
    SharedPreferences pref = await SharedPreferences.getInstance();
    Future.delayed(Duration(seconds: 1));
    setState(() {
      _user = listUser[0];
      code = pref.getInt("code");
    });
  }

  Future<bool> onBackPressLines() {
    Get.off(DashboardApprovalPP(
      initialIndexs: 0,
    ));
    // return Navigator.pushReplacement(context,
    //     MaterialPageRoute(builder: (context) {
    //   return HistoryNomorPP();
    // }));
  }
}
