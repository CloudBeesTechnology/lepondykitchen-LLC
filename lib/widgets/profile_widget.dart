import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/constant.dart';
import '../providers/profile_page_provider.dart';

class ProfileWidget extends ConsumerStatefulWidget {
  const ProfileWidget({super.key});

  @override
  ConsumerState<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends ConsumerState<ProfileWidget> {
  String fullname = '';
  String phoneNumber = '';
  String email = '';
  String referralCode = '';
  final formKeyNew = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileNotifierProvider);
    final notifier = ref.read(userProfileNotifierProvider.notifier);
    return userProfile.when(data: (v) {
      return FormBuilder(
         key: formKeyNew,
        child: Column(
          mainAxisAlignment: MediaQuery.of(context).size.width >= 1100
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Gap(10),
            if (MediaQuery.of(context).size.width >= 1100)
              Align(
                alignment: MediaQuery.of(context).size.width >= 1100
                    ? Alignment.bottomLeft
                    : Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width >= 1100 ? 50 : 0),
                  child: Text(
                    'Account Information',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width >= 1100
                            ? 16
                            : 15),
                  ).tr(),
                ),
              ),
            if (MediaQuery.of(context).size.width >= 1100)
              const Divider(
                color: Color.fromARGB(255, 237, 235, 235),
                thickness: 1,
              ),
            const Gap(20),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width >= 1100 ? 50 : 15),
                child: Text(
                  'Full Name',
                  style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                      fontSize:
                          MediaQuery.of(context).size.width >= 1100 ? 16 : 13),
                ).tr(),
              ),
            ),
            const Gap(10),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width >= 1100 ? 50 : 8,
                  right: MediaQuery.of(context).size.width >= 1100 ? 50 : 8),
              child: FormBuilderTextField(
                onChanged: (v) {
                  setState(() {
                    fullname = v!;
                  });
                },
                initialValue: v.displayName,
                name: 'full name',
                decoration: const InputDecoration(
                    // filled: true,
                    // // border: InputBorder.none,
                    // fillColor: Colors.white,
                    // hintText: 'Email'.tr(),
                    border: OutlineInputBorder()),
              ),
            ),
            const Gap(20),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width >= 1100 ? 50 : 15),
                child: Text(
                  'Email Address',
                  style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                      fontSize:
                          MediaQuery.of(context).size.width >= 1100 ? 16 : 13),
                ).tr(),
              ),
            ),
            const Gap(10),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width >= 1100 ? 50 : 8,
                  right: MediaQuery.of(context).size.width >= 1100 ? 50 : 8),
              child: FormBuilderTextField(
                readOnly: true,
                onChanged: (v) {
                  setState(() {
                  email = v!;
                  });
                },
                initialValue: v.email,
                name: 'email address',
                decoration: const InputDecoration(
                    // filled: true,
                    // // border: InputBorder.none,
                    // fillColor: Colors.white,
                    // hintText: 'Email'.tr(),
                    border: OutlineInputBorder()),
              ),
            ),
            const Gap(20),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width >= 1100 ? 50 : 15),
                child: Text(
                  'Phone Number',
                  style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                      fontSize:
                          MediaQuery.of(context).size.width >= 1100 ? 16 : 13),
                ).tr(),
              ),
            ),
            const Gap(10),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width >= 1100 ? 50 : 8,
                  right: MediaQuery.of(context).size.width >= 1100 ? 50 : 8),
              child: FormBuilderTextField(
                maxLength: 14,
                onChanged: (v) {
                  setState(() {
              phoneNumber = v!;
                  });
                },
                initialValue: v.phonenumber,
                name: 'phone number',
                decoration: const InputDecoration(
                    counterText: '',
                    // filled: true,
                    // // border: InputBorder.none,
                    // fillColor: Colors.white,
                    // hintText: 'Email'.tr(),
                    border: OutlineInputBorder()),
              ),
            ),
            const Gap(20),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width >= 1100 ? 50 : 15),
                child: Text(
                  'Referral Code',
                  style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                      fontSize:
                          MediaQuery.of(context).size.width >= 1100 ? 16 : 13),
                ).tr(),
              ),
            ),
            const Gap(10),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width >= 1100 ? 50 : 8,
                  right: MediaQuery.of(context).size.width >= 1100 ? 50 : 8),
              child: FormBuilderTextField(
                readOnly: true,
                onChanged: (v) {
                  setState(() {
                    referralCode = v!;
                  });
                },
                initialValue: v.referralCode,
                name: 'referral code',
                decoration: InputDecoration(
                    // filled: true,
                    // // border: InputBorder.none,
                    // fillColor: Colors.white,
                    // hintText: 'Email'.tr(),
                    suffixIcon: IconButton(
                        onPressed: () {
                          FlutterClipboard.copy(v.referralCode)
                              // ignore: avoid_print
                              .then((value) => print('copied'));
                          Fluttertoast.showToast(
                              msg: "Referral code copied".tr(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              backgroundColor:  const Color(0xFFFFD581),
                              textColor: Colors.black,
                              timeInSecForIosWeb: 3,
                              webBgColor: "#FFD581",
                              webPosition: "center",
                              fontSize: 14.0);
                        },
                        icon: const Icon(Icons.copy)),
                    border: const OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 20),
            const Gap(20),
            SizedBox(
              width: MediaQuery.of(context).size.width >= 1100
                  ? 280
                  : MediaQuery.of(context).size.width / 1.2,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const BeveledRectangleBorder(),
                    backgroundColor: appColor,
                    textStyle: const TextStyle(color: Colors.white)),
                // color: Theme.of(context).colorScheme.secondary,
                onPressed: () async {
                  if (formKeyNew.currentState!.validate()) {
                    context.loaderOverlay.show();
                    try {
                      await notifier.updateUser(
                        fullname.isEmpty ? v.displayName : fullname,
                        phoneNumber.isEmpty ? v.phonenumber : phoneNumber,
                        context
                      );
                    } finally {
                      if (context.mounted) {
                        context.loaderOverlay.hide();
                      }
                    }
                  }
                  // if (formKeyNew.currentState!.validate()) {
                  //   // context.loaderOverlay.show();
                  //   // AuthService()
                  //   //     .signIn(email, password, context, tokenID)
                  //   //     .then((value) {
                  //   //   context.loaderOverlay.hide();
                  //   // });
                  //   // Validate and save the form values
                  //   // _formKey.currentState?.saveAndValidate();
                  //   // debugPrint(_formKey.currentState?.value.toString());

                  //   // // On another side, can access all field values without saving form with instantValues
                  //   // _formKey.currentState?.validate();
                  //   //   debugPrint(_formKey.currentState?.instantValue.toString());
                  // }
                },
                child:  Text(
                  'UPDATE PROFILE',
                  style: TextStyle(
                      fontFamily: 'Nunito',
                     color: AdaptiveTheme.of(context).mode.isDark == true
                          ? Colors.white
                          : Colors.black87,
                      fontWeight: FontWeight.w600,fontSize: 16),
                ).tr(),
              ),
            ),
            const Gap(20),
          ],
        ),
      );
    }, error: (e, r) {
      return Text(e.toString());
    }, loading: () {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            return ListTile(
              title: Container(
                width: double.infinity,
                height: 16.0,
                color: Colors.white,
              ),
              subtitle: Container(
                width: double.infinity,
                height: 12.0,
                color: Colors.white,
              ),
            );
          },
        ),
      );
    });
  }
}
