import 'package:flutter/cupertino.dart';

class Tip {
  IconData icon;
  String text = "";

  Tip(String chText, IconData chIcon) {
    text = chText;
    icon = chIcon;
  }
}
