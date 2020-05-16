# cyberpayflutter

# Introduction

Cyberpay provides you with the most convenient and fastest process of making and collecting payments from your customers all over the world

---


|                     CYBERPAY MASTER CARD                           |                       CYBERPAY  SECURE 3D                             |                      CYBERPAY BANK PAYMENT                | 
| :----------------------------------------------------------------: | :-------------------------------------------------------------------: |  :------------------------------------------------------: |
| 
<img src="https://raw.githubusercontent.com/cyberspace-ltd/cyberpay-androidx/dev/cyberpaysdk/src/main/java/com/cyberspace/cyberpaysdk/utils/screenshot/screenrecord.gif" width="30%" />
 | 
<img src="https://raw.githubusercontent.com/cyberspace-ltd/cyberpay-androidx/dev/cyberpaysdk/src/main/java/com/cyberspace/cyberpaysdk/utils/screenshot/secure3dpayment.gif" width="30%" />
 |
<img src="https://raw.githubusercontent.com/cyberspace-ltd/cyberpay-androidx/dev/cyberpaysdk/src/main/java/com/cyberspace/cyberpaysdk/utils/screenshot/bankpayment.gif" width="30%" />
 |



# About the SDK

The mobile SDK will serve as an easy to use library to quickly integrate Cyberpay to your mobile application.

The will serve as a wrapper on the existing Cyberpay web services and create a mobile entry point for making both Card and Bank transactions.

The SDK will provide custom views/layouts for checkout, pin, otp, sucured3d as well as handles all business logics taking the bulk of the job and exposing just three call backs representing the status of the transaction.


## Requirements

The Cyberpay Flutter SDK is compatible with iOS Apps supporting iOS 11 and above.

## Getting Started

### Installing

1. Add the cyberpay flutter sdk to your pubspec.yaml file

   ```yaml
   cyberpayflutter:
   ```

2. Run the following command in your terminal after navigating to your project directory, to download the package

    ```shell
    flutter pub get
    ```

### Using the Cyberpay SDK

**Step 1**: Import the cyberpay sdk

```dart
    import 'package:cyberpayflutter/cyberpayflutter.dart';
```

**Step 2**: Complete integration with Our Drop-In UI

```dart
    try {
      var result = await Cyberpayflutter.makePayment(
          integrationKey: "MERCHANT_INTEGRATION_KEY",
          amount: "PAYMENT_AMOUNT_IN_KOBO",
          customerEmail: "CUSTOMER_EMAIL",
          liveMode: false);
        if (result.isPaymentSuccessFul) {
        print("Payment is Successfult, Your Payment Reference: ${result.paymentReference}");
        } 
        else {
            print(result.errorMessage);
      }
    } on PlatformException catch (e) {
        var error = "Cyberpay Error: '${e.message}'.";
        print(error);
    }
```

### Cyberpay Intergration, when Transaction has been set in the server)

**Step 1**: Import the cyberpay sdk

```dart
    import 'package:cyberpayflutter/cyberpayflutter.dart';
```

**Step 2**: Complete integration with Our Server Drop-In UI

```dart
    try {
      var result = await Cyberpayflutter.makePaymentWithReference(
          integrationKey: "MERCHANT_INTEGRATION_KEY",
          reference: "TRANSACTION_REFERENCE_FROM_SERVER",
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
```

**Note** : Ensure when going live, you change `liveMode` to `true`, and also change the _integration key_. This key can be gotten from the merchant dashboard on the cyberpay merchant portal

## Example

To run the example project, clone the repo, and run the following command in your terminal:
```shell
flutter run
```

## License

cyberpaysdk is available under the MIT license. See the LICENSE file for more info.

