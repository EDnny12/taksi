import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:taksi/providers/estilos.dart';

class Preguntas_frecuentes extends StatefulWidget {
  @override
  _Preguntas_frecuentesState createState() => _Preguntas_frecuentesState();
}

class _Preguntas_frecuentesState extends State<Preguntas_frecuentes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Estilos().estilo(context, 'Preguntas frecuentes'),
        backgroundColor: Estilos().background(context),
        iconTheme: Estilos().colorIcon(context),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              ExpandablePanel(
                header: Text(
                  '¿Que puedo hacer si olvido un objeto en el Tak-si?',
                  style: TextStyle(fontSize: 20),
                ),
                expanded: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    'Dentro de la sección mis viajes podras consultar el número de telefono del chofer que te brindo '
                        'el ultimo servicio y de esta forma poder contactarlo',
                    softWrap: true,
                    style: TextStyle(fontSize: 17, color: Colors.black54,), textAlign: TextAlign.justify,
                  ),
                ),
                tapHeaderToExpand: true,
                hasIcon: true,
              ),
              SizedBox(height: 10,),
              ExpandablePanel(
                header: Text(
                  '¿Cómo puedo contactar a Tak-si?',
                  style: TextStyle(fontSize: 20),
                ),
                expanded: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    'Por medio de la pagina de Facebook iSoft con gusto aclararemos todas tus dudas o al correo teamisoft@gmail.com',
                    softWrap: true,
                    style: TextStyle(fontSize: 17, color: Colors.black54,), textAlign: TextAlign.justify,
                  ),
                ),
                tapHeaderToExpand: true,
                hasIcon: true,
              ),
              SizedBox(height: 10,),
              ExpandablePanel(
                header: Text(
                  '¿Es seguro Tak-si?',
                  style: TextStyle(fontSize: 20),
                ),
                expanded: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    'Tu seguridad es nuestra prioridad cada viaje que realices con nosotros esta geolocalizado y vinculado a un vehiculo, '
                        'conductor y matricula; y puedes compartir esta informacion con tus amigos y familiares, nuestros conductores disponen de '
                        'todas las licencias y seguros necesarios',
                    softWrap: true,
                    style: TextStyle(fontSize: 17, color: Colors.black54,), textAlign: TextAlign.justify,
                  ),
                ),
                tapHeaderToExpand: true,
                hasIcon: true,
              ),
              SizedBox(height: 10,),
              ExpandablePanel(
                header: Text(
                  'Cómo puedo compartir informacion de mi viaje?',
                  style: TextStyle(fontSize: 20),
                ),
                expanded: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    'mensaje',
                    softWrap: true,
                    style: TextStyle(fontSize: 17, color: Colors.black54,), textAlign: TextAlign.justify,
                  ),
                ),
                tapHeaderToExpand: true,
                hasIcon: true,
              ),
              SizedBox(height: 10,),
              ExpandablePanel(
                header: Text(
                  'La aplicación no me ubica correctamente ¿que puedo hacer?',
                  style: TextStyle(fontSize: 20),
                ),
                expanded: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    'Varifica que la aplicación cuente con los permisos de ubicación y tu ubicacion este en alta precicion',
                    softWrap: true,
                    style: TextStyle(fontSize: 17, color: Colors.black54,), textAlign: TextAlign.justify,
                  ),
                ),
                tapHeaderToExpand: true,
                hasIcon: true,
              ),
              SizedBox(height: 10,),
              ExpandablePanel(
                header: Text(
                  '¿Como cancelo un viaje?',
                  style: TextStyle(fontSize: 20),
                ),
                expanded: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    'Puedes cancelar tu viaje unicamente cuando el conductor aun no ha llegado al punto de partida precionando el boton de cancelar,'
                        'cabe mencionar que el conductor tambien puede cancelar el viaje, en caso de una algun incidente',
                    softWrap: true,
                    style: TextStyle(fontSize: 17, color: Colors.black54,), textAlign: TextAlign.justify,
                  ),
                ),
                tapHeaderToExpand: true,
                hasIcon: true,
              ),
              SizedBox(height: 10,),
              ExpandablePanel(
                header: Text(
                  '¿Cómo puedo reportar a un conductor?',
                  style: TextStyle(fontSize: 20),
                ),
                expanded: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    'Dentro de la aplicación en la seccion de ayuda>Reportar un problema puedes informarnos del reporte que deseas realizar. El equipo'
                        ' de iSoft tomara las medidas necesarias para que tal incidencia no vuelva a ocurrir',
                    softWrap: true,
                    style: TextStyle(fontSize: 17, color: Colors.black54,), textAlign: TextAlign.justify,
                  ),
                ),
                tapHeaderToExpand: true,
                hasIcon: true,
              ),
              SizedBox(height: 10,),
              ExpandablePanel(
                header: Text(
                  '¿Cómo se calcula el precio del viaje?',
                  style: TextStyle(fontSize: 20),
                ),
                expanded: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    'mensaje',
                    softWrap: true,
                    style: TextStyle(fontSize: 17, color: Colors.black54,), textAlign: TextAlign.justify,
                  ),
                ),
                tapHeaderToExpand: true,
                hasIcon: true,
              ),
              SizedBox(height: 10,),
              ExpandablePanel(
                header: Text(
                  '¿Cómo puedo recibir promociones?',
                  style: TextStyle(fontSize: 20),
                ),
                expanded: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    'Mantente al pendiente de la pagina oficial de tak-si en Facebook ya que los codigos de descuentos seran publicados por ese medio',
                    softWrap: true,
                    style: TextStyle(fontSize: 17, color: Colors.black54,), textAlign: TextAlign.justify,
                  ),
                ),
                tapHeaderToExpand: true,
                hasIcon: true,
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      )),
    );
  }
}
