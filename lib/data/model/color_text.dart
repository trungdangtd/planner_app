import 'package:flutter/material.dart';

class ColorTextProvider with ChangeNotifier {
  Color _appColor = const Color(0xFF398378); 
  Color _backgroundColor = const Color.fromRGBO(200, 230, 201, 1); 
  String _font = 'Roboto'; // Default font

  Color get appColor => _appColor;
  Color get backgroundColor => _backgroundColor;
  String get font => _font; // Getter for font

  void setColor(Color color) {
    _appColor = color;
    notifyListeners(); 
  }

  void setBackgroundColor(Color color) {
    _backgroundColor = color;
    notifyListeners(); 
  }

  void setFont(String font) {
    _font = font; // Update font
    notifyListeners(); 
  }
}
