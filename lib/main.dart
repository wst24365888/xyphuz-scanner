import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models/barcodeData.dart';
import 'models/customThemeData.dart';
import 'views/home.dart';

void main() {

  SystemChrome.setEnabledSystemUIOverlays([]);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => BarcodeData()),
        ChangeNotifierProvider(builder: (context) => CustomThemeData()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.black,
        ),
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    )
  );

}
