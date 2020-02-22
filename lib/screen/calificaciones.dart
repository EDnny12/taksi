import 'package:expandable/expandable.dart';
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
      appBar: AppBar(
        elevation: 1,
        title: Estilos().estilo(context, 'Calificaciones'),
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
                      '¿Porque debo de calificar?',
                      style: TextStyle(fontSize: 23),
                    ),
                    expanded: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        'Con el objetivo de brindar un servicio de calidad y seguro, tu calificación nos proporciona una medida para lograr nuestro compromiso',
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
                      '¿Como funciona el sistema de calificación?',
                      style: TextStyle(fontSize: 23),
                    ),
                    expanded: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        'Tú le brindas una calificación a cada servicio recibido, con esto le permites al siguiente usuario ver que calidad de servicio '
                            'ofrece el chofer, ten en cuenta que 5 estrellas se refiere a un excelente servicio y 1 estrella significa que el servicio '
                            'fue deficiente',
                        softWrap: true,
                        style: TextStyle(fontSize: 17, color: Colors.black54),textAlign: TextAlign.justify,
                      ),
                    ),
                    tapHeaderToExpand: true,
                    hasIcon: true,
                  ),
                  SizedBox(height: 10,),
                  ExpandablePanel(
                    header: Text(
                      '¿A quien le beneficia?',
                      style: TextStyle(fontSize: 23),
                    ),
                    expanded: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        'El beneficio de tener una calificacion es tanto para el usuario como para los prestadores del servicio, '
                            'ya que con ello se crea un entorno de confinza y seguridad entre el usuario y el prestador del servicio',
                        softWrap: true,
                        style: TextStyle(fontSize: 17, color: Colors.black54),textAlign: TextAlign.justify,
                      ),
                    ),
                    tapHeaderToExpand: true,
                    hasIcon: true,
                  ),
                  SizedBox(height: 10,),
                  ExpandablePanel(
                    header: Text(
                      '¿Porque es obligatorio?',
                      style: TextStyle(fontSize: 23),
                    ),
                    expanded: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        'Gracias a las calificaciones que otorgas ayudas a mejorar el servicio que se ofrece en tu ciudad',
                        softWrap: true,
                        style: TextStyle(fontSize: 17, color: Colors.black54),textAlign: TextAlign.justify,
                      ),
                    ),
                    tapHeaderToExpand: true,
                    hasIcon: true,
                  ),
                  SizedBox(height: 10,),
                  ExpandablePanel(
                    header: Text(
                      '¿Que pasa si no califico?',
                      style: TextStyle(fontSize: 23),
                    ),
                    expanded: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        'Estas perdiendo la oportunidad de tener en un futuro un mejor servicio para ti y para los demas usuarios',
                        softWrap: true,
                        style: TextStyle(fontSize: 17, color: Colors.black54),textAlign: TextAlign.justify,
                      ),
                    ),
                    tapHeaderToExpand: true,
                    hasIcon: true,
                  ),
                  SizedBox(height: 10,),
                  ExpandablePanel(
                    header: Text(
                      '¿Que significa el número de estrellas en mi perfil?',
                      style: TextStyle(fontSize: 23),
                    ),
                    expanded: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        'Es el promedio que adquieres en base a cada calificacion que te otorga el brindador del servicio',
                        softWrap: true,
                        style: TextStyle(fontSize: 17, color: Colors.black54),textAlign: TextAlign.justify,
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
