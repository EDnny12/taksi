import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taksi/dialogs/dialogGuardarUbicacion.dart';
import 'package:taksi/providers/payment_provider.dart';
import 'package:taksi/providers/publicidad.dart';
import 'package:taksi/providers/ubicaciones_guardadas.dart';
import 'package:taksi/providers/usuario.dart';
import 'package:taksi/state/app_state.dart';
import 'package:taksi/providers/db_helper.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  Future<List<Ubicaciones>> ubicaciones;
  var dbHelper;

  @override
  void initState() {
    dbHelper = DBHelper();
    refreshList();
  }

  refreshList() {
    setState(() {
      ubicaciones = dbHelper.getUbicaciones();
    });
  }

  dataTable(List<Ubicaciones> ubicaciones) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: CarouselSlider(
        height: 35.0,
        enableInfiniteScroll: false,
        items: ubicaciones.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return InkWell(
                onTap: () {
                  Provider.of<AppState>(context, listen: false).markerSaved = true;
                  Provider.of<AppState>(context, listen: false).getDestinationLongPress(
                      LatLng(i.latitud, i.longitud), context);
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(
                        top: 3, left: 3, right: 3, bottom: 3),
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white12
                                  : Colors.grey,
                              spreadRadius: 2)
                        ]),
                    child: Center(
                        child: Text(
                      i.nombre,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ))),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  list() {
    return FutureBuilder(
      future: ubicaciones,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return dataTable(snapshot.data);
        }
        if (snapshot.data == null || snapshot.data.length == 0) {
          return Text('');
        }

        return CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Usuario>(context, listen: true).map = this;
    PaymentProvider payment = new PaymentProvider.initialize();
    double mitad = MediaQuery.of(context).size.height / 2;
    final appState = Provider.of<AppState>(context, listen: true);
    return appState.initialPosition == null
        ? Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/loader_tak-si.gif",
                ),
                Visibility(
                  visible: appState.locationServiceActive == false,
                  child: Text(
                    appState
                        .msgUsuario, //"Por favor active el gps o verifique su conexion a internet"
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                appState.msgUsuario == 'Permiso de ubicación no otorgado'
                    ? RaisedButton.icon(
                        color: Colors.lightBlue,
                        label: Text('Otorgar permiso',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                        icon: Icon(
                          Icons.not_listed_location,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          appState.requestUbicationPermission(
                              onPermissionDenied: () {
                                print('permiso denegado');
                              });
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      )
                    : SizedBox()
              ],
            ),
          )
        : Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: appState.initialPosition, zoom: 16.0),
                onMapCreated: appState.onCreated,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
                myLocationEnabled: true,
                mapType: MapType.normal, //normal
                compassEnabled: true,
                rotateGesturesEnabled: true,
                markers: appState.markers,
                onCameraMove: appState.onCameraMove,
                onLongPress: (latLng) {
                  Provider.of<AppState>(context, listen: false).markerSaved = false;
                  appState.getDestinationLongPress(latLng, context);
                },
                polylines: appState.polyLines,
              ),
              Positioned(
                top: 95,
                right: 8,
                child: SizedBox.fromSize(
                  size: Size(40, 40), // button width and height
                  child: ClipOval(
                    child: Material(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white24
                          : Colors.black26, // button color
                      child: InkWell(
                        splashColor: Colors.blue, // splash color
                        onTap: () {
                          Provider.of<AppState>(context, listen: false)
                              .cameraPositionUser();
                          //payment.addCard();
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.my_location,
                              color: Colors.white70,
                              size: 30,
                            ), // icon
                            //Text("Call"), // text
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Provider.of<AppState>(context, listen: true).showBtnPersistentDialog == false
                  ? Positioned(
                      top: 42,
                      right: 10.0, //15
                      left: 65.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 40.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(1.0, 5.0),
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white12
                                          : Colors.grey,
                                      blurRadius: 10.0,
                                      spreadRadius: 3)
                                ]),
                            child: TextField(
                              onTap: () async {
                                appState.getDestinationLocation(context);
                              },
                              cursorColor: Colors.blue.shade900,
                              controller: appState.destinationController,
                              textInputAction: TextInputAction.go,
                              decoration: InputDecoration(
                                icon: Container(
                                  margin: EdgeInsets.only(left: 20.0),
                                  width: 10.0,
                                  height: 10,
                                  child: Icon(
                                    Icons.local_taxi,
                                  ),
                                ),
                                hintText: "¿A dónde vamos?",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 15.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              Provider.of<AppState>(context, listen: true).showbtnNext
                  ? Positioned(
                      bottom: 5,
                      right: 10,
                      left: 10,
                      child: Container(
                        margin: const EdgeInsets.only(
                            top: 5, left: 5, right: 5, bottom: 5),
                        height: 75,
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 10,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white12
                                      : Colors.grey,
                                  spreadRadius: 3)
                            ]),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Positioned(
                              left: 10,
                              child: SizedBox.fromSize(
                                size: Size(40, 40), // button width and height
                                child: ClipOval(
                                  child: Material(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white24
                                        : Colors.black26, // button color
                                    child: InkWell(
                                      splashColor: Colors.blue, // splash color
                                      onTap: () {
                                        !Provider.of<AppState>(context, listen: false)
                                                .showBtnPersistentDialog
                                            ? Provider.of<AppState>(context, listen: false)
                                                .restablecerVariables(
                                                    context, 'menu')
                                            : Provider.of<AppState>(context, listen: false)
                                                .cancelPuntoPartida(context);
                                      }, // button pressed
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.arrow_back,
                                            color: Colors.white70,
                                            size: 30,
                                          ), // icon
                                          //Text("Call"), // text
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 60, right: 10),
                                  child: RaisedButton.icon(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.tealAccent
                                        : Colors.lightBlue,
                                    label: Text(
                                        !Provider.of<AppState>(context, listen: true)
                                                .showBtnPersistentDialog
                                            ? 'Continuar'
                                            : 'Confirmar',
                                        style: TextStyle(
                                            fontSize: 20, color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.black
                                            : Colors.white)),
                                    icon: Icon(
                                      Icons.navigate_next,
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    onPressed: () {
                                      if (!Provider.of<AppState>(context, listen: false)
                                          .showBtnPersistentDialog) {
                                        Provider.of<AppState>(context, listen: false)
                                            .selectPuntoPartida(context);
                                      } else {
                                        Provider.of<AppState>(context, listen: false)
                                            .btnContinuarPuntoPartida(context);
                                      }
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  : const SizedBox(),
              Provider.of<AppState>(context, listen: true).showAppBar
                  ? Positioned(
                      child: Container(
                      alignment: Alignment.center,
                      height: 75,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.tealAccent
                          : Colors.lightBlue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            'Punto de partida',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ))
                  : const SizedBox(),
              Provider.of<AppState>(context, listen: true).showInfoMarker
                  ? Positioned(
                      top: mitad,
                      left: 20,
                      right: 20,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black87
                                  : Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 10,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white12
                                        : Colors.grey,
                                    spreadRadius: 3)
                              ]),
                          child: Stack(
                            children: <Widget>[
                              SizedBox(
                                height: 5,
                              ),
                              Center(
                                child: Text(
                                  Provider.of<Publicidad>(context, listen: true).empresa,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, bottom: 5, left: 10),
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundImage: NetworkImage(
                                      Provider.of<Publicidad>(context, listen: true).marker),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, left: 45),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              Provider.of<Publicidad>(context, listen: true)
                                                  .descripcion,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(fontSize: 13),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Tel: ' +
                                                    Provider.of<Publicidad>(
                                                            context, listen: true)
                                                        .telefono,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )))
                  : SizedBox(),
              Provider.of<AppState>(context, listen: true).showSaveDestination
                  ? Positioned(
                      top: mitad,
                      left: 50,
                      right: 50,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black87
                                  : Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 10,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white12
                                        : Colors.grey,
                                    spreadRadius: 3)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Destino',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  Provider.of<AppState>(context, listen: true)
                                      .destinationController
                                      .text,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300),
                                ),
                                Provider.of<AppState>(context, listen: true).markerSaved
                                    ? Text(
                                        'Ubicación guardada',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      )
                                    : MaterialButton(
                                        minWidth: 150.0,
                                        height: 30.0,
                                        onPressed: () {
                                          DialogGuardarUbicacion()
                                              .dialogGuardarUbicacion(context);
                                        },
                                        color: Colors.lightBlue,
                                        child: Text('Guardar ubicación',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                              ],
                            ),
                          )))
                  : SizedBox(),
              Provider.of<AppState>(context, listen: true).showUbicaciones
                  ? Positioned(
                      bottom:
                          Provider.of<AppState>(context, listen: true).showbtnNext ? 100 : 5,
                      left: 80,
                      right: 80,
                      child: list())
                  : SizedBox()
            ],
          );
  }
}
