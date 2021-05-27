import 'package:flutter/cupertino.dart';

class SelectedItems with ChangeNotifier {
  List<int> _selectedItems = [];

  List<int> get selectedBlogs {
    return _selectedItems;
  }

  void select(int id) {
    _selectedItems.add(id);
    notifyListeners();
  }

  void deselect(int id) {
    _selectedItems.remove(id);
    notifyListeners();
  }

  void empty() {
    _selectedItems = [];
    notifyListeners();
  }
}
