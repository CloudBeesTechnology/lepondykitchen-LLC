import 'dart:convert';
import 'dart:math';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:user_web/constant.dart';
import 'package:user_web/model/formatter.dart';
import 'package:user_web/widgets/footer_widget.dart';
import 'package:user_web/widgets/web_menu.dart';
// ignore: unused_import
import 'platforms/payment_element.dart'
    if (dart.library.js) 'platforms/payment_element_web.dart';

class StripeWebWidget extends StatefulWidget {
  const StripeWebWidget({super.key});

  @override
  State<StripeWebWidget> createState() => _StripeWebWidgetState();
}

class _StripeWebWidgetState extends State<StripeWebWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //  backgroundColor: const Color.fromARGB(255, 238, 237, 237),
        // appBar: AppBar(
        //     // title: const Text('Paystack'),
        //     ),
        body: SingleChildScrollView(
      child: Column(
        children: [
          MediaQuery.of(context).size.width >= 1100
              ? Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Card(
                            shape: const BeveledRectangleBorder(),
                            color: AdaptiveTheme.of(context).mode.isDark == true
                                ? Colors.black87
                                : Colors.white,
                            surfaceTintColor: Colors.white,
                            child: const WebMenu(path: '/wallet')),
                      ),
                      const Gap(20),
                      Expanded(
                          flex: 6,
                          child: Card(
                            shape: const BeveledRectangleBorder(),
                            color: AdaptiveTheme.of(context).mode.isDark == true
                                ? Colors.black87
                                : Colors.white,
                            surfaceTintColor: Colors.white,
                            child: const SingleChildScrollView(
                              child: StripeForm(),
                            ),
                          ))
                    ],
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: StripeForm(),
                ),
          const Gap(20),
          const FooterWidget()
        ],
      ),
    ));
  }
}

class StripeForm extends StatefulWidget {
  const StripeForm({super.key});

  @override
  State<StripeForm> createState() => _StripeFormState();
}

class _StripeFormState extends State<StripeForm> {
  final emailController = TextEditingController();
  final amountController = TextEditingController();
  String publicKey = '';
  String secretKey = '';

  getStripeKeys() {
    FirebaseFirestore.instance
        .collection('Payment System Details')
        .doc('Stripe')
        .snapshots()
        .listen((value) {
      setState(() {
        publicKey = value['Publishable key'];
        secretKey = value['Secret Key'];
        getStripeDetail(value['Publishable key']);
      });
    });
  }

  num wallet = 0;
  bool isLoading = true;
  getUserDetail() {
    setState(() {
      isLoading = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        isLoading = false;
        wallet = event['wallet'];
      });
      //  print('Fullname is $fullName');
    });
  }

  String currency = '';
  String currencyCode = '';
  getCurrency() {
    FirebaseFirestore.instance
        .collection('Currency Settings')
        .doc('Currency Settings')
        .get()
        .then((value) {
      setState(() {
        currency = value['Currency symbol'];
        currencyCode = value['Currency code'];
      });
    });
  }

  @override
  void initState() {
    getUserDetail();

    getCurrency();
    getStripeKeys();
    amountController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  String generateRef() {
    final randomCode = Random().nextInt(3234234);
    return 'ref-$randomCode';
  }

  getStripeDetail(String publicKey) async {
    Stripe.publishableKey = publicKey;
    Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
    Stripe.urlScheme = 'flutterstripe';
    await Stripe.instance.applySettings();
  }

  @override
  Widget build(BuildContext context) {
    return publicKey.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.9,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(8),
              //   color: Colors.white,
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back)),
                        const Gap(20),
                        Text(
                          'Stripe Payment',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                // color: Colors.black,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email'.tr(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: amountController,
                    decoration: InputDecoration(
                      hintText: 'Amount($currency)'.tr(),
                    ),
                  ),
                  //   const Spacer(),
                  const Gap(50),

                  ElevatedButton(
                    onPressed: amountController.text.isEmpty ||
                            emailController.text.isEmpty
                        ? null
                        : () async {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return StripeCard(
                                  publicKey: publicKey,
                                  secretKey: secretKey,
                                  email: emailController.text.toString(),
                                  amount: amountController.text,
                                  currency: currency,
                                  currencyCode: currencyCode,
                                  wallet: wallet);
                            }));
                          },
                    style: ElevatedButton.styleFrom(
                      shape: const BeveledRectangleBorder(),
                      backgroundColor: Colors.blue,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Pay${amountController.text.isEmpty ? '' : ' $currency${Formatter().converter(double.parse(amountController.text))}'} with Stripe',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  // color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class StripeCard extends StatefulWidget {
  final String amount;
  final String currency;
  final String currencyCode;
  final num wallet;
  final String email;
  final String publicKey;
  final String secretKey;
  const StripeCard(
      {super.key,
      required this.amount,
      required this.currency,
      required this.currencyCode,
      required this.wallet,
      required this.publicKey,
      required this.secretKey,
      required this.email});

  @override
  State<StripeCard> createState() => _StripeCardState();
}

class _StripeCardState extends State<StripeCard> {
  String? clientSecret;
  Future<String> createPaymentIntent() async {
    final url = Uri.parse('$serverUrl/create-payment-intent');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': widget.secretKey,
        'x-secret-key': widget.publicKey,
      },
      body: json.encode({
        'currency': widget.currencyCode.toLowerCase(),
        'email': widget.email,
        'amount': num.parse(widget.amount),
        'payment_method_types': ['card'],
        'request_three_d_secure': 'any',
      }),
    );

    // // ignore: avoid_print
    // print('Status code is ${response.body}');
    return json.decode(response.body)['clientSecret'];
  }

  Future<void> getClientSecret() async {
    try {
      final client = await createPaymentIntent();
      setState(() {
        clientSecret = client;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error is ${e.toString()}');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    getClientSecret();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              child: clientSecret != null
                  ? PlatformPaymentElement(
                      clientSecret,
                      amount: widget.amount,
                      wallet: widget.wallet,
                    )
                  : const Center(child: CircularProgressIndicator())),
          const Gap(20),
          ElevatedButton(
            onPressed: () {
              pay(widget.amount, widget.wallet, true);
            },
            style: ElevatedButton.styleFrom(
              shape: const BeveledRectangleBorder(),
              backgroundColor: Colors.blue,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Pay${widget.amount.isEmpty ? '' : ' ${widget.currency}${Formatter().converter(double.parse(widget.amount))}'} with Stripe',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
