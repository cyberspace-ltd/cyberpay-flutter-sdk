// Copyright 2020 The Cyberspace Authors. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:cyberpayflutter/model/cyberpay_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// API for processing payment using the Cyberpay SDK
class Cyberpayflutter {
  /// The Cyberpay method channel for communicating with the native SDKs
  static const MethodChannel _channel = const MethodChannel('cyberpayflutter');

  /// This constructor is only used for testing and shouldn't be accessed by
  /// users of the plugin. It isn't useful for this plugin.
  @visibleForTesting
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Function to make a new payment. Returns a CyberpayResult class.
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

  /// Function to make a new payment, when transaction has already been initated from the server.
  /// Returns a CyberpayResult class.
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
      var _paymentReference = '$result';
      return CyberpayResult(
          isPaymentSuccessFul: true, paymentReference: _paymentReference);
    } on PlatformException catch (e) {
      var _errorMessage = "Error: '${e.message}'.";
      return CyberpayResult(
          isPaymentSuccessFul: false, errorMessage: _errorMessage);
    }
  }
}
