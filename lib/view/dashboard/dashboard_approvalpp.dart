import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_sms/view/HistoryNomorPP_All.dart';
import 'package:mobile_sms/view/HistoryNomorPP_Approved.dart';
import 'package:mobile_sms/view/HistoryNomorPP_Pending.dart';
import 'package:mobile_sms/view/input-page/input-page-new.dart';
import 'package:mobile_sms/view/input-page/input-page.dart';

class DashboardApprovalPP extends StatefulWidget {
  int initialIndexs;

  DashboardApprovalPP({Key key, this.initialIndexs}) : super(key: key);

  @override
  State<DashboardApprovalPP> createState() => _DashboardApprovalPPState();
}

class _DashboardApprovalPPState extends State<DashboardApprovalPP> {


  checkInitialIndexTabbar(){
    print("widget.initialIndexs :${widget.initialIndexs}");
    if(widget.initialIndexs==null||widget.initialIndexs==0){
      tabController.initialIndex = 0;
    }else if(widget.initialIndexs==1){
      tabController.initialIndex = 1;
      Future.delayed(Duration(seconds: 1),(){
        tabController.controller.animateTo(tabController.initialIndex);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInitialIndexTabbar();
  }
  final tabController = Get.put(DashboardApprovalPPTabController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Dashboard Approval"),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: DefaultTabController(
            initialIndex: tabController.initialIndex,
            length: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  unselectedLabelColor: Colors.black,
                  labelColor: Colors.green,
                  controller: tabController.controller,
                  tabs: [
                    Tab(text: "Pending PP"),
                    Tab(text: "Approved PP"),
                  ],
                ),
                Container(
                  width: Get.width,
                  height: Get.height,
                  child: TabBarView(
                    controller: tabController.controller,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: Get.height-670),
                        child: HistoryPending(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: Get.height-670),
                        child: HistoryApproved(),
                      ),
                    ],
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
}

class DashboardApprovalPPTabController extends GetxController with GetSingleTickerProviderStateMixin {
  // dynamic myTab;
  int initialIndex = 0;
  DashboardApprovalPPTabController({this.initialIndex});

  TabController controller;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 1),(){
      controller = TabController(vsync: this, length: 2, initialIndex: initialIndex);
    });
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}