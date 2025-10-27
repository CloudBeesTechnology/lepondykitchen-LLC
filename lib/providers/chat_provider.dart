// Provider to handle Firebase Auth State
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_web/model/chat_model.dart';
import 'package:user_web/model/user.dart';
import 'package:uuid/uuid.dart';
part 'chat_provider.g.dart';

@riverpod
Stream<User?> authState( Ref ref) {
  return FirebaseAuth.instance.authStateChanges();
}

// Provider to get user details from Firestore
@riverpod
Stream<DocumentSnapshot> userDetails(Ref ref, String uid) {
  return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
}

// Provider to get messages from Firestore
@riverpod
Stream<List<ChatModel>> chatMessages(Ref ref, String userId, String riderId) {
  return FirebaseFirestore.instance
      .collection('Chats')
      .where('userID', isEqualTo: userId)
      .where('riderID', isEqualTo: riderId)
      .snapshots()
      .asyncMap((chatSnapshot) async {
        if (chatSnapshot.docs.isNotEmpty) {
          final chatUID = chatSnapshot.docs.first['uid'];
          final messageSnapshot = await FirebaseFirestore.instance
              .collection('Chats')
              .doc(chatUID)
              .collection('Messages')
              .orderBy('timestamp', descending: true)
              .get();

          return messageSnapshot.docs.map((doc) => ChatModel(
            // riderID: doc['riderID'],
            userID: doc['userID'],
            message: doc['message'],
            timestamp: doc['timestamp'].toDate(),
            uid: doc['uid'],
          )).toList();
        }
        return [];
      });
}

// Provider for posting a message
@riverpod
Future<void> postMessage( Ref ref, String chatUID, String message) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception('User not logged in');
  }

  const uuid = Uuid();
  final messageUID = uuid.v1();
  
  await FirebaseFirestore.instance
      .collection('Chats')
      .doc(chatUID)
      .collection('Messages')
      .doc(messageUID)
      .set({
        'timestamp': DateTime.now(),
        'userID': user.uid,
        'message': message,
        'uid': messageUID,
      });
}

// Provider for creating or updating a chat
@riverpod
Future<void> createOrUpdateChat( Ref ref, UserModel rider) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final chatCollection = FirebaseFirestore.instance.collection('Chats');
  final chatQuery = await chatCollection
      .where('userID', isEqualTo: user.uid)
      .where('riderID', isEqualTo: rider.uid)
      .get();

  if (chatQuery.docs.isEmpty) {
    // Create a new chat
    const uuid = Uuid();
    final chatUID = uuid.v1();
    await chatCollection.doc(chatUID).set({
      'riderID': rider.uid,
      'userID': user.uid,
      'timestamp': DateTime.now(),
      'uid': chatUID,
    });
    ref.read(postMessageProvider(chatUID, "Welcome to the chat!"));
  } else {
    // Update the existing chat
    for (var doc in chatQuery.docs) {
      await chatCollection.doc(doc['uid']).update({
        'timestamp': DateTime.now(),
      });
    }
  }
}