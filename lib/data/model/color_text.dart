import 'package:flutter/material.dart';

class ColorTextProvider with ChangeNotifier {
  Color _appColor = const Color(0xFF398378);
  Color? _backgroundColor;
  String _font = 'Roboto';

  Color get appColor => _appColor;
  Color? get backgroundColor => _backgroundColor;
  String get font => _font;

  void setColor(Color color) {
    _appColor = color;
    notifyListeners();
  }

  void setBackgroundColor(Color color) {
    _backgroundColor = color;
    notifyListeners();
  }

  void setFont(String font) {
    _font = font;
    notifyListeners();
  }
}
