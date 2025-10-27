import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_web/constant.dart';
import 'package:user_web/model/user.dart';
part 'profile_page_provider.g.dart';

@riverpod
class UserProfileNotifier extends _$UserProfileNotifier {
  @override
  Stream<UserModel> build() {
    return getUserDetail();
  }



  Stream<UserModel> getUserDetail() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .snapshots()
        .map((e) {
      return UserModel.fromMap(e.data()!, e.id);
    });
  }

  Future<void> updateUser(String fullname, String phonenumber,BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null && phonenumber.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'fullname': fullname,
        'phone': phonenumber,
      }).then((_) {
        // Fluttertoast.showToast(
        //   msg: "Update completed".tr(),
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.TOP,
        //   timeInSecForIosWeb: 6,
        //   fontSize: 14.0,
        // );

        showAlertsDialog(context, "Update completed");
      });
    } else {
      // Fluttertoast.showToast(
      //   msg: "Please check the phone number and try again.".tr(),
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.TOP,
      //   timeInSecForIosWeb: 6,
      //   fontSize: 14.0,
      // );
      showAlertDialog(context,"Alert","Please check the phone number and try again.");
    }
  }
}
