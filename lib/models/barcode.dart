import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Barcode {

  final String content;
  final int timestamp;

  String timestampString;
  String type;
  IconData icon;

  Barcode({@required this.content, @required this.timestamp}) {

    timestampString = DateFormat('MMM d (EEE) kk:mm:ss').format(DateTime.fromMicrosecondsSinceEpoch(timestamp));

    if(content.contains("http")) {
      type = "Link";
      icon = Icons.link;
    } else {
      type = "Text";
      icon = Icons.text_fields;
    }
  }

}