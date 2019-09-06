import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xyphuz_scanner/views/home.dart';

import 'checkResult.dart';
import '../models/barcodeData.dart';
import '../models/customThemeData.dart';

class CheckHistoryPage extends StatefulWidget {

  @override
  CheckHistoryPageState createState() => CheckHistoryPageState();

}

class CheckHistoryPageState extends State<CheckHistoryPage> {

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

    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.teal,
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Text(
                        Provider.of<CustomThemeData>(context).getLanguageData("History"),
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          fontSize: 50.0
                        )
                      ),
                    )
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: Provider.of<BarcodeData>(context).resultLength,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(Provider.of<BarcodeData>(context).resultData[index].timestamp.toString()),
                        onDismissed: (direction) {
                          Provider.of<BarcodeData>(context).removeResult(index);
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CheckResultPage(index: index, backTo: CheckHistoryPage(),)),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                            padding: EdgeInsets.all(15.0),
                            child: Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: null,
                                  child: Container(
                                    width: 80.0,
                                    height: 80.0,
                                    margin: EdgeInsets.only(right: 12.0),
                                    padding: EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Icon(
                                        Provider.of<BarcodeData>(context).resultData[index].icon, 
                                        color: Colors.white,
                                      )
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.lightGreen[500]
                                    ),
                                  ),
                                ),
                                VerticalDivider(color: Colors.black, width: 10.0,),
                                Flexible(
                                  child: Column(
                                    //讓整個Column都一樣寬
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(right: 10.0),
                                        child: Text(
                                          Provider.of<BarcodeData>(context).resultData[index].content,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: "Quicksand",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 25.0
                                          )
                                        ),
                                      ),
                                      Container(
                                        height: 7.0,
                                      ),
                                      Text(
                                        Provider.of<BarcodeData>(context).resultData[index].timestampString,
                                        style: TextStyle(
                                          fontFamily: "Quicksand",
                                          fontWeight: FontWeight.w300,
                                          color: Colors.grey,
                                          fontSize: 15.0
                                        )
                                      ),
                                    ],
                                  )
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[300], 
                                  offset: Offset(5.0, 5.0),
                                  blurRadius: 20.0, 
                                  spreadRadius: 0.5
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                    color: Colors.white
                  ),
                ),
              )
            ],
          ),
        )
      ),
      onWillPop: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      )
    );
  }

}