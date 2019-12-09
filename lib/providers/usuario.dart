
import 'package:flutter/cupertino.dart';

class Usuario with ChangeNotifier{

  String _correo=null;
<<<<<<< HEAD
=======
  String _nombre=null;
  String _foto=null;
>>>>>>> 30d8f271757d03b3ff4be800c1d8ea611e07ce2b

  get correo{
    return this._correo;
  }
  set correo(final correo){
    this._correo=correo;
    notifyListeners();
  }
<<<<<<< HEAD
=======
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
>>>>>>> 30d8f271757d03b3ff4be800c1d8ea611e07ce2b


}