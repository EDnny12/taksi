import 'package:flutter/material.dart';
import 'package:taksi/providers/estilos.dart';


class Gratis extends StatefulWidget {
  @override
  _GratisState createState() => _GratisState();
}

class _GratisState extends State<Gratis> {

   TextEditingController cupon=TextEditingController();

   @override
  void dispose() {
    // TODO: implement dispose
     cupon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Estilos().estilo(context, "Viajes gratis"),
        backgroundColor: Estilos().background(context),
        iconTheme: Estilos().colorIcon(context),
        elevation: 0.0,
      ),
      body: SafeArea(

        child: SingleChildScrollView(
          child:
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width*0.90,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 50.0,),
                const Text("¿Tienes un cupón de descuento?",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 30.0),),

                const SizedBox(height:50.0),
                const Text("Cuando tengas un cupón de descuento recuerda usarlo en los próximos 15 dias, de lo contrario el cupón perderá validez",textAlign: TextAlign.justify,),
                const SizedBox(height:50.0),
                TextFormField(
                  controller: cupon,
                  decoration: InputDecoration(
                    hintText: "Ingresa tu cupón",
                    border: const UnderlineInputBorder(),
                    filled: true,
                       suffixIcon: Icon(Icons.local_offer)
                  ),
                ),


              ],),
            ),
          ),
        ),
      ),

    );
  }
}
