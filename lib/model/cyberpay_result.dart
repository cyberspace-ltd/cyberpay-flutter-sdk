/// Indicates the result expected after payment is initiated
class CyberpayResult {
  /// This returns true if the payment is successful, and false if payment fails
  bool isPaymentSuccessFul;

  /// The payment reference
  String? paymentReference;

  /// The error message returned when a payment fails. This returns null when payment is successful
  String? errorMessage;

  CyberpayResult({
    required this.isPaymentSuccessFul,
    this.paymentReference,
    this.errorMessage,
  });
}
