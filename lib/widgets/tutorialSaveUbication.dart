import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:taksi/dialogs/showPhoto.dart';
import 'package:taksi/login/login.dart';

class TutorialSaveUbication extends StatefulWidget {
  String nombre;

  TutorialSaveUbication(this.nombre);

  @override
  _TutorialSaveUbicationState createState() => _TutorialSaveUbicationState();
}

class _TutorialSaveUbicationState extends State<TutorialSaveUbication> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
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
                bodyWidget: bodyPanel1(),
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
            ],
            showSkipButton: true,
            skipFlex: 0,
            nextFlex: 0,
            skip: const Text('Omitir'),
            next: const Icon(Icons.arrow_forward),
            onDone: () => _onIntroEnd(context),
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

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/logo.png', width: 200.0),
      alignment: Alignment.bottomCenter,
    );
  }

  bodyPanel1() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                widget.nombre,
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
                'Guarda ubicaciones y accede fácilmente a ellas. A continuación te explicamos como hacerlo.',
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

  bodyPanel2() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  DialogPhoto()
                      .dialogPhoto(context, 'assets/img1.png', 'assets');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/img1.png",
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
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Selecciona un destino y toca el marcador.',
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
                'Presiona Guardar ubicación',
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.50,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      'A continuación agrega una referencia para la ubicación.',
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
                      .dialogPhoto(context, 'assets/img2.png', 'assets');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/img2.png",
                    height: 200,
                    fit: BoxFit.contain, //cover
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Presiona aceptar',
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

  bodyPanel3() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                      'Las ubicaciones guardadas se mostrarán en la parte inferior del mapa.',
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
                      .dialogPhoto(context, 'assets/img3.png', 'assets');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/img3.png",
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
                'Al presionar una ubicación',
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  DialogPhoto()
                      .dialogPhoto(context, 'assets/img4.png', 'assets');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/img4.png",
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
                      'El marcador de destino se posicionará sobre las coordenadas que indica la ubicación guardada.',
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
                'Puedes eliminar ubicaciones accediendo al menu > Mis ubicaciones.',
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
}
