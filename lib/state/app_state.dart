import 'dart:async';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:taksi/providers/usuario.dart';
import 'package:taksi/requests/google_maps_requests.dart';

class AppState with ChangeNotifier {
  String distanciaViaje = '',
      tiempo = '',
      status = '',
      _distanciaChofer = '',
      _tiempoChofer = '',
      _mensajeTime = '',
      calificacion;
  int listPositionDriver, itemLineas = 0;
  bool showFloating = true,
      showBtnAbordar = false,
      showBtnPersistentDialog = false,
      cargar = true,
      BtnCancelViaje = true;
  List<String> listLineas = List<String>();
  var listDriver, listTaxi, list;
  double distancia = 0.0,
      dis,
      latDriver,
      lonDriver,
      calificacionDriver = 0.0,
      sizeSlider = 0, sizeSliderOpen = 310;
  static LatLng _initialPosition, destination, ubicationDriver;
  LatLng _lastPosition = _initialPosition, position;
  bool locationServiceActive = true;
  String ciudadUsuario, codigo_postal, codigo_postal2, chofer, correo;
  BitmapDescriptor pinLocationIcon, markerDriver;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  GoogleMapController _mapController;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  LatLng get initialPosition => _initialPosition;
  LatLng get lastPosition => _lastPosition;
  GoogleMapsServices get googleMapsServices => _googleMapsServices;
  GoogleMapController get mapController => _mapController;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polyLines => _polyLines;
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  GoogleMapsPlaces _places =
      GoogleMapsPlaces(apiKey: "AIzaSyCrT1IGaVcQHRkf3ONb2I-LVvs-vfdt5Ug");
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Metodos metodos = Metodos();
  //Position position;
  Geolocator geolocator = Geolocator();
  PersistentBottomSheetController controller, controller2;
  TextEditingController cupon = TextEditingController();

  // firebase
  final databaseReference = Firestore.instance;
  StreamSubscription<QuerySnapshot> streamSub, streamSub2;

  AppState(context) {
    setCustomMapPin();
    getUserCurrentLocation(context);
    //getUserLocation(context);
    _loadingInitialPosition();
    Firestore.instance.settings(persistenceEnabled: false);
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2), 'assets/marker.png');
    markerDriver = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2), 'assets/marker_taxi.png');
  }

  getUserCurrentLocation(context) {
    geolocator
        .getPositionStream(LocationOptions(
            accuracy: LocationAccuracy.high, timeInterval: 5000))
        .listen((posi) {
      print('hola mundo');
      position = LatLng(posi.latitude, posi.longitude);
      if (_initialPosition == null) {
        getUserLocation(context);
      }
    });
  }

  //obtener la ubicacion del usuario
  void getUserLocation(context) async {
    //position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    _initialPosition = LatLng(position.latitude, position.longitude);

    //codigo_postal2 = placemark[0].administrativeArea; // chiapas
    if (_mapController != null) {
      updateLocationCamara(_initialPosition);
    } else {
      List<Placemark> placemark = await Geolocator()
          .placemarkFromCoordinates(position.latitude, position.longitude);
      locationController.text = placemark[0].name;
      ciudadUsuario = placemark[0].locality; // comitan de dominguez
      getCalificacionUser(context);
    }
    //locationController.text = placemark[0].thoroughfare + "-" + placemark[0].name + "," + placemark[0].subLocality;
    notifyListeners();
  }

  void getDestinationLocation(context) async {
    Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: "AIzaSyCrT1IGaVcQHRkf3ONb2I-LVvs-vfdt5Ug",
        mode: Mode.overlay,
        language: "es", //es-419
        components: [
          Component(Component.country, "MX"), //"MX" MX-CHP
        ]);
    if (p != null) {
      PlacesDetailsResponse detalles =
          await _places.getDetailsByPlaceId(p.placeId);

      double lat = detalles.result.geometry.location.lat;
      double lng = detalles.result.geometry.location.lng;

      // var address = await Geocoder.local.findAddressesFromQuery(p.description);
      List<Placemark> placemark =
          await Geolocator().placemarkFromCoordinates(lat, lng);
      //destinationController.text = placemark[0].name;
      destinationController.text = placemark[0].thoroughfare +
          "-" +
          placemark[0].name +
          "," +
          placemark[0].subLocality;
      destination = LatLng(lat, lng);
      FocusScope.of(context).requestFocus(new FocusNode());
      setPolynes(destination, context);
      addMarker(destination, "destino");
      //mover la camara
      updateLocationCamara(destination);
      notifyListeners();
    }
  }

  //agregar destino presionando en el mapa
  void getDestinationLongPress(LatLng coordenadas, context) async {
    if (!showBtnPersistentDialog) {
      List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
          coordenadas.latitude, coordenadas.longitude);
      destinationController.text = placemark[0].thoroughfare +
          "-" +
          placemark[0].name +
          "," +
          placemark[0].subLocality;

      destination = LatLng(coordenadas.latitude, coordenadas.longitude);

      setPolynes(destination, context);
      addMarker(destination, "destino");
      //mover la camara
      updateLocationCamara(coordenadas);
      notifyListeners();
    } else {
      showSnackBar('El destino ya ha sido seleccionado');
    }
  }

  showAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext c) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Image.asset(
                    "assets/logo.png",
                    height: 250,
                    //width: MediaQuery.of(context).size.width,
                    scale: 4,
                  ),
                  /*SizedBox(
                    height: 0,
                  ),*/
                  Center(
                    child: Text('Lo sentimos!', style: TextStyle(fontSize: 20)),
                  ),
                  Center(
                    child: Text(
                      'Tak-si aun no se encuentra en tu ciudad',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: RaisedButton.icon(
                      onPressed: () {
                        insertSolicitud(context);
                        Navigator.of(context).pop();
                        showSnackBar('Tu solicitud ha sido enviada!');
                      },
                      label: Text('Solicitar', style: TextStyle(fontSize: 20)),
                      icon: Icon(Icons.departure_board),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20))),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void updateLocationCamara(LatLng position) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 17.0)),
    );
  }

  mostraCamaraDosMarkers(LatLng segundoMarker) {
    //mover la camara entre dos puntos
    mapController.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest:
                LatLng(_initialPosition.latitude, _initialPosition.longitude),
            northeast: LatLng(segundoMarker.latitude, segundoMarker.longitude)),
        100.0));
    notifyListeners();
  }

  //Agregar un marcador en el mapa
  void addMarker(LatLng location, String marker) {
    if (marker == 'destino') {
      _markers.removeWhere((m) => m.markerId.toString() == 'destino');
      _markers.add(Marker(
          markerId: MarkerId("destino"),
          position: location,
          infoWindow: InfoWindow(title: marker, snippet: "Destino"),
          icon: pinLocationIcon));
    } else {
      _markers.removeWhere((m) => m.markerId.toString() == 'chofer');
      _markers.add(Marker(
          markerId: MarkerId("chofer"),
          position: location,
          infoWindow: InfoWindow(title: marker, snippet: "Mi Tak-si"),
          icon: markerDriver));
    }

    notifyListeners();
  }

  void setPolynes(LatLng destino, context) async {
    _polyLines.clear();
    polylineCoordinates.clear();
    List<PointLatLng> result = (await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyCrT1IGaVcQHRkf3ONb2I-LVvs-vfdt5Ug",
        _initialPosition.latitude,
        _initialPosition.longitude,
        destino.latitude,
        destino.longitude));
    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    Polyline polyline = Polyline(
        polylineId: PolylineId("poly"),
        color: Color.fromARGB(255, 40, 122, 198),
        width: 5,
        points: polylineCoordinates);

    _polyLines.add(polyline);

    //obtener distancia y tiempo
    metodos.getTime(_initialPosition, destination).then((value) {
      if (value != null) {
        distanciaViaje = value.split(',')[0];
        tiempo = value.split(',')[1];
        persistentBottomSheetDatosViaje(context, tiempo, distanciaViaje);
      }
    });
    notifyListeners();
  }

  //movimiento de la camara
  void onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
    notifyListeners();
  }

  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    //changeMapMode();
    notifyListeners();
  }

  changeMapMode() {
    /*if(ConfigBloc().darkModeOn){
      getJsonFile("assets/nightmode.json").then(setMapStyle);
    } else {
      getJsonFile("assets/daymode.json").then(setMapStyle);
    }*/

    if (Usuario().darkMode) {
      getJsonFile("assets/nightmode.json").then(setMapStyle);
    } else {
      getJsonFile("assets/daymode.json").then(setMapStyle);
    }
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    _mapController.setMapStyle(mapStyle);
  }

  //loader de ubicacion inicial
  void _loadingInitialPosition() async {
    //GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus(); ejemplo para checar si los permisos estan habilitados
    //if(_initialPosition == null){
    await Future.delayed(Duration(seconds: 8)).then((v) {
      if (_initialPosition == null) {
        locationServiceActive = false;
        notifyListeners();
      }
    });
    //}
  }

  persistentBottomSheetDatosViaje(context2, String tiempo, String distancia) {
    controller2 = scaffoldKey.currentState.showBottomSheet((context, {backgroundColor: Colors.transparent}) {
      //BottomSheetThemeData(backgroundColor: Colors.transparent);
      return Container(
        margin: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
        height: 150,
        decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                  blurRadius: 10, color: Colors.grey[300], spreadRadius: 5)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /*
                  Text(
                    'Tiempo estimado',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        tiempo,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        distancia,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 1.5,
                    //color: Colors.blueGrey,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Metodo de pago',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 1.5,
                    //color: Colors.blueGrey,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Column(
                  children: <Widget>[
                    Text(
                      'Efectivo',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    Text(
                      '\$ 35.00',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )),
                /*Expanded(
                  child: Container(
                    //margin: EdgeInsets.only(left: 10, right: 10),
                    width: 5.5,
                    //color: Colors.blueGrey,
                    color: Colors.white,
                  ),
                ),*/
                Expanded(
                    child: FlatButton(
                  child: new Text(
                    'Código',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  onPressed: () {
                    print('precionado');
                    showAlertCodigoViaje(context);
                  },
                )),
              ],
            ),
            /*Center(
              child: Text(
                '\$ 35.00',
                style: TextStyle(fontSize: 25, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),*/
            SizedBox(
              height: 5,
            ),
            SizedBox(
              width: double.infinity,
              height: 35,
              child: RaisedButton.icon(
                color: Colors.blue,
                label: Text('Continuar',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                onPressed: () {
                  showAlertLoader(
                      context2, 'Obteniendo los sitios de taxis de su ciudad');
                  showBottomShettLineas(context2);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
              ),
            ),
          ],
        ),
      );
    });
    controller2.closed.then((value) {
      persistentBottomSheetDatosViaje(context2, tiempo, distancia);
    });
  }

  void showBottomShettLineas(context2) async {
    getCiudadAfiliada().then((ciudad) async {
      Navigator.of(context2).pop();
      if (ciudad == 0) {
        showAlert(context2);
      } else {
        showModalBottomSheet(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            context: context2,
            builder: (context) {
              //return Container(
              return Container(
                height: 180,
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection("lineas")
                      .where("ciudad", isEqualTo: ciudadUsuario)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error al obtener la información"),
                      );
                    }
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                          child: Text("Cargando..."),
                        );
                      default:
                        if (cargar) {
                          listLineas.add('Todos');
                          snapshot.data.documents.forEach((value) {
                            listLineas.add(value['nombre']);
                            cargar = false;
                          });
                        }
                        return InkWell(
                          onTap: () {
                            getLocationDrivers(
                                listLineas[itemLineas],
                                _initialPosition.latitude.toString() +
                                    " " +
                                    _initialPosition.longitude.toString(),
                                destination.latitude.toString() +
                                    " " +
                                    destination.longitude.toString(),
                                ciudadUsuario,
                                Provider.of<Usuario>(context).nombre,
                                Provider.of<Usuario>(context).correo,
                                Provider.of<Usuario>(context).foto,
                                context2);
                            Navigator.of(context).pop();
                            showAlertLoader(
                                context2, 'Bucando el Tak-si mas cercano!');
                          },
                          child: CarouselSlider(
                            onPageChanged: (index) {
                              itemLineas = index;
                            },
                            enableInfiniteScroll: false,
                            items: listLineas.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0, top: 10, right: 0, bottom: 10),
                                    child: Container(
                                        decoration: new BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: new BorderRadius.only(
                                                topLeft: Radius.circular(20.0),
                                                topRight: Radius.circular(20.0),
                                                bottomLeft:
                                                    Radius.circular(20.0),
                                                bottomRight:
                                                    Radius.circular(20.0))),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Center(
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                i.toString(),
                                                style: TextStyle(
                                                  fontSize: 25.0,
                                                ),
                                              ),
                                              CircleAvatar(
                                                radius: 60.0,
                                                child: Image.asset(
                                                  "assets/taxiApp.png",
                                                  height: 250,
                                                  //width: MediaQuery.of(context).size.width,
                                                  scale: 4,
                                                ),
                                                //backgroundImage: Image.asset('assets/taxiApp.png',scale: 4,height: 20,),
                                                //NetworkImage(Provider.of<Usuario>(context).foto),
                                                backgroundColor:
                                                    Colors.transparent,
                                              ),
                                            ],
                                          ),
                                        )),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        );
                    }
                  },
                ),
              );
            });
      }
    });
  }

  showSnackBar(String texto) {
    final snackBar = SnackBar(
      content: Text(texto),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future getLineasTaxis() async {
    QuerySnapshot qn = await databaseReference
        .collection("lineas")
        .where("ciudad", isEqualTo: ciudadUsuario)
        .getDocuments();
    return qn.documents;
  }

  Future<int> getCiudadAfiliada() async {
    QuerySnapshot qn = await databaseReference
        .collection("ciudades_afiliadas")
        .where("ciudad", isEqualTo: ciudadUsuario)
        .getDocuments();
    return qn.documents.length;
  }

  void insertSolicitud(context) async {
    await databaseReference.collection("solicitudes").document().setData({
      'usuario': Provider.of<Usuario>(context).nombre,
      'ciudad': ciudadUsuario,
    });
  }

  //(String sitio, String email)
  void getLocationDrivers(
      String sitio,
      String origen,
      String destino,
      String ciudad,
      String nombreUsuario,
      String email,
      String foto,
      context) async {
    if (sitio == 'Todos') {
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection(ciudadUsuario)
          .where('estado', isEqualTo: 'online')
          .getDocuments();
      list = querySnapshot.documents;
    } else {
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection(ciudadUsuario)
          .where('estado', isEqualTo: 'online')
          .where('sitio', isEqualTo: sitio)
          .getDocuments();
      list = querySnapshot.documents;
    }

    if (list.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        latDriver = list[i].data["latitud"];
        lonDriver = list[i].data['longitud'];

        dis = await Geolocator().distanceBetween(
            _initialPosition.latitude,
            _initialPosition.longitude, //origen
            latDriver,
            lonDriver //destino
            );

        if (distancia == 0.0) {
          distancia = dis;
          chofer = list[i].data['identificador'];
          listPositionDriver = i;
        } else {
          if (distancia > dis) {
            distancia = dis;
            chofer = list[i].data['identificador'];
            listPositionDriver = i;
          }
        }
      }
      //insertChoferSeleccionado(chofer, email);
      insertSolicitudViaje(sitio, origen, destino, ciudad, nombreUsuario, email,
          chofer, foto, context);
    } else {
      itemLineas = 0;
      Navigator.of(context).pop(); // no hay taxis disponibles
      if (sitio == 'Todos') {
        showDialogError(context, 'Lo sentimos!',
            'No se encontro taxi disponible, intentelo de nuevo');
      } else {
        showDialogError(context, 'Lo sentimos!',
            'No se encontro taxi disponible, seleccione otro sitio de taxi');
      }
    }
  }

  Future insertSolicitudViaje(
      String nombreLinea,
      String origen,
      String destino,
      String ciudad,
      String nombreUsuario,
      String correo,
      String chofer,
      String foto,
      context) async {
    /*await Firestore.instance
        .collection('solicitudes_viajes')
        .where('correo', isEqualTo: correo)
        .snapshots()
        .first
        .then((value) {
      Firestore.instance.runTransaction((transaction) async {
        await transaction.delete(value.documents[0].reference);
      });
    });*/

    await databaseReference
        .collection('solicitudes_viajes')
        .document()
        .setData({
      'nombreLinea': nombreLinea,
      'origen': origen,
      'destino': destino,
      'ciudad': ciudad,
      'nombreUsuario': nombreUsuario,
      'correo': correo,
      'identificador': chofer,
      'foto': foto,
      'status': 'false',
      'calificacion': calificacion
    });
    getStatusAceptDriver(context, correo);
  }

  void getStatusAceptDriver(context, String correo) {
    CollectionReference reference =
        Firestore.instance.collection('solicitudes_viajes');
    streamSub = reference
        .where("correo", isEqualTo: correo)
        .snapshots()
        .listen((data) async {
      status = '';
      status = data.documents.first['status'];
      //status = data.documents[0]['status'];
      if (status == 'true') {
        print('taxista acepto');
        if (distancia <= 50.0) {
          showBtnAbordar = true;
        }
        getDataTaxiChofer(context);
      } else if (status == 'cancelado') {
        print('taxista rechazo');
        list.removeAt(listPositionDriver);
        distancia = 0.0;

        for (int i = 0; i < list.length; i++) {
          latDriver = list[i].data["latitud"];
          lonDriver = list[i].data['longitud'];

          dis = await Geolocator().distanceBetween(
              _initialPosition.latitude,
              _initialPosition.longitude, //origen
              latDriver,
              lonDriver //destino
              );

          if (distancia == 0.0) {
            distancia = dis;
            chofer = list[i].data['identificador'];
            listPositionDriver = i;
            print('distancia: ' + distancia.toString());
            print('id: ' + chofer);
          } else {
            if (distancia > dis) {
              distancia = dis;
              chofer = list[i].data['identificador'];
              listPositionDriver = i;
              print('distancia: ' + distancia.toString());
              print('id: ' + chofer);
            }
          }
        }
        updateChoferCercano(chofer, correo);
      }
      if (status == 'cancelado_usuario') {
        cancelViaje();
      } else if (status == 'cancelado_chofer') {
        cancelViaje();
        showDialogCancelDriver(context);
        print('taxista cancelo');
      } else if (status == 'iniciado') {
        // inicio el viaje
        BtnCancelViaje = false;
        mensajeTime = 'Su destino esta a: ';
        notifyListeners();
        print('viaje iniciado');
      } else if (status == 'finalizado') {
        // inicio el viaje
        showAlertCalificacion(context);
        cancelViaje();
        print('viaje finalizado');
      } else if (status == 'false') {
        print('taxista no acepto');
      }
    });
  }

  void cancelViaje() {
    if (streamSub != null) {
      streamSub.cancel();
      streamSub = null;
      if (streamSub2 != null) {
        streamSub2.cancel();
        streamSub2 = null;
      }
      print('termino de escuchar');
      print('status $status');
    }
  }

  void updateChoferCercano(String chofer, String correo) async {
    await Firestore.instance
        .collection('solicitudes_viajes')
        .where('correo', isEqualTo: correo)
        .snapshots()
        .first
        .then((value) {
      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(value.documents[0].reference,
            {'identificador': chofer, 'status': 'false'});
      });
    });
  }

  //obtener los datos del taxi y el chofer
  void getDataTaxiChofer(context) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("choferes")
        .where('identificador', isEqualTo: chofer)
        .getDocuments();
    listDriver = querySnapshot.documents;
    if (listDriver.isNotEmpty) {
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection('taxis')
          .where('choferes', arrayContains: chofer)
          .getDocuments();
      listTaxi = querySnapshot.documents;
      if (listTaxi.isNotEmpty) {
        showLocationDriver(context, chofer);
        mensajeTime = 'Su Tak-si llega en: ';
        //persistentBottomSheet(context);
        sliderPanelDatosChofer(context);
        Navigator.pop(context);
      } else {
        print('lista vacia');
      }
    }
  }

  //mostrar los datos del chofer
  persistentBottomSheet(context2) {
    //context2
    controller2.closed;
    showFloating = false;
    showBtnPersistentDialog = true;
    controller = scaffoldKey.currentState.showBottomSheet((context) {
      return Container(
        margin: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
        decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                  blurRadius: 10, color: Colors.grey[300], spreadRadius: 5)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min, //adaptar al tamaño
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    Provider.of<AppState>(context).mensajeTime +
                        Provider.of<AppState>(context).tiempoChofer +
                        ' ' +
                        Provider.of<AppState>(context).distanciaChofer,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              height: 1.5,
              //color: Colors.blueGrey,
              color: Colors.black54,
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          NetworkImage(Provider.of<Usuario>(context).foto),
                      backgroundColor: Colors.transparent,
                    ),
                    Row(
                      children: <Widget>[
                        Text(listDriver[0].data['calificacion'],
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.star,
                          color: Color(0xFFFFD700),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'Nombre:',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            listDriver[0].data["nombre"],
                            style: TextStyle(
                                fontSize: 18, color: Color(0xFFFFD700)),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            listDriver[0].data["apellidos"],
                            style: TextStyle(
                                fontSize: 18, color: Color(0xFFFFD700)),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Row(
                        children: <Widget>[
                          Text('Sitio:',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                              textAlign: TextAlign.justify),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            listTaxi[0].data["sitio"],
                            style: TextStyle(
                                fontSize: 18, color: Color(0xFFFFD700)),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              height: 1.5,
              //color: Colors.blueGrey,
              color: Colors.black54,
            ),
            SizedBox(
              height: 2,
            ),
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30.0,
                  child: Image.asset(
                    "assets/taxiApp.png",
                    height: 250,
                    //width: MediaQuery.of(context).size.width,
                    scale: 4,
                  ),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('Placa:',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                              textAlign: TextAlign.start),
                          SizedBox(
                            width: 6,
                          ),
                          Text(listTaxi[0].data["placa"],
                              style: TextStyle(
                                  fontSize: 18, color: Color(0xFFFFD700))),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('No de Taxi:',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                              textAlign: TextAlign.start),
                          SizedBox(
                            width: 6,
                          ),
                          Text(listTaxi[0].data["numero"],
                              style: TextStyle(
                                  fontSize: 18, color: Color(0xFFFFD700))),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Marca:',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                              textAlign: TextAlign.start),
                          SizedBox(
                            width: 6,
                          ),
                          Text(listTaxi[0].data["marca"],
                              style: TextStyle(
                                  fontSize: 18, color: Color(0xFFFFD700))),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                BtnCancelViaje
                    ? Expanded(
                        child: SizedBox(
                          //width: MediaQuery.of(context).size.width * 0.50,
                          height: 38,
                          child: RaisedButton.icon(
                            color: Colors.red,
                            label: Text('Cancelar',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              showCustomDialogWithImage(context2); //context2
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15))),
                          ),
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ],
        ),
      );
    });
    controller.closed.then((value) {
      //persistentBottomSheet(context);
    });
  }

  sliderPanelDatosChofer(context) {
    controller2.closed;
    showFloating = false;
    sizeSliderOpen = 310;
    sizeSlider = 70;
    //showBtnPersistentDialog = true;
    controller = scaffoldKey.currentState.showBottomSheet((context) {
      return const SizedBox();
    });
  }

  //widget cuando esta cerrado
  Widget floatingCollapsed(context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text(
                showFloating ? '' : listTaxi[0].data["placa"],
                style: TextStyle(color: Colors.white, fontSize: 21),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  Provider.of<AppState>(context).mensajeTime,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      Provider.of<AppState>(context).tiempoChofer,
                      style: TextStyle(color: Colors.white, fontSize: 19),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      Provider.of<AppState>(context).distanciaChofer,
                      style: TextStyle(color: Colors.white, fontSize: 19),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //widget cuando esta abierto
  Widget floatingPanel(context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 20.0,
              color: Colors.grey,
            ),
          ]),
      margin: const EdgeInsets.all(18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min, //adaptar al tamaño
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  Provider.of<AppState>(context).mensajeTime,
                  style: TextStyle(color: Colors.blueGrey, fontSize: 16),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      Provider.of<AppState>(context).tiempoChofer,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      Provider.of<AppState>(context).distanciaChofer,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            height: 1.5,
            //color: Colors.blueGrey,
            color: Colors.black54,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 25,
                    backgroundImage:
                        NetworkImage(Provider.of<Usuario>(context).foto),
                    backgroundColor: Colors.transparent,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                          showFloating
                              ? ''
                              : listDriver[0].data['calificacion'],
                          style:
                              TextStyle(fontSize: 15, color: Colors.blueGrey)),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.star,
                        color: Color(0xFFFFD700),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Nombre:',
                          style:
                              TextStyle(fontSize: 15, color: Colors.blueGrey),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          showFloating ? '' : listDriver[0].data["nombre"],
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          showFloating ? '' : listDriver[0].data["apellidos"],
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        Text('Sitio:',
                            style:
                                TextStyle(fontSize: 15, color: Colors.blueGrey),
                            textAlign: TextAlign.justify),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          showFloating ? '' : listTaxi[0].data["sitio"],
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            height: 1.5,
            //color: Colors.blueGrey,
            color: Colors.black54,
          ),
          SizedBox(
            height: 2,
          ),
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 30.0,
                child: Image.asset(
                  "assets/taxiApp.png",
                  height: 250,
                  //width: MediaQuery.of(context).size.width,
                  scale: 4,
                ),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('Placa:',
                            style:
                                TextStyle(fontSize: 15, color: Colors.blueGrey),
                            textAlign: TextAlign.start),
                        SizedBox(
                          width: 6,
                        ),
                        Text(showFloating ? '' : listTaxi[0].data["placa"],
                            style:
                                TextStyle(fontSize: 18, color: Colors.black)),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        Text('No de Taxi:',
                            style:
                                TextStyle(fontSize: 15, color: Colors.blueGrey),
                            textAlign: TextAlign.start),
                        SizedBox(
                          width: 6,
                        ),
                        Text(showFloating ? '' : listTaxi[0].data["numero"],
                            style:
                                TextStyle(fontSize: 18, color: Colors.black)),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        Text('Marca:',
                            style:
                                TextStyle(fontSize: 15, color: Colors.blueGrey),
                            textAlign: TextAlign.start),
                        SizedBox(
                          width: 6,
                        ),
                        Text(showFloating ? '' : listTaxi[0].data["marca"],
                            style:
                                TextStyle(fontSize: 18, color: Colors.black)),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              BtnCancelViaje
                  ? Expanded(
                      child: SizedBox(
                        //width: MediaQuery.of(context).size.width * 0.50,
                        height: 38,
                        child: RaisedButton.icon(
                          color: Colors.red,
                          label: Text('Cancelar',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            showCustomDialogWithImage(context); //context2
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15))),
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ],
      ),
    );
  }

  void showLocationDriver(context, String chofer) {
    CollectionReference reference =
        Firestore.instance.collection(ciudadUsuario);
    streamSub2 = reference
        .where("identificador", isEqualTo: chofer)
        .snapshots()
        .listen((data) async {
      ubicationDriver =
          LatLng(data.documents[0]['latitud'], data.documents[0]['longitud']);
      addMarker(ubicationDriver, 'chofer');
      updateLocationCamara(ubicationDriver);

      if (BtnCancelViaje) {
        metodos.getTime(_initialPosition, ubicationDriver).then((value) {
          if (value != null) {
            distanciaChofer = value.split(',')[0];
            tiempoChofer = value.split(',')[1];
            notifyListeners();
          }
        });
      } else {
        metodos.getTime(ubicationDriver, destination).then((value) {
          if (value != null) {
            distanciaChofer = value.split(',')[0];
            tiempoChofer = value.split(',')[1];
            notifyListeners();
          }
        });
      }
    });

    /*Firestore.instance
        .collection(ciudadUsuario)
        .where('identificador', isEqualTo: chofer)
        .snapshots()
        .listen((data) async {
      ubicationDriver =
          LatLng(data.documents[0]['latitud'], data.documents[0]['longitud']);
      addMarker(ubicationDriver, 'chofer');
      updateLocationCamara(ubicationDriver);
      dis = await Geolocator().distanceBetween(
          _initialPosition.latitude,
          _initialPosition.longitude, //origen
          ubicationDriver.latitude,
          ubicationDriver.longitude //destino
          );
      if (dis < 50.0) {
        showBtnAbordar = true;
      }
      //mostraCamaraDosMarkers(ubicationDriver);
    });*/
  }

  void showCustomDialogWithImage(context) {
    Dialog dialogWithImage = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 300.0,
        width: 300.0,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: Text(
                "Confirme la cancelación de su viaje",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 200,
              width: 300,
              child: Image.asset(
                'assets/taxiApp.png',
                fit: BoxFit.scaleDown,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  color: Colors.red,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancelar!',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    controller.closed;
                    Navigator.of(context).pop();
                    showAlertLoader(context, 'Cancelando su viaje');
                    cancelarViaje(context);
                  },
                  child: Text(
                    'Aceptar',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => dialogWithImage);
  }

  void showDialogCancelDriver(context) {
    Dialog dialogWithImage = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 310.0,
        width: 300.0,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: Text(
                'Lo sentimos, el taxista ha cancelado el viaje',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 180,
              width: 280,
              child: Image.asset(
                'assets/taxiApp.png',
                fit: BoxFit.scaleDown,
              ),
            ),
            Center(
              child: Text(
                'Intentelo de nuevo por favor',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    //Navigator.of(context).pop();
                    showAlertLoader(context, 'Cancelando su viaje');
                    //cancelarViaje(context); verificar si hay que eliminar el registro
                    restablecerVariables(context, 'cancelado');
                  },
                  child: Text(
                    'Aceptar',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => dialogWithImage);
  }

  void showDialogError(context, String titulo, String mensaje) {
    Dialog dialogWithImage = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 310.0,
        width: 300.0,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: Text(
                titulo,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 180,
              width: 280,
              child: Image.asset(
                'assets/taxiApp.png',
                fit: BoxFit.scaleDown,
              ),
            ),
            Center(
              child: Text(
                mensaje,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Aceptar',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => dialogWithImage);
  }

  void cancelarViaje(context) async {
    await Firestore.instance
        .collection('solicitudes_viajes')
        .where('correo', isEqualTo: correo)
        .snapshots()
        .first
        .then((value) {
      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(
            value.documents[0].reference, {'status': 'cancelado_usuario'});
        restablecerVariables(context, 'cancelado');
      });
    });
  }

  void restablecerVariables(context, String status) {
    listPositionDriver = null;
    itemLineas = 0;
    showFloating = true;
    showBtnAbordar = false;
    showBtnPersistentDialog = false;
    cargar = true;
    listLineas = List<String>();
    listDriver = null;
    listTaxi = null;
    list = null;
    distancia = 0.0;
    dis = null;
    latDriver = null;
    lonDriver = null;
    ubicationDriver = null;
    chofer = null;
    distanciaChofer = '';
    tiempoChofer = '';
    BtnCancelViaje = true;
    calificacionDriver = 0.0;
    //_markers.removeWhere((m) => m.markerId.toString() == 'chofer');

    Navigator.of(context).pop();
    Navigator.of(context).pop();

    if (status == 'finalizado') {
      _markers.clear();
      destination = null;
      _polyLines.clear();
      polylineCoordinates.clear();
      destinationController.clear();
      //controller2.closed;
    } else {
      persistentBottomSheetDatosViaje(context, tiempo, distanciaViaje);
    }
    sizeSlider = 0;
    sizeSliderOpen = 0;
    notifyListeners();
  }

  void getCalificacionUser(context) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('calificaciones_usuarios')
        .where('email', isEqualTo: Provider.of<Usuario>(context).correo)
        .getDocuments();
    if (querySnapshot.documents.length != 0) {
      final datos = querySnapshot.documents[0].data['calificacion'];
      calificacion = (datos[0] / datos[1]).toStringAsFixed(1);
    } else {
      calificacion = '';
    }
  }

  get distanciaChofer => _distanciaChofer;
  set distanciaChofer(value) {
    _distanciaChofer = value;
  }

  get tiempoChofer => _tiempoChofer;
  set tiempoChofer(value) {
    _tiempoChofer = value;
  }

  get mensajeTime => _mensajeTime;

  set mensajeTime(value) {
    _mensajeTime = value;
  }

  void showAlertCalificacion(context) {
    Navigator.of(context).pop();
    Dialog dialogWithImage = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 300.0,
        width: 300.0,
        child: Column(
          children: <Widget>[
            Container(
              height: 140,
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[500],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "\$ 89.00",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Paga al Tak-si",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 7,
            ),
            Text(
              "Califica al chofer",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 7,
            ),
            RatingBar(
                initialRating: 3,
                itemCount: 5,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return Icon(
                        Icons.sentiment_very_dissatisfied,
                        color: Colors.red,
                      );
                    case 1:
                      return Icon(
                        Icons.sentiment_dissatisfied,
                        color: Colors.redAccent,
                      );
                    case 2:
                      return Icon(
                        Icons.sentiment_neutral,
                        color: Colors.amber,
                      );
                    case 3:
                      return Icon(
                        Icons.sentiment_satisfied,
                        color: Colors.lightGreen,
                      );
                    case 4:
                      return Icon(
                        Icons.sentiment_very_satisfied,
                        color: Colors.green,
                      );
                  }
                },
                onRatingUpdate: (rating) {
                  calificacionDriver = rating;
                  print(calificacionDriver);
                }),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  color: Colors.red,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Ahora no',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.of(context).pop();
                    showAlertLoader(context, 'Enviando su calificacion');
                    updateCalificacionDriver(calificacionDriver, context);
                  },
                  child: Text(
                    'Enviar',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => dialogWithImage);
  }

  void updateCalificacionDriver(double calificacionDriver, context) async {
    var numeroViajes = (listDriver[0].data['viajes'] + 1);
    String calificacionfinal =
        ((double.parse(listDriver[0].data['calificacion']) +
                    calificacionDriver) /
                numeroViajes)
            .toStringAsFixed(1);
    print(calificacionfinal);

    await Firestore.instance
        .collection('choferes')
        .where('identificador', isEqualTo: chofer)
        .snapshots()
        .first
        .then((value) {
      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(value.documents[0].reference,
            {'calificacion': calificacionfinal, 'viajes': numeroViajes});
        restablecerVariables(context, 'finalizado');
        getUserLocation(context);
      });
    });
  }

  void showAlertCodigoViaje(context) {
    Dialog alertCodigo = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 300,
        width: 300,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
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
                "Cuando tengas un cupón de descuento recuerda usarlo en los próximos 15 dias, de lo contrario el cupón perderá validez",
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
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  //print('precionado');
                  //showAlertCodigoViaje(context);
                },
              )
            ],
          ),
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => alertCodigo);
  }
}

//loader
showAlertLoader(BuildContext context, String texto) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SpinKitFadingCircle(
                        color: Colors.black,
                        size: 55.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Text(
                      texto,
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
