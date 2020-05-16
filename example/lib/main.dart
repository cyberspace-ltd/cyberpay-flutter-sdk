import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:cyberpayflutter/cyberpayflutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }


  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> makePaymentWithReference() async {
    try {
      var result = await Cyberpayflutter.makePaymentWithReference(
          integrationKey: "MERCHANT_INTEGRATION_KEY",
          reference: "REFERENCE_GOTTEN_FROM_SERVER",
          liveMode: false);
      if (result.isPaymentSuccessFul) {
        print(
            "Payment is Successfult, Your Payment Reference: ${result.paymentReference}");
      } else {
        print(result.errorMessage);
      }
    } on PlatformException catch (e) {
      var error = "Cyberpay Error: '${e.message}'.";
      print(error);
    }
  }

  Future<void> makeSamplePayment() async {
    try {
      var result = await Cyberpayflutter.makePayment(
          integrationKey: "MERCHANT_INTEGRATION_KEY",
          amount: 10000,
          customerEmail: "CUSTOMER_EMAIL",
          liveMode: false);
      if (result.isPaymentSuccessFul) {
        print(
            "Payment is Successfult, Your Payment Reference: ${result.paymentReference}");
      } else {
        print(result.errorMessage);
      }
    } on PlatformException catch (e) {
      var error = "Cyberpay Error: '${e.message}'.";
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('A demo Cyberpay Flutter Payment'),
        ),
        body: Center(
            child: MaterialButton(
          child: Text('Pay Demo N100'),
          elevation: 8,
          color: Colors.redAccent,
          colorBrightness: Brightness.dark,
          highlightElevation: 2,
          padding: EdgeInsets.all(20.0),
          onPressed: () {
            makeSamplePayment();
          },
        )),
      ),
    );
  }
}
