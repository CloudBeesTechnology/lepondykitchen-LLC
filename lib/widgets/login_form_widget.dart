import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:user_web/constant.dart';
import 'package:user_web/Providers/auth.dart';

import '../pages/otp_page.dart';
import '../pages/otp_page2.dart';
// import 'package:icons_plus/icons_plus.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKeyLogin = GlobalKey<FormBuilderState>();
  final TextEditingController phoneController = TextEditingController();
  final _emailFieldKeyLogin = GlobalKey<FormBuilderFieldState>();

  bool showPassword = true;
  String dailCode = '+1';
  String phone = '';
  String email = '';
  String password = '';
  String tokenID = '';

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login(BuildContext context) async {
      String fullPhone = dailCode + phone;
      try {
        // 1. Check if user exists in Firestore
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('phone', isEqualTo: fullPhone)
            .get();

        if (snapshot.docs.isEmpty) {
          showErrorDialog(context,'Phone Number not registered');

          // Fluttertoast.showToast(
          //   msg: 'Phone number not registered',
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.CENTER,
          //   backgroundColor: Colors.blueAccent,
          //   textColor: Colors.white,
          //   fontSize: 14.0,
          //   timeInSecForIosWeb: 3,
          //   webBgColor: "#116fc2", // for web only
          //   webPosition: "center", // for web only
          // );

          return;
        }

        final userData = snapshot.docs.first.data();
        if (userData['password'] != password) {
          showErrorDialog(context,'Incorrect Password');
          return;
        }

        // 2. Send OTP using Firebase
        await auth.verifyPhoneNumber(
          phoneNumber: fullPhone,
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {
            showErrorDialog(context,e.message ?? 'Verification failed');
          },
          codeSent: (String verificationId, int? resendToken) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => OtpPage2(
                  verificationId: verificationId,
                ),
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } catch (e) {
        showErrorDialog(context,'Login error : $e');
      }

  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AdaptiveTheme.of(context).mode.isDark
              ? Colors.grey[900]
              : Colors.white,
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
    // getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKeyLogin,
      child: Column(
        mainAxisAlignment: MediaQuery.of(context).size.width >= 1100
            ? MainAxisAlignment.start
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MediaQuery.of(context).size.width >= 1100 ? const Gap(85) : Gap(50) ,
          MediaQuery.of(context).size.width >= 1100 ?
            Image.asset(
              AdaptiveTheme.of(context).mode.isDark == true ? verticalWhite : onlyLogo,
              scale: 3,
              // color: AdaptiveTheme.of(context).mode.isDark == true
              //     ? Colors.white
              //     : null,
            ) :  Image.asset(
            AdaptiveTheme.of(context).mode.isDark == true ? verticalWhite :onlyLogo,
            scale: 3,
            // color: AdaptiveTheme.of(context).mode.isDark == true
            //     ? Colors.white
            //     : null,
          ),
          const Gap(35),
          Align(
            alignment: MediaQuery.of(context).size.width >= 1100
                ? Alignment.bottomLeft
                : Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width >= 1100 ? 65 : 0),
              child: Text(
                'Sign in to continue.',
                style: TextStyle(
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize:
                        MediaQuery.of(context).size.width >= 1100 ? 20 : 18),
              ).tr(),
            ),
          ),
          const Gap(20),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width >= 1100
          //       ? MediaQuery.of(context).size.width / 2
          //       : MediaQuery.of(context).size.width / 1.2,
          //   child: FormBuilderTextField(
          //     style: TextStyle(
          //       color: AdaptiveTheme.of(context).mode.isDark == true
          //           ? Colors.black
          //           : null,
          //     ),
          //     onChanged: (v) {
          //       setState(() {
          //         email = v!;
          //       });
          //     },
          //     key: _emailFieldKeyLogin,
          //     name: 'login email',
          //     decoration: InputDecoration(
          //       filled: true,
          //       border: InputBorder.none,
          //       hintStyle: TextStyle(
          //           color: AdaptiveTheme.of(context).mode.isDark == true
          //               ? Colors.black
          //               : null),
          //       fillColor: const Color.fromARGB(255, 236, 234, 234),
          //       hintText: 'Email'.tr(),
          //       //border: OutlineInputBorder()
          //     ),
          //     validator: FormBuilderValidators.compose([
          //       FormBuilderValidators.required(),
          //       FormBuilderValidators.email(),
          //     ]),
          //   ),
          // ),
          SizedBox(
            width: MediaQuery.of(context).size.width >= 1100
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width / 1.2,
            child:Row(
              children: [
                CountryCodePicker(
                  dialogTextStyle: TextStyle(
                    color: AdaptiveTheme.of(context).mode.isDark == true
                        ? Colors.black
                        : null,
                  ),
                  showDropDownButton: true,
                  //    backgroundColor: Color.fromARGB(255, 236, 234, 234),
                  onChanged: (v) {
                    setState(() {
                      dailCode = v.dialCode!;
                    });
                  },
                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                  initialSelection: 'US',
                  // favorite: const ['+39', 'FR'],
                  //  countryFilter: const ['IT', 'FR'],
                  showFlagDialog: true,
                  comparator: (a, b) => b.name!.compareTo(a.name!),
                  //Get the country information relevant to the initial selection
                  onInit: (code) {
                    // setState(() {
                    //   dailCode = code!.dialCode!;
                    // });
                  },
                ),
                Expanded(
                  flex: 6,
                  child: FormBuilderTextField(
                    controller: phoneController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: TextStyle(
                      color: AdaptiveTheme.of(context).mode.isDark == true
                          ? Colors.black
                          : null,
                    ),
                    onChanged: (v) {
                      setState(() {
                        phone = v!;
                      });
                    },
                    name: 'number',
                    maxLength: 10,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: AdaptiveTheme.of(context).mode.isDark == true
                            ? Colors.black
                            : null,
                      ),
                      filled: true,
                      counterText: "",
                      border: InputBorder.none,
                      fillColor: const Color.fromARGB(255, 236, 234, 234),
                      hintText: 'XXXX XXX XXX',
                      //border: OutlineInputBorder()
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric()
                    ]),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width >= 1100
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width / 1.2,
            child: FormBuilderTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: TextStyle(
                color: AdaptiveTheme.of(context).mode.isDark == true
                    ? Colors.black
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  password = value!;
                });
              },
              name: 'login password',
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: AdaptiveTheme.of(context).mode.isDark == true
                        ? Colors.black
                        : null),
                suffixIcon: showPassword == true
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            showPassword = false;
                          });
                        },
                        child: const Icon(
                          Icons.visibility,
                          color: Colors.grey,
                          size: 30,
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          setState(() {
                            showPassword = true;
                          });
                        },
                        child: const Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
                filled: true,
                border: InputBorder.none,
                fillColor: const Color.fromARGB(255, 236, 234, 234),
                hintText: 'Password'.tr(),
                //   border: OutlineInputBorder()
              ),
              obscureText: showPassword,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),
          ),
          const Gap(10),
          SizedBox(
            width: MediaQuery.of(context).size.width >= 1100
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width / 1.2,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    context.go('/forgot-password');
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      color: Colors.orange.shade900,
                    ),
                  ).tr(),
                ),
              ],
            ),
          ),
          const Gap(20),
          SizedBox(
            width: MediaQuery.of(context).size.width >= 1100
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width / 1.2,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const BeveledRectangleBorder(),
                  backgroundColor: appColor,
                  textStyle: const TextStyle(color: Colors.white)),
              // color: Theme.of(context).colorScheme.secondary,
              onPressed: () async {
                if (_formKeyLogin.currentState?.saveAndValidate() ?? false) {
                  context.loaderOverlay.show();


                  try {
                    await login(context);
                  } finally {
                    if (context.mounted) {
                      context.loaderOverlay.hide();
                    }
                  }


                  // AuthService()
                  //     .signIn(email, password, context, tokenID)
                  //     .then((value) {
                  //   if (context.mounted) {
                  //     context.loaderOverlay.hide();
                  //   }
                  // });


                }
              },
              child: const Text(
                'SIGN IN',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ).tr(),
            ),
          ),
          const Gap(10),
          Padding(
            padding: const EdgeInsets.only(top: 15, right: 15),
            child: RichText(
              text: TextSpan(
                  text: 'Don\'t have an account?',
                  style: TextStyle(
                    color: AdaptiveTheme.of(context).mode.isDark == true
                        ? Colors.white
                        : Colors.black,
                    fontSize: MediaQuery.of(context).size.width >= 1100 ? 17 : 15,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' Sign up',
                        style: TextStyle(
                          color: Colors.orange.shade900,
                          fontSize: MediaQuery.of(context).size.width >= 1100 ? 17 : 15,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.go('/signup');
                          })
                  ]),
            ),
          ),
          // Icon(Bootstrap.google)
        ],
      ),
    );
  }
}
