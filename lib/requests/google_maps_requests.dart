import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/distance.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
const apikey = "AIzaSyCrT1IGaVcQHRkf3ONb2I-LVvs-vfdt5Ug";

final GoogleDistanceMatrix distanceMatrix =
    GoogleDistanceMatrix(apiKey: "AIzaSyCrT1IGaVcQHRkf3ONb2I-LVvs-vfdt5Ug");

class GoogleMapsServices {
  Future<String> getRoutesCoordinates(LatLng l1, LatLng l2) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apikey";
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    return values["routes"][0]["overview_polyline"]["points"];
  }
}

class Metodos {

  Future<String> getTime(LatLng origen, LatLng destino) async {
    List<Location> origin = [Location(origen.latitude, origen.longitude)];
    List<Location> destination = [
      Location(destino.latitude, destino.longitude)
    ];

    DistanceResponse distance =
        await distanceMatrix.distanceWithLocation(origin, destination, travelMode: TravelMode.driving);

    try {
      print('response ${distance.status}');

      if (distance.isOkay) {
        print(distance.destinationAddress.length);
        for (var row in distance.results) {
          for (var element in row.elements) {
            //print('distance ${element.distance.text} duration ${element.duration.text}');
            return element.distance.text+ ',' + element.duration.text;
          }
        }
      } else {
        print('ERROR: ${distance.errorMessage}');
      }
    } finally {

    }
  }
}
