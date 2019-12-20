import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttie/fluttie.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:taksi/providers/usuario.dart';
import 'package:taksi/requests/google_maps_requests.dart';

class AppState with ChangeNotifier {
  static LatLng _initialPosition, destination;
  LatLng _lastPosition = _initialPosition;
  bool locationServiceActive = true;
  String ciudadUsuario, codigo_postal, codigo_postal2;
  BitmapDescriptor pinLocationIcon;
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
  GoogleMapsPlaces _places =
      GoogleMapsPlaces(apiKey: "AIzaSyCrT1IGaVcQHRkf3ONb2I-LVvs-vfdt5Ug");
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // firebase
  final databaseReference = Firestore.instance;

  AppState() {
    setCustomMapPin();
    _getUserLocation();
    _loadingInitialPosition();
  }


  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2), 'assets/marker.png');
  }

  //obtener la ubicacion del usuario
  void _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);

    _initialPosition = LatLng(position.latitude, position.longitude);
    locationController.text = placemark[0].name;
    ciudadUsuario = placemark[0].locality; // comitan de dominguez
    codigo_postal2 = placemark[0].administrativeArea; // chiapas
    print("cuidad $codigo_postal");
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
      addMarker(destination, "destino");
      //mover la camara
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(lat, lng), zoom: 17.0)),
      );

      //mover la camara entre dos puntos
      /*mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: LatLng(_initialPosition.latitude,_initialPosition.longitude),
              northeast: LatLng(destination.latitude, destination.longitude)
            ), 32.0)
      );*/
      notifyListeners();
    }
  }

  //agregar destino presionando en el mapa
  void getDestinationLongPress(LatLng coordenadas, context) async {
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(coordenadas.latitude, coordenadas.longitude);
    destinationController.text = placemark[0].thoroughfare +
        "-" +
        placemark[0].name +
        "," +
        placemark[0].subLocality;

    destination = LatLng(coordenadas.latitude, coordenadas.longitude);
    addMarker(destination, "destino");
    //mover la camara
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(coordenadas.latitude, coordenadas.longitude),
          zoom: 17.0)),
    );
    notifyListeners();
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

  //Agregar un marcador en el mapa
  void addMarker(LatLng location, String address) {
    _markers.clear();
    _markers.add(Marker(
        markerId: MarkerId("destino"),
        position: location,
        infoWindow: InfoWindow(title: address, snippet: "go here"),
        icon: pinLocationIcon));
    notifyListeners();
  }

  // crear la ruta
  void createRoute(String encodedPoly) {
    _polyLines.add(Polyline(
        polylineId: PolylineId(_lastPosition.toString()),
        width: 10,
        points: _convertToLatLng(_decodePoly(encodedPoly)),
        color: Colors.black));
    notifyListeners();
  }

  // crear la lista de latitudes y longitudes
  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  //metodo que covierte la repsuesta de la peticion en datos de longitud y latitud
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  // enviar peticion
  void sendRequest(String intendedLocation) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(intendedLocation);
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;
    LatLng destination = LatLng(latitude, longitude);
    addMarker(destination, intendedLocation);
    String route = await _googleMapsServices.getRoutesCoordinates(
        _initialPosition, destination);
    createRoute(route);
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
    await Future.delayed(Duration(seconds: 5)).then((v) {
      if (_initialPosition == null) {
        locationServiceActive = false;
        notifyListeners();
      }
    });
    //}
  }

  void showBottomShettLineas(context) async {
    getCiudadAfiliada().then((ciudad) async {
      if (ciudad == 0) {
        showAlert(context);
      } else {
        showModalBottomSheet(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0))),
            context: context,
            builder: (context) {
              //return Container(
              return StreamBuilder<QuerySnapshot>(
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
                      return ListView(
                        shrinkWrap: true,
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                          return ListTile(
                            leading: Icon(Icons.directions_car),
                            title: Text(document["nombre"]),
                            onTap: () {
                              print('Selecciono ' + document["nombre"]);
                              print('Selecciono ' + " " +  _initialPosition.latitude.toString() + " " + _initialPosition.longitude.toString());
                              print('Selecciono ' + " " +destination.latitude.toString() + " " + destination.longitude.toString());
                              print('Selecciono ' + ciudadUsuario);
                              print('Selecciono ' + Provider.of<Usuario>(context).nombre);
                              print('Selecciono ' + Provider.of<Usuario>(context).correo);
                              Navigator.of(context).pop();
                              },
                          );
                        }).toList(),
                      );
                  }
                },
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
}
