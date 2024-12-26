import 'package:flutter/material.dart';

class CustomAppBarProvider extends ChangeNotifier {
  bool _isMenuOpen = false;
  bool _isIconEnable = true;
  bool get isMenuOpen => _isMenuOpen;
  bool get isIconEnable => _isIconEnable;

  void setIsMenuOpen(bool isMenuOpen){
    _isMenuOpen = isMenuOpen;
    notifyListeners();
  }
  void setIsIconEnable(bool isIconEnable){
    _isIconEnable = isIconEnable;
    notifyListeners();
  }
}
