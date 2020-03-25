import 'package:flutter/cupertino.dart';

class Publicidad with ChangeNotifier {

  String _descripcion;
  String _empresa;
  String _telefono;
  String _marker;

  String get descripcion => _descripcion;

  set descripcion(String value) {
    _descripcion = value;
    //notifyListeners();
  }

  String get empresa => _empresa;

  set empresa(String value) {
    _empresa = value;
    //notifyListeners();
  }

  String get telefono => _telefono;

  set telefono(String value) {
    _telefono = value;
    //notifyListeners();
  }

  String get marker => _marker;

  set marker(String value) {
    _marker = value;
    //notifyListeners();
  }


}