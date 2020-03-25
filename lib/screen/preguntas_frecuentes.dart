import 'package:flutter/material.dart';

class PreguntasFrecuentes extends StatefulWidget {
  @override
  _PreguntasFrecuentesState createState() => _PreguntasFrecuentesState();
}

class _PreguntasFrecuentesState extends State<PreguntasFrecuentes> {
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
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white12
                    : Colors.white,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Dentro de la sección mis viajes podrás consultar el número de teléfono del chofer que te brindo '
                          'el último servicio y de esta forma poder contactarlo.',
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
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white12
                    : Colors.white,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Por medio de la página de Facebook Tak-si con gusto aclararemos todas tus dudas o al correo teamisoft@gmail.com',
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
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white12
                    : Colors.white,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Tu seguridad es nuestra prioridad, cada viaje que realices con nosotros esta geolocalizado y vinculado a un vehículo, '
                          'conductor y matricula; Y puedes compartir esta información con tus amigos y familiares, nuestros conductores disponen de '
                          'todas las licencias y seguros necesarios para brindar el servicio.',
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
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white12
                    : Colors.white,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Tu seguridad es lo más importante para nosotros, por lo tanto,'
                          ' cuando te encuentras en un viaje puedes compartir los detalles de tu viaje con tus contactos, '
                          'o redes sociales, en tu mensaje se envía tu ubicación en ese momento, el lugar hacia el '
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
                    'La aplicación no me ubica correctamente ¿qué puedo hacer?'),
                leading: Icon(Icons.location_off),
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white12
                    : Colors.white,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Verifica que la aplicación cuente con los permisos de ubicación y tu ubicación este en alta precisión.',
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
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white12
                    : Colors.white,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Puedes cancelar tu viaje únicamente cuando el conductor aún no ha llegado al punto de partida presionando el botón de cancelar,'
                          'cabe mencionar que el conductor también puede cancelar el viaje, en caso de algún inconveniente.',
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
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white12
                    : Colors.white,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Dentro de la aplicación en la sección de ayuda > Reportar un problema puedes informarnos del reporte que deseas realizar. El equipo'
                          ' de soporte de Tak-si tomara las medidas necesarias para que tal incidencia no vuelva a ocurrir.',
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
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white12
                    : Colors.white,
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
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white12
                    : Colors.white,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Mantente al pendiente de la página oficial de Tak-si en Facebook ya que los códigos de descuentos serán publicados por ese medio.',
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
  }
}
