import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart' as ml;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'checkResult.dart';
import '../models/barcode.dart' as bc;
import '../models/barcodeData.dart';
import '../models/customThemeData.dart';

class UploadFilePage extends StatefulWidget {

  @override
  UploadFilePageState createState() => UploadFilePageState();

}

class UploadFilePageState extends State<UploadFilePage> {

  bool _isLodaing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();   
  }
  

  _scan(Function toDo) async {

    File tempStore = await ImagePicker.pickImage(source: ImageSource.gallery);

    if(tempStore != null) {
      // 加個if判斷，不然選照片階段按返回鍵時toDo(tempStore)會報錯
      toDo(tempStore);
    }

  }

  _scanText(File image) async {

    _isLodaing = true;
    
    String scanResult = "";

    ml.FirebaseVisionImage ourImage = ml.FirebaseVisionImage.fromFile(image);
    ml.TextRecognizer recognizeText = ml.FirebaseVision.instance.textRecognizer();
    ml.VisionText readText = await recognizeText.processImage(ourImage);

    scanResult += readText.text;

    if(scanResult != "") {     

      bc.Barcode result = bc.Barcode(content: scanResult, timestamp: DateTime.now().microsecondsSinceEpoch);
      Provider.of<BarcodeData>(context).addResult(result);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CheckResultPage(index: 0)),
      );

    } else {

      Navigator.pop(
        context,
      );

    }

  }
  

  _scanBarcode(File image) async {

    _isLodaing = true;
    
    String scanResult = "";
    
    ml.FirebaseVisionImage ourImage = ml.FirebaseVisionImage.fromFile(image);
    ml.BarcodeDetector barcodeDetector = ml.FirebaseVision.instance.barcodeDetector();
    List<ml.Barcode> barCodes = await barcodeDetector.detectInImage(ourImage);
    
    for (ml.Barcode readableCode in barCodes) {      
      scanResult += " " + readableCode.rawValue;
    }

    if(scanResult != "") {     

      bc.Barcode result = bc.Barcode(content: scanResult, timestamp: DateTime.now().microsecondsSinceEpoch);
      Provider.of<BarcodeData>(context).addResult(result);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CheckResultPage(index: 0)),
      );

    } else {

      Navigator.pop(
        context,
      );

    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210.0,
      child: _isLodaing ?
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(25.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
            Text(
              Provider.of<CustomThemeData>(context).getLanguageData("Calculating..."),
              style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                fontSize: 20.0
              )
            ),
          ],
        )
      )
      :
      Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                _scan(_scanBarcode);
              },
              child: Container(
                margin: EdgeInsets.only(top: 30.0, left: 20.0, right: 10.0, bottom: 30.0),
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    Provider.of<CustomThemeData>(context).getLanguageData("Scan Barcode"),
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 30.0
                    )
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.lightGreen[400],
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            )
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                _scan(_scanText);
              },
              child: Container(
                margin: EdgeInsets.only(top: 30.0, left: 10.0, right: 20.0, bottom: 30.0),
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    Provider.of<CustomThemeData>(context).getLanguageData("Scan Text"),
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 30.0
                    )
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.lightGreen[400],
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            )
          )
        ],
      ),
    );
  }

}