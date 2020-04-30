import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OpcionesPago extends StatefulWidget {
  @override
  _OpcionesPagoState createState() => _OpcionesPagoState();
}

class _OpcionesPagoState extends State<OpcionesPago> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 0.0,
                floating: true,
                pinned: false,
                snap: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text("Opciones de pago",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                    //labelColor: Colors.black87,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(icon: Icon(Icons.monetization_on), text: "Efectivo"),
                      Tab(icon: Icon(Icons.comment), text: "Código"),
                      Tab(icon: Icon(Icons.payment), text: "Tarjeta"),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: SafeArea(
            child: TabBarView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Image.asset(
                      "assets/taxiApp.png",
                      height: 250,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Si vas a realizar tu pago en efectivo, te recomendamos hacerlo al finalizar el servicio'
                        ' y verificar que el precio indicado al principio de tu viaje sea el mismo.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Image.asset(
                      "assets/taxiApp.png",
                      height: 250,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('El valor del cupón puede variar y al utilizarlo en la aplicación se aplica un descuento '
                          'al precio total del servicio.',
                        textAlign: TextAlign.justify,style: TextStyle(
                          fontSize: 16.0,
                        ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('El cupón se debe ingresar antes de seleccionar el sitio de taxi, '
                          'si ha ingresado un cupón y cancela el viaje, el cupón se toma como ya utilizado y no '
                          'podrá volver a utilizarlo.',
                        textAlign: TextAlign.justify,style: TextStyle(
                          fontSize: 16.0,
                        ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Los cupones son distribuidos en la página oficial de Tak-si en Facebook.'
                          ' Te recomendamos que sigas la página y estés al pendiente de nuestras publicaciones.',
                        textAlign: TextAlign.justify,style: TextStyle(
                          fontSize: 16.0,
                        ),),
                    ),
                  ],
                ),
                Center(
                  child: Text("No disponible en esta versión.",style: TextStyle(
                    fontSize: 16.0,
                  ),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
