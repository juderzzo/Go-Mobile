import 'package:flutter/widgets.dart';

class BaseModel extends ChangeNotifier {
  //Busy State
  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  //Tab Bar State
  int _navBarIndex = 0;
  int get navBarIndex => _navBarIndex;

  void setNavBarIndex(int index) {
    _navBarIndex = index;
    notifyListeners();
  }
}
