import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:user_web/constant.dart';
import 'package:user_web/model/chat_model.dart';

class ChatUserMessage extends StatefulWidget {
  final String userUid;
  final String comment;
  final DateTime timestamp;
  final String messageUID;
  final String chatUID;
  final bool updatingMessages;
  final ChatModel chatModel;
  final String collection;
  const ChatUserMessage({
    super.key,
    required this.userUid,
    required this.comment,
    required this.timestamp,
    required this.messageUID,
    required this.chatUID,
    required this.updatingMessages,
    required this.chatModel, required this.collection,
  });

  @override
  State<ChatUserMessage> createState() => _ChatUserMessageState();
}

class _ChatUserMessageState extends State<ChatUserMessage> {
  DocumentReference? userRef;
  DocumentReference? userDetails;
  String fullname = '';
  String email = '';
  String userPic = '';
  Future<void> _getUserDetails() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    setState(() {
      firestore
          .collection(widget.collection)
          .doc(widget.userUid)
          .snapshots()
          .listen((value) {
        if (value.exists) {
          setState(() {
            fullname = value['fullname'];
            email = value['email'];
            userPic = value['photoUrl'];
          });
        } else {
          setState(() {
            fullname = '';
            email = '';
            userPic = '';
          });
        }
      });
    });
  }

  @override
  void initState() {
    _getUserDetails();
    getCurrentUser();
    super.initState();
  }

  String currentUser = '';
  getCurrentUser() {
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    setState(() {
      currentUser = user!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Container(
              height: 50,
              width: 50,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: appColor),
              child: Center(
                child: Text(
                  fullname[0],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.r),
                ),
              ),
            ),
          ),
          const Gap(10),
          Flexible(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                  color: AdaptiveTheme.of(context).mode.isDark == false
                      ? const Color(0xFFE8E8EE)
                      : Colors.black26,
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullname,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.comment,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 11.r),
                    ),
                    const Gap(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          timeago.format(widget.timestamp, locale: 'en'),
                          style: TextStyle(fontSize: 8.r),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
