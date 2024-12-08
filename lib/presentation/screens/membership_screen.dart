import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_force/config/providers/payment_provider.dart';
import 'package:gym_force/config/providers/user_provider.dart';
import 'package:gym_force/main.dart';
import 'package:gym_force/presentation/widgets/yellow_button.dart';
import 'package:gym_force/services/memberships_services.dart';
import 'package:gym_force/services/payment_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MembershipScreen extends ConsumerStatefulWidget {
  final String? status;
  const MembershipScreen({super.key, this.status});

  @override
  MembershipScreenState createState() => MembershipScreenState();
}

class MembershipScreenState extends ConsumerState<MembershipScreen>
    with WidgetsBindingObserver {
  List<Map<String, dynamic>> memberships = [];
  bool isLoading = true;
  bool isLoadingPurchase = false;
  bool isLoadingPayment = false;
  int? selectedMembershipIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchMemberships();
    if (widget.status == 'success') {
      _startPaymentVerification();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _fetchMemberships() async {
    try {
      final fetchedMemberships = await MembershipService().getMemberships();

      fetchedMemberships.sort((a, b) {
        double priceA = double.tryParse(a['price'].toString()) ?? 0.0;
        double priceB = double.tryParse(b['price'].toString()) ?? 0.0;
        return priceB.compareTo(priceA);
      });
      setState(() {
        memberships = fetchedMemberships;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _startPaymentVerification() async {
    setState(() {
      isLoading = true;
    });

    try {
      final userState = ref.read(userProvider);
      final paymentState = ref.read(paymentProvider.notifier);
      final payment =
          await PaymentService().getLatestPaymentForUser(userState.uid);

      if (payment != null) {
        paymentState.setPayment(
            amount: payment['amount'],
            date: payment['date'],
            duration: payment['duration'],
            title: payment['title'],
            transactionId: payment['transactionId'],
            userId: payment['userId'],
            expirationDate: payment['expirationDate']);
      }
    } catch (e) {
      print(e);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _handlePurchase() async {
    setState(() {
      isLoadingPurchase = true;
    });
    final userState = ref.read(userProvider);
    if (selectedMembershipIndex != null) {
      final selectedMembership = memberships[selectedMembershipIndex!];
      final duration = selectedMembership['duration'];
      final name = selectedMembership['name'];
      final title = 'Membresía: $name válido por $duration';
      final double price =
          double.tryParse(selectedMembership['price'].toString()) ?? 0.0;
      const quantity = 1;

      final transactionId = await MembershipService()
          .createMembershipTransaction(
              userState.uid, title, price, quantity, duration);

      if (transactionId != null) {
        final url =
            'https://www.mercadopago.com.ar/checkout/v1/redirect?pref_id=$transactionId';
        await launchUrl(Uri.parse(url));

        await Future.delayed(const Duration(seconds: 3));
        setState(() {
          isLoadingPurchase = false;
        });
      } else {
        scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text('Error al crear la transacción.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final paymentState = ref.watch(paymentProvider);

    String? expirationDateString =
        '${paymentState.expirationDate?.day}/${paymentState.expirationDate?.month}/${paymentState.expirationDate?.year}';

    return Scaffold(
      appBar: isLoadingPayment
          ? null
          : AppBar(
              title: const Text('Membresía'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (widget.status == 'success' ||
                      widget.status == 'failed' ||
                      widget.status == 'pending') {
                    context.push('/');
                  } else {
                    context.pop();
                  }
                },
              ),
            ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isLoadingPayment
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      Padding(
                        padding: EdgeInsetsDirectional.only(top: 20),
                        child: Text(
                          'Estamos procesando tu pago, por favor espera...',
                        ),
                      )
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(
                          top: 20,
                        ),
                        color: Colors.black,
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Text(
                                userState.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                paymentState.isActive ? 'Activo' : 'Inactivo',
                                style: TextStyle(
                                  color: paymentState.isActive
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                              if (paymentState.title != '') ...[
                                Text(
                                  'Plan: ${paymentState.title.split(' ')[1]}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                              if (expirationDateString != 'null/null/null') ...[
                                Text(
                                  'Vencimiento: $expirationDateString',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/images/memberships_wallpaper.png',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: memberships.asMap().entries.map((entry) {
                            int index = entry.key;
                            Map<String, dynamic> membership = entry.value;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedMembershipIndex = index;
                                });
                              },
                              child: Card(
                                elevation: 4,
                                margin: const EdgeInsets.all(8),
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: selectedMembershipIndex == index
                                        ? Colors.yellow
                                        : Colors.transparent,
                                    width: 4,
                                  ),
                                ),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.80,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          '\$${membership['price'] ?? 'Sin precio'}',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                      const Text(
                                        ' por mes',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                      const Spacer(),
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFAF9D44),
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(8),
                                            bottomRight: Radius.circular(8),
                                          ),
                                        ),
                                        width: 110,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        alignment: Alignment.center,
                                        child: Text(
                                          membership['duration']
                                                  ?.toString()
                                                  .toUpperCase() ??
                                              'Sin duración',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50.0),
                          child: YellowButton(
                            isLoading: isLoadingPurchase,
                            onPressed: _handlePurchase,
                            text: 'Comprar',
                            isEnabled: selectedMembershipIndex != null,
                          )),
                    ],
                  ),
                ),
    );
  }
}
