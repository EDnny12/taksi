import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';

class PaymentProvider with ChangeNotifier {
  PaymentMethod _paymentMethod = PaymentMethod();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  PaymentProvider.initialize() {
    StripePayment.setOptions(StripeOptions(
        publishableKey: 'pk_test_13iHEwCjZs4s9U5hRfDlsAU600TH0oVrJt'));
  }

  void addCard() {
    StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
        .then((paymentMethod) {
      _paymentMethod = paymentMethod;
      FirebaseAuth.instance.currentUser().then((user) { //nuevo
        Firestore.instance
            .collection('tarjetas')
            .document(user.uid)
            .collection('tokens')
            .add({'tokenId': paymentMethod}).then((val) {
          print('hecho');
        });
      });
    }).catchError((error) {
      print('ocurrio un error: ' + error.toString());
    });
  }
}
