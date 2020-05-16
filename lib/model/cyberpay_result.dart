class CyberpayResult {
  bool isPaymentSuccessFul;
  String paymentReference;
  String errorMessage;

  CyberpayResult(
      {this.isPaymentSuccessFul, this.paymentReference, this.errorMessage});
}
