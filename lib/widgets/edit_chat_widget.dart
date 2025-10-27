import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../model/chat_model.dart';

class EditChatWidget extends StatefulWidget {
  final String chatUID;
  final String messageUID;
  final String message;
  final ChatModel chatModel;
  const EditChatWidget(
      {super.key,
      required this.chatUID,
      required this.messageUID,
      required this.message,
      required this.chatModel});

  @override
  State<EditChatWidget> createState() => _EditChatWidgetState();
}

class _EditChatWidgetState extends State<EditChatWidget> {
  @override
  void initState() {
    var uuid = const Uuid();
    uid = uuid.v1();
    super.initState();
  }

  postComment(String text) {
    FirebaseFirestore.instance
        .collection('Chats')
        .doc(widget.chatUID)
        .collection('Messages')
        .doc(widget.messageUID)
        .update({'message': text}).then((value) {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  String? uid;
  // String? userId;
  String? username;
  String? profileImageUrl;
  String? text;
  List<String> likes = [];
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: TextFormField(
            initialValue: widget.message,
            validator: (v) {
              if (v!.isEmpty) {
                return 'Required field';
              } else {
                return null;
              }
            },
            onChanged: (v) {
              setState(() {
                text = v;
              });
            },
            autofocus: true,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: text == ''
                        ? null
                        : () {
                            postComment(text == null ? widget.message : text!);
                            _formKey.currentState!.reset();
                          },
                    icon: const Icon(Icons.send)),
                hintText: 'Edit Message',
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)))),
          ),
        ),
      ),
    );
  }
}
