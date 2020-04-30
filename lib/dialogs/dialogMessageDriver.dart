import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taksi/providers/usuario.dart';
import 'package:toast/toast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'dart:async';

class DialogMessage {
  TextEditingController message = TextEditingController();

  dialogMessage(context2) {
    Provider.of<Usuario>(context2, listen: false).messageChofer != null
        ? message.text =
            Provider.of<Usuario>(context2, listen: false).messageChofer
        : SizedBox();
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
                opacity: a1.value,
                child: Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    height: 310.0,
                    width: 300.0,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 120,
                          padding: EdgeInsets.all(5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  'Mensaje al conductor',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Ejemplo:',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  'Llevo 2 maletas grandes',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            maxLines: 2,
                            maxLength: 50,
                            controller: message,
                            decoration: InputDecoration(
                              labelText: 'Descripción',
                              suffixIcon: Icon(Icons.sentiment_very_satisfied),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            RaisedButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              onPressed: () {
                                if (message.text.isEmpty) {
                                  Toast.show('Ingrese el mensaje', context,
                                      duration: Toast.LENGTH_SHORT,
                                      gravity: Toast.CENTER);
                                } else {
                                  //var newString = message.text.substring(message.text.length - 5);
                                  var newString = message.text.substring(0, 5);
                                  print(newString + '...');
                                  Provider.of<Usuario>(context, listen: false)
                                      .messageChofer = message.text;
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Text(
                                'Aceptar',
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context2,
        pageBuilder: (context, animation1, animation2) {});
  }
}
