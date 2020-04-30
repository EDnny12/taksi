import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taksi/providers/metodos.dart';
import 'package:taksi/providers/usuario.dart';

class Calificacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("calificaciones_usuarios")
          .where("email", isEqualTo: Provider.of<Usuario>(context, listen: true).correo)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return const Text('ERROR AL CARGAR LOS AVISOS');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Text("");

          default:
            return lista(snapshot.data.documents, context);
        }
      },
    );
  }

  Widget lista(List<DocumentSnapshot> document, BuildContext context) {
    if (document.length == 0) {
      return const Text(
        "Aún no tienes calificación",
        style: const TextStyle(color: Colors.grey, fontSize: 11.5),
      );
    } else {
      final datos = document[0].data["calificacion"];
      String califi = (datos[0] / datos[1]).toStringAsFixed(1);
      print('calificacion: ' + califi);
      return GestureDetector(
          onTap: () {
            showGeneralDialog(
                barrierColor: Colors.black.withOpacity(0.5),
                transitionBuilder: (context, a1, a2, widget) {
                  return Transform.scale(
                    scale: a1.value,
                    child: Opacity(
                        opacity: a1.value,
                        child: Metodos()
                            .showInfoCalificacion(datos[0] / datos[1])),
                  );
                },
                transitionDuration: Duration(milliseconds: 200),
                barrierDismissible: true,
                barrierLabel: '',
                context: context,
                pageBuilder: (context, animation1, animation2) {});
          },
          child: Text(
            califi,
            textAlign: TextAlign.right,
          ));
    }
  }
}