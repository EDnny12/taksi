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
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 0.0,
              floating: true,
              pinned: false,
              snap: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text('Preguntas frecuentes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    )),
              ),
            ),
          ];
        },
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ExpansionTile(
                title:
                    Text('¿Que puedo hacer si olvido un objeto en el Tak-si?'),
                leading: Icon(Icons.directions_car),
                backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white12 : Colors.white,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Dentro de la sección mis viajes podras consultar el número de telefono del chofer que te brindo '
                          'el ultimo servicio y de esta forma poder contactarlo',
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              ExpansionTile(
                title: Text('¿Cómo puedo contactar a Tak-si?'),
                leading: Icon(Icons.contact_mail),
                backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white12 : Colors.white,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Por medio de la pagina de Facebook iSoft con gusto aclararemos todas tus dudas o al correo teamisoft@gmail.com',
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              ExpansionTile(
                title: Text('¿Es seguro Tak-si?'),
                leading: Icon(Icons.security),
                backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white12 : Colors.white,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Tu seguridad es nuestra prioridad cada viaje que realices con nosotros esta geolocalizado y vinculado a un vehiculo, '
                          'conductor y matricula; y puedes compartir esta informacion con tus amigos y familiares, nuestros conductores disponen de '
                          'todas las licencias y seguros necesarios',
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              ExpansionTile(
                title: Text('¿Cómo puedo compartir información de mi viaje?'),
                leading: Icon(Icons.share),
                backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white12 : Colors.white,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Tu seguridad es lo mas importante para nosotros, por lo tanto,'
                          ' cuando te encuentras en un viaje puedes compartir los detalles de tu viaje con tus contactos, '
                          'o redes sociales, en tu mensaje se envia tu ubicación en ese momento, el lugar hacia el '
                          'cual te diriges, los datos del taxi y conductor.  Usa esa función responsablemente ya que '
                          'es información sumamente sensible.',
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              ExpansionTile(
                title: Text(
                    'La aplicación no me ubica correctamente ¿que puedo hacer?'),
                leading: Icon(Icons.location_off),
                backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white12 : Colors.white,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Verifica que la aplicación cuente con los permisos de ubicación y tu ubicacion este en alta precición',
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              ExpansionTile(
                title: Text('¿Como cancelo un viaje?'),
                leading: Icon(Icons.cancel),
                backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white12 : Colors.white,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Puedes cancelar tu viaje unicamente cuando el conductor aun no ha llegado al punto de partida precionando el boton de cancelar,'
                          'cabe mencionar que el conductor tambien puede cancelar el viaje, en caso de una algun incidente',
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              ExpansionTile(
                title: Text('¿Cómo puedo reportar a un conductor?'),
                leading: Icon(Icons.report_problem),
                backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white12 : Colors.white,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Dentro de la aplicación en la seccion de ayuda>Reportar un problema puedes informarnos del reporte que deseas realizar. El equipo'
                          ' de iSoft tomara las medidas necesarias para que tal incidencia no vuelva a ocurrir',
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              ExpansionTile(
                title: Text('¿Cómo se calcula el precio del viaje?'),
                leading: Icon(Icons.payment),
                backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white12 : Colors.white,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Tak-si se adapta a las tarifas ya establecidas en cada ciudad por lo que el precio de viaje '
                          'puede variar entre una ciudad y otra.',
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              ExpansionTile(
                title: Text('¿Cómo puedo recibir promociones?'),
                leading: Icon(Icons.check),
                backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white12 : Colors.white,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Mantente al pendiente de la pagina oficial de tak-si en Facebook ya que los codigos de descuentos seran publicados por ese medio',
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        )),
      ),
    );

    /*return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Estilos().estilo(context, 'Preguntas frecuentes'),
        backgroundColor: Estilos().background(context),
        iconTheme: Estilos().colorIcon(context),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ExpansionTile(
                  title: Text('¿Que puedo hacer si olvido un objeto en el Tak-si?'),
                  leading: Icon(Icons.directions_car),
                  backgroundColor: Colors.white,
                  children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Dentro de la sección mis viajes podras consultar el número de telefono del chofer que te brindo '
                              'el ultimo servicio y de esta forma poder contactarlo',
                          softWrap: true,
                          style: TextStyle(fontSize: 15.5, color: Colors.black54,), textAlign: TextAlign.justify,
                        ),
                      ),
                      //Text("Pieter's Very own Pizza. Taste the richness",textAlign:TextAlign.center, style: TextStyle(fontStyle:FontStyle.italic,color: Colors.black87, fontSize: 20.0),),
                      //Image.network("https://cdn3.iconfinder.com/data/icons/food-4-5/128/178-512.png")
                    ],)
                  ],
                ),
                ExpansionTile(
                  title: Text('¿Cómo puedo contactar a Tak-si?'),
                  leading: Icon(Icons.contact_mail),
                  backgroundColor: Colors.white,
                  children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Por medio de la pagina de Facebook iSoft con gusto aclararemos todas tus dudas o al correo teamisoft@gmail.com',
                          softWrap: true,
                          style: TextStyle(fontSize: 15.5, color: Colors.black54,), textAlign: TextAlign.justify,
                        ),
                      ),
                    ],)
                  ],
                ),
                ExpansionTile(
                  title: Text('¿Es seguro Tak-si?'),
                  leading: Icon(Icons.security),
                  backgroundColor: Colors.white,
                  children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Tu seguridad es nuestra prioridad cada viaje que realices con nosotros esta geolocalizado y vinculado a un vehiculo, '
                              'conductor y matricula; y puedes compartir esta informacion con tus amigos y familiares, nuestros conductores disponen de '
                              'todas las licencias y seguros necesarios',
                          softWrap: true,
                          style: TextStyle(fontSize: 15.5, color: Colors.black54,), textAlign: TextAlign.justify,
                        ),
                      ),
                    ],)
                  ],
                ),
                ExpansionTile(
                  title: Text('¿Cómo puedo compartir información de mi viaje?'),
                  leading: Icon(Icons.share),
                  backgroundColor: Colors.white,
                  children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Tu seguridad es lo mas importante para nosotros, por lo tanto,'
                              ' cuando te encuentras en un viaje puedes compartir los detalles de tu viaje con tus contactos, '
                              'o redes sociales, en tu mensaje se envia tu ubicación en ese momento, el lugar hacia el '
                              'cual te diriges, los datos del taxi y conductor.  Usa esa función responsablemente ya que '
                              'es información sumamente sensible.',
                          softWrap: true,
                          style: TextStyle(fontSize: 15.5, color: Colors.black54,), textAlign: TextAlign.justify,
                        ),
                      ),
                    ],)
                  ],
                ),
                ExpansionTile(
                  title: Text('La aplicación no me ubica correctamente ¿que puedo hacer?'),
                  leading: Icon(Icons.location_off),
                  backgroundColor: Colors.white,
                  children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Verifica que la aplicación cuente con los permisos de ubicación y tu ubicacion este en alta precición',
                          softWrap: true,
                          style: TextStyle(fontSize: 15.5, color: Colors.black54,), textAlign: TextAlign.justify,
                        ),
                      ),
                    ],)
                  ],
                ),
                ExpansionTile(
                  title: Text('¿Como cancelo un viaje?'),
                  leading: Icon(Icons.cancel),
                  backgroundColor: Colors.white,
                  children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Puedes cancelar tu viaje unicamente cuando el conductor aun no ha llegado al punto de partida precionando el boton de cancelar,'
                              'cabe mencionar que el conductor tambien puede cancelar el viaje, en caso de una algun incidente',
                          softWrap: true,
                          style: TextStyle(fontSize: 15.5, color: Colors.black54,), textAlign: TextAlign.justify,
                        ),
                      ),
                    ],)
                  ],
                ),
                ExpansionTile(
                  title: Text('¿Cómo puedo reportar a un conductor?'),
                  leading: Icon(Icons.report_problem),
                  backgroundColor: Colors.white,
                  children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Dentro de la aplicación en la seccion de ayuda>Reportar un problema puedes informarnos del reporte que deseas realizar. El equipo'
                              ' de iSoft tomara las medidas necesarias para que tal incidencia no vuelva a ocurrir',
                          softWrap: true,
                          style: TextStyle(fontSize: 15.5, color: Colors.black54,), textAlign: TextAlign.justify,
                        ),
                      ),
                    ],)
                  ],
                ),
                ExpansionTile(
                  title: Text('¿Cómo se calcula el precio del viaje?'),
                  leading: Icon(Icons.payment),
                  backgroundColor: Colors.white,
                  children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Tak-si se adapta a las tarifas ya establecidas en cada ciudad por lo que el precio de viaje '
                              'puede variar entre una ciudad y otra.',
                          softWrap: true,
                          style: TextStyle(fontSize: 15.5, color: Colors.black54,), textAlign: TextAlign.justify,
                        ),
                      ),
                    ],)
                  ],
                ),
                ExpansionTile(
                  title: Text('¿Cómo puedo recibir promociones?'),
                  leading: Icon(Icons.check),
                  backgroundColor: Colors.white,
                  children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Mantente al pendiente de la pagina oficial de tak-si en Facebook ya que los codigos de descuentos seran publicados por ese medio',
                          softWrap: true,
                          style: TextStyle(fontSize: 15.5, color: Colors.black54,), textAlign: TextAlign.justify,
                        ),
                      ),
                    ],)
                  ],
                ),
              ],
            ),
          )),
    ); */
  }
}
