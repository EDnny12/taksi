import 'package:flutter/cupertino.dart';

class Usuario with ChangeNotifier {
  String _correo;
  String _nombre;
  String _foto;
  String _calificacion;
  String _telefono;
  String _ciudad;
  String _estado;
  String _inicio;
  bool darkMode = false;


  String get inicio => _inicio;

  set inicio(String value) {
    _inicio = value;
  }

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

  String get telefono => _telefono;

  set telefono(String value) {
    _telefono = value;
  }

  String get ciudad => _ciudad;

  set ciudad(String value) {
    _ciudad = value;
  }

  String get estado => _estado;

  set estado(String value) {
    _estado = value;
  }

}
