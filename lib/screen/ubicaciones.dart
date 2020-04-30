import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:taksi/dialogs/dialogConfirmarEliminacion.dart';
import 'package:taksi/dialogs/exitoso.dart';
import 'package:taksi/providers/db_helper.dart';
import 'package:taksi/providers/ubicaciones_guardadas.dart';
import 'package:taksi/providers/usuario.dart';
import 'package:taksi/widgets/tutorialSaveUbication.dart';

class UbicacionesPage extends StatefulWidget {
  final _MapState;
  UbicacionesPage(this._MapState);

  @override
  _UbicacionesPageState createState() => _UbicacionesPageState();
}

class _UbicacionesPageState extends State<UbicacionesPage> {
  Future<List<Ubicaciones>> ubicaciones;
  TextEditingController controller = TextEditingController();
  String nombre, direccion;
  double latitud, longitud;
  int currenUserId;
  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  refreshList() {
    setState(() {
      ubicaciones = dbHelper.getUbicaciones();
    });
  }

  limpiarNombre() {
    controller.text = '';
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        Ubicaciones ubi =
            Ubicaciones(currenUserId, nombre, 'actualizar', 16.00, -92.098);
        dbHelper.update(ubi);
        setState(() {
          isUpdating = false;
        });
      } else {
        Ubicaciones ubi = Ubicaciones(null, nombre, 'insertar', 16.00, -92.098);
        dbHelper.save(ubi);
      }
      limpiarNombre();
      refreshList();
    }
  }

  /*form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Nombre'),
              validator: (val) =>
                  val.length == 0 ? 'Nombre de la ubicación' : null,
              onSaved: (val) => nombre = val,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                    onPressed: validate,
                    child: Text(isUpdating ? 'actualizar' : 'agregar')),
                FlatButton(
                    onPressed: () {
                      setState(() {
                        isUpdating = false;
                      });
                      limpiarNombre();
                    },
                    child: Text('cancelar'))
              ],
            )
          ],
        ),
      ),
    );
  }*/

  SingleChildScrollView dataTable(
      UbicacionesPage widget2, List<Ubicaciones> ubicaciones) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
          columns: [
            DataColumn(
                label: Text(
              'Nombre',
            )),
            DataColumn(label: Text('Dirección')),
            DataColumn(label: Text('Eliminar'))
          ],
          rows: ubicaciones
              .map(
                (ubicacion) => DataRow(cells: [
                  DataCell(
                      Text(
                        ubicacion.nombre,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ), onTap: () {
                    setState(() {
                      isUpdating = true;
                      currenUserId = ubicacion.id;
                    });
                    controller.text = ubicacion.nombre;
                  }),
                  DataCell(
                    Text(ubicacion.direccion),
                  ),
                  DataCell(
                    IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          /*ConfirmarEliminacion().dialogConfirmar(
                              context,
                              'Eliminar ubicación',
                              '¿Esta seguro que desea eliminar esta ubicación?',
                              ubicacion.id);*/
                          showGeneralDialog(
                              barrierColor: Colors.black.withOpacity(0.5),
                              transitionBuilder: (context, a1, a2, widget) {
                                return Transform.scale(
                                  scale: a1.value,
                                  child: Opacity(
                                    opacity: a1.value,
                                    child: AlertDialog(
                                      contentPadding: EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      content: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Center(
                                                child: Text(
                                                    'Eliminar ubicación',
                                                    style: TextStyle(
                                                        fontSize: 20)),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Lottie.asset(
                                                  'assets/pregunta.json',
                                                  width: 180,
                                                  height: 150),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Center(
                                                child: Text(
                                                  '¿Está seguro que desea eliminar esta ubicación?',
                                                  style:
                                                      TextStyle(fontSize: 17),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              RaisedButton.icon(
                                                color: Colors.redAccent,
                                                textColor: Colors.white,
                                                onPressed: () {
                                                  dbHelper.delete(ubicacion.id);
                                                  refreshList();
                                                  widget2._MapState
                                                      .refreshList();
                                                  Navigator.of(context).pop();
                                                  DialogExitoso().dialogExitoso(
                                                      context,
                                                      'Ubicación eliminada',
                                                      'Se eliminó el registro correctamente');
                                                },
                                                label: Text('Aceptar',
                                                    style: TextStyle(
                                                        fontSize: 20)),
                                                icon: Icon(
                                                  Icons.tag_faces,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              transitionDuration: Duration(milliseconds: 200),
                              barrierDismissible: true,
                              barrierLabel: '',
                              context: context,
                              pageBuilder:
                                  (context, animation1, animation2) {});

                          //dbHelper.delete(ubicacion.id);
                          //refreshList();
                        }),
                  ),
                ]),
              )
              .toList()),
    );
  }

  list(UbicacionesPage widget) {
    return Expanded(
      child: FutureBuilder(
        future: ubicaciones,
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                      child: TypewriterAnimatedTextKit(
                    speed: Duration(milliseconds: 70),
                    totalRepeatCount: 100,
                    text: ['Aun no tiene ubicaciones guardadas'],
                    textStyle: TextStyle(fontSize: 18.0, fontFamily: "Agne"),
                  )),
                  SizedBox(
                    height: 15,
                  ),
                  RaisedButton.icon(
                    color: Colors.lightBlue,
                    label: Text('Ver tutorial',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    icon: Icon(
                      Icons.view_carousel,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => TutorialSaveUbication(
                                  Provider.of<Usuario>(context, listen: true).nombre)));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  )
                ],
              ),
            );
          } else if (snapshot.hasData) {
            return dataTable(widget, snapshot.data);
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 230.0,
                floating: false, //true
                pinned: true, //false
                //snap: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text('Mis ubicaciones',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      )),
                  background: Image.asset(
                    'assets/img_locations.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ];
          },
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                //form(),
                SizedBox(
                  height: 20,
                ),
                list(widget),
              ],
            ),
          )),
    );
  }
}
