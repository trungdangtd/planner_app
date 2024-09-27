import 'package:flutter/material.dart';

class ColorProvider with ChangeNotifier {
  Color _appColor = const Color(0xFF398378); // Default AppBar color
  Color _backgroundColor =
      const Color.fromRGBO(200, 230, 201, 1); // Default background color

  Color get appColor => _appColor;
  Color get backgroundColor => _backgroundColor;

  void setColor(Color color) {
    _appColor = color;
    notifyListeners(); // Notify listeners to update the UI
  }

  void setBackgroundColor(Color color) {
    _backgroundColor = color;
    notifyListeners(); // Notify listeners to update the UI
  }
}
