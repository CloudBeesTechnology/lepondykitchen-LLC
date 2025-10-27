import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'profile_provider.g.dart';

@riverpod
Future<String> getFullName( Ref ref) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  var result =
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
  // return result['fullname'].substring(0, result['fullname'].indexOf(" "));
  String fullname = result['fullname'];

  if (fullname.contains(' ')) {
    return fullname.substring(0, fullname.indexOf(' '));
  } else {
    return fullname; // return as it is if no space
  }
}

@riverpod
Stream<bool> getAuthListener( Ref ref) async* {
  var logger = Logger();
  yield* FirebaseAuth.instance.authStateChanges().map((User? user) {
    logger.d('User is Logged in value is $user');
    return user !=
        null; // Returns true if the user is authenticated, false if not
  });
}
