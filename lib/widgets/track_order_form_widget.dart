// ignore_for_file: avoid_print

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:user_web/constant.dart';
import 'package:user_web/providers/track_order_provider.dart';

class TrackOrderFormWidget extends ConsumerStatefulWidget {
  const TrackOrderFormWidget({super.key});

  @override
  ConsumerState<TrackOrderFormWidget> createState() =>
      _TrackOrderFormWidgetState();
}

class _TrackOrderFormWidgetState extends ConsumerState<TrackOrderFormWidget> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _emailFieldKey = GlobalKey<FormBuilderFieldState>();

  String email = '';

  // getToken() async {
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   setState(() {
  //     tokenID = token!;
  //   });
  // }

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
          MediaQuery.of(context).size.width >= 1100
              ? const Gap(50)
              : const Gap(20),
          if (MediaQuery.of(context).size.width <= 1100)
            Image.asset(
              AdaptiveTheme.of(context).mode.isDark == true ? verticalWhite :onlyLogo,
              scale: 6,
              // color: AdaptiveTheme.of(context).mode.isDark == true
              //     ? Colors.white
              //     : null,
            ),
          const Gap(10),
          Align(
            alignment: MediaQuery.of(context).size.width >= 1100
                ? Alignment.center
                : Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width >= 1100 ? 0 : 0),
              child: Text(
                'Track Your Order',
                style: TextStyle(
                    color: appColor,
                    fontWeight: FontWeight.bold,
                    fontSize:
                        MediaQuery.of(context).size.width >= 1100 ? 20 : 20),
              ).tr(),
            ),
          ),
          Padding(
            padding: MediaQuery.of(context).size.width >= 1100
                ? const EdgeInsets.only(left: 100, right: 100)
                : const EdgeInsets.all(8),
            child: Center(
              child: const Text(
                'Enter Order ID To Track Your Package.',
                textAlign: TextAlign.center,
              ).tr(),
            ),
          ),
          const Gap(20),
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
              onChanged: (v) {
                setState(() {
                  email = v!;
                });
              },
              key: _emailFieldKey,
              name: 'email',
              decoration: InputDecoration(
                  filled: true,
                  border: InputBorder.none,
                  fillColor: const Color.fromARGB(255, 236, 234, 234),
                  hintText: 'Your Order Id'.tr(),
                  //border: OutlineInputBorder()
                  hintStyle: TextStyle(
                    color: AdaptiveTheme.of(context).mode.isDark == true
                        ? Colors.black
                        : null,
                  )),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.integer(),
              ]),
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
                if (_formKey.currentState!.validate()) {
                  ref.read(trackOrderProviderProvider(email, context));
                  // context.loaderOverlay.show();
                  // AuthService().forgotPassword(context, email).then((value) {
                  //   context.loaderOverlay.hide();
                  // });
                  // Validate and save the form values
                  // _formKey.currentState?.saveAndValidate();
                  // debugPrint(_formKey.currentState?.value.toString());

                  // // On another side, can access all field values without saving form with instantValues
                  // _formKey.currentState?.validate();
                  //   debugPrint(_formKey.currentState?.instantValue.toString());
                }
              },
              child: const Text(
                'TRACK ORDER',
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
