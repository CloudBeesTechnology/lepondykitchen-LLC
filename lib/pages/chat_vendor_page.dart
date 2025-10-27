// ignore_for_file: avoid_print
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/constant.dart';
import 'package:uuid/uuid.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../model/chat_model.dart';
import '../providers/push_notification.dart';
import '../widgets/chat_user_message_widget.dart';
import '../widgets/edit_chat_widget.dart';

class ChatVendorPage extends StatefulWidget {
  final String vendorID;
  const ChatVendorPage({
    super.key,
    required this.vendorID,
  });

  @override
  State<ChatVendorPage> createState() => _ChatVendorPageState();
}

class _ChatVendorPageState extends State<ChatVendorPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    getMessages();
    getReceiverToken();
    _getUserDetails();
    getAuth();

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  String text = '';
  String chatUID = '';
  int onLongPress = -1;
  DocumentReference? userRef;
  DocumentReference? userDetails;
  String fullname = '';
  String email = '';
  String phone = '';
  String callerToken = '';
  String receiverToken = '';
  String userName = '';
  var logger = Logger();

  Future<void> _getUserDetails() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    User? user = auth.currentUser;
    if (mounted) {
      setState(() {
        firestore
            .collection('users')
            .doc(user!.uid)
            .snapshots()
            .listen((value) {
          setState(() {
            email = value['email'];
            fullname = value['fullname'];
            phone = value['phone'];
            callerToken = value['tokenID'];
          });
        });
      });
    }
  }

  getReceiverToken() {
    FirebaseFirestore.instance
        .collection('vendors')
        .doc(widget.vendorID)
        .snapshots()
        .listen((event) {
      if (mounted) {
        setState(() {
          receiverToken = event['tokenID'];
          userName = event['fullname'];
        });
      }
    });
  }

  void postMessage(String text) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user == null) {
      // Handle the case where the user is null
      print("User is not logged in.");
      return;
    }
    if (mounted) {
      setState(() {
        updatingMessages = true;
      });
    }

    // Check if there's an existing chat between this user and the rider
    FirebaseFirestore.instance
        .collection('Chats Vendor')
        .where('userID', isEqualTo: user.uid)
        .where('vendorID', isEqualTo: widget.vendorID)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        // No chat exists, create a new one
        createNewChat(user, text);
      } else {
        // Chat exists, update the existing one
        updateExistingChat(value.docs, user);
      }
    }).catchError((error) {
      print("Error fetching chats: $error");
    });

    // Send push notification
    PushNotificationFunction.sendPushNotification(
        appName, 'You have a new message', receiverToken);
  }

// Function to create a new chat
  void createNewChat(User user, String text) {
    var uuid = const Uuid();
    String mainUID = uuid.v1();

    FirebaseFirestore.instance.collection('Chats Vendor').doc(mainUID).set({
      'vendorID': widget.vendorID,
      'userID': user.uid,
      'timestamp': DateTime.now(),
      'uid': mainUID,
    }).then((_) {
      if (mounted) {
        setState(() {
          updatingMessages = false;
        });
      }
      sendMessage(mainUID, user, text);
    }).catchError((error) {
      print("Error creating chat: $error");
    });
  }

// Function to update an existing chat
  void updateExistingChat(List<DocumentSnapshot> chatDocs, User user) {
    for (var doc in chatDocs) {
      FirebaseFirestore.instance
          .collection('Chats Vendor')
          .doc(doc['uid'])
          .update({'timestamp': DateTime.now()}).then((_) {
        sendMessage(doc['uid'], user, text);
      }).catchError((error) {
        print("Error updating chat: $error");
      });
    }
  }

// Function to send a message
  void sendMessage(String chatUID, User user, String text) {
    var uuid = const Uuid();
    String messageUID = uuid.v1();
    FirebaseFirestore.instance
        .collection('Chats Vendor')
        .doc(chatUID)
        .collection('Messages')
        .doc(messageUID)
        .set({
      'timestamp': DateTime.now(),
      'userID': user.uid,
      // 'vendorID': widget.vendorID,
      'message': text, // Ensure 'text' is properly defined and initialized
      'uid': messageUID,
    }).then((_) {
      if (mounted) {
        setState(() {
          _formKey.currentState!.reset();
          updatingMessages = false;
        });
      }
    }).catchError((error) {
      print("Error sending message: $error");
    });
  }

  List<ChatModel> messages = [];
  bool loading = false;
  bool updatingMessages = false;

  void getMessages() {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user == null) {
      // Handle case where user is not logged in
      print("User is not logged in.");
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
      return;
    }

    // Fetch chat for the current user and rider
    FirebaseFirestore.instance
        .collection('Chats Vendor')
        .where('userID', isEqualTo: user.uid)
        .where('vendorID', isEqualTo: widget.vendorID)
        .snapshots()
        .listen((chatSnapshot) {
      if (chatSnapshot.docs.isNotEmpty) {
        if (mounted) {
          setState(() {
            // If a chat exists
            chatUID = chatSnapshot.docs.first['uid'];
            logger.d('Chat id is $chatUID');
            fetchMessages(chatUID);
          });
        }
      } else {
        // No chat found
        if (mounted) {
          setState(() {
            loading = false;
          });
        }
        print("No chat found between user and rider.");
      }
    }, onError: (error) {
      // Handle error case
      print("Error fetching chats: $error");
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
  }

// Function to fetch messages for a given chatUID
  void fetchMessages(String chatUID) {
    FirebaseFirestore.instance
        .collection('Chats Vendor')
        .doc(chatUID)
        .collection('Messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((messageSnapshot) {
      if (mounted) {
        setState(() {
          messages.clear();
          loading = false; // Set loading to false after fetching messages
        });
      }

      for (var doc in messageSnapshot.docs) {
        var result = ChatModel(
          // vendorID: doc.data()['vendorID'],
          userID: doc.data()['userID'],
          message: doc.data()['message'],
          timestamp: doc.data()['timestamp'].toDate(),
          uid: doc.data()['uid'],
        );
        if (mounted) {
          setState(() {
            messages.add(result);
          });
        }
      }

      print('Messages: $messages');
    }, onError: (error) {
      // Handle error case
      print("Error fetching messages: $error");
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  String currentUser = '';
  getAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
      } else {
        if (mounted) {
          setState(() {
            currentUser = user.uid;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('loading is $loading');
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(userName),
      ),
      body: loading == true
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: 5, // Replace with the actual number of chat items
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          radius: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: double.infinity,
                                height: 16,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : CustomScrollView(
              reverse: true,
              slivers: [
                const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        childCount: messages.length, (context, index) {
                  ChatModel chatModel = messages[index];
                  return chatModel.userID == currentUser
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onLongPress: () {
                                setState(() {
                                  onLongPress = index;
                                });
                                showMaterialModalBottomSheet(
                                    expand: false,
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => Material(
                                          child: SafeArea(
                                            top: false,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ListTile(
                                                  title: const Text('Edit Chat')
                                                      .tr(),
                                                  leading: const Icon(
                                                      Icons.edit,
                                                      color: Colors.blue),
                                                  onTap: () {
                                                    setState(() {
                                                      updatingMessages = true;
                                                    });
                                                    showMaterialModalBottomSheet(
                                                        expand: false,
                                                        context: context,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        builder:
                                                            (context) =>
                                                                Material(
                                                                  child: SafeArea(
                                                                      top: false,
                                                                      child: EditChatWidget(
                                                                        chatModel:
                                                                            chatModel,
                                                                        chatUID:
                                                                            chatUID,
                                                                        message:
                                                                            chatModel.message,
                                                                        messageUID:
                                                                            chatModel.uid,
                                                                      )),
                                                                )).then(
                                                        (value) {
                                                      setState(() {
                                                        updatingMessages =
                                                            false;
                                                      });
                                                      if (context.mounted) {
                                                        Navigator.pop(context);
                                                      }
                                                    });
                                                  },
                                                ),
                                                ListTile(
                                                  title:
                                                      const Text('Delete').tr(),
                                                  leading:
                                                      const Icon(Icons.delete),
                                                  onTap: () {
                                                    setState(() {
                                                      updatingMessages = true;
                                                    });
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            'Chats Vendor')
                                                        .doc(chatUID)
                                                        .collection('Messages')
                                                        .doc(chatModel.uid)
                                                        .delete()
                                                        .then((value) {
                                                      setState(() {
                                                        updatingMessages =
                                                            false;
                                                      });
                                                      Fluttertoast.showToast(
                                                              msg:
                                                                  "Message has been deleted"
                                                                      .tr(),
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .TOP,
                                                              timeInSecForIosWeb:
                                                                  3,
                                                          backgroundColor:  const Color(0xFFFFD581),
                                                            textColor: Colors.black,
                                                          webBgColor: "#FFD581",
                                                            webPosition: "center",
                                                              fontSize: 14.0)
                                                          .then((value) {
                                                        setState(() {
                                                          onLongPress = -1;
                                                        });

                                                        print(onLongPress);
                                                      });

                                                      if (context.mounted) {
                                                        Navigator.pop(context);
                                                      }
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        )).then((value) {
                                  setState(() {
                                    onLongPress = -1;
                                  });

                                  print(onLongPress);
                                });
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                width: MediaQuery.of(context).size.width / 2,
                                decoration: BoxDecoration(
                                    color:
                                        AdaptiveTheme.of(context).mode.isDark ==
                                                false
                                            ? const Color(0xFFE8E8EE)
                                            : Colors.black26,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        chatModel.message,
                                        textAlign: TextAlign.left,
                                        style: onLongPress == index
                                            ? TextStyle(
                                                fontSize: 11.r,
                                                color: Colors.blue)
                                            : TextStyle(
                                                fontSize: 11.r,
                                              ),
                                      ),
                                      const Gap(5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            timeago.format(chatModel.timestamp,
                                                locale: 'en'),
                                            style: TextStyle(fontSize: 8.r),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : ChatUserMessage(
                          collection: 'vendors',
                          chatModel: chatModel,
                          chatUID: chatUID,
                          messageUID: chatModel.uid,
                          updatingMessages: updatingMessages,
                          timestamp: chatModel.timestamp,
                          userUid: widget.vendorID,
                          comment: chatModel.message,
                        );
                })),
              ],
            ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: TextFormField(
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
            autofocus: false,
            decoration: InputDecoration(
                suffixIcon: text == ''
                    ? null
                    : IconButton(
                        onPressed: text == '' || updatingMessages == true
                            ? null
                            : () {
                                //  postChat();
                                if (_formKey.currentState!.validate()) {
                                  postMessage(text);
                                  // getMessages();
                                }
                                // setState(() {
                                //   text = '';
                                // });
                              },
                        icon: const Icon(Icons.send)),
                hintText: 'Write your message',
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)))),
          ),
        ),
      ),
    );
  }
}
