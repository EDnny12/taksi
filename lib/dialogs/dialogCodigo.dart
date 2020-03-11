import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taksi/dialogs/loader.dart';
import 'package:taksi/state/app_state.dart';
import 'package:toast/toast.dart';

class dialogCodigo {

  TextEditingController cupon = TextEditingController();

  showAlertCodigoViaje(context2) {
    showGeneralDialog(
        context: context2,
        barrierColor: Colors.black.withOpacity(0.5),
        barrierLabel: '',
        barrierDismissible: true,
        transitionDuration: Duration(milliseconds: 200),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                contentPadding: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                content: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "¿Tienes un cupón de descuento?",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "Cuando tengas un cupón de descuento ingresalo para obtener fabulosos descuentos en tus viajes",
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: cupon,
                        decoration: InputDecoration(
                            hintText: "Ingresa tu cupón",
                            border: const UnderlineInputBorder(),
                            filled: true,
                            suffixIcon: Icon(Icons.local_offer)),
                      ),
                      SizedBox(height: 20.0),
                      FlatButton(
                        child: new Text(
                          'Aceptar',
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                          if (cupon.text.isNotEmpty) {
                            Navigator.of(context).pop();
                            Loader().ShowCargando(context2, 'Validando su código');
                            Provider.of<AppState>(context2).verifyCodigo(context2, cupon.text);
                          } else {
                            Toast.show('Ingrese un código', context2,
                                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        pageBuilder: (context, animation1, animation2) {});
  }

}