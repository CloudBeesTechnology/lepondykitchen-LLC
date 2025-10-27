import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/payment_settings_model.dart';
part 'payment_setting_provider.g.dart';

final CollectionReference paymentSystem =
    FirebaseFirestore.instance.collection('Payment System');

final CollectionReference paymentDetail =
    FirebaseFirestore.instance.collection('Payment System Details');

@riverpod
class PaymentSettingsProvider extends _$PaymentSettingsProvider {
  @override
  PaymentSettingsModel build() {
    initialized();
    return PaymentSettingsModel();
  }

  updateEnebleStripe() {
    var logger = Logger();
    state = state.copyWith(enableStripe: !state.enableStripe);
    logger.d('State is $state');
    return state.enableStripe;
  }

  updateEneblePaystack() {
    state = state.copyWith(enablePaystack: !state.enablePaystack);
    return state.enablePaystack;
  }

  updateEnebleFlutterwave() {
    state = state.copyWith(enableFlutterwave: !state.enableFlutterwave);
    return state.enableFlutterwave;
  }

  updateEnebleRazorpay() {
    state = state.copyWith(enableRazorpay: !state.enableRazorpay);
    return state.enableRazorpay;
  }

  initialized() {
    var logger = Logger();
    logger.d('Payment settings has been initialized');
    FirebaseFirestore.instance
        .collection('Payment System')
        .doc('Stripe')
        .snapshots()
        .listen((value) {
      state = state.copyWith(enableStripe: value['Stripe']);
      // logger.d(state.enableStripe);
    });

    FirebaseFirestore.instance
        .collection('Payment System')
        .doc('Paystack')
        .snapshots()
        .listen((value) {
      state = state.copyWith(enablePaystack: value['Paystack']);
    });

    FirebaseFirestore.instance
        .collection('Payment System')
        .doc('Flutterwave')
        .snapshots()
        .listen((value) {
      state = state.copyWith(enableFlutterwave: value['Flutterwave']);
    });

    FirebaseFirestore.instance
        .collection('Payment System')
        .doc('Razorpay')
        .snapshots()
        .listen((value) {
      state = state.copyWith(enableRazorpay: value['Razorpay']);
    });

    FirebaseFirestore.instance
        .collection('Payment System')
        .doc('Cash on delivery')
        .snapshots()
        .listen((value) {
      state = state.copyWith(enableCashondelivery: value['Cash on delivery']);
    });

    FirebaseFirestore.instance
        .collection('Payment System Details')
        .doc('Stripe')
        .snapshots()
        .listen((value) {
      state = state.copyWith(
          getPublishableKey: value['Publishable key'],
          getSecretKey: value['Secret Key']);
    });

    FirebaseFirestore.instance
        .collection('Payment System Details')
        .doc('Razorpay')
        .snapshots()
        .listen((value) {
      state = state.copyWith(getRazorPayKey: value['Razorpay']);
    });

    FirebaseFirestore.instance
        .collection('Payment System Details')
        .doc('Paystack')
        .snapshots()
        .listen((value) {
      state = state.copyWith(
          getPaystackPublicKey: value['Public key'],
          getBackendUrl: value['banckendUrl']);
    });

    FirebaseFirestore.instance
        .collection('Payment System Details')
        .doc('Flutterwave')
        .snapshots()
        .listen((value) {
      state = state.copyWith(
          getFlutterwavePublicKey: value['Public key'],
          getFlutterwaveSecretKey: value['Secret Key']);
    });
  }

  Future<void> updateStripe(String publishableKey, String secretKey) async {
    await paymentDetail.doc('Stripe').set({
      'Publishable key':
          publishableKey.isEmpty ? state.getPublishableKey : publishableKey,
      'Secret Key': secretKey.isEmpty ? state.getSecretKey : secretKey
    });
  }

  Future<void> updatePaystack(String publicKey, String backendUrl) async {
    await paymentDetail.doc('Paystack').set({
      'Public key': publicKey.isEmpty ? state.getPaystackPublicKey : publicKey,
      'banckendUrl': backendUrl.isEmpty ? state.getBackendUrl : backendUrl
    });
  }

  Future<void> updateFlutterwave(String publicKey, String encryptionKey) async {
    await paymentDetail.doc('Flutterwave').set({
      'Public key':
          publicKey.isEmpty ? state.getFlutterwavePublicKey : publicKey,
      'Secret Key':
          encryptionKey.isEmpty ? state.getFlutterwaveSecretKey : encryptionKey
    });
  }

  Future<void> updateRazorpay(String publicKey) async {
    await paymentDetail.doc('Razorpay').set(
        {'Razorpay': publicKey.isEmpty ? state.getRazorPayKey : publicKey});
  }

  Future<void> enableStripe(bool enableStripe) async {
    await paymentSystem.doc('Stripe').set({'Stripe': enableStripe});
  }

  Future<void> enableCashondelivery(bool enableCashondelivery) async {
    await paymentSystem
        .doc('Cash on delivery')
        .set({'Cash on delivery': enableCashondelivery});
  }

  Future<void> enableFlutterwave(bool enableFlutterwave) async {
    await paymentSystem
        .doc('Flutterwave')
        .set({'Flutterwave': enableFlutterwave});
  }

  Future<void> enableRazorpay(bool enableFlutterwave) async {
    await paymentSystem.doc('Razorpay').set({'Razorpay': enableFlutterwave});
  }

  Future<void> enablePaystack(bool enablePaystack) async {
    await paymentSystem.doc('Paystack').set({'Paystack': enablePaystack});
  }
}
