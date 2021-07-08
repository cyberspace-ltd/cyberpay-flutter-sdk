import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cyberpayflutter/cyberpayflutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool liveMode = false;
  String transactionRef = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> makePaymentWithReference() async {
    try {
      var result = await Cyberpayflutter.makePaymentWithReference(
        integrationKey: "005e84081f9f408586de873338fa54b7",
        reference: transactionRef.trim(),
        liveMode: liveMode,
      );
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
          integrationKey: "005e84081f9f408586de873338fa54b7",
          amount: 10000,
          customerEmail: "sample@demoemail.com",
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
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      liveMode ? Text("Production") : Text("Staging"),
                      Switch(
                          value: liveMode,
                          onChanged: (bool newValue) {
                            setState(() {
                              liveMode = newValue;
                            });
                          })
                    ],
                  ),
                  SizedBox(height: 16),
                  MaterialButton(
                    child: Text('Pay Demo N100'),
                    onPressed: () => makeSamplePayment(),
                    elevation: 8,
                    highlightElevation: 2,
                    color: Colors.redAccent,
                    padding: EdgeInsets.all(20.0),
                    colorBrightness: Brightness.dark,
                  ),
                  SizedBox(height: 32),
                  TextFormField(
                    validator: (value) => value!.isEmpty ? "Required" : null,
                    decoration: InputDecoration(
                      labelText: "Transaction Reference",
                      hintText: "Enter Transaction Reference",
                    ),
                    onChanged: (value) {
                      setState(() {
                        transactionRef = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  MaterialButton(
                    child: Text('Pay Demo N100 with reference'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        makePaymentWithReference();
                      }
                    },
                    elevation: 8,
                    highlightElevation: 2,
                    color: Colors.redAccent,
                    padding: EdgeInsets.all(20.0),
                    colorBrightness: Brightness.dark,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
