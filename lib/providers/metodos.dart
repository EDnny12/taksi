import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Metodos {
  Future<File> selectImage() async {
    return await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Widget showInfoCalificacion(final calificacion) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      contentPadding: EdgeInsets.all(0.0),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0)),
                    color: Colors.grey,
                  ),
                  height: 150.0,
                  //width: 281.0,
                ),
                Column(
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      size: 70.0,
                      color: Colors.white,
                    ),
                    Text(
                      "TÚ CALIFICACIÓN",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
              child: calificacion >= 4 && calificacion < 4.5
                  ? const Text(
                      "Eres un buen pasajero \n ¡Sigue así!",
                      textAlign: TextAlign.center,
                    )
                  : calificacion >= 4.5
                      ? const Text(
                          "Eres un excelente pasajero \n ¡Sigue así!",
                          textAlign: TextAlign.center,
                        )
                      : calificacion >= 3.5 && calificacion < 4
                          ? const Text(
                              "Podrías mejorar como pasajero",
                              textAlign: TextAlign.center,
                            )
                          : const Text(
                              "Recuerda dirigirte con respeto al chofer y a su unidad",
                              textAlign: TextAlign.center,
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
