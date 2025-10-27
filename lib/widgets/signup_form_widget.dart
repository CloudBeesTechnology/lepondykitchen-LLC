import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_web/firebase_auth_web.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
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
import '../pages/terms2_page.dart';
import '../pages/terms_page.dart';


class SignupFormWidget extends StatefulWidget {
  const SignupFormWidget({super.key});

  @override
  State<SignupFormWidget> createState() => _SignupFormWidgetState();
}

class _SignupFormWidgetState extends State<SignupFormWidget> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _emailFieldKey = GlobalKey<FormBuilderFieldState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool showPassword = true;
  String fullname = '';
  String email = '';
  String phone = '';
  String password = '';
  String dailCode = '+1';
  // final _formKey = GlobalKey<FormState>();
  // Timer? oneSignalTimer;
  String playerId = '';
  String getOnesignalKey = '';
  String referralCode = '';
  bool referralStatus = false;
  num? reward;



  final FirebaseAuth auth = FirebaseAuth.instance;


  Future<void> signUpWithPhone(
      String phone,
      String fullname,
      String email,
      BuildContext context,
      String password,
      String referralCode,
      referralBonus,
      bool referralStatus,
      String token,
      ) async {
    try {
      // 1. Check if phone number already exists
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get();

      if (snapshot.docs.isNotEmpty) {
       showErrorDialog(context, "Phone number already exists");
        return;
      }

      // 2. If phone number not found, send OTP
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        // timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // await FirebaseAuth.instance.signInWithCredential(credential);
          // You can call your saveUserData() method here if needed
        },
        verificationFailed: (FirebaseAuthException e) {
         showErrorDialog(context, e.message ?? "Phone verification failed");
        },
        codeSent: (String verificationId, int? resendToken) {
          // ✅ Navigate to OTP screen using normal Navigator
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OtpPage(
                verificationId: verificationId,
                fullname: fullname,
                phone: phone,
                email: email,
                password: password,
                token: token,
                referralCode: referralCode,
                referralBonus: referralBonus,
                referralStatus: referralStatus,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
     showErrorDialog(context, e.toString());
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
    // _retrieveToken();
    getReferralStatus();
    super.initState();
  }

  @override
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    super.dispose();
  }



  getReferralStatus() {
    FirebaseFirestore.instance
        .collection('Referral System')
        .doc('Referral System')
        .snapshots()
        .listen((value) {
      setState(() {
        referralStatus = value['Status'];
        reward = value['Referral Amount'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MediaQuery.of(context).size.width >= 1100
              ? MainAxisAlignment.start
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MediaQuery.of(context).size.width >= 1100 ? const Gap(30) : Gap(5) ,
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
            const Gap(10),
            Align(
              alignment: MediaQuery.of(context).size.width >= 1100
                  ? Alignment.bottomLeft
                  : Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width >= 1100 ? 65 : 0),
                child: Text(
                  'Sign up to continue.',
                  style: TextStyle(
                      color: Colors.orange.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize:
                      MediaQuery.of(context).size.width >= 1100 ? 20 : 18),
                ).tr(),
              ),
            ),
            const Gap(20),
            SizedBox(
              width: MediaQuery.of(context).size.width >= 1100
                  ? MediaQuery.of(context).size.width / 2
                  : MediaQuery.of(context).size.width / 1.2,
              child: FormBuilderTextField(
                controller: nameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: TextStyle(
                  color: AdaptiveTheme.of(context).mode.isDark == true
                      ? Colors.black
                      : null,
                ),
                name: 'full_name',
                onChanged: (v) {
                  setState(() {
                    fullname = v!;
                  });
                },
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: AdaptiveTheme.of(context).mode.isDark == true
                        ? Colors.black
                        : null,
                  ),
                  filled: true,
                  border: InputBorder.none,
                  fillColor: const Color.fromARGB(255, 236, 234, 234),
                  hintText: 'Full name'.tr(),
                  //border: OutlineInputBorder()
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
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
                onChanged: (v) {
                  setState(() {
                    email = v!;
                  });
                },
                key: _emailFieldKey,
                name: 'email',
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: AdaptiveTheme.of(context).mode.isDark == true
                        ? Colors.black
                        : null,
                  ),
                  filled: true,
                  border: InputBorder.none,
                  fillColor: const Color.fromARGB(255, 236, 234, 234),
                  hintText: 'Email'.tr(),
                  //border: OutlineInputBorder()
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.match(
                    RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|in|net|org|edu|gov|mil|biz|info|io|co)$"),
                    errorText: 'Enter a valid email with domain like .com, .in etc.',
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 20),
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
                  errorStyle: TextStyle(color: Colors.grey),
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
            if (referralStatus == true) const SizedBox(height: 20),
            if (referralStatus == true)
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
              //         referralCode = v!;
              //       });
              //     },
              //     name: 'text',
              //     decoration: InputDecoration(
              //       hintStyle: TextStyle(
              //         color: AdaptiveTheme.of(context).mode.isDark == true
              //             ? Colors.black
              //             : null,
              //       ),
              //       filled: true,
              //       border: InputBorder.none,
              //       fillColor: const Color.fromARGB(255, 236, 234, 234),
              //       hintText: 'Referral Code'.tr(),
              //       //border: OutlineInputBorder()
              //     ),
              //     // validator: FormBuilderValidators.compose([
              //     //   FormBuilderValidators.required(),
              //     // ]),
              //   ),
              // ),
            const SizedBox(height: 10),
            Padding(
              padding: MediaQuery.of(context).size.width >= 1100
                  ? const EdgeInsets.only(left: 40, right: 40)
                  : const EdgeInsets.all(8.0),
              child: FormBuilderFieldDecoration<bool>(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                name: 'test',
                validator: FormBuilderValidators.equal(
                  true,
                  errorText: 'Please accept the Terms to complete your sign-up.',
                ),

                // initialValue: true,
                decoration: const InputDecoration(labelText: 'Accept Terms?'),
                builder: (FormFieldState<bool?> field) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: AdaptiveTheme.of(context).mode.isDark == true
                            ? Colors.black
                            : null,
                      ),
                      errorText: field.errorText,
                    ),
                    child: SwitchListTile(
                      title: RichText(
                        text: TextSpan(
                            text: 'I have agreed to the'.tr(),
                            style: TextStyle(
                              color:
                              AdaptiveTheme.of(context).mode.isDark == true
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' Terms of Services'.tr(),
                                  style: TextStyle(
                                    color: Colors.orange.shade900,
                                    fontWeight:FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.width >= 1100 ? 14 : 12
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const TermssPage()),
                                      );
                                    }),
                              const TextSpan(
                                text: ' Le Pondy Kitchen',
                                // style: TextStyle(
                                //   color: appColor,
                                // ),
                                // recognizer: TapGestureRecognizer()
                                //   ..onTap = () {
                                //     context.go('/login');
                                //   }
                              )
                            ]),
                      ),
                      onChanged: field.didChange,
                      value: field.value ?? false,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
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
                onPressed: () {
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    context.loaderOverlay.show();

                    signUpWithPhone(
                      '$dailCode${phoneController.text.trim()}',
                      nameController.text.trim(),
                      email,
                      context,
                      password,
                      referralCode,
                      reward,
                      referralStatus,
                      playerId,
                    ).then((value) {
                  if (context.mounted) {
                  context.loaderOverlay.hide();
                  }
                  });


                    // AuthService()
                    //     .signUp(
                    //     email,
                    //     password,
                    //     fullname,
                    //     '$dailCode$phone',
                    //     context,
                    //     referralCode,
                    //     reward,
                    //     referralStatus,
                    //     playerId)
                    //     .then((value) {
                    //   if (context.mounted) {
                    //     context.loaderOverlay.hide();
                    //   }
                    // });


                  }
                },
                child: Text(
                  'SIGN UP'.tr(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Gap(5),
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 15),
              child: RichText(
                text: TextSpan(
                    text: 'Already have an account?',
                    style: TextStyle(
                      color: AdaptiveTheme.of(context).mode.isDark == true
                          ? Colors.white
                          : Colors.black,
                      fontSize: MediaQuery.of(context).size.width >= 1100 ? 16 : 14,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' Sign in',
                          style: TextStyle(
                            color: Colors.orange.shade900,
                            fontSize: MediaQuery.of(context).size.width >= 1100 ? 16 : 14,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.go('/login');
                            })
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


