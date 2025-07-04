import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  int? _id;
  String? _name;
  String? _email;
  String? _photo;

  int? get id => _id;

  String? get name => _name;

  String? get email => _email;

  String? get photo => _photo;

  void setUser({
    required int id,
    required String name,
    required String email,
    required String photo,
  }) {
    _id = id;
    _name = name;
    _email = email;
    _photo = photo;
    notifyListeners();
  }

  void updateProfile({String? name, String? email}) {
    if (name != null) _name = name;
    if (email != null) _email = email;
    notifyListeners();
  }

  void updatePhoto(String newPhoto) {
    _photo = newPhoto;
    notifyListeners();
  }

  void logout() {
    _id = null;
    _name = null;
    _email = null;
    _photo = null;
    notifyListeners();
  }
}
