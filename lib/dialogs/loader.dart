import 'package:flutter/material.dart';

class Loader {
  ShowCargando(context, String texto) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              contentPadding: EdgeInsets.all(0),
              elevation: 0, //0
              //backgroundColor: Colors.transparent,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Image.asset(
                    "assets/loader_tak-si.gif",
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Center(
                      child: Text(
                        texto,
                        style: TextStyle(
                            fontSize: 20,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
