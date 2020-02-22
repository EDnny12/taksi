import 'package:flutter/material.dart';

class Dialog_Photo {

  dialogPhoto(context, String photo) {
    showGeneralDialog(
        context: context,
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
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(photo),
                ),
              ),
            ),
          );
        },
        pageBuilder: (context, animation1, animation2) {});
  }
}
