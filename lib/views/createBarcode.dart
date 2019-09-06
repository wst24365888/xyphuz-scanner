import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'checkResult.dart';
import '../models/barcode.dart';
import '../models/barcodeData.dart';
import '../models/customThemeData.dart';

class CreateBarcodePage extends StatefulWidget {

  @override
  CreateBarcodePageState createState() => CreateBarcodePageState();

}

class CreateBarcodePageState extends State<CreateBarcodePage> {

  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                Provider.of<CustomThemeData>(context).getLanguageData("Create Barcode"),
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.w600,
                  color: Colors.lightGreen[400],
                  fontSize: 25.0
                )
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                onEditingComplete: () => SystemChrome.restoreSystemUIOverlays(),
                controller: _contentController,
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.w400,
                  fontSize: 18.0
                ),
                decoration: InputDecoration(
                  hintText: "Type something...", 
                  hintStyle: TextStyle(
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0
                  )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: GestureDetector(
                onTap: () {
                  SystemChrome.restoreSystemUIOverlays();

                  Barcode result = Barcode(content: _contentController.text, timestamp: DateTime.now().microsecondsSinceEpoch);
                  Provider.of<BarcodeData>(context).addResult(result);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CheckResultPage(index: 0)),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    Provider.of<CustomThemeData>(context).getLanguageData("Generate"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 25.0
                    )
                  ),
                  decoration: BoxDecoration(
                    color: Colors.lightGreen[400],
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                ),
              ),
            )
          ],
        )
      )
    );
  }

}