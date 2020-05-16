import 'dart:async';

import 'package:cyberpayflutter/model/cyberpay_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Cyberpayflutter {
  static const MethodChannel _channel = const MethodChannel('cyberpayflutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<CyberpayResult> makePayment({
    @required String integrationKey,
    @required double amount,
    @required String customerEmail,
    @required bool liveMode,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{
      "integrationKey": integrationKey,
      "amount": amount,
      "customerEmail": customerEmail,
      "liveMode": liveMode
    };

    try {
      final String result = await _channel.invokeMethod('checkout', params);
      var _paymentReference = '$result';
      return CyberpayResult(
          isPaymentSuccessFul: true, paymentReference: _paymentReference);
    } on PlatformException catch (e) {
      var _errorMessage = "Error: '${e.message}'.";
      return CyberpayResult(
          isPaymentSuccessFul: false, errorMessage: _errorMessage);
    }
  }

 static Future<CyberpayResult> makePaymentWithReference({
    @required String integrationKey,
    @required String reference,
    @required bool liveMode,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{
      "integrationKey": integrationKey,
      "reference": reference,
      "liveMode": liveMode,
    };
    try {
      final String result = await _channel.invokeMethod('checkoutRef', params);
      var  _paymentReference = '$result';
      return CyberpayResult(isPaymentSuccessFul: true, paymentReference: _paymentReference);
    } on PlatformException catch (e) {
      var _errorMessage = "Error: '${e.message}'.";
      return CyberpayResult(isPaymentSuccessFul: false, errorMessage: _errorMessage);
    }
  }

}
