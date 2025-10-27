import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:random_string/random_string.dart';

import '../constant.dart';
import '../database/database.dart';
import '../widgets/login_form_widget.dart';
class OtpPage extends StatefulWidget {
  final String verificationId;
  final String fullname;
  final String phone;
  final String email;
  final String password;
  final String token;
  final String referralCode;
  final int referralBonus;
  final bool referralStatus;
  const OtpPage({
    super.key,
    required this.verificationId,
    required this.fullname,
    required this.phone,
    required this.email,
    required this.password,
    required this.token,
    required this.referralCode,
    required this.referralBonus,
    required this.referralStatus,

  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  bool isResendEnabled = true;
  DateTime? _nextResendAvailableAt;
  int _resendCooldownSeconds = 15;


  Future<bool> verifyOtpAndSaveUserData({
    required BuildContext context,
    required String verificationId,
    required String fullname,
    required String phone,
    required String password,
    required String email,
    required String token,
    required String referralCode,
    required int referralBonus,
    required bool referralStatus,
  }) async {
    String otp = otpController.text.trim();

    if (otp.isEmpty) {
      showErrorDialog(context, 'Please enter OTP');
      return false;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Save user data
        await Database(uid: user.uid).updateUserData(
          email,
          fullname,
          phone,
          password,
          token,
          referralCode,
        );

        // Add personalReferralCode
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'personalReferralCode': randomAlphaNumeric(8)});

        // Handle referral
        if (referralStatus && referralCode.trim().isNotEmpty) {
          final snapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('personalReferralCode', isEqualTo: referralCode)
              .get();

          for (var item in snapshot.docs) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(item.id)
                .collection('Referral Bonuses')
                .add({
              'Referral Bonus': referralBonus,
              'Claim Bonus': false,
              'Referred': fullname,
            });

            await FirebaseFirestore.instance
                .collection('users')
                .doc(item.id)
                .update({
              'wallet': (item['wallet'] ?? 0) + referralBonus,
            });

            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({'awardReferral': true});
          }
        }

        return true; // success
      }
      return false;
    } on FirebaseAuthException catch (_) {
      showErrorDialog(context, "Invalid OTP. Please try again.");
      return false;
    } catch (e) {
      showErrorDialog(context, e.toString());
      return false;
    }
  }



  Future<void> resendOtp() async {
    if (!isResendEnabled) return;

    setState(() {
      isResendEnabled = false; // Disable the button
    });

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: auth.currentUser?.phoneNumber ?? '',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          // Fluttertoast.showToast(
          //   msg: "Failed to resend OTP: ${e.message}",
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.CENTER,
          //   fontSize: 14.0,
          // );
          showErrorDialog(context,  "Failed to resend OTP: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          // Handle verificationId if needed
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle timeout if needed
        },
      );
    } catch (e) {
      // Fluttertoast.showToast(
      //   msg: "An unexpected error occurred: $e",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      //   fontSize: 14.0,
      // );
      showErrorDialog(context, "An unexpected error occurred: $e");
    } finally {
      otpController.clear();

      // Re-enable button after 15 seconds
      Future.delayed(const Duration(seconds: 15), () {
        if (mounted) {
          setState(() {
            isResendEnabled = true;
          });
        }
      });
    }
  }


  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }




  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MediaQuery.of(context).size.width >= 1100
          ? null
          : AppBar(automaticallyImplyLeading: false, actions: [
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: RichText(
        //     text: TextSpan(
        //         text: 'Don\'t have an account?',
        //         style: const TextStyle(
        //           color: Colors.black,
        //         ),
        //         children: <TextSpan>[
        //           TextSpan(
        //               text: ' Sign up',
        //               style: TextStyle(
        //                 color: appColor,
        //               ),
        //               recognizer: TapGestureRecognizer()
        //                 ..onTap = () {
        //                   context.push('/signup');
        //                 })
        //         ]),
        //   ),
        // ),
      ]),
      body: MediaQuery.of(context).size.width >= 1100
          ? Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Image.asset(
                    'assets/image/otp image.png',
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    scale: 1,
                  ),
                ),
                Expanded(
                    flex: 7, child: SizedBox(
                  child:Column(
                    mainAxisAlignment: MediaQuery.of(context).size.width >= 1100
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MediaQuery.of(context).size.width >= 1100 ? const Gap(85) : Gap(50) ,
                      MediaQuery.of(context).size.width >= 1100 ?
                      Image.asset(
                        AdaptiveTheme.of(context).mode.isDark == true ? verticalWhite :onlyLogo,
                        scale: 4,
                        // color: AdaptiveTheme.of(context).mode.isDark == true
                        //     ? Colors.white
                        //     : null,
                      ) :  Image.asset(
                        AdaptiveTheme.of(context).mode.isDark == true ? verticalWhite :onlyLogo,
                        scale: 4,
                        // color: AdaptiveTheme.of(context).mode.isDark == true
                        //     ? Colors.transparent
                        //     : null,
                      ),
                      const Gap(35),
                      Align(
                        alignment: MediaQuery.of(context).size.width >= 1100
                            ? Alignment.center
                            : Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(
                            10.0
                          ),
                          child: Text(
                            'Please check your registered number for the OTP',
                            style: TextStyle(
                                // color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize:
                                MediaQuery.of(context).size.width >= 1100 ? 15 : 12),
                          ).tr(),
                        ),
                      ),
                      const Gap(20),
                      Align(
                        alignment: MediaQuery.of(context).size.width >= 1100
                            ? Alignment.center
                            : Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width >= 1100 ? 30 : 0),
                          child: Text(
                            'Enter Your OTP Code',
                            style: TextStyle(
                                // color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize:
                                MediaQuery.of(context).size.width >= 1100 ? 18 : 15),
                          ).tr(),
                        ),
                      ),

                      // const SizedBox(height: 20),
                      const Gap(25),
                      PinCodeTextField(
                        controller: otpController,
                        appContext: context,
                        length: 6,
                        onChanged: (value) {},
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 40,
                          fieldWidth: 40,
                          borderWidth: 1,
                          inactiveColor: Colors.grey,
                          activeColor: Colors.grey,
                          selectedColor: Colors.grey,
                          inactiveFillColor: Colors.transparent,
                          activeFillColor: Colors.transparent,
                          selectedFillColor: Colors.transparent,
                          fieldOuterPadding: EdgeInsets.symmetric(horizontal: 12), // 🔥 Control gap manually
                        ),
                        cursorColor: Colors.grey,
                        animationType: AnimationType.fade,
                        keyboardType: TextInputType.number,
                        backgroundColor: Colors.transparent,
                        enableActiveFill: false,
                        mainAxisAlignment: MainAxisAlignment.center, // or center
                      ),
                      const Gap(20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width >= 1100
                            ? MediaQuery.of(context).size.width / 4.0
                            : MediaQuery.of(context).size.width / 1.2,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const BeveledRectangleBorder(),
                              backgroundColor: appColor,
                              textStyle: const TextStyle(color: Colors.white)),
                          // color: Theme.of(context).colorScheme.secondary,
                          onPressed: () async {
                            context.loaderOverlay.show();

                            final success = await verifyOtpAndSaveUserData(
                              context: context,
                              verificationId: widget.verificationId,
                              fullname: widget.fullname,
                              phone: widget.phone,
                              password: widget.password,
                              email: widget.email,
                              token: widget.token,
                              referralCode: widget.referralCode,
                              referralBonus: widget.referralBonus,
                              referralStatus: widget.referralStatus,
                            );

                            if (context.mounted) context.loaderOverlay.hide();

                            if (success && context.mounted) {
                              await showAlertsDialog(
                                context,
                                "Account created successfully\nYou got New user offer 10%",
                              );

                              if (context.mounted) {
                                GoRouter.of(context).go('/restaurant');
                              }
                            }
                          },

                          child: const Text(
                            'Verify',
                            style:
                            TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ).tr(),
                        ),
                      ),
                      const Gap(20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width >= 1100
                            ? MediaQuery.of(context).size.width / 2.4
                            : MediaQuery.of(context).size.width / 1.2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: 'Didn\'t receive OTP?',
                                  style: const TextStyle(
                                      // color: Colors.black,
                                      fontFamily: 'Nunito',
                                      fontSize: 18
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '  Resend Again',
                                      style: TextStyle(
                                        color: isResendEnabled ? Colors.orange.shade800 : Colors.grey,
                                        fontFamily: 'Nunito',
                                        fontSize: 18,
                                      ),
                                      recognizer: isResendEnabled
                                          ? (TapGestureRecognizer()..onTap = resendOtp)
                                          : null,
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                      // Icon(Bootstrap.google)
                    ],
                  ),
                ))
              ],
            ),
          ),
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: InkWell(
          //     onTap: () {
          //       context.push('/');
          //     },
          //     child: Image.asset(
          //       logo,
          //       scale: 6,
          //     ),
          //   ),
          // ),
          // Align(
          //   alignment: Alignment.topRight,
          //   child: Padding(
          //     padding: const EdgeInsets.only(top: 15, right: 15),
          //     child: RichText(
          //       text: TextSpan(
          //           text: 'Don\'t have an account?',
          //           style: const TextStyle(
          //             color: Colors.black,
          //           ),
          //           children: <TextSpan>[
          //             TextSpan(
          //                 text: ' Sign up',
          //                 style: TextStyle(
          //                   color: appColor,
          //                 ),
          //                 recognizer: TapGestureRecognizer()
          //                   ..onTap = () {
          //                     context.push('/signup');
          //                   })
          //           ]),
          //     ),
          //   ),
          // )
        ],
      )
          :  Column(
        mainAxisAlignment: MediaQuery.of(context).size.width >= 1100
            ? MainAxisAlignment.start
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MediaQuery.of(context).size.width >= 1100 ? const Gap(85) : Gap(50) ,
          MediaQuery.of(context).size.width >= 1100 ?
          Image.asset(
            AdaptiveTheme.of(context).mode.isDark == true ? verticalWhite :onlyLogo,
            scale: 4,
            // color: AdaptiveTheme.of(context).mode.isDark == true
            //     ? Colors.white
            //     : null,
          ) :  Image.asset(
            AdaptiveTheme.of(context).mode.isDark == true ? verticalWhite :onlyLogo,
            scale: 4,
            // color: AdaptiveTheme.of(context).mode.isDark == true
            //     ? Colors.white
            //     : null,
          ),
          const Gap(25),
          Align(
            alignment: MediaQuery.of(context).size.width >= 1100
                ? Alignment.center
                : Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(
                  10.0),
              child: Text(
                'Please check your registered number for the OTP',
                style: TextStyle(
                    // color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize:
                    MediaQuery.of(context).size.width >= 1100 ? 17 : 13),
              ).tr(),
            ),
          ),
          const Gap(20),
          Align(
            alignment: MediaQuery.of(context).size.width >= 1100
                ? Alignment.center
                : Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width >= 1100 ? 65 : 0),
              child: Text(
                'Enter Your OTP Code',
                style: TextStyle(
                    // color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize:
                    MediaQuery.of(context).size.width >= 1100 ? 18 : 15),
              ).tr(),
            ),
          ),

          // const SizedBox(height: 20),
          const Gap(25),
          PinCodeTextField(
            controller: otpController,
            appContext: context,
            length: 6,
            onChanged: (value) {},
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 40,
              fieldWidth: 40,
              borderWidth: 1,
              inactiveColor: Colors.black,
              activeColor: Colors.black,
              selectedColor: Colors.black,
              inactiveFillColor: Colors.transparent,
              activeFillColor: Colors.transparent,
              selectedFillColor: Colors.transparent,
              fieldOuterPadding: EdgeInsets.symmetric(horizontal: 8), // 🔥 Control gap manually
            ),
            cursorColor: Colors.black,
            animationType: AnimationType.fade,
            keyboardType: TextInputType.number,
            backgroundColor: Colors.transparent,
            enableActiveFill: false,
            mainAxisAlignment: MainAxisAlignment.center, // or center
          ),
          const Gap(20),
          SizedBox(
            width: MediaQuery.of(context).size.width >= 1100
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width / 1.5,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const BeveledRectangleBorder(),
                  backgroundColor: appColor,
                  textStyle: const TextStyle(color: Colors.white)),
              // color: Theme.of(context).colorScheme.secondary,
              onPressed: () async {
                context.loaderOverlay.show();

                final success = await verifyOtpAndSaveUserData(
                  context: context,
                  verificationId: widget.verificationId,
                  fullname: widget.fullname,
                  phone: widget.phone,
                  password: widget.password,
                  email: widget.email,
                  token: widget.token,
                  referralCode: widget.referralCode,
                  referralBonus: widget.referralBonus,
                  referralStatus: widget.referralStatus,
                );

                if (context.mounted) context.loaderOverlay.hide();

                if (success && context.mounted) {
                  await showAlertsDialog(
                    context,
                    "Account created successfully\nYou got New user offer 10%",
                  );

                  if (context.mounted) {
                    GoRouter.of(context).go('/restaurant');
                  }
                }
              },
              child: const Text(
                'Verify',
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ).tr(),
            ),
          ),
          const Gap(20),
          SizedBox(
            width: MediaQuery.of(context).size.width >= 1100
                ? MediaQuery.of(context).size.width / 2.4
                : MediaQuery.of(context).size.width / 1.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                      text: 'Didn\'t receive OTP?',
                      style: const TextStyle(
                          // color: Colors.black,
                          fontFamily: 'Nunito',
                          fontSize: 16
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '  Resend Again',
                          style: TextStyle(
                            color: isResendEnabled ? Colors.orange.shade800 : Colors.grey,
                            fontFamily: 'Nunito',
                            fontSize: 16,
                          ),
                          recognizer: isResendEnabled
                              ? (TapGestureRecognizer()..onTap = resendOtp)
                              : null,
                        ),
                      ]),
                ),
              ],
            ),
          ),
          // Icon(Bootstrap.google)
        ],
      ),
    );
  }
}
