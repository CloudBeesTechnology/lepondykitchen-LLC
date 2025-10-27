import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:user_web/constant.dart';
import 'package:user_web/Providers/auth.dart';

import '../pages/otp_page3.dart';

class ForgotPasswordFormWidget extends StatefulWidget {
  const ForgotPasswordFormWidget({super.key});

  @override
  State<ForgotPasswordFormWidget> createState() =>
      _ForgotPasswordFormWidgetState();
}

class _ForgotPasswordFormWidgetState extends State<ForgotPasswordFormWidget> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController phoneController = TextEditingController();
  final _emailFieldKey = GlobalKey<FormBuilderFieldState>();
  bool showPassword = true;
  String phone = '';
  String dailCode = '+1';
  String password = '';
  String tokenID = '';

  // getToken() async {
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   setState(() {
  //     tokenID = token!;
  //   });
  // }

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> handleForgotPassword({
    required BuildContext context,
    required String phone,
    required String newPassword,
    }) async {

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get();

      if (querySnapshot.docs.isEmpty) {
       showErrorDialog(context, "Phone number not registered");
        return;
      }

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          showErrorDialog(context,e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          // Fluttertoast.showToast(msg: 'OTP sent successfully');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => OtpPage3(
                verificationId: verificationId,
                phone: phone,
                newPassword: newPassword,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      showErrorDialog(context,  "Error $e");
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
      key: _formKey,
      child: Column(
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
          const Gap(20),
          Align(
            alignment: MediaQuery.of(context).size.width >= 1100
                ? Alignment.center
                : Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width >= 1100 ? 0 : 0),
              child: Text(
                'Reset your password',
                style: TextStyle(
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize:
                        MediaQuery.of(context).size.width >= 1100 ? 20 : 20),
              ).tr(),
            ),
          ),
          const Gap(12),
          Padding(
            padding: MediaQuery.of(context).size.width >= 1100
                ? const EdgeInsets.only(left: 100, right: 100)
                : const EdgeInsets.all(8),
            child: const Text(
              'You can request a password reset below. We will send a security code to the phone number, please make sure it is correct.',
              textAlign: TextAlign.center,
            ).tr(),
          ),
          const Gap(20),
          SizedBox(
            width: MediaQuery.of(context).size.width >= 1100
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width / 1.2,
            child: Row(
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
          const SizedBox(height: 22),
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
              onChanged: (v) {
                setState(() {
                  password = v!;
                });
              },
              name: 'password',
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: AdaptiveTheme.of(context).mode.isDark == true
                      ? Colors.black
                      : null,
                ),
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
                FormBuilderValidators.match(
                  RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'),
                  errorText:
                  // 'Password must include:\n'
                  '• At least 8 characters\n'
                      '• An uppercase letter\n'
                      '• A lowercase letter\n'
                      '• A number\n'
                      '• A special character (!@#\$&*~)',
                ),
              ]),

            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width >= 1100
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width / 1.2,
            child: FormBuilderTextField(
              style: TextStyle(
                color: AdaptiveTheme.of(context).mode.isDark == true
                    ? Colors.black
                    : null,
              ),
              name: 'confirm_password',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: AdaptiveTheme.of(context).mode.isDark == true
                      ? Colors.black
                      : null,
                ),
                filled: true,
                border: InputBorder.none,
                fillColor: const Color.fromARGB(255, 236, 234, 234),
                hintText: 'Confirm Password'.tr(),
                suffixIcon: (_formKey.currentState?.fields['confirm_password']
                    ?.hasError ??
                    false)
                    ? const Icon(Icons.error, color: Colors.red)
                    : const Icon(Icons.check, color: Colors.green),
              ),
              obscureText: true,
              validator: (value) =>
              _formKey.currentState?.fields['password']?.value != value
                  ? 'Password didn\'t match'.tr()
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          const Gap(10),
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
              onPressed: () {
              if (_formKey.currentState?.saveAndValidate() ?? false) {
                context.loaderOverlay.show();
                final fullPhone = dailCode + phoneController.text.trim();
                handleForgotPassword(
                  context: context,
                  phone: fullPhone,
                  newPassword: password,
                ).then((value) {
                  if (context.mounted) {
                    context.loaderOverlay.hide();
                  }
                });
              }
              },
              child: const Text(
                'REQUEST PASSWORD RESET',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ).tr(),
            ),
          )
        ],
      ),
    );
  }
}
