import 'package:flutter/cupertino.dart';

class Usuario with ChangeNotifier {
  String _correo = null;
  String _nombre = null;
  String _foto = null;
  String _calificacion = null;
  bool darkMode = false;

  set dark(final modo) {
    this.darkMode = modo;
  }

  get correo {
    return this._correo;
  }

  set correo(final correo) {
    this._correo = correo;
    notifyListeners();
  }

  get nombre {
    return this._nombre;
  }

  set nombre(final nom) {
    this._nombre = nom;
    notifyListeners();
  }

  get foto {
    return this._foto;
  }

  set foto(final fo) {
    this._foto = fo;
    notifyListeners();
  }

  String get calificacion => _calificacion;

  set calificacion(String value) {
    _calificacion = value;
  }

}
