import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:taksi/dialogs/showPhoto.dart';
import 'package:taksi/login/login.dart';

class Tutorial extends StatefulWidget {
  String nombre;
  Tutorial(this.nombre);

  @override
  _TutorialState createState() => _TutorialState(nombre);
}

class _TutorialState extends State<Tutorial> {
  final introKey = GlobalKey<IntroductionScreenState>();

  String nombre;
  _TutorialState(this.nombre);

  void _onIntroEnd(context) {
    Navigator.of(context).pop();
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/logo.png', width: 200.0),
      alignment: Alignment.bottomCenter,
    );
  }

  bodyPage1() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                nombre,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Spectral',
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'A continuación, te explicaremos como usar Tak-si.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Spectral',
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            'Tu destino es el nuestro!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  bodyPanel2() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Punto de partida',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Spectral',
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Stack(
            children: <Widget>[
              InkWell(
                onTap: () {
                  DialogPhoto()
                      .dialogPhoto(context, 'assets/mapa.png', 'assets');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/mapa.png",
                    //height: 250,
                    fit: BoxFit.contain, //cover
                  ),
                ),
              ),
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      'Tak-si automáticamente tomara tu ubicación cuando ingreses a la aplicación. '
                      'Se tomará como referencia para el punto de partida',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: 'Spectral',
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Procura activar tu GPS antes de ingresar a Tak-si',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Spectral',
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bodyPanel3() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Elige tu destino',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Spectral',
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  DialogPhoto()
                      .dialogPhoto(context, 'assets/destino.png', 'assets');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/destino.png",
                    height: 200,
                    fit: BoxFit.contain, //cover
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: Text(
                      'Selecciona tu destino escribiendo una referencia en el cuadro de texto.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: 'Spectral',
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'O bien',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Spectral',
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: Text(
                      'Buscar el lugar en el mapa, haciendo zoom y mantenerlo presionado por unos segundos.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: 'Spectral',
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  DialogPhoto()
                      .dialogPhoto(context, 'assets/tap.png', 'assets');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/tap.png",
                    height: 200,
                    fit: BoxFit.contain, //cover
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Si ya has elegido un destino y deseas cambiarlo, puedes hacerlo utilizando los'
                ' métodos antes mencionados.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Spectral',
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bodyPanel4() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Destino seleccionado',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Spectral',
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: Text(
                      'Marcador que indica el destino que ha seleccionado.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: 'Spectral',
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  DialogPhoto()
                      .dialogPhoto(context, 'assets/destino1.png', 'assets');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/destino1.png",
                    height: 200,
                    fit: BoxFit.contain, //cover
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Al presionar continuar',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Spectral',
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  DialogPhoto()
                      .dialogPhoto(context, 'assets/origen1.png', 'assets');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/origen1.png",
                    height: 200,
                    fit: BoxFit.contain, //cover
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: Text(
                      'Confirme su punto de partida, Mueva el mapa hasta posicionar el marcador' +
                          ' en la calle en la cual tomara el taxi.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: 'Spectral',
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Presione continuar',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Spectral',
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bodyPanel5() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Detalles de su viaje',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Spectral',
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: Text(
                      'Se busca la ruta más optima y se muestran los detalles de tu viaje.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: 'Spectral',
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  DialogPhoto()
                      .dialogPhoto(context, 'assets/detalles.png', 'assets');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/detalles.png",
                    height: 200,
                    fit: BoxFit.contain, //cover
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Al presionar continuar',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Spectral',
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  DialogPhoto()
                      .dialogPhoto(context, 'assets/sitios.png', 'assets');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/sitios.png",
                    height: 200,
                    fit: BoxFit.contain, //cover
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: Text(
                      'Selecciona el sitio de taxi, pueden ser todos los sitios o uno en específico.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: 'Spectral',
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bodyPanel6(context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'En camino',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Spectral',
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  DialogPhoto()
                      .dialogPhoto(context, 'assets/aceptado.png', 'assets');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/aceptado.png",
                    height: 200,
                    fit: BoxFit.contain, //cover
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: Text(
                      'Cuando tu viaje es aceptado, puedes ver el trayecto del taxi hasta llegar a ti.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: 'Spectral',
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Abordo',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Spectral',
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: Text(
                      'Puedes ver el recorrido que realizaras y '
                      'el tiempo en el que llegaras a tu destino.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: 'Spectral',
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  DialogPhoto()
                      .dialogPhoto(context, 'assets/iniciado.png', 'assets');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/iniciado.png",
                    height: 200,
                    fit: BoxFit.contain, //cover
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bodyPanel7() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Esperamos que este tutorial haya sido de tu ayuda, puedes acceder a él cuándo gustes, '
                'seleccionando en el menú la opción de Ayuda > Tutorial.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Spectral',
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            'Tu destino es el nuestro!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      //descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: EdgeInsets.zero,
    );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Fondo(),
          IntroductionScreen(
            globalBackgroundColor: Colors.transparent,
            key: introKey,
            pages: [
              PageViewModel(
                bodyWidget: bodyPage1(),
                title: "HOLA!",
                image: _buildImage('img1'),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "",
                bodyWidget: bodyPanel2(),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "",
                bodyWidget: bodyPanel3(),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "",
                bodyWidget: bodyPanel4(),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: '',
                bodyWidget: bodyPanel5(),
                /*footer: RaisedButton(
                  onPressed: () {
                    introKey.currentState?.animateScroll(0);
                  },
                  child: const Text(
                    'FooButton',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),*/
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: '',
                bodyWidget: bodyPanel6(context),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: '',
                bodyWidget: bodyPanel7(),
                image: _buildImage('img1'),
                decoration: pageDecoration,
              ),
            ],
            onDone: () => _onIntroEnd(context),
            //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
            showSkipButton: true,
            skipFlex: 0,
            nextFlex: 0,

            skip: const Text('Omitir'),
            next: const Icon(Icons.arrow_forward),
            done: const Text('Finalizar',
                style: TextStyle(fontWeight: FontWeight.w600)),
            dotsDecorator: const DotsDecorator(
              activeColor: Colors.black87,
              size: Size(8.0, 8.0),
              color: Color(0xFFBDBDBD),
              activeSize: Size(18.0, 10.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
