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

  /*List<Slide> slides = new List();
  Function goToTab;*/

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
                'A continuación te explicaremos como usar Tak-si.',
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
          Text(
            'Punto de partida',
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.w800, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15,),
          Stack(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Dialog_Photo().dialogPhoto(context, 'assets/mapa.png', 'assets');
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
                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      'Tak-si automaticamente tomara tu ubicación cuando ingreses a la aplicación. '
                          'Ese sera tu punto de partida.',
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
          SizedBox(height: 10,),
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
          Text(
            'Elige tu destino',
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.w800, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15,),
          Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Dialog_Photo().dialogPhoto(context, 'assets/destino.png', 'assets');
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
                      'Selecciona tu destino escribiendo su nombre en el cuadro de texto.',
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
          SizedBox(height: 10,),
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
          SizedBox(height: 10,),
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
                    child: Text('Buscar el lugar en el mapa haciendo zoom y mantenerlo precionado por unos segundos.',
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
                  Dialog_Photo().dialogPhoto(context, 'assets/tap.png', 'assets');
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
          SizedBox(height: 15,),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Si ya has elegido un destino y deseas cambiarlo, puedes hacerlo utilizando los'
                    ' metodos antes mencionados.',
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
          Text(
            'Detalles de su viaje',
            style: TextStyle(
                fontSize: 25,
                fontWeight:
                FontWeight.w800,
                color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30,),
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
                    child: Text('Se busca la ruta mas optima y se muestran los detalles de tu viaje.',
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
                  Dialog_Photo().dialogPhoto(context, 'assets/detalles.png', 'assets');
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
          SizedBox(height: 15,),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Al precionar continuar',
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
          SizedBox(height: 15,),
          Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Dialog_Photo().dialogPhoto(context, 'assets/sitios.png', 'assets');
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
                      'Selecciona el taxi, puede ser de todas los sitios o uno en especifico.',
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
  bodyPanel5(context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text(
            'En camino',
            style: TextStyle(
                fontSize: 25,
                fontWeight:
                FontWeight.w800,
                color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 25,),
          Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Dialog_Photo().dialogPhoto(context, 'assets/aceptado.png', 'assets');
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
                      'Cuando tu viaje es aceptado, puedes ver el trayecto de tu taxi hasta llegar a ti.',
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
          SizedBox(height: 15,),
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
          SizedBox(height: 15,),
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
                    child: Text('Puedes ver el recorrido que realizaras y '
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
                  Dialog_Photo().dialogPhoto(context, 'assets/iniciado.png', 'assets');
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
  bodyPanel6() {
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
                'Esperemos que este tutorial haya sido de tu ayuda, puedes acceder a el cuando gustes '
                    'seleccionando en el menu la opción de Ayuda > Tutorial.',
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


  /*
  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "BIENVENIDO \n " + nombre,
        styleTitle: TextStyle(
            color: Color(0xff3da4ab),
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        widgetDescription: Container(
          child: Text('hola mundo'),
        ),
        description: '',
        styleDescription: TextStyle(
            color: Color(0xfffe9c8f),
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        pathImage: "assets/logo.png",
        //pathImage: "images/photo_school.png",
      ),
    );
    slides.add(
      new Slide(
        title: "MUSEUM",
        styleTitle: TextStyle(
            color: Color(0xff3da4ab),
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
            "Ye indulgence unreserved connection alteration appearance",
        styleDescription: TextStyle(
            color: Color(0xfffe9c8f),
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        pathImage: "assets/logo.png",
      ),
    );
    slides.add(
      new Slide(
        title: "TAK-SI",
        styleTitle: TextStyle(
            color: Color(0xff3da4ab),
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
            "Ye indulgence unreserved connection alteration appearance",
        styleDescription: TextStyle(
            color: Color(0xfffe9c8f),
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        pathImage: "assets/logo.png",
      ),
    );
  }

  // 4 Step: Create Other functions
  void onDonePress() {
    // Back to the first tab
    Navigator.of(context).pop();
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Color(0xffffcc5c),
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Color(0xffffcc5c),
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Color(0xffffcc5c),
    );
  }

  // 5 Step: Custom Tabs
  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = new List();
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: EdgeInsets.only(bottom: 60.0, top: 60.0),
          child: ListView(
            children: <Widget>[
              GestureDetector(
                  child: Image.asset(
                currentSlide.pathImage,
                width: 200.0,
                height: 200.0,
                fit: BoxFit.contain,
              )),
              Container(
                child: Text(
                  currentSlide.title,
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
              Container(
                child: Text(
                  currentSlide.description,
                  style: currentSlide.styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
            ],
          ),
        ),
      ));
    }
    return tabs;
  }
  }*/

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
          fondo(),
          IntroductionScreen(
            globalBackgroundColor: Colors.transparent,
            key: introKey,
            pages: [
              PageViewModel(
                bodyWidget: bodyPage1(),
                title: "BIENVENIDO",
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
                title: '',
                bodyWidget: bodyPanel4(),
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
                bodyWidget: bodyPanel5(context),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: '',
                bodyWidget: bodyPanel6(),
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
              activeColor: Colors.cyan,
              size: Size(10.0, 10.0),
              color: Color(0xFFBDBDBD),
              activeSize: Size(22.0, 10.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
          )
          /*IntroSlider(
            slides: this.slides,

            // Skip button
            renderSkipBtn: this.renderSkipBtn(),
            colorSkipBtn: Color(0x33ffcc5c),
            highlightColorSkipBtn: Color(0xffffcc5c),

            // Next button
            renderNextBtn: this.renderNextBtn(),

            // Done button
            renderDoneBtn: this.renderDoneBtn(),
            onDonePress: this.onDonePress,
            colorDoneBtn: Color(0x33ffcc5c),
            highlightColorDoneBtn: Color(0xffffcc5c),

            // Dot indicator
            colorDot: Color(0xffffcc5c),
            sizeDot: 13.0,

            // Tabs
            listCustomTabs: this.renderListCustomTabs(),
            //backgroundColorAllSlides: Colors.white,
            refFuncGoToTab: (refFunc) {
              this.goToTab = refFunc;
            },

            // Show or hide status bar
            shouldHideStatusBar: false,

            // On tab change completed
            onTabChangeCompleted: this.onTabChangeCompleted,
          ),*/
        ],
      ),
    );
  }

}
