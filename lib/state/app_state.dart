import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:taksi/dialogs/dialogCancelacionViaje.dart';
import 'package:taksi/dialogs/dialogCodigo.dart';
import 'package:taksi/dialogs/dialogError.dart';
import 'package:taksi/dialogs/dialogSolicitar.dart';
import 'package:taksi/dialogs/exitoso.dart';
import 'package:taksi/dialogs/loader.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taksi/dialogs/showPhoto.dart';
import 'package:taksi/providers/estilos.dart';
import 'package:taksi/providers/usuario.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taksi/requests/google_maps_requests.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:taksi/widgets/tutorial.dart';
import 'package:url_launcher/url_launcher.dart';

class AppState with ChangeNotifier {
  Timer timer;
  String distanciaViaje = '',
      tiempo = '',
      status = '',
      _distanciaChofer = '',
      _tiempoChofer = '',
      _mensajeTime = '',
      calificacion,
      costo = '', //0
      _costoDescuento = '',
      tipoViaje = 'normal',
      costoDes,
      statusRecuperado = '',
      _msgUsuario2 = '';
  int listPositionDriver, itemLineas = 0, descuentoCupon;
  bool showFloating = true,
      showBtnRestablecer = true,
      showBtnPersistentDialog = false,
      cargar = true,
      BtnCancelViaje = true,
      ciudadRegistrada = false,
      descuentoAplicado = false,
      viajeForaneo = false;
  List<String> listLineas = List<String>();
  var listDriver, listTaxi, list;
  double distancia = 0.0,
      dis,
      latDriver,
      lonDriver,
      calificacionDriver = 5.0,
      sizeSlider = 0,
      sizeSliderOpen = 310;
  static LatLng _initialPosition, destination, ubicationDriver;
  LatLng _lastPosition = _initialPosition, position;
  bool locationServiceActive = true;
  String ciudadUsuario, codigo_postal, codigo_postal2, chofer, correo;
  BitmapDescriptor pinLocationIcon, markerDriver, markerPublicidad;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  GoogleMapController _mapController;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  String get msgUsuario => _msgUsuario2;
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
  final PermissionHandler _permissionHandler = PermissionHandler();

  final controllerFab = FabCircularMenuController();
  SharedPreferences prefs;
  File markerImageFile;
  Uint8List markerImageBytes;
  Metodos metodos = Metodos();
  Geolocator geolocator = Geolocator();
  PersistentBottomSheetController controller, controller2;

  // firebase
  QuerySnapshot datosCiudad;
  final databaseReference = Firestore.instance;
  StreamSubscription<QuerySnapshot> streamSub, streamSub2;

  BuildContext context1;
  var a;

  AppState(context, sa) {
    this.context1 = context;
    this.a = sa;
    setCustomMapPin();
    Firestore.instance.settings(persistenceEnabled: false);
    getUserCurrentLocation(context);
    _loadingInitialPosition(context);
  }

  Future<void> verificarTutorial(context) async {
    prefs = await SharedPreferences.getInstance();

    String tutorial = prefs.getString('tutorial');
    if (tutorial == null) {
      print('tutorial no visto');
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => Tutorial(Provider.of<Usuario>(context).nombre)));
      prefs.setString('tutorial', 'true');
    } else {
      print('tutorial visto');
    }
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2), 'assets/marker.png');
    markerDriver = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: 2,
        ),
        'assets/marker_taxi.png'); //aqui va el carro
  }

  getUserCurrentLocation(context) {
    geolocator
        .getPositionStream(LocationOptions(
            accuracy: LocationAccuracy.high, timeInterval: 2000))
        .listen((posi) {
      position = LatLng(posi.latitude, posi.longitude);
      getNameUbicationUser(position);
      if (_initialPosition == null) {
        getUserLocation(context);
      }

      if (ciudadRegistrada) {
        if (listLineas.isEmpty) {
          getLineasTaxis();
        }
      }
    });
  }

  Future<void> getNameUbicationUser(LatLng position) async {
    List<Placemark> placemarkUser = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude)
        .catchError((error) {
      print('error al obtener la ubicacion del usuario');
    });

    locationController.text = placemarkUser[0].thoroughfare +
        "-" +
        placemarkUser[0].name +
        " " +
        placemarkUser[0].subLocality +
        ' ' +
        placemarkUser[0].locality;
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
      Provider.of<Usuario>(context).ciudad = ciudadUsuario;
      Provider.of<Usuario>(context).estado = placemark[0].administrativeArea;
      getCalificacionUser(context);
      checkStatusViajesUser(context, ciudadUsuario);
      /* verificar si la ciudad esta registrada*/
      getCiudadAfiliada().then((value) {
        if (value.documents.isEmpty) {
          ciudadRegistrada = false;
        } else {
          ciudadRegistrada = true;
          datosCiudad = value;
          getLineasTaxis();
        }
      });
    }
    //locationController.text = placemark[0].thoroughfare + "-" + placemark[0].name + "," + placemark[0].subLocality;
    notifyListeners();
  }

  void checkStatusViajesUser(context, String ciudadUsuario) async {
    await databaseReference
        .collection('solicitudes_viajes')
        .where('correo', isEqualTo: Provider.of<Usuario>(context).correo)
        .getDocuments()
        .then((value) {
      if (value.documents.isNotEmpty) {
        if (value.documents[0]['status'] == 'finalizado' ||
            value.documents[0]['status'] == 'cancelado_usuario' ||
            value.documents[0]['status'] == 'cancelado_chofer') {
          databaseReference.runTransaction((transaction) async {
            await transaction.delete(value.documents[0].reference);
          });
        } else {
          tipoViaje = 'recuperado';
          statusRecuperado = value.documents[0]['status'];
          //el usuario esta en un viaje
          chofer = value.documents[0]['identificador'];
          _initialPosition = LatLng(
              double.parse(value.documents[0]['origen'].split(' ')[0]),
              double.parse(value.documents[0]['origen'].split(' ')[1]));
          destination = LatLng(
              double.parse(value.documents[0]['destino'].split(' ')[0]),
              double.parse(value.documents[0]['destino'].split(' ')[1]));
          addMarker(destination, "destino", '', null);
          setPolynes(destination, context);
          showDialogRecuperarViaje(context, 'Viaje en curso', 'Usted se encuentra en un viaje', 'inicio');
          //mover la camara
          //updateLocationCamara(destination);
          notifyListeners();
        }
      }
    });
  }

  void getDestinationLocation(context) async {
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: "AIzaSyCrT1IGaVcQHRkf3ONb2I-LVvs-vfdt5Ug",
      mode: Mode.overlay,
      language: "es",
      //es-4197yuy7
      location: Location(_initialPosition.latitude, _initialPosition.longitude),
      radius: 5000,
      /*components: [
          Component(Component.administrativeArea, "CHIS"), //"MX" MX-CHP
        ]*/
    );
    if (p != null) {
      Loader().ShowCargando(context, 'Calculando la mejor ruta');
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
          " " +
          placemark[0].subLocality +
          ' ' +
          placemark[0].locality;
      destination = LatLng(lat, lng);
      setPolynes(destination, context);
      addMarker(destination, "destino", '', null);
      //mover la camara
      mostraCamaraDosMarkers(destination);
      //updateLocationCamara(destination);
      notifyListeners();
    }
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  //agregar destino presionando en el mapa
  void getDestinationLongPress(LatLng coordenadas, context) async {
    if (!showBtnPersistentDialog) {
      Loader().ShowCargando(context, 'Calculando la mejor ruta');
      List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
          coordenadas.latitude, coordenadas.longitude);

      destinationController.text = placemark[0].thoroughfare +
          "-" +
          placemark[0].name +
          " " +
          placemark[0].subLocality +
          ' ' +
          placemark[0].locality;

      if (placemark[0].locality != ciudadUsuario) {
        print('viaje foraneo ciudad: ' + placemark[0].locality.toString());
        viajeForaneo = true;
      }

      destination = LatLng(coordenadas.latitude, coordenadas.longitude);

      print(coordenadas);
      setPolynes(destination, context);
      addMarker(destination, "destino", '', null);
      //mover la camara
      mostraCamaraDosMarkers(coordenadas);
      notifyListeners();
    } else {
      showSnackBar('El destino ya ha sido seleccionado');
    }
  }

  void updateLocationCamara(LatLng position) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 16.0)),
    );
  }

  mostraCamaraDosMarkers(LatLng segundoMarker) async {
    List<LatLng> datos = List<LatLng>();
    datos.add(_initialPosition);
    datos.add(segundoMarker);
    Future.delayed(
        Duration(milliseconds: 500),
        () => mapController.animateCamera(CameraUpdate.newLatLngBounds(
            metodos.boundsFromLatLngList(datos), 55)));
    notifyListeners();
  }

  //Agregar un marcador en el mapa
  void addMarker(
      LatLng location, String marker, String empresa, double rotacion) {
    if (marker == 'restablecer') {
      _markers.removeWhere((m) => m.markerId.value == 'chofer');
    } else if (marker == 'destino') {
      _markers.removeWhere((m) => m.markerId.toString() == 'Destino');
      _markers.add(Marker(
          markerId: MarkerId("Destino"),
          position: location,
          /*draggable: true,
          onDragEnd: ((value) {
            print(value.latitude);
            print(value.longitude);
          }),*/
          infoWindow: InfoWindow(title: marker, snippet: "Destino"),
          icon: pinLocationIcon));
    } else if (marker == 'publicidad') {
      _markers.add(Marker(
          markerId: MarkerId(empresa),
          position: location,
          infoWindow: InfoWindow(title: empresa, snippet: empresa),
          icon: markerPublicidad));
    } else {
      _markers.removeWhere((m) => m.markerId.toString() == 'chofer');
      _markers.add(Marker(
          markerId: MarkerId("chofer"),
          position: location,
          rotation: rotacion,
          infoWindow: InfoWindow(title: marker, snippet: "Mi Tak-si"),
          icon: markerDriver));
    }

    notifyListeners();
  }

  void setPolynes(LatLng destino, context) async {
    _polyLines.clear();
    polylineCoordinates.clear();

    List<PointLatLng> result;

    try {
      result = (await polylinePoints.getRouteBetweenCoordinates(
          "AIzaSyCrT1IGaVcQHRkf3ONb2I-LVvs-vfdt5Ug",
          _initialPosition.latitude,
          _initialPosition.longitude,
          destino.latitude,
          destino.longitude));

      if (result.isNotEmpty) {
        result.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });

        Polyline polyline = Polyline(
            polylineId: PolylineId("poly"),
            color: Color.fromARGB(255, 40, 122, 198),
            width: 5,
            points: polylineCoordinates);

        _polyLines.add(polyline);

        if (!ciudadRegistrada) {
          Navigator.of(context).pop();
          dialogSolicitar(ciudadUsuario, scaffoldKey).Dialog_solicitar(context);
        } else {
          //obtener distancia y tiempo
          metodos.getTime(_initialPosition, destination).then((value) async {
            if (value != null) {
              print('value + ' + value);
              distanciaViaje = value.split('-')[0];
              print('poli ' + distanciaViaje);
              tiempo = value.split('-')[1];
              calculatePrecioViaje(context, datosCiudad, distanciaViaje);

              if (tipoViaje != 'recuperado') {
                Navigator.of(context).pop();
                persistentBottomSheetDatosViaje(context, tiempo, distanciaViaje);
                await Future.delayed(Duration(seconds: 1));
                showAnimationCar(polylineCoordinates);
              }
              //persistentBottomSheetDatosViaje(context, tiempo, distanciaViaje);
              //await Future.delayed(Duration(seconds: 1));
              //showAnimationCar(polylineCoordinates);
            }
          });
        }
      } else {
        //error al trazar la linea
        Navigator.of(context).pop();
        dialogError().Dialog_Error(context, 'Ocurrio un error',
            'Ocurrio un error al obtener la mejor ruta', 'menu');
      }
    } catch (e) {
      print('error en el try catch');
      Navigator.of(context).pop();
      dialogError().Dialog_Error(context, 'Ocurrio un error',
          'Ocurrio un error al obtener la mejor ruta', 'menu');
    }
    notifyListeners();
  }

  void showAnimationCar(List<LatLng> polylineCoordinates) async {
    LatLng ubicationAnimation;
    for (var i = 0; i < polylineCoordinates.length; i++) {
      ubicationAnimation = LatLng(
          polylineCoordinates[i].latitude, polylineCoordinates[i].longitude);
      addMarker(ubicationAnimation, 'chofer', '', null);
      notifyListeners();
      await Future.delayed(Duration(milliseconds: 15));
      if (i == polylineCoordinates.length - 1) {
        addMarker(destination, 'restablecer', '', null);
        notifyListeners();
      }
    }
  }

  //movimiento de la camara
  void onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
    notifyListeners();
  }

  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    changeMapMode(a);
    a = false;
    notifyListeners();
  }

  changeMapMode(final as) {
    if (a == Brightness.dark || as == Brightness.dark) {
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
  void _loadingInitialPosition(context) async {
    GeolocationStatus geolocationStatus = await Geolocator()
        .checkGeolocationPermissionStatus(); //ejemplo para checar si los permisos estan habilitados
    bool isLocationEnabled = await Geolocator().isLocationServiceEnabled();
    if (geolocationStatus == GeolocationStatus.denied) {
      print('Permiso de ubicación no otorgado');
      locationServiceActive = false;
      _msgUsuario2 = 'Permiso de ubicación no otorgado';
      _loadingInitialPosition(context);
    } else if (isLocationEnabled == false) {
      print('Gps desactivado');
      locationServiceActive = false;
      _msgUsuario2 = 'Por favor, active su GPS';
      _loadingInitialPosition(context);
    } else {
      verificarTutorial(context);
      getUserCurrentLocation(context);
      locationServiceActive = true;
      addMarkersPublicidad();
      await Future.delayed(Duration(seconds: 8)).then((v) {
        //no carga porque no tiene internet
        if (_initialPosition == null) {
          locationServiceActive = false;
          _msgUsuario2 = 'Verifique su conexión a internet';
        }
      });
    }
    notifyListeners();
  }

  Future<bool> _requestPermission(PermissionGroup permission) async {
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  Future<bool> requestUbicationPermission({Function onPermissionDenied}) async {
    var granted = await _requestPermission(PermissionGroup.location);
    if (!granted) {
      onPermissionDenied();
    }
    return granted;
  }

  persistentBottomSheetDatosViaje(context2, String tiempo, String distancia) {
    showBtnRestablecer = false;
    controller2 = scaffoldKey.currentState.showBottomSheet((context) {
      return Container(
        margin: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
        height: 150,
        decoration: BoxDecoration(
            //color: Colors.white,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black87
                : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                  blurRadius: 10,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white12
                      : Colors.grey,
                  //color: Colors.grey,
                  spreadRadius: 3)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        tiempo,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '(' + distancia + ')',
                        style: TextStyle(fontSize: 20),
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
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54,
                  ),
                ),
                Text(
                  'Método de pago',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 1.5,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54,
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
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.black54,
                        //color: Colors.black54,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '\$ $costo.00',
                          style: TextStyle(
                              fontSize: 20,
                              color: Provider.of<AppState>(context)
                                          ._costoDescuento ==
                                      ''
                                  ? Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black
                                  : Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white70
                                      : Colors.black54,
                              decoration: Provider.of<AppState>(context)
                                          ._costoDescuento ==
                                      ''
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          Provider.of<AppState>(context)._costoDescuento,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                )),
                Expanded(
                    child: FlatButton(
                  child: new Text(
                    'Código',
                    style: TextStyle(fontSize: 15),
                  ),
                  onPressed: () {
                    if (!ciudadRegistrada) {
                      dialogSolicitar(ciudadUsuario, scaffoldKey)
                          .Dialog_solicitar(context2);
                    } else {
                      //showAlertCodigoViaje(context);
                      dialogCodigo().showAlertCodigoViaje(context);
                    }
                  },
                )),
              ],
            ),
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
                  //Loader().ShowCargando(context2, 'Obteniendo los sitios de taxis de su ciudad');
                  // si el error persiste se puede llamar el metodo y hacer el then
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
    showModalBottomSheet(
        backgroundColor: Theme.of(context2).brightness == Brightness.dark
            ? Colors.black87
            : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context2,
        builder: (context) {
          return Container(
              height: 220,
              child: Stack(
                children: <Widget>[
                  Align(
                      alignment: Alignment.topCenter,
                      child: Estilos().estilo(context, 'Seleccione un sitio')),
                  CarouselWithIndicator(context2, listLineas),
                ],
              ));
        });
  }

  void onPressedBottomSheetLineas(context, String sitio) {
    //print(sitio);
    getLocationDrivers(
        Provider.of<Usuario>(context).telefono,
        sitio,
        // listLineas[itemLineas],
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
        context);
    Navigator.of(context).pop();
    Loader().ShowCargando(context, 'Bucando el Tak-si mas cercano!');
  }

  void calculatePrecioViaje(context, QuerySnapshot ciudad, String distancia) {
    print('costo_kilometro ' +
        ciudad.documents.first['costo_kilometro'].toString());
    print('tarifa base ' + ciudad.documents.first['tarifa_base'].toString());
    print('tarifa_kilometros ' +
        ciudad.documents.first['tarifa_kilometros'].toString());
    print('distancia' + distancia);

    if (distancia.isNotEmpty) {
      if (distancia.split(' ')[1] == 'm') {
        costo = ciudad.documents.first['tarifa_base'].toString();
        print('costo tarifa');
      } else {
        if ((double.parse(distancia.split(' ')[0].replaceAll(',', '')) <=
            (ciudad.documents.first['tarifa_kilometros']))) {
          costo = ciudad.documents.first['tarifa_base'].toString();
          print('costo tarifa km');
        } else {
          costo =
              (((double.parse(distancia.split(' ')[0].replaceAll(',', ''))) -
                          (ciudad.documents.first['tarifa_kilometros'])) *
                      ciudad.documents.first['costo_kilometro'])
                  .toString();
          if (costo.contains('.')) {
            costo = (int.parse(costo.split('.')[0]) +
                    ciudad.documents.first['tarifa_base'])
                .toString();
          } else {
            costo = (int.parse(costo) + ciudad.documents.first['tarifa_base'])
                .toString();
          }
          print(costo);
        }
      }
      if (descuentoAplicado) {
        print('el viaje tiene descuento');
        costoDes = (int.parse(costo) - descuentoCupon).toString();
        _costoDescuento = '\$ ' + costoDes + '.00';
      }
    } else {
      dialogError().Dialog_Error(context, 'Ocurrio un error',
          'Ocurrio un error por favor intentelo de nuevo', 'menu');
    }
  }

  showSnackBar(String texto) {
    final snackBar = SnackBar(
      content: Text(texto),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  getLineasTaxis() async {
    databaseReference
        .collection("lineas")
        .where("ciudad", isEqualTo: ciudadUsuario)
        .getDocuments()
        .then((value) {
      if (cargar) {
        listLineas.add('Todos los sitios');
        value.documents.forEach((value2) {
          listLineas.add(value2['nombre']);
          cargar = false;
        });
      }
      return listLineas;
    }).catchError((error) {
      getLineasTaxis();
    });
  }

  Future<QuerySnapshot> getCiudadAfiliada() async {
    QuerySnapshot qn = await databaseReference
        .collection("ciudades_afiliadas")
        .where("ciudad", isEqualTo: ciudadUsuario)
        .getDocuments();
    return qn;
  }

  //(String sitio, String email)
  void getLocationDrivers(
      String telefono,
      String sitio,
      String origen,
      String destino,
      String ciudad,
      String nombreUsuario,
      String email,
      String foto,
      context) async {
    if (sitio == 'Todos los sitios') {
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

      insertSolicitudViaje(telefono, sitio, origen, destino, ciudad,
          nombreUsuario, email, chofer, foto, context);
    } else {
      itemLineas = 0;
      Navigator.of(context).pop(); // no hay taxis disponibles
      if (sitio == 'Todos los sitios') {
        //showDialogError(context, 'Lo sentimos!', 'No se encontro taxi disponible, intentelo de nuevo', 'final');
        dialogError().Dialog_Error(context, 'Lo sentimos!',
            'No se encontro taxi disponible, intentelo de nuevo', 'state');
      } else {
        //showDialogError(context, 'Lo sentimos!', 'No se encontro taxi disponible, seleccione otro sitio de taxi', 'final');
        dialogError().Dialog_Error(
            context,
            'Lo sentimos!',
            'No se encontro taxi disponible, seleccione otro sitio de taxi',
            'state');
      }
    }
  }

  Future insertSolicitudViaje(
      String telefono,
      String nombreLinea,
      String origen,
      String destino,
      String ciudad,
      String nombreUsuario,
      String correo,
      String chofer,
      String foto,
      context) async {
    await databaseReference
        .collection('solicitudes_viajes')
        .document()
        .setData({
      'telefono': telefono,
      'nombreLinea': nombreLinea,
      'origen': origen,
      'destino': destino,
      'ciudad': ciudad,
      'nombreUsuario': nombreUsuario,
      'correo': correo,
      'identificador': chofer,
      'foto': foto,
      'status': 'false',
      'calificacion': calificacion,
      'precio': _costoDescuento == '' ? costo : costoDes,
      'tipoPago': _costoDescuento == '' ? 'Efectivo' : 'Codigo'
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
      if (status == 'true') {
        print('taxista acepto');
        //taxiAcept = true;
        if (timer != null) {
          timer.cancel();
        }
        showBtnRestablecer = true;
        notifyListeners();
        getDataTaxiChofer(context);
      } else if (status == 'cancelado') {
        print('taxista rechazo');
        timer.cancel();
        list.removeAt(listPositionDriver);
        if (list.length > 0) {
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
        } else {
          Navigator.of(context).pop();
          dialogError().Dialog_Error(
              context,
              'Lo sentimos!',
              'No se encontraron taxis disponibles por favor, intentelo de nuevo',
              'busqueda');
          cancelViaje();
          deleteRegistroViaje();
        }
      }
      if (status == 'cancelado_usuario') {
        cancelViaje();
      } else if (status == 'cancelado_chofer') {
        print('taxista cancelo');
        dialogCancelacionViaje().CancelacionViaje(
            context,
            'Viaje cancelado',
            'Lo sentimos, el taxista ha cancelado el viaje, intentelo de nuevo por favor',
            'chofer');
      } else if (status == 'iniciado') {
        // inicio el viaje
        BtnCancelViaje = false;
        if (statusRecuperado == 'iniciado') {
          showBtnRestablecer = true;
          getDataTaxiChofer(context);
        }
        //mensajeTime = 'Su destino esta a: ';
        notifyListeners();
        print('viaje iniciado');
      } else if (status == 'finalizado') {
        // inicio el viaje
        showAlertCalificacion(context);
        cancelViaje();
        print('viaje finalizado');
      } else if (status == 'false') {
        iniciarTimer();
        print('taxista no acepto');
      }
    });
  }

  void iniciarTimer() async {
    timer = Timer(Duration(seconds: 12), () {
      print('timer terminado');
      Firestore.instance
          .collection('solicitudes_viajes')
          .where('correo', isEqualTo: correo)
          .snapshots()
          .first
          .then((value) {
        Firestore.instance.runTransaction((update) async {
          await update
              .update(value.documents.first.reference, {'status': 'cancelado'});
        });
      });
    });
  }

  void deleteRegistroViaje() {
    Firestore.instance
        .collection('solicitudes_viajes')
        .where('correo', isEqualTo: correo)
        .snapshots()
        .first
        .then((delete) {
      Firestore.instance.runTransaction((operacion) async {
        await operacion.delete(delete.documents.first.reference);
      });
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
        sliderPanelDatosChofer(context);
        Navigator.pop(context); //debe de ir en el normal
      } else {
        print('lista vacia');
      }
    }
  }

  sliderPanelDatosChofer(context) {
    //controller2.closed;
    showFloating = false;
    sizeSliderOpen = 440;
    sizeSlider = 65;
    showBtnPersistentDialog = true;
    controller = scaffoldKey.currentState.showBottomSheet((context) {
      return const SizedBox();
    });
  }

  //widget cuando esta cerrado
  Widget floatingCollapsed(context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
          boxShadow: [BoxShadow(color: Colors.transparent, spreadRadius: 5)]),
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
                child: FlatButton.icon(
              onPressed: () {},
              label: Text(''),
              //icon: Icons.expand_less,
              icon: Icon(Icons.expand_less),
              //child: Icons.expand_less,
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Text(
                      showFloating ? '' : listTaxi[0].data["placa"],
                      style: TextStyle(fontSize: 21),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        Provider.of<AppState>(context).mensajeTime,
                        style: TextStyle(color: Colors.blueGrey, fontSize: 14),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            Provider.of<AppState>(context).tiempoChofer,
                            style: TextStyle(fontSize: 19),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '(' +
                                Provider.of<AppState>(context).distanciaChofer +
                                ')',
                            style: TextStyle(fontSize: 19),
                          ),
                        ],
                      ),
                    ],
                  ),
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
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black87
              : Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          boxShadow: [
            BoxShadow(
              //blurRadius: 5.0,
              color: Colors.transparent,
              spreadRadius: 5,
            ),
          ]),
      margin: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min, //adaptar al tamaño
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
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
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '(' +
                              Provider.of<AppState>(context).distanciaChofer +
                              ')',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                SizedBox.fromSize(
                  size: Size(40, 40), // button width and height
                  child: ClipOval(
                    child: Material(
                      //color: Colors.blue, // button color
                      child: InkWell(
                        splashColor: Colors.green, // splash color
                        onTap: () {
                          print('compartir viaje');
                          Share.share(
                              'Hola! te estoy compartiendo la información de mi viaje desde Tak-si. Mi ubicación actual es: ' +
                                  locationController.text +
                                  '; Mi destino es: ' +
                                  destinationController.text +
                                  '; Mi chofer es: ' +
                                  listDriver[0].data["nombre"] +
                                  ' ' +
                                  listDriver[0].data["apellidos"] +
                                  ' pertenece al sitio de taxi: ' +
                                  listTaxi[0].data["sitio"] +
                                  '; El número del taxi es: ' +
                                  listTaxi[0].data["numero"] +
                                  ' y la placa es: ' +
                                  listTaxi[0].data["placa"] +
                                  '.          '
                                      '   La información enviada es sumamente '
                                      'sensible usece solamente en caso de ser necesario... Equipo de soporte de Tak-si',
                              subject: 'hola');
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.share), // icon
                            //Text("Call"), // text
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5,),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            height: 1.5,
            //color: Colors.blueGrey,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white30 : Colors.blueGrey,
          ),
          SizedBox(height: 5,),
          Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Dialog_Photo().dialogPhoto(context,
                          showFloating ? '' : listDriver[0].data['foto'], 'internet');
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: showFloating
                          ? null
                          : NetworkImage(listDriver[0].data['foto']),
                      backgroundColor: Colors.transparent,
                    ),
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
              SizedBox(width: 20,),
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
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          showFloating ? '' : listDriver[0].data["apellidos"],
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
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
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5,),
          ConfirmationSlider(
            height: 45,
            icon: Icons.phone,
            text: 'Deslize para llamar',
            onConfirmation: () => confirmed(context),
          ),
          SizedBox(height: 10,),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            height: 1.5,
            //color: Colors.blueGrey,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white30 : Colors.blueGrey,
          ),
          SizedBox(height: 10,),
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
              SizedBox(width: 20,),
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
                        SizedBox(width: 6,),
                        Text(showFloating ? '' : listTaxi[0].data["placa"],
                            style:
                                TextStyle(fontSize: 18)),
                      ],
                    ),
                    SizedBox(height: 5,),
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
                                TextStyle(fontSize: 18)),
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
                                TextStyle(fontSize: 18)),
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
          SizedBox(
            height: 6,
          ),
          Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  child: Text(
                    'Por su seguridad, antes de abordar el vehiculo, compruebe que los datos del conductor y '
                    'vehiculo coincidan con los datos mostrados en la aplicación',
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
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
                            if (descuentoAplicado) {
                              dialogCancelacionViaje().CancelacionViaje(
                                  context,
                                  'Cancelar viaje',
                                  'Al cancelar su viaje, el cupon que ha ingresado se perdera ¿Desea continuar?',
                                  'usuario');
                            } else {
                              dialogCancelacionViaje().CancelacionViaje(
                                  context,
                                  'Cancelar viaje',
                                  'Confirme la cancelación de su viaje',
                                  'usuario');
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15))),
                        ),
                      ),
                    )
                  : const SizedBox(),

              /*Scaffold(
                body: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    FabCircularMenu(
                      controller: controllerFab,
                      options: <Widget> [
                        IconButton(icon: Icon(Icons.widgets), onPressed: () {
                          controllerFab.isOpen = false;
                        }, iconSize: 48.0, color: Colors.white),
                        IconButton(icon: Icon(Icons.widgets), onPressed: () {}, iconSize: 48.0, color: Colors.white),
                        IconButton(icon: Icon(Icons.widgets), onPressed: () {}, iconSize: 48.0, color: Colors.white),
                        IconButton(icon: Icon(Icons.widgets), onPressed: () {}, iconSize: 48.0, color: Colors.white),
                      ],
                      child: Container(
                        color: Colors.indigo[900],
                        child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 0.0, right: 0),
                              child: Text(
                                  'SOS',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 36.0)
                              ),
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),*/
            ],
          ),
        ],
      ),
    );
  }

  confirmed(context) async {
    String numero = listDriver[0].data['telefono'];
    String telephoneUrl = "tel:$numero";
    if (await canLaunch(telephoneUrl)) {
      await launch(telephoneUrl);
    } else {
      throw "Can't phone that number.";
    }
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
      addMarker(ubicationDriver, 'chofer', '', data.documents[0]['rotacion']);

      if (BtnCancelViaje) {
        mostraCamaraDosMarkers(ubicationDriver);
        metodos.getTime(_initialPosition, ubicationDriver).then((value) {
          if (value != null) {
            distanciaChofer = value.split('-')[0];
            tiempoChofer = value.split('-')[1];
            mensajeTime = 'Su Tak-si llega en: ';
            notifyListeners();
          }
        });
      } else {
        updateLocationCamara(ubicationDriver);
        metodos.getTime(ubicationDriver, destination).then((value) {
          if (value != null) {
            distanciaChofer = value.split('-')[0];
            tiempoChofer = value.split('-')[1];
            mensajeTime = 'Su destino esta a: ';
            notifyListeners();
          }
        });
      }
    });
  }

  void showDialogRecuperarViaje(
      context2, String titulo, String mensaje, String status) {
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
                    borderRadius: BorderRadius.circular(20)),
                content: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(titulo, style: TextStyle(fontSize: 20)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Lottie.asset('assets/exitoso.json',
                            width: 160, height: 160),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Text(
                            mensaje,
                            style: TextStyle(fontSize: 17),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        RaisedButton.icon(
                          color: Colors.blue,
                          onPressed: () {
                            if (status == 'inicio') {
                              Navigator.of(context).pop();
                              Loader().ShowCargando(context2, 'Obteniendo los datos de su viaje');
                              getStatusAceptDriver(context2, Provider.of<Usuario>(context).correo);
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          label: Text('Aceptar',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                          icon: Icon(
                            Icons.tag_faces,
                            color: Colors.white,
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
        barrierDismissible: false,
        barrierLabel: '',
        context: context2,
        pageBuilder: (context, animation1, animation2) {});

    /*Dialog dialogWithImage = Dialog(
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
                    if (status == 'inicio') {
                      Navigator.of(context).pop();
                      Loader().ShowCargando(context, 'Obteniendo los datos de su viaje');
                      //showAlertLoader(context, 'Obteniendo los datos de su viaje');
                      getStatusAceptDriver(context, Provider.of<Usuario>(context).correo);
                    } else {
                      Navigator.of(context).pop();
                    }
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
        builder: (BuildContext context) => dialogWithImage);*/
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
    showBtnRestablecer = true;
    showBtnPersistentDialog = false;
    cargar = true;
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
    calificacionDriver = 5.0;
    costo = '';
    costoDescuento = '';
    descuentoAplicado = false;
    descuentoCupon = 0;
    statusRecuperado = '';
    tipoViaje = 'normal';
    viajeForaneo = false;

    if (status == 'menu') {
      controller = scaffoldKey.currentState.showBottomSheet((context) {
        return const SizedBox();
      });
      _markers.removeWhere((m) => m.markerId.value == 'Destino');
    } else {
      _markers.removeWhere((m) => m.markerId.value == 'chofer');
      _markers.removeWhere((m) => m.markerId.value == 'Destino');

      if (status == 'cancelado') {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    }

    getUserLocation(context);
    //prubas
    destination = null;
    _polyLines.clear();
    polylineCoordinates.clear();
    destinationController.clear();

    //finaliza

    /*if (status == 'finalizado') {
      _markers.clear();
      destination = null;
      _polyLines.clear();
      polylineCoordinates.clear();
      destinationController.clear();
      //controller2.closed;
    } else {
      persistentBottomSheetDatosViaje(context, tiempo, distanciaViaje);
      addMarker(destination, 'restablecer');
    }*/
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
    Provider.of<Usuario>(context).calificacion = calificacion;
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

  get costoDescuento => _costoDescuento;

  set costoDescuento(value) {
    _costoDescuento = value;
  }

  void showAlertCalificacion(context) {
    if (tipoViaje == 'normal') {
      Navigator.pop(context); //debe de ir en el normal
    }
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
                    descuentoAplicado
                        ? '\$ $costoDescuento.00'
                        : '\$ $costo.00',
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
              initialRating: 5,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                calificacionDriver = rating;
                print('en el rating' + calificacionDriver.toString());
              },
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.of(context).pop();
                    Loader().ShowCargando(context, 'Enviando su calificacion');
                    //showAlertLoader(context, 'Enviando su calificacion');
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
        builder: (BuildContext context) =>
            WillPopScope(onWillPop: () async => false, child: dialogWithImage));
  }

  void updateCalificacionDriver(double calificacionDriver, context) async {
    print(calificacionDriver.toString());
    var numeroViajes = (listDriver[0].data['viajes'] + 1);
    String calificacionfinal =
        ((double.parse(listDriver[0].data['calificacion']) +
                    calificacionDriver) /
                2)
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
        //deleteRegistroViaje();
      });
    }).catchError((value) {
      //updateCalificacionDriver(calificacionDriver, context);
    });
  }

  void verifyCodigo(context, String text) {
    Firestore.instance
        .collection('codigos_descuento')
        .where('codigo', isEqualTo: text)
        .getDocuments()
        .then((value) {
      if (value.documents.isNotEmpty) {
        if (value.documents.first.data['usos'] >= 1) {
          //verificar que el usuario no haya utilizado el codigo
          Firestore.instance
              .collection('usuarios')
              .where('telefono',
                  isEqualTo: Provider.of<Usuario>(context).telefono)
              .where('codigos', arrayContains: text)
              .getDocuments()
              .then((usuario) {
            if (usuario.documents.isEmpty) {
              descuentoCupon = value.documents.first.data['descuento'];
              // no ha utilizado el codigo
              print('el codigo no ha sido utilizado');

              //agragamos el codigo a su arreglo de codigos
              Firestore.instance
                  .collection('usuarios')
                  .where('telefono',
                      isEqualTo: Provider.of<Usuario>(context).telefono)
                  .getDocuments()
                  .then((usuario2) {
                Firestore.instance.runTransaction((add) async {
                  add.update(usuario2.documents[0].reference, {
                    'codigos': FieldValue.arrayUnion([text])
                  });
                });
              });

              //le restamos uno a la variable usos del codigo en bd
              Firestore.instance.runTransaction((transaction) async {
                await transaction.update(value.documents[0].reference,
                    {'usos': (value.documents.first.data['usos'] - 1)});
              });

              //realizamos el calculo del descuento
              Navigator.of(context).pop();
              Dialog_Exitoso().DialogExitoso(context, 'Cupon valido!',
                  'Disfruta de los beneficios de utilizar Tak-si');
              costoDes = (int.parse(costo) - descuentoCupon).toString();
              _costoDescuento = '\$ ' + costoDes + '.00';

              descuentoAplicado = true;
              notifyListeners();
            } else {
              // ya utilizo el codigos
              Navigator.of(context).pop();
              dialogError().Dialog_Error(
                  context,
                  'Verifique su código',
                  ' Lo sentimos! Los codigos de descuento se pueden utilizar una sola vez',
                  'codigo');
            }
          });
        } else {
          Navigator.of(context).pop();
          dialogError().Dialog_Error(
              context,
              'Verifique su código',
              ' Lo sentimos! El código que ha ingresado ya no se encuentra disponible',
              'codigo');
        }
      } else {
        Navigator.of(context).pop();
        dialogError().Dialog_Error(
            context,
            'Verifique su código',
            ' Lo sentimos! El código que ha ingresado no es valido, intentelo de nuevo',
            'codigo');
      }
    });
  }

  void addMarkersPublicidad() {
    List<GeoPoint> ubi;
    Firestore.instance
        .collection('marcadores_publicidad')
        .where('ciudad', isEqualTo: ciudadUsuario)
        .getDocuments()
        .then((value) async {
      if (value.documents.isNotEmpty) {
        for (int i = 0; i < value.documents.length; i++) {
          if (value.documents[i].data['status'] == 'true') {
            markerImageFile = await DefaultCacheManager()
                .getSingleFile(value.documents[i].data['marker']);
            markerImageBytes = await markerImageFile.readAsBytes();
            markerPublicidad = BitmapDescriptor.fromBytes(markerImageBytes);
            ubi = List.from(value.documents[i].data['ubicaciones']);
            for (int o = 0; o < ubi.length; o++) {
              print(value.documents[i].data['empresa']);
              addMarker(LatLng(ubi[o].latitude, ubi[o].longitude), 'publicidad',
                  value.documents[i].data['empresa'], null);
            }
          }
        }
      }
    });
  }

  void notify() {
    notifyListeners();
  }
}

List<String> listLineas2 = List<String>();

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

final List child = map<Widget>(
  listLineas2,
  (index, i) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(children: <Widget>[
          //Image.network(i, fit: BoxFit.cover, width: 1000.0),
          Image.asset(
            "assets/taxiApp.png",
            //height: 250,
            fit: BoxFit.contain, //cover
            width: 1000,
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Color.fromARGB(0, 0, 0, 0)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  listLineas2[index], //'No. $index image'
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  },
).toList();

class CarouselWithIndicator extends StatefulWidget {
  BuildContext contexta;
  CarouselWithIndicator(context, listLineas) {
    listLineas2 = listLineas;
    this.contexta = context;
  }

  @override
  _CarouselWithIndicatorState createState() =>
      _CarouselWithIndicatorState(contexta);
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;
  BuildContext context2;

  _CarouselWithIndicatorState(this.context2);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      InkWell(
        onTap: () {
          Provider.of<AppState>(context2)
              .onPressedBottomSheetLineas(context2, listLineas2[_current]);
        },
        child: CarouselSlider(
          items: child,
          autoPlay: false,
          enlargeCenterPage: true,
          aspectRatio: 2.0,
          onPageChanged: (index) {
            setState(() {
              _current = index;
            });
          },
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: map<Widget>(
          listLineas2,
          (index, url) {
            //(index, url)
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Colors.blue
                      : Theme.of(context2).brightness == Brightness.dark
                          ? Colors.white30
                          : Colors.black54),
            );
          },
        ),
      ),
    ]);
  }
}
