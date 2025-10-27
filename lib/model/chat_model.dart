class ChatModel {
  final String userID;

  final String message;
  final DateTime timestamp;

  final String uid;

  ChatModel({
    required this.userID,
    required this.message,
    required this.timestamp,
    required this.uid,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      userID: json['userID'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']).toLocal(),
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toUtc(),
      'userID': userID,
      'message': message,
      'uid': uid,
    };
  }
}
