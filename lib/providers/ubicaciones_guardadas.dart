
class Ubicaciones {

  int id;
  String nombre;
  String direccion;
  double latitud;
  double longitud;

  Ubicaciones(this.id, this.nombre, this.direccion, this.latitud, this.longitud);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'id': id,
      'nombre': nombre,
      'direccion': direccion,
      'latitud': latitud,
      'longitud': longitud,
    };
    return map;
  }

  Ubicaciones.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nombre = map['nombre'];
    direccion = map['direccion'];
    latitud = map['latitud'];
    longitud = map['longitud'];
  }


}