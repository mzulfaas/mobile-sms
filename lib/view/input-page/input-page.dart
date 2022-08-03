import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
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

  String valType;
  List<dynamic> dataType = [
    {
      "id": "1",
      "name": "Diskon",
    },
    {"id": "2", "name": "Bonus"},
    {
      "id": "3",
      "name": "Live",
    },
    {"id": "4", "name": "Diskon & Bonus"},
    {
      "id": "5",
      "name": "Sample",
    },
    {"id": "6", "name": "Rebate"},
    {
      "id": "7",
      "name": "Rafraksi",
    },
    {"id": "8", "name": "Gimmick"},
    {"id": "9", "name": "Trading Term"},
  ];

  void getType() {
    var listData = [];
    dataType = listData;
    setState(() {
      if (!typeContains(valType)) {
        valType = null;
      }
    });
  }

  bool typeContains(var type) {
    for (int i = 0; i < dataType.length; i++) {
      if (type == dataType[i]["name"]) return true;
    }
    return false;
  }

  String valVendor;
  List dataVendor = [].obs;

  void getVendor() async {
    var urlGetVendor = "http://119.18.157.236:8869/api/Vendors";
    final response = await get(Uri.parse(urlGetVendor));
    var listData = jsonDecode(response.body);
    print("ini url getVendor : $urlGetVendor");
    setState(() {
      dataVendor = listData;
      if (!vendorContains(valVendor)) {
        valVendor = null;
      }
    });
    print("Data Vendor : $listData");
  }

  bool vendorContains(var vendor) {
    for (int i = 0; i < dataVendor.length; i++) {
      if (vendor == dataVendor[i]["VENDNAME"]) return true;
    }
    return false;
  }

  String valLocation;
  List dataLocation = [].obs;

  void getLocation() async {
    var urlGetLocation = "http://119.18.157.236:8869/api/SalesOffices";
    final response = await get(Uri.parse(urlGetLocation));
    var listData = jsonDecode(response.body);
    print("ini url getLocation");
    setState(() {
      dataLocation = listData;
      if (!locationContains(valLocation)) {
        valLocation = null;
      }
    });
    print("Data Location : $listData");
  }

  bool locationContains(var location) {
    for (int i = 0; i < dataLocation.length; i++) {
      if (location == dataLocation[i]["NameSO"]) return true;
    }
    return false;
  }

  String valCustomerOrGroup;
  List<dynamic> dataCustomerOrGroup = [
    {
      "id": "1",
      "name": "Customer",
    },
    {"id": "2", "name": "Disc Group"},
  ];

  void getCustomerOrGroup() {
    var listData = [];
    setState(() {
      dataCustomerOrGroup = listData;
      if (!typeContains(valCustomerOrGroup)) {
        valCustomerOrGroup = null;
      }
    });
  }

  bool customerOrGroupContains(var type) {
    for (int i = 0; i < dataCustomerOrGroup.length; i++) {
      if (type == dataCustomerOrGroup[i]["name"]) return true;
    }
    return false;
  }

  // int counter = 0;

  String valStatusTesting;
  List<dynamic> dataStatusTesting = [
    {
      "id": "1",
      "name": "Live",
    },
    {"id": "2", "name": "Testing"},
  ];

  void getStatusTesting() {
    var listData = [];
    setState(() {
      dataCustomerOrGroup = listData;
      if (!typeContains(valCustomerOrGroup)) {
        valCustomerOrGroup = null;
      }
    });
  }

  bool statusTestingContains(var type) {
    for (int i = 0; i < dataStatusTesting.length; i++) {
      if (type == dataStatusTesting[i]["name"]) return true;
    }
    return false;
  }


  List valCustomer = [];
  List dataCustomer = [];

  void getCustomer(var selected) async {
    if (selected == "Customer") {
      var urlGetCustomerChoice =
          "http://119.18.157.236:8869/api/custtables?salesOffice=${valLocation}";
      final response = await get(Uri.parse(urlGetCustomerChoice));
      var listData = jsonDecode(response.body);
      print("ini url getCustomerChoice : $urlGetCustomerChoice");
      dataCustomer = listData;
      bool choiceContains(var choice) {
        for (int i = 0; i < dataCustomer.length; i++) {
          if (choice == dataCustomer[i]["nameCust"]) return true;
        }
        return false;
      }

      if (!choiceContains(valCustomer)) {
        valCustomer = null;
      }
      print("Data CustomerChoice : $listData");
    } else if (selected == "Disc Group") {
      var urlGetDiscGroup =
          "http://119.18.157.236:8869/api/CustPriceDiscGroup";
      final response = await get(Uri.parse(urlGetDiscGroup));
      var listData = jsonDecode(response.body);
      print("ini url getDiscGroup : $urlGetDiscGroup");
      setState(() {
        dataCustomer = listData;
      });
      bool discGroupContains(var choice) {
        for (int i = 0; i < dataCustomer.length; i++) {
          if (choice == dataCustomer[i]["NAME"]) return true;
        }
        return false;
      }

      if (!discGroupContains(valCustomer)) {
        valCustomer = null;
      }
      print("Data DiscGroup : $listData");
    }
  }

  List<Widget> cardItem = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVendor();
    getLocation();
    getCustomerOrGroup();
  }

  Widget customCardLines() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Lines"),
                Spacer(),
                IconButton(
                    onPressed: () {
                      setState(() {
                        cardItem.add(customCardLines());
                      });
                    },
                    icon: Icon(
                      Icons.add,
                    )),
                IconButton(
                    onPressed: () {
                      setState(() {
                        cardItem.removeLast();
                      });
                    },
                    icon: Icon(
                      Icons.delete,
                    )),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Customer/Group"),
                DropdownButtonFormField(
                  value: valCustomerOrGroup,
                  items: dataCustomerOrGroup.map(
                    (item) {
                      // print(valCustomer[index]);
                      return DropdownMenuItem(
                        child: Text(item['name']),
                        value: item['name'],
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      valCustomerOrGroup = value;
                      // getCustomer(value);
                    });
                  },
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Customer"),
                SearchChoices.single(
                  value: valCustomer,
                  isExpanded: true,
                  items: dataCustomer.map(
                    (item) {
                      return DropdownMenuItem(
                        child: Text(item['nameCust']),
                        value: item['nameCust'],
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      valCustomerOrGroup = value;
                    });
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColorDark,
          title: Text("New Promotion Program"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Create"),
                          Text("Setup trade agreement"),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Program Number"),
                                    Container(
                                      width: 150,
                                      child: TextFormField(
                                        controller: programNumberController,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Spacer(),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Program Name"),
                                    Container(
                                      width: 150,
                                      child: TextFormField(
                                        controller: programNameController,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Type"),
                              DropdownButtonFormField(
                                isExpanded: true,
                                value: valType,
                                items: dataType.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(item['name']),
                                    value: item['name'],
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    valType = value;
                                  });
                                },
                                // value: ,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Vendor"),
                              SearchChoices.single(
                                isExpanded: true,
                                value: valVendor,
                                items: dataVendor.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(item['VENDNAME']),
                                    value: item['VENDNAME'],
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    valVendor = value;
                                  });
                                },
                                // value: ,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Location"),
                              SearchChoices.single(
                                isExpanded: true,
                                value: valLocation,
                                items: dataLocation.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(item['NameSO']),
                                    value: item['NameSO'],
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    valLocation = value;
                                  });
                                },
                                // value: ,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Status Testing"),
                              DropdownButtonFormField(
                                isExpanded: true,
                                value: valStatusTesting,
                                items: dataStatusTesting.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(item['name']),
                                    value: item['name'],
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    valStatusTesting = value;
                                  });
                                },
                                // value: ,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  cardItem.length == 0
                      ? RaisedButton(
                          child: Text("Add",
                              style: TextStyle(color: Colors.white)),
                          color: Theme.of(context).primaryColorDark,
                          onPressed: () {
                            setState(() {
                              cardItem.add(customCardLines());
                            });
                          })
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cardItem.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                cardItem[index],
                                index == cardItem.length - 1
                                    ? RaisedButton(
                                        color: Colors.green,
                                        child: Text("Submit"),
                                        onPressed: () {})
                                    : SizedBox()
                              ],
                            );
                          })
                ],
              ),
            ),
          ),
        ));
  }
}
