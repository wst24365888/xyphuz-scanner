import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/customThemeData.dart';

class SettingsPage extends StatefulWidget {

  @override
  SettingsPageState createState() => SettingsPageState();

}

class SettingsPageState extends State<SettingsPage> {

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

    return Scaffold(
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
                      Provider.of<CustomThemeData>(context).getLanguageData("Settings"),
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
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 10.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            Provider.of<CustomThemeData>(context).getLanguageData("Language"),
                            style: TextStyle(
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 20.0
                            )
                          ),
                          Container(
                            width: 150.0,
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Text(
                                  Provider.of<CustomThemeData>(context).getLanguageData("Select Language"),
                                  style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontSize: 20.0
                                  )
                                ),
                                value: Provider.of<CustomThemeData>(context).selectedLanguage,
                                onChanged: (String languageToChange) {                                  
                                  Provider.of<CustomThemeData>(context).changeLanguage(languageToChange);
                                },
                                items: Provider.of<CustomThemeData>(context).supportedLanguages.map((String language) {
                                  return DropdownMenuItem<String>(
                                    value: language, 
                                    child: Text(
                                      language,
                                      style: TextStyle(
                                        fontFamily: "Quicksand",
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      )
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
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
    );
  }

}