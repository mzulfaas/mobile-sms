import 'dart:convert';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mobile_sms/assets/widgets/ConditionNull.dart';
import 'package:mobile_sms/assets/widgets/TextResultCard.dart';
import 'package:mobile_sms/models/Lines.dart';
import 'package:mobile_sms/models/Promosi.dart';
import 'package:mobile_sms/models/User.dart';
import 'package:mobile_sms/providers/LinesProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HistoryNomorPP.dart';
import 'HistorySO.dart';


class HistoryLines extends StatefulWidget {
  @override
  _HistoryLinesState createState() => _HistoryLinesState();
  String numberPP;
  int idEmp;
  HistoryLines({this.numberPP, this.idEmp});
}

class _HistoryLinesState extends State<HistoryLines> {
  var _listHistorySO;
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

  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    getSharedPreference();
  }

  Future<Null> listHistorySO() async {
    await Future.delayed(Duration(seconds: 5));
    Promosi.getListLines(widget.numberPP, code, _user.token, _user.username)
        .then((value) {
      setState(() {
        _listHistorySO = value;
      });
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(
    //   BoxConstraints(
    //     maxWidth: MediaQuery.of(context).size.width,
    //     maxHeight: MediaQuery.of(context).size.height,
    //   )
    // );

    return WillPopScope(
      onWillPop: onBackPressLines,
      child: MaterialApp(
        theme: Theme.of(context),
        home: ChangeNotifierProvider<LinesProvider>(
          create: (ctx) => LinesProvider(),
          // builder: (context) => LinesProvider(),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColorDark,
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
            body: Scaffold(
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
                        return ListView.builder(
                          itemCount: _listHistorySO?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CardLinesAdapter(
                                widget.numberPP, _listHistorySO[index], index);
                          },
                        );
                      }
                    }
                  },
                ),
              ),
            ),
            bottomNavigationBar: Container(
              width: MediaQuery.of(context).size.width,
              child: Consumer<LinesProvider>(
                builder: (context, linesProv, _) => RaisedButton(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(13)),
                  color: Theme.of(context).primaryColorDark,
                  child: Text(
                    'Approve',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: ScreenUtil().setSp(25),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
//                    listDisc = getUpdateData() as List<Lines>;
//                    String result = linesProv.getBundleLines;
                    getUpdateData(context, listDisc, widget.idEmp, code);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container CardLinesAdapter(String namePP, Promosi promosi, int index) {
    TextEditingController discController =
        new TextEditingController(text: promosi.disc);
    return Container(
        margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
        padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColorDark),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: <Widget>[
            Container(
              child: CheckboxListTile(
                value: promosi.status,
                onChanged: (bool value) {
                  setState(() {
                    promosi.status = value;
                    // _statusDisable = value;
                    value == true
                        ? _statusDisable = false //_listid.add(promosi.id)
                        : _statusDisable = true; //_listid.remove(promosi.id);
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.red,
              ),
            ),
            TextResultCard(
              context: context,
              title: "No. PP",
              value: promosi.nomorPP,
            ),
            TextResultCard(
              context: context,
              title: "Customer",
              value: promosi.customer,
            ),
            TextResultCard(
              context: context,
              title: "Product",
              value: promosi.product,
            ),
            TextResultCard(
              context: context,
              title: "Qty",
              value: promosi.qty.toString(),
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
            //Period Date
            Container(
                margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
                width: ScreenUtil()
                    .setWidth(MediaQuery.of(context).size.width),
                child: Text(
                    'Period Date(hapus dgn klik X jika ingin ganti period)',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: ScreenUtil().setSp(15),
                    ))),
            Container(
                width:
                    ScreenUtil().setHeight(MediaQuery.of(context).size.width),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Consumer<LinesProvider>(
                    builder: (context, linesProv, _) => DateTimeField(
                          readOnly: true,
                          format: DateFormat('dd/MMM/yyyy'),
                          initialValue: DateTime.now(),
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              labelText: 'From Date',
                              hintStyle: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15),
                              errorStyle: TextStyle(
                                  color: Theme.of(context).errorColor,
                                  fontSize: 15)),
                          // ignore: missing_return
                          onShowPicker: (context, currentValue) {
                            return showDatePicker(
                                context: context,
                                firstDate: DateTime(DateTime.now().year - 1),
                                initialDate: currentValue ??
                                    DateTime.parse(promosi.fromDate),
                                lastDate: DateTime(DateTime.now().year + 1),
                                builder: (BuildContext context, Widget child) {
                                  return Theme(
                                    data: ThemeData.light(),
                                    child: child,
                                  );
                                });
                          },
                          onChanged: (value) {
                            if (value != null) {
                              setBundleLines(promosi.id, null, value, null);
                            }
                          },
                        ))),
            Container(
                width:
                    ScreenUtil().setHeight(MediaQuery.of(context).size.width),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Consumer<LinesProvider>(
                    builder: (context, linesProv, _) => DateTimeField(
                          readOnly: true,
                          format: DateFormat('dd/MMM/yyyy'),
                          // initialValue: convertDate(promosi.toDate),
                          initialValue: DateTime.now(),
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              labelText: 'To Date',
                              hintStyle: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15),
                              errorStyle: TextStyle(
                                  color: Theme.of(context).errorColor,
                                  fontSize: 15)),
                          // ignore: missing_return
                          onShowPicker: (context, currentValue) {
                            return showDatePicker(
                                context: context,
                                firstDate: DateTime(DateTime.now().year - 1),
                                initialDate: currentValue ??
                                    DateTime.parse(promosi.toDate),
                                lastDate: DateTime(DateTime.now().year + 1),
                                builder: (BuildContext context, Widget child) {
                                  return Theme(
                                    data: ThemeData.light(),
                                    child: child,
                                  );
                                });
                          },
                          onChanged: (value) {
                            if (value != null) {
                              setBundleLines(promosi.id, null, null, value);
                            }
                          },
                        ))),
            //Discount
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
                  width: MediaQuery.of(context).size.width / 5,
                  child: Text(
                    "Disc(%) ",
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
                      readOnly: _statusDisable,
                      keyboardType: TextInputType.text,
                      initialValue: promosi.disc,
                      onFieldSubmitted: (value) {
                        setBundleLines(
                            promosi.id, double.parse(value), null, null);
                      },
                    ),
                  ),
                )
              ],
            ),

            TextResultCard(
              context: context,
              title: "Total",
              value: promosi.totalAmount,
            ),
            FlatButton(
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
              color: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                    color: Theme.of(context).primaryColor,
                    style: BorderStyle.solid,
                    width: 2),
              ),
              padding: EdgeInsets.all(ScreenUtil().setWidth(7)),
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

  void getUpdateData(
      BuildContext context, List<Lines> listDisc, int idEmp, int code) async {
    List<Lines> listDisc = new List<Lines>();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Future.delayed(Duration(milliseconds: 10));
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
    final dateTime = DateTime.parse(date??"");
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
    Future.delayed(Duration(milliseconds: 10));
    setState(() {
      _user = listUser[0];
      code = pref.getInt("code");
    });
  }

  Future<bool> onBackPressLines() {
    return Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
      return HistoryNomorPP();
    }));
  }
}
