import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/email_settings_model.dart';
part 'email_settings_provider.g.dart';

@riverpod
class EmailSettingsNotifier extends _$EmailSettingsNotifier {
  @override
  EmailSettingsModel build() {
    // Initialize the state and set up listeners
    _initializeListeners();
    return EmailSettingsModel();
  }

  void _initializeListeners() {
    var logger = Logger();
    logger.d('email settings is being initialized');
    FirebaseFirestore.instance
        .collection('Email System')
        .doc('Email System')
        .snapshots()
        .listen((value) {
      state = state.copyWith(selectedPlatform: value['selectedPlatform']);
    });

    FirebaseFirestore.instance
        .collection('Email Status')
        .doc('Email Status')
        .snapshots()
        .listen((value) {
      state = state.copyWith(disableEmail: value['disable email']);
    });

    FirebaseFirestore.instance
        .collection('Email System Details')
        .doc('Mailgun')
        .snapshots()
        .listen((value) {
      state = state.copyWith(
        mailGunApi: value['apiKey'],
        mailGunDomain: value['domain'],
      );
    });

    FirebaseFirestore.instance
        .collection('Email System Details')
        .doc('Sendgrid')
        .snapshots()
        .listen((value) {
      state = state.copyWith(
        // nexmoApiKey: value['api key'],
        // nexmoNumber: value['nexmo number'],
        sendGridApi: value['apiKey'],
      );
    });
  }


 
}

