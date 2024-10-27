import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_force/domain/payment_domain.dart';

class PaymentNotifier extends StateNotifier<PaymentData> {
  PaymentNotifier()
      : super(PaymentData(
            amount: null,
            date: null,
            duration: '',
            title: '',
            transactionId: '',
            userId: '',
            isActive: false,
            expirationDate: null));

  void setPayment({
    required int? amount,
    required DateTime? date,
    required String duration,
    required String title,
    required String transactionId,
    required String userId,
  }) {
    DateTime expirationDate = date ?? DateTime.now();

    if (duration == '6 meses') {
      expirationDate = expirationDate.add(const Duration(days: 180));
    } else if (duration == 'mensual') {
      expirationDate = DateTime(
          expirationDate.year, expirationDate.month + 1, expirationDate.day);
    } else if (duration == '1 año') {
      expirationDate = DateTime(
          expirationDate.year + 1, expirationDate.month, expirationDate.day);
    }

    bool isActive = DateTime.now().isBefore(expirationDate);

    state = PaymentData(
      amount: amount,
      date: date,
      duration: duration,
      title: title,
      transactionId: transactionId,
      userId: userId,
      isActive: isActive,
      expirationDate: expirationDate,
    );
  }
}

final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentData>(
    (ref) => PaymentNotifier());
