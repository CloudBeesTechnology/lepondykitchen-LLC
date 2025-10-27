// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe_web/flutter_stripe_web.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import '../../model/stripe_checkout_web.dart';

Future<void> pay(String amount, num wallet, bool showToast) async {
  try {
    await WebStripe.instance.confirmPaymentElement(
      ConfirmPaymentElementOptions(
        confirmParams: ConfirmPaymentParams(return_url: getReturnUrl()),
      ),
    );
  } catch (e) {
    print('e.runtimeType==== ${e.runtimeType}');
    print('THe ERROR IS $e');
    if (showToast == true) {
      Fluttertoast.showToast(
          msg: 'Please check your card and try again'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          fontSize: 14.0);
    }
    // ignore: unnecessary_null_comparison
    if (e == null) {
    } else {}
  }
}
//}

class PlatformPaymentElement extends StatefulWidget {
  const PlatformPaymentElement(
    this.clientSecret, {
    super.key,
    required this.amount,
    required this.wallet,
  });

  final String? clientSecret;
  final String amount;
  final num wallet;

  @override
  State<PlatformPaymentElement> createState() => _PlatformPaymentElementState();
}

class _PlatformPaymentElementState extends State<PlatformPaymentElement> {
  @override
  void initState() {
    pay(widget.amount, widget.wallet, false);
    super.initState();
  }

  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    return PaymentElement(
      autofocus: true,
      enablePostalCode: true,
      onCardChanged: (v) {
        logger.d(v);
        // updateWallet();
        // if(clientSecret.)
        if (v!.complete == true) {
          DateTime now = DateTime.now();

          // Format the date to '24th January, 2024' format
          String formattedDate = DateFormat('d MMMM, y').format(now);
          final FirebaseAuth auth = FirebaseAuth.instance;
          User? user = auth.currentUser;
          FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .update({'wallet': widget.wallet + num.parse(widget.amount)});
          FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('Transaction History')
              .add({
            'message': 'Credit Alert',
            'amount': widget.amount,
            'paymentSystem': 'Stripe',
            'timeCreated': formattedDate
          });
        }
      },
      clientSecret: widget.clientSecret ?? '',
    );
  }
}
