import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:mobile_sms/assets/widgets/ConditionNull.dart';
import 'package:mobile_sms/assets/widgets/SalesOrderAdapter.dart';
import 'package:mobile_sms/models/Promosi.dart';
import 'package:mobile_sms/models/User.dart';
import 'package:mobile_sms/view/HistoryLinesAll.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HistoryLines.dart';


class HistorySOAll extends StatefulWidget {
  @override
  _HistorySOAllState createState() => _HistorySOAllState();
  int idEmp;
  String namePP;
  String idProduct;
  String idCustomer;
  HistorySOAll(
      {this.idEmp, this.namePP, this.idProduct, this.idCustomer});
}

class _HistorySOAllState extends State<HistorySOAll> {
  var _listHistory;
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
    Promosi.getListSalesOrder(widget.idProduct, widget.idCustomer, code, _user.token, _user.username)
        .then((value) {
      setState(() {
        _listHistory = value;
      });
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(
    //     BoxConstraints(
    //       maxWidth: MediaQuery.of(context).size.width,
    //       maxHeight: MediaQuery.of(context).size.height,
    //     ));

    return WillPopScope(
      onWillPop: onBackPressSalesOrder,
      child: MaterialApp(
        theme: Theme.of(context),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColorDark,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).accentColor,
              ),
              onPressed: onBackPressSalesOrder,
            ),
            title: Text(
              "List Sales Order",
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(20),
                  color: Theme.of(context).accentColor),
            ),
          ),
          body: Scaffold(
            body: RefreshIndicator(
              onRefresh: listHistory,
              child: FutureBuilder(
                future: Promosi.getListSalesOrder(
                    widget.idProduct, widget.idCustomer, code, _user.token, _user.username),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  _listHistory == null
                      ? _listHistory = snapshot.data
                      : _listHistory = _listHistory;
                  if (_listHistory == null) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          semanticsLabel: "Loading...",
                        ),
                      ),
                    );
                  } else {
                    if (_listHistory[0].codeError != 404 ||
                        _listHistory[0].codeError != 303) {
                      return ListView.builder(
                        itemCount: _listHistory?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return SalesOrderAdapter(
                            models: _listHistory[index],
                          );
                        },
                      );
                    } else {
                      return ConditionNull(message: _listHistory[0].message);
                    }
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
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

  Future<bool> onBackPressSalesOrder() {
    return Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
      return HistoryLinesAll(
        idEmp: widget.idEmp,
        numberPP: widget.namePP
      );
    }));
  }
}
