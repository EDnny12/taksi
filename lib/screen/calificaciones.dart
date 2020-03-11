import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taksi/providers/estilos.dart';

class Calificaciones extends StatefulWidget {
  @override
  _CalificacionesState createState() => _CalificacionesState();
}

class _CalificacionesState extends State<Calificaciones> {
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
                title: Text('Calificaciones',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    )),
                /*background: Image.network(
                      "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                      fit: BoxFit.cover,
                    )*/
              ),
            ),
          ];
        },
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ExpansionTile(
                  title: Text('¿Porque debo de calificar?'),
                  leading: Icon(Icons.star),
                  //backgroundColor: Colors.white,
                  backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white12 : Colors.white,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Text(
                            'Con el objetivo de brindar un servicio de calidad y seguro, '
                            'tu calificación nos proporciona una medida para lograr nuestro compromiso',
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 15.5,
                              //color: Colors.black54,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                ExpansionTile(
                  title: Text('¿Como funciona el sistema de calificación?'),
                  leading: Icon(Icons.build),
                  backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white12 : Colors.white,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Text(
                            'Tú le brindas una calificación a cada servicio recibido, con esto le permites al siguiente usuario ver que calidad de servicio '
                            'ofrece el chofer, ten en cuenta que 5 estrellas se refiere a un excelente servicio y 1 estrella significa que el servicio '
                            'fue deficiente',
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
                  title: Text('¿A quien le beneficia?'),
                  leading: Icon(Icons.supervised_user_circle),
                  backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white12 : Colors.white,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Text(
                            'El beneficio de tener una calificacion es tanto para el usuario como para los prestadores del servicio, '
                            'ya que con ello se crea un entorno de confinza y seguridad entre el usuario y el prestador del servicio',
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
                  title: Text('¿Porque es obligatorio?'),
                  leading: Icon(Icons.error),
                  backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white12 : Colors.white,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Text(
                            'Gracias a las calificaciones que otorgas ayudas a mejorar el servicio que se ofrece en tu ciudad',
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
                  title: Text('¿Que pasa si no califico?'),
                  leading: Icon(Icons.sentiment_very_dissatisfied),
                  backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white12 : Colors.white,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Text(
                            'Estas perdiendo la oportunidad de tener en un futuro un mejor servicio para ti y para los demas usuarios',
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
                      '¿Que significa el número de estrellas en mi perfil?'),
                  leading: Icon(Icons.tag_faces),
                  backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white12 : Colors.white,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Text(
                            'Es el promedio que adquieres en base a cada calificacion que te otorga el brindador del servicio',
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
          ),
        ),
      ),
    );

    /*return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Estilos().estilo(context, 'Calificaciones'),
        backgroundColor: Estilos().background(context),
        iconTheme: Estilos().colorIcon(context),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ExpansionTile(
                  title: Text('¿Porque debo de calificar?'),
                  leading: Icon(Icons.star),
                  backgroundColor: Colors.white,
                  children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Con el objetivo de brindar un servicio de calidad y seguro, '
                              'tu calificación nos proporciona una medida para lograr nuestro compromiso',
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
                  title: Text('¿Como funciona el sistema de calificación?'),
                  leading: Icon(Icons.build),
                  backgroundColor: Colors.white,
                  children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Tú le brindas una calificación a cada servicio recibido, con esto le permites al siguiente usuario ver que calidad de servicio '
                              'ofrece el chofer, ten en cuenta que 5 estrellas se refiere a un excelente servicio y 1 estrella significa que el servicio '
                              'fue deficiente',
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
                  title: Text('¿A quien le beneficia?'),
                  leading: Icon(Icons.supervised_user_circle),
                  backgroundColor: Colors.white,
                  children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'El beneficio de tener una calificacion es tanto para el usuario como para los prestadores del servicio, '
                              'ya que con ello se crea un entorno de confinza y seguridad entre el usuario y el prestador del servicio',
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
                  title: Text('¿Porque es obligatorio?'),
                  leading: Icon(Icons.error),
                  backgroundColor: Colors.white,
                  children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Gracias a las calificaciones que otorgas ayudas a mejorar el servicio que se ofrece en tu ciudad',
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
                  title: Text('¿Que pasa si no califico?'),
                  leading: Icon(Icons.sentiment_very_dissatisfied),
                  backgroundColor: Colors.white,
                  children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Estas perdiendo la oportunidad de tener en un futuro un mejor servicio para ti y para los demas usuarios',
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
                  title: Text('¿Que significa el número de estrellas en mi perfil?'),
                  leading: Icon(Icons.tag_faces),
                  backgroundColor: Colors.white,
                  children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          'Es el promedio que adquieres en base a cada calificacion que te otorga el brindador del servicio',
                          softWrap: true,
                          style: TextStyle(fontSize: 15.5, color: Colors.black54,), textAlign: TextAlign.justify,
                        ),
                      ),
                      //Text("Pieter's Very own Pizza. Taste the richness",textAlign:TextAlign.center, style: TextStyle(fontStyle:FontStyle.italic,color: Colors.black87, fontSize: 20.0),),
                      //Image.network("https://cdn3.iconfinder.com/data/icons/food-4-5/128/178-512.png")
                    ],)
                  ],
                ),
              ],
            ),
          )),
    );*/
  }
}
