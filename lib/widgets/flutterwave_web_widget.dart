import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paystack_plus/flutter_paystack_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:user_web/model/formatter.dart';
import 'package:user_web/model/history.dart';
import 'package:user_web/widgets/flutterwave_credit_card_widget.dart';
import 'package:user_web/widgets/footer_widget.dart';
import 'package:user_web/widgets/web_menu.dart';

class FlutterwaveWebWidget extends StatefulWidget {
  const FlutterwaveWebWidget({super.key});

  @override
  State<FlutterwaveWebWidget> createState() => _FlutterwaveWebWidgetState();
}

class _FlutterwaveWebWidgetState extends State<FlutterwaveWebWidget> {
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
                              child: FlutterwaveCreditCardWidget(),
                            ),
                          ))
                    ],
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FlutterwaveCreditCardWidget(),
                ),
          const Gap(20),
          const FooterWidget()
        ],
      ),
    ));
  }
}

class PaystackForm extends StatefulWidget {
  const PaystackForm({super.key});

  @override
  State<PaystackForm> createState() => _PaystackFormState();
}

class _PaystackFormState extends State<PaystackForm> {
  final emailController = TextEditingController();
  final amountController = TextEditingController();
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

  updateWallet() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance.collection('users').doc(user!.uid).update(
        {'wallet': wallet + num.parse(amountController.text)}).then((value) {
      // // Get the current date and time
      // DateTime now = DateTime.now();

      // // Format the date to '24th January, 2024' format
      // String formattedDate = DateFormat('d MMMM, y').format(now);
      history(HistoryModel(
          message: 'Credit Alert',
          amount: amountController.text,
          paymentSystem: 'Paystack',
          timeCreated: DateTime.now()));
      Fluttertoast.showToast(
              msg: "Wallet has been uploaded successfully".tr(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 3,
              fontSize: 14.0)
          .then((value) {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    });
  }

  history(HistoryModel historyModel) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('Transaction History')
        .add(historyModel.toMap());
  }

  @override
  void initState() {
    getUserDetail();
    getPaystackDetails();
    amountController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  String generateRef() {
    final randomCode = Random().nextInt(3234234);
    return 'ref-$randomCode';
  }

  getPaystackDetails() {
    FirebaseFirestore.instance
        .collection('Payment System Details')
        .doc('Paystack')
        .snapshots()
        .listen((value) {
      if (mounted) {
        setState(() {
          getPaystackPublicKey = value['Public key'];
          getBackendUrl = value['banckendUrl'];
        });
      }
    });
  }

  String getPaystackPublicKey = '';
  String getBackendUrl = '';
  @override
  Widget build(BuildContext context) {
    return Center(
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
                    'Paystack Payment',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.black,
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
              controller: amountController,
              decoration: InputDecoration(
                hintText: 'Amount(₦)'.tr(),
              ),
            ),
            //   const Spacer(),
            const Gap(50),
            TextButton(
              onPressed: isLoading == true
                  ? null
                  : () async {
                      final ref = generateRef();
                      final amount = int.parse(amountController.text);
                      try {
                        return await FlutterPaystackPlus.openPaystackPopup(
                            publicKey: getPaystackPublicKey,
                            context: context,
                            secretKey: getBackendUrl,
                            currency: 'NGN',
                            customerEmail: emailController.text,
                            amount: (amount * 100).toString(),
                            reference: ref,
                            callBackUrl:
                                "[GET IT FROM YOUR PAYSTACK DASHBOARD]",
                            onClosed: () {
                              debugPrint('Could\'nt finish payment');
                            },
                            onSuccess: () {
                              updateWallet();
                              debugPrint('Payment successful');
                            });
                      } catch (e) {
                        debugPrint(e.toString());
                        // Fluttertoast.showToast(
                        //     msg: e.toString(),
                        //     toastLength: Toast.LENGTH_SHORT,
                        //     gravity: ToastGravity.TOP,
                        //     timeInSecForIosWeb: 1,
                        //     fontSize: 14.0);
                      }
                    },
              style: TextButton.styleFrom(
                shape: const BeveledRectangleBorder(),
                backgroundColor: Colors.green[400],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Pay${amountController.text.isEmpty ? '' : ' ₦${Formatter().converter(double.parse(amountController.text))}'} with Paystack',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
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
