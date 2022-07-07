import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextResultCard extends StatelessWidget {
  String title, value;
  BuildContext context;
  TextResultCard({this.title, this.value, this.context});

  @override
  Widget build(BuildContext context2) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
          width: MediaQuery.of(context).size.width / 5,
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontSize: ScreenUtil().setSp(15),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
            child: Text(
              value,
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(17)),
            ),
          ),
        )
      ],
    );
  }
}
