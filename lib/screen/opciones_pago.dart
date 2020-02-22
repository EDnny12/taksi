import 'package:flutter/material.dart';
import 'package:taksi/providers/estilos.dart';

class Opciones_pago extends StatefulWidget {
  @override
  _Opciones_pagoState createState() => _Opciones_pagoState();
}

class _Opciones_pagoState extends State<Opciones_pago> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Estilos().estilo(context, 'Opciones de pago'),
        backgroundColor: Estilos().background(context),
        iconTheme: Estilos().colorIcon(context),
      ),
    );
  }
}
