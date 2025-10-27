class NotificationsModel {
  final String uid;
  final String heading;
  final String content;
  final String orderId;

  NotificationsModel({required this.uid, required this.heading, required this.content,required this.orderId});

  NotificationsModel.fromMap(Map<String, dynamic> data, this.uid)
      : heading = data['heading'],
        content = data['content'],
        orderId = data['orderId'];

  Map<String, dynamic> toMap() {
    return {'heading': heading, 'content': content,'orderId':orderId};
  }
}
