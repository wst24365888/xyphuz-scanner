import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../models/customThemeData.dart';
import '../models/barcodeData.dart';
import '../models/barcode.dart';
import 'checkHistory.dart';
import 'createBarcode.dart';
import 'uploadFile.dart';
import 'scanBarcode.dart';
import 'settings.dart';

class HomePage extends StatefulWidget {

  @override
  HomePageState createState() => HomePageState();

}

class HomePageState extends State<HomePage> {

  _initLocalThemeData() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Provider.of<CustomThemeData>(context).changeLanguage(sharedPreferences.getString("language")??"English");

  }

  _initLocalBarcodeData() async {

    List<String> emptyList = List<String>();  // 做個空List預防tempBarcodeData為null

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    List<String> tempBarcodeData = sharedPreferences.getStringList("BarcodeData");  // 取得目錄

    for(String timestamp in tempBarcodeData??emptyList) {
      Barcode result = Barcode(content: sharedPreferences.getString(timestamp), timestamp: int.parse(timestamp));
      Provider.of<BarcodeData>(context).addResult(result);
    }

  }

  @override
  void initState() {
    super.initState();    
  }

  @override
  void dispose() {
    super.dispose();   
  }

  @override
  Widget build(BuildContext context) {

    // 在initState()中不能先寫到Provider
    if(!Provider.of<BarcodeData>(context).initialized) {
      Provider.of<BarcodeData>(context).initialized = true;
      _initLocalThemeData();
      _initLocalBarcodeData();
    }

    return WillPopScope(
      child: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 8 / 1,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.settings
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SettingsPage()),
                          );
                        },
                      ),
                      Text(
                        Provider.of<CustomThemeData>(context).getLanguageData("Just Scan"),
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0
                        )
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.history
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CheckHistoryPage()),
                          );
                        },
                      )
                    ],
                  ),
                )
              ),
              AspectRatio(
                aspectRatio: 1 / 1,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScanBarcodePage()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(30.0),
                    padding: EdgeInsets.all(15.0),
                    child: Center(
                      child: Text(
                        Provider.of<CustomThemeData>(context).getLanguageData("Scan Barcode"),
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          fontSize: 50.0
                        )
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[400], 
                          offset: Offset(5.0, 5.0),
                          blurRadius: 30.0, 
                          spreadRadius: 1.5
                        ),
                      ],
                    ),
                  ),
                )
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                            ),
                            context: context,
                            builder: (context) => UploadFilePage(),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 30.0, bottom: 30.0),
                          padding: EdgeInsets.all(12.5),
                          child: Center(
                            child: Text(
                              Provider.of<CustomThemeData>(context).getLanguageData("Upload File"),
                              style: TextStyle(
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                fontSize: 30.0
                              )
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[400], 
                                offset: Offset(5.0, 5.0),
                                blurRadius: 30.0, 
                                spreadRadius: 1.5
                              ),
                            ],
                          ),
                        ),
                      )
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                            ),
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => CreateBarcodePage()
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(30.0),
                          padding: EdgeInsets.all(10.0),
                          child: Center(
                            child: Text(
                              Provider.of<CustomThemeData>(context).getLanguageData("Create Barcode"),
                              style: TextStyle(
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 18.0
                              )
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.lightGreen[800],
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[400], 
                                offset: Offset(5.0, 5.0),
                                blurRadius: 30.0, 
                                spreadRadius: 1.5
                              ),
                            ],
                          ),
                        ),
                      )
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ),
      onWillPop: () {
        exit(0);
        return null;
      },
    );
  }

}