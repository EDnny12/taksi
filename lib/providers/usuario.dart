
import 'package:flutter/cupertino.dart';

class Usuario with ChangeNotifier{

  String _correo=null;
  String _nombre=null;
  String _foto=null;

  get correo{
    return this._correo;
  }
  set correo(final correo){
    this._correo=correo;
    notifyListeners();
  }
  get nombre{
    return this._nombre;
  }
  set nombre(final nom){
    this._nombre=nom;
    notifyListeners();
  }
  get foto{
    return this._foto;
  }
  set foto(final fo){
    this._foto=fo;
    notifyListeners();
  }


}