import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mobile_sms/assets/global.dart';
import 'package:mobile_sms/assets/widgets/Debounce.dart';
import 'package:mobile_sms/assets/widgets/TextResultCard.dart';
import 'package:mobile_sms/models/Promosi.dart';
import 'package:mobile_sms/models/User.dart';
import 'package:mobile_sms/view/input-page/input-page-new.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HistoryLines.dart';
import 'Login.dart';

class HistoryNomorPP extends StatefulWidget {
  @override
  _HistoryNomorPPState createState() => _HistoryNomorPPState();
  // int idEmp;
  // int codeUrl;
  // HistoryNomorPP({this.idEmp, this.codeUrl});
}

class _HistoryNomorPPState extends State<HistoryNomorPP> {
  final _debouncer = Debounce(miliseconds: 5);
  TextEditingController filterController = new TextEditingController();
  var _listHistory, listHistoryReal;
  GlobalKey<RefreshIndicatorState> refreshKey;
  User _user;
  int code;

  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    getSharedPreference();
  }

  Future<Null> listHistory() async {
    await Future.delayed(Duration(seconds: 5));
    Promosi.getListPromosi(0, code, _user.token??"token kosong", _user.username).then((value) {
      print("userToken: ${_user.token}");
      setState(() {
        listHistoryReal = value;
        _listHistory = listHistoryReal;
      });
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(
    //   BoxConstraints(
    //     maxHeight: MediaQuery.of(context).size.height,
    //     maxWidth: MediaQuery.of(context).size.width,
    //   )
    // );
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        theme: Theme.of(context),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColorDark,
            leading: IconButton(
              icon: Icon(
                Icons.home,
                color: Theme.of(context).accentColor,
              ),
              onPressed: LogOut,
            ),
            actions: [
              Center(
                child: IconButton(
                  icon: Icon(Icons.edit,color: Colors.white,),
                  onPressed: (){
                    Get.to(InputPage());
                  },
                ),
              )
            ],
            title: Text(
              "List PP",
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(20),
                  color: Theme.of(context).accentColor),
            ),
          ),
          body: Scaffold(
            body: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  child: TextField(
                    controller: filterController,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.all(ScreenUtil().setHeight(10)),
                        hintText: 'Enter customer, number PP or date',
                        suffixIcon: IconButton(
                            icon: Icon(Icons.search, color: colorPrimary),
                            onPressed: () {
                              String value = filterController.text;
                              _debouncer.run(() {
                                setState(() {
                                  _listHistory = listHistoryReal.where((element) =>
                                          element.nomorPP
                                              .toLowerCase()
                                              .contains(value.toLowerCase()) ||
                                          element.date
                                              .toLowerCase()
                                              .contains(value.toLowerCase())||element.customer
                                              .toLowerCase()
                                              .contains(value.toLowerCase()))
                                      .toList();
                                  print(_listHistory);
                                });
                              });
                            })),
                    onEditingComplete: () {
                      String value = filterController.text;
                      _debouncer.run(() {
                        setState(() {
                          _listHistory = listHistoryReal
                              .where((element) =>
                                  element.nomorPP
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.date
                                      .toLowerCase()
                                      .contains(value.toLowerCase())||element.customer
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                              .toList();
                          print(_listHistory);
                        });
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: listHistory,
                    child: FutureBuilder(
                      future: Promosi.getListPromosi(
                          0, code, _user?.token??"", _user?.username??""),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError != true) {
                            _listHistory == null
                                ? _listHistory = listHistoryReal = snapshot.data
                                : _listHistory = _listHistory;
                            if (_listHistory.length == 0) {
                              return Center(
                                child: Column(
                                  children: <Widget>[
                                    Text('No Data'),
                                    Text('Swipe down for refresh item'),
                                  ],
                                ),
                              );
                            }
                            return ListView.builder(
                                itemCount: _listHistory?.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        CardAdapter(
                                          _listHistory[index],
                                        ));
                          } else {
                            print(snapshot.error.toString());
                          }
                        } else if (snapshot.connectionState ==
                            ConnectionState.none) {
                          return Center(
                            child: Column(
                              children: <Widget>[
                                Text('No Data'),
                                Text('Swipe down for refresh item'),
                              ],
                            ),
                          );
                        } else {
                          Future.delayed(Duration(milliseconds: 5));
                          return Center(
                            child: CircularProgressIndicator(
                              semanticsLabel: 'Loading',
                            ),
                          );
                        }return Container();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container CardAdapter(Promosi promosi) {
    return Container(
        margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
        padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColorDark),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: <Widget>[
            TextResultCard(
              context: context,
              title: "No. PP",
              value: promosi.nomorPP,
            ),
            TextResultCard(
              context: context,
              title: "Date",
              value: promosi.date,
            ),
            TextResultCard(
              context: context,
              title: "Customer",
              value: promosi.customer,
            ),
            FlatButton(
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(ScreenUtil().setWidth(7)),
                padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
                child: Center(
                  child: Text(
                    "VIEW LINES",
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
                  return HistoryLines(
                    numberPP: promosi?.namePP,
                    idEmp: _user.id,
                  );
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

  void getSharedPreference() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Box _userBox = await Hive.openBox('users');
    List<User> listUser = _userBox.values.map((e) => e as User).toList();
    SharedPreferences pref = await SharedPreferences.getInstance();
    Future.delayed(Duration(milliseconds: 20));
    setState(() {
      _user = listUser[0];
      code = pref.getInt("code");
    });
  }

  Future<bool> onBackPress() {
    deleteBoxUser();
    return Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
      return LoginView();
    }));
  }

  void deleteBoxUser() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Box _userBox = await Hive.openBox('users');
    SharedPreferences pref = await SharedPreferences.getInstance();

    Future.delayed(Duration(milliseconds: 10));
    await _userBox.deleteFromDisk();
    pref.setInt("flag", 0);
    pref.setString("result", "");
  }

  void LogOut() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('Log Out'),
              content: Text('Are you sure log out ?'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: Text('Cancel')),
                FlatButton(onPressed: onBackPress, child: Text('Ok')),
              ],
            ));
  }
}
