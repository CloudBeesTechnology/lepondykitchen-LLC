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
import '../widgets/login_form_widget.dart';
class OtpPage3 extends StatefulWidget {
  final String verificationId;
  final String phone;
  final String newPassword;

  const OtpPage3({
    super.key,
    required this.verificationId,
    required this.phone,
    required this.newPassword,
  });

  @override
  State<OtpPage3> createState() => _OtpPage3State();
}

class _OtpPage3State extends State<OtpPage3> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  bool isResendEnabled = true;
  DateTime? _nextResendAvailableAt;
  int _resendCooldownSeconds = 15;


  @override
  void initState() {
    super.initState();
  }

  Future<void> verifyOtpAndUpdatePassword() async {
    final smsCode = otpController.text.trim();
    final credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: smsCode,
    );

    try {
      // Sign in temporarily to verify OTP
      await auth.signInWithCredential(credential);

      // Update password in Firestore
      final userDocs = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: widget.phone)
          .get();

      if (userDocs.docs.isNotEmpty) {
        final userId = userDocs.docs.first.id;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'password': widget.newPassword});

        if (context.mounted) {
          // ✅ Hide loader before showing dialog
          context.loaderOverlay.hide();

          // ✅ Wait for user to tap OK
          await showAlertsDialog(context, "Password updated successfully");

          // ✅ Then navigate to login
          GoRouter.of(context).go('/login');
        }
      } else {
        if (context.mounted) context.loaderOverlay.hide();
        showErrorDialog(context, "User not found");
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) context.loaderOverlay.hide();
      showErrorDialog(context, "Invalid OTP: ${e.message}");
    } catch (e) {
      if (context.mounted) context.loaderOverlay.hide();
      showErrorDialog(context, "Error: $e");
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
    void dispose() {
      otpController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: MediaQuery
            .of(context)
            .size
            .width >= 1100
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
        body: MediaQuery
            .of(context)
            .size
            .width >= 1100
            ? Stack(
          children: [
            SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
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
                    child: Column(
                      mainAxisAlignment: MediaQuery
                          .of(context)
                          .size
                          .width >= 1100
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MediaQuery
                            .of(context)
                            .size
                            .width >= 1100 ? const Gap(85) : Gap(50),
                        MediaQuery
                            .of(context)
                            .size
                            .width >= 1100 ?
                        Image.asset(
                          AdaptiveTheme.of(context).mode.isDark == true ? verticalWhite :onlyLogo,
                          scale: 4,
                          // color: AdaptiveTheme
                          //     .of(context)
                          //     .mode
                          //     .isDark == true
                          //     ? Colors.white
                          //     : null,
                        ) : Image.asset(
                          AdaptiveTheme.of(context).mode.isDark == true ? verticalWhite :onlyLogo,
                          scale: 4,
                          // color: AdaptiveTheme
                          //     .of(context)
                          //     .mode
                          //     .isDark == true
                          //     ? Colors.white
                          //     : null,
                        ),
                        const Gap(35),
                        Align(
                          alignment: MediaQuery
                              .of(context)
                              .size
                              .width >= 1100
                              ? Alignment.center
                              : Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.all(
                               10.0),
                            child: Text(
                              'Please check your registered number for the OTP',
                              style: TextStyle(
                                  // color: Colors.orange.shade800,
                                  fontWeight: FontWeight.w600,
                                  fontSize:
                                  MediaQuery.of(context).size.width >= 1100 ? 15 : 12),
                            ).tr(),
                          ),
                        ),
                        const Gap(20),
                        Align(
                          alignment: MediaQuery
                              .of(context)
                              .size
                              .width >= 1100
                              ? Alignment.center
                              : Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery
                                    .of(context)
                                    .size
                                    .width >= 1100 ? 30 : 0),
                            child: Text(
                              'Enter Your OTP Code',
                              style: TextStyle(
                                  // color: Colors.orange.shade800,
                                  fontWeight: FontWeight.w600,
                                  fontSize:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width >= 1100 ? 18 : 15),
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
                            fieldOuterPadding: EdgeInsets.symmetric(
                                horizontal: 8), // 🔥 Control gap manually
                          ),
                          cursorColor: Colors.grey,
                          animationType: AnimationType.fade,
                          keyboardType: TextInputType.number,
                          backgroundColor: Colors.transparent,
                          enableActiveFill: false,
                          mainAxisAlignment: MainAxisAlignment
                              .center, // or center
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
                                textStyle: const TextStyle(
                                    color: Colors.white)),
                            // color: Theme.of(context).colorScheme.secondary,
                            onPressed: () {
                              context.loaderOverlay.show();
                              verifyOtpAndUpdatePassword();
                            },

                            child: const Text(
                              'Verify',
                              style:
                              TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ).tr(),
                          ),
                        ),
                        const Gap(20),
                        SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width >= 1100
                              ? MediaQuery
                              .of(context)
                              .size
                              .width / 2.4
                              : MediaQuery
                              .of(context)
                              .size
                              .width / 1.2,
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
            : Column(
          mainAxisAlignment: MediaQuery
              .of(context)
              .size
              .width >= 1100
              ? MainAxisAlignment.start
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MediaQuery
                .of(context)
                .size
                .width >= 1100 ? const Gap(85) : Gap(50),
            MediaQuery
                .of(context)
                .size
                .width >= 1100 ?
            Image.asset(
              AdaptiveTheme.of(context).mode.isDark == true ? verticalWhite :onlyLogo,
              scale: 4,
              // color: AdaptiveTheme
              //     .of(context)
              //     .mode
              //     .isDark == true
              //     ? Colors.white
              //     : null,
            ) : Image.asset(
              AdaptiveTheme.of(context).mode.isDark == true ? verticalWhite :onlyLogo,
              scale: 4,
              // color: AdaptiveTheme
              //     .of(context)
              //     .mode
              //     .isDark == true
              //     ? Colors.white
              //     : null,
            ),
            const Gap(25),
            Align(
              alignment: MediaQuery
                  .of(context)
                  .size
                  .width >= 1100
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
                      fontWeight: FontWeight.w500,
                      fontSize:
                      MediaQuery.of(context).size.width >= 1100 ? 17 : 13),
                ).tr(),
              ),
            ),
            const Gap(20),
            Align(
              alignment: MediaQuery
                  .of(context)
                  .size
                  .width >= 1100
                  ? Alignment.center
                  : Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery
                        .of(context)
                        .size
                        .width >= 1100 ? 65 : 0),
                child: Text(
                  'Enter Your OTP Code',
                  style: TextStyle(
                      // color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize:
                      MediaQuery
                          .of(context)
                          .size
                          .width >= 1100 ? 18 : 15),
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
                fieldOuterPadding: EdgeInsets.symmetric(
                    horizontal: 8), // 🔥 Control gap manually
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
                  ? MediaQuery.of(context).size.width / 2
                  : MediaQuery.of(context).size.width / 1.5,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const BeveledRectangleBorder(),
                    backgroundColor: appColor,
                    textStyle: const TextStyle(color: Colors.white)),
                // color: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  context.loaderOverlay.show();
                  verifyOtpAndUpdatePassword();
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
              width: MediaQuery
                  .of(context)
                  .size
                  .width >= 1100
                  ? MediaQuery
                  .of(context)
                  .size
                  .width / 2.4
                  : MediaQuery
                  .of(context)
                  .size
                  .width / 1.2,
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

