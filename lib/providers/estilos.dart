import 'package:flutter/material.dart';
class Estilos{


  Widget estilo(final BuildContext context,final String titulo){
    return FittedBox(
      fit: BoxFit.contain,
      child: Text(
        titulo,style: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFFFFFFFF) : Colors.white,
        fontWeight: FontWeight.bold,
        fontSize:16,
      ),
      ),
    );
  }

  Widget estilo2(final BuildContext context,final String titulo){
    return FittedBox(
      fit: BoxFit.contain,
      child: Text(
        titulo,style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        // fontSize:22,
      ),
      ),
    );
  }

  Color background(final BuildContext context){
    Theme.of(context).brightness == Brightness.dark ? Theme.of(context).scaffoldBackgroundColor :  Colors.lightBlue;
    //return Theme.of(context).scaffoldBackgroundColor;
  }

  IconThemeData colorIcon(final BuildContext context){
    return IconThemeData(
        color:Theme.of(context).brightness == Brightness.dark ? const Color(0xFFFFFFFF):  Colors.white
    );
  }



}