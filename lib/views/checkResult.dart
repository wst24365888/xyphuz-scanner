import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

import 'home.dart';
import '../models/barcodeData.dart';
import '../models/customThemeData.dart';

class CheckResultPage extends StatefulWidget {

  final int index;
  final Widget backTo;

  CheckResultPage({@required this.index, this.backTo});

  @override
  CheckResultPageState createState() => CheckResultPageState(index: index, backTo: backTo??HomePage());

}

class CheckResultPageState extends State<CheckResultPage> {

  final int index;
  final Widget backTo;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  CheckResultPageState({@required this.index, @required this.backTo});

  @override
  void initState() {
    super.initState();   
  }

  @override
  void dispose() {
    super.dispose();   
  }

  SnackBar coustomSnackBar(String content) => SnackBar(
    content: Container(
      height: 100.0,
        child: Center(
          child: Text(
            content,
            style: TextStyle(
              fontFamily: "Quicksand",
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            )
          ),
        ),
    duration: Duration(seconds: 1),
    backgroundColor: Colors.lightGreen[300],
  );

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _shareText(String textToShare) {
    Share.text("Xpyhuz's Scanner", textToShare, "text/plain");
  }

  _shareBarcode(String barcodeToShare) async {
    ByteData bytes = await QrPainter(data: barcodeToShare, version: QrVersions.auto, color: Colors.green[800]).toImageData(500.0);
    await Share.file("Xpyhuz's Scanner", "result.png", bytes.buffer.asUint8List(), "image/png");
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Center(
                    child: QrImage(
                      data: Provider.of<BarcodeData>(context).resultData[index].content,
                      version: QrVersions.auto,
                      size: 225.0,
                      foregroundColor: Colors.green[800],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: Provider.of<BarcodeData>(context).resultData[index].content));
                    _scaffoldKey.currentState.showSnackBar(coustomSnackBar(Provider.of<CustomThemeData>(context).getLanguageData("Text copied."),));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    padding: EdgeInsets.all(10.0),
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Icon(
                            Icons.content_copy,
                            color: Colors.grey[300],
                          ),
                        ),
                        Center(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Text(
                              Provider.of<BarcodeData>(context).resultData[index].content,
                              style: TextStyle(
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w400,
                                fontSize: 25.0,
                              ),
                            ),
                          )
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[200], 
                          offset: Offset(5.0, 5.0),
                          blurRadius: 30.0, 
                          spreadRadius: 1.5
                        ),
                      ],
                    ),
                  ),
                )
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(37.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FloatingActionButton(
                        heroTag: "Home",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => backTo),
                          );
                        },
                        child: Icon(
                          Icons.arrow_back_ios
                        ),
                        backgroundColor: Colors.greenAccent[700],
                      ),
                      FloatingActionButton(
                        heroTag: "Browser",
                        onPressed: () {
                          if(Provider.of<BarcodeData>(context).resultData[index].content.contains("http")) {
                            _launchURL(Provider.of<BarcodeData>(context).resultData[index].content);
                          } else {
                            _launchURL("https://www.google.com/search?q=${Provider.of<BarcodeData>(context).resultData[index].content}");
                          }
                        },
                        child: Transform.rotate(
                          angle: - pi / 2,
                          child: Icon(
                            Icons.send
                          ),
                        ),
                        backgroundColor: Colors.teal,
                      ),
                      FloatingActionButton(
                        heroTag: "Share",
                        onPressed: () {
                          showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                            ),
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 210.0,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          _shareBarcode(Provider.of<BarcodeData>(context).resultData[index].content);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: 30.0, left: 20.0, right: 10.0, bottom: 30.0),
                                          padding: EdgeInsets.all(10.0),
                                          child: Center(
                                            child: Text(
                                              Provider.of<CustomThemeData>(context).getLanguageData("Share Barcode"),
                                              style: TextStyle(
                                                fontFamily: "Quicksand",
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                                fontSize: 30.0
                                              )
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.lightGreen[300],
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      )
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          _shareText(Provider.of<BarcodeData>(context).resultData[index].content);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: 30.0, left: 10.0, right: 20.0, bottom: 30.0),
                                          padding: EdgeInsets.all(10.0),
                                          child: Center(
                                            child: Text(
                                              Provider.of<CustomThemeData>(context).getLanguageData("Share Text"),
                                              style: TextStyle(
                                                fontFamily: "Quicksand",
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                                fontSize: 30.0
                                              )
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.lightGreen[300],
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      )
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Transform.rotate(
                          angle: - pi,
                          child: Icon(
                            Icons.share
                          ),
                        ),
                        backgroundColor: Colors.greenAccent[700],
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        )
      ),
      onWillPop: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => backTo),
      ),
    );
  }

}