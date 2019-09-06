import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
import 'package:provider/provider.dart';

import 'checkResult.dart';
import '../models/barcode.dart';
import '../models/barcodeData.dart';

class ScanBarcodePage extends StatefulWidget {

  @override
  ScanBarcodePageState createState() => ScanBarcodePageState();

}

class ScanBarcodePageState extends State<ScanBarcodePage> {

  GlobalKey _scannerKey = GlobalKey();
  QRViewController _scannerController;

  bool _frontCamera = false;
  bool _flashLight = false;
  bool _pause = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scannerController?.dispose();
    super.dispose();   
  }

  void _onQRViewCreated(QRViewController controller) {

    _scannerController = controller;
    _scannerController.scannedDataStream.listen((resultContent) {

      _pause = true;
      _scannerController.pauseCamera();

      Barcode result = Barcode(content: resultContent, timestamp: DateTime.now().microsecondsSinceEpoch);
      Provider.of<BarcodeData>(context).addResult(result);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CheckResultPage(index: 0)),
      );

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: _scannerKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderRadius: 10.0,
                borderColor: Colors.green,
                borderLength: 30.0,
                borderWidth: 10.0,
                cutOutSize: 250.0,
              ),
            )
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        _frontCamera ? Icons.camera_rear : Icons.camera_front
                      ),
                      onPressed: () {
                        _scannerController.flipCamera();
                        setState(() {                       
                          _frontCamera = !_frontCamera; 
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        _flashLight ? Icons.flash_off : Icons.flash_on
                      ),
                      onPressed: () {
                        _scannerController.toggleFlash();
                        setState(() {                       
                          _flashLight = !_flashLight; 
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        _pause ? Icons.play_arrow : Icons.pause
                      ),
                      onPressed: () {
                        _pause ? _scannerController.resumeCamera() : _scannerController.pauseCamera();
                        setState(() {                       
                          _pause = !_pause; 
                        });
                      },
                    )
                  ],
                ),
              )
            )
          ),
        ],
      )
    );
  }

}