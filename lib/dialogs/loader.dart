import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class Loader {
  showCargando(context, String texto) {
    showDialog(
        context: context,
        builder: (_) => Material(
              type: MaterialType.transparency,
              child: WillPopScope(
                onWillPop: () async => false,
                child: Center(
                    // Aligns the container to center
                    child: Container(
                  // A simplified version of dialog.
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Image.asset(
                        "assets/loader_tak-si.gif",
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Center(
                          child: ColorizeAnimatedTextKit(
                            text: [texto],
                            textStyle:
                                TextStyle(fontSize: 20, color: Colors.white),
                            colors: [
                              Colors.yellow,
                              Colors.lightBlue,
                              Colors.white,
                              Colors.amber
                            ],
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                )),
              ),
            ));
  }
}
