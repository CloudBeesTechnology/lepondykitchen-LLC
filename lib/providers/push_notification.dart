import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/notifications.dart';
import '../constant.dart';

class PushNotificationFunction {
  static Future<void> sendPushNotification(
      String title, String msg, String token) async {
    final jsonCredentials = dotenv.env['GOOGLE_SERVICE_ACCOUNT_KEY'];
    if (jsonCredentials == null) {
      print('❌ GOOGLE_SERVICE_ACCOUNT_KEY missing from .env file');
      return;
    }

    final credentials =
        ServiceAccountCredentials.fromJson(json.decode(jsonCredentials));

    const scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final client = await clientViaServiceAccount(credentials, scopes);

    final url =
        'https://fcm.googleapis.com/v1/projects/$projectID/messages:send';

    final message = {
      "message": {
        "token": token,
        "notification": {"title": title, "body": msg},
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "id": "1",
          "status": "done"
        }
      }
    };

    try {
      final response = await client.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(message),
      );

      if (response.statusCode == 200) {
        print("✅ Notification sent successfully to $token");
      } else {
        print("❌ Failed to send notification: ${response.body}");
      }
    } catch (e) {
      print("⚠️ Error sending notification: $e");
    } finally {
      client.close();
    }
  }

  static sendFirebaseNotification(
      NotificationsModel notificationsModel, String userID, String uid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Notifications')
        .doc(uid)
        .set(notificationsModel.toMap());
  }
}
