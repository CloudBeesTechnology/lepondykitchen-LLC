import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/sms_settings_model.dart';
part 'sms_settings_provider.g.dart';

@riverpod
class SmsSettingsNotifier extends _$SmsSettingsNotifier {
  @override
  SmsSettingsState build() {
    // Initialize the state and set up listeners
    _initializeListeners();
    return SmsSettingsState();
  }

  void _initializeListeners() {
    var logger = Logger();
    logger.d('sms settings is being initialized');
    FirebaseFirestore.instance
        .collection('Sms System')
        .doc('Sms System')
        .snapshots()
        .listen((value) {
      state = state.copyWith(selectedPlatform: value['selectedPlatform']);
    });

    FirebaseFirestore.instance
        .collection('Whatsapp System')
        .doc('Whatsapp System')
        .snapshots()
        .listen((value) {
      state = state.copyWith(enableWhatsapp: value['enable whatsapp']);
    });

    FirebaseFirestore.instance
        .collection('Sms Status')
        .doc('Sms Status')
        .snapshots()
        .listen((value) {
      state = state.copyWith(enableSms: value['enable sms']);
    });

    FirebaseFirestore.instance
        .collection('Sms System Details')
        .doc('Twilio')
        .snapshots()
        .listen((value) {
      state = state.copyWith(
        twilioNumber: value['twilio number'],
        authToken: value['auth token'],
        accountSID: value['account sid'],
      );
    });

    FirebaseFirestore.instance
        .collection('Sms System Details')
        .doc('Nexmo')
        .snapshots()
        .listen((value) {
      state = state.copyWith(
        nexmoApiKey: value['api key'],
        nexmoNumber: value['nexmo number'],
        nexmoSecretKey: value['nexmo secretKey'],
      );
    });

    FirebaseFirestore.instance
        .collection('Sms System Details')
        .doc('Telesign')
        .snapshots()
        .listen((value) {
      state = state.copyWith(
        telesignApiKey: value['api key'],
        telesignCustomerID: value['customer id'],
      );
    });
  }

 
}


