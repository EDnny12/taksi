
import 'package:flutter/cupertino.dart';

class Usuario with ChangeNotifier{

  String _correo=null;

  get correo{
    return this._correo;
  }
  set correo(final correo){
    this._correo=correo;
    notifyListeners();
  }


}