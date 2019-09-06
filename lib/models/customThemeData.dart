import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomThemeData extends ChangeNotifier {

  // index of English = 0, Chinese = 1
  String _selectedLanguage;
  List<String> _supportedLanguages = ["English", "中文"];
  Map<String, List<String>> _languageData = {
    "Just Scan": ["Just Scan", "就掃"],
    "Scan Barcode": ["Scan Barcode", "掃條碼"],
    "Scan Text": ["Scan Text", "掃文字"],
    "Upload File": ["Upload File", "上傳文件"],
    "Create Barcode": ["Create Barcode", "建立條碼"],
    "Generate": ["Generate", "生成"],
    "Calculating...": ["Calculating...", "計算中..."],
    "Text copied.": ["Text copied.", "已複製文字"],
    "Share Barcode": ["Share Barcode", "分享條碼"],
    "Share Text": ["Share Text", "分享文字"],
    "History": ["History", "歷史"],
    "Settings": ["Settings", "設定"],
    "Language": ["Language", "語言"],
    "Select Language": ["Select Language", "選擇語言"],
  };

  CustomThemeData() {
    _selectedLanguage = _supportedLanguages[0];
  }

  String get selectedLanguage {
    return _selectedLanguage;
  }

  UnmodifiableListView<String> get supportedLanguages {
    return UnmodifiableListView(_supportedLanguages);
  }

  String getLanguageData(String string) {
    return _languageData[string][_supportedLanguages.indexOf(_selectedLanguage)];
  }

  void changeLanguage(String languageToChange) async {

    _selectedLanguage = languageToChange;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString("language", _selectedLanguage);

    notifyListeners();

  }

}