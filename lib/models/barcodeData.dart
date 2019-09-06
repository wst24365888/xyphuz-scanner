import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'barcode.dart';

class BarcodeData extends ChangeNotifier {

  List<Barcode> _resultData = List<Barcode>();
  bool initialized = false;

  UnmodifiableListView<Barcode> get resultData {
    return UnmodifiableListView(_resultData);
  }

  int get resultLength {
    return _resultData.length;
  }

  void addResult(Barcode result) async {

    List<String> emptyList = List<String>();  // 做個空List預防tempBarcodeData為null

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    List<String> tempBarcodeData = sharedPreferences.getStringList("BarcodeData");  // 取得目錄

    // 若該筆資料不在本地資料庫則新增資料
    if(!(tempBarcodeData??emptyList).contains(result.timestamp.toString())) {
      (tempBarcodeData??emptyList).add(result.timestamp.toString()); // 以時間戳(唯一值)來做為目錄內容

      sharedPreferences.setStringList("BarcodeData", (tempBarcodeData??emptyList));
      sharedPreferences.setString(result.timestamp.toString(), result.content); // 以時間戳為key來記錄該筆資料的content
    }

    _resultData.insert(0, result);
    notifyListeners();

  }

  void removeResult(int index) async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    List<String> tempBarcodeData = sharedPreferences.getStringList("BarcodeData");  // 取得目錄

    sharedPreferences.remove(tempBarcodeData[index]); // 先移除資料

    tempBarcodeData.removeAt(index);
    sharedPreferences.setStringList("BarcodeData", tempBarcodeData);  // 再從目錄中移除

    _resultData.removeAt(index);
    notifyListeners();
    
  }

}