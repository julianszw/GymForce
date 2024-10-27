class PaymentData {
  int? amount;
  DateTime? date;
  String duration;
  String title;
  String transactionId;
  String userId;
  final bool isActive;
  DateTime? expirationDate;

  PaymentData(
      {required this.amount,
      required this.date,
      required this.duration,
      required this.title,
      required this.transactionId,
      required this.userId,
      required this.isActive,
      required this.expirationDate});
}
