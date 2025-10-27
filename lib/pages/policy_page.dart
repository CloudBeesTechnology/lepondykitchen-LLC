import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:user_web/widgets/footer_widget.dart';
import 'package:user_web/constant.dart';
import 'package:user_web/providers/legal_page_provider.dart';

class PolicyPage extends ConsumerStatefulWidget {
  const PolicyPage({super.key});

  @override
  ConsumerState<PolicyPage> createState() => _PolicyPageState();
}

class _PolicyPageState extends ConsumerState<PolicyPage> {
  final QuillController _controller = QuillController.basic();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final about = ref.watch(getPrivacyPolicyDetailsProvider).value;
    // if (about != null) {
    //   _controller.document = Document.fromJson(jsonDecode(about));
    //   _controller.readOnly = true;
    // }
    return Scaffold(
      // backgroundColor: const Color(0xFFDF7EB).withOpacity(1.0),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              width: double.infinity,
              decoration: BoxDecoration(
                // color: const Color(0x5E5656).withOpacity(0.5),
                  image: const DecorationImage(
                    opacity: 0.6,
                    image:
                    AssetImage('assets/image/pp.png',),
                    fit: BoxFit.cover,
                  )),
              child: Center(
                child: const Text(
                  'Privacy Policy',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30,color: Colors.white),
                ).tr(),
              ),
            ),
            Padding(
              padding: MediaQuery.of(context).size.width >= 1100
                  ? const EdgeInsets.only(left: 100, right: 100)
                  : const EdgeInsets.all(8),
              child: MediaQuery.of(context).size.width >= 1100 ?
              Column(
                children: [
                  const Gap(10),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        // Text(
                        //   'Privacy Policy For $appName',
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'Nunito'),
                        //   textAlign: TextAlign.left,
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: QuillEditor.basic(
                      controller: _controller,
                      configurations: const QuillEditorConfigurations(),
                    ),
                  ),
                  Gap(10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '1.Introduction ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'Nunito'),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        "Le Pondy Kitchen values your privacy and is committed to protecting your personal information. This Privacy Policy outlines how we collect, use, and safeguard your data when you visit our restaurant, website, or use our services.",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),)

                  ),
                  Gap(10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '2.Information We collect',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'Nunito'),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'We may collect the following types of information:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                            "Personal Information: Name, contact details (phone number, email address), and  payment details when making reservations, placing orders, or subscribing to newsletters.",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                        ),
                      ],
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                            "Transaction Information: Orders placed, payment methods, and billing details.",
                          style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                        ),
                      ],
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                            "Technical Information: IP address, browser type, and website usage data when accessing our online services.",
                          style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                        ),
                      ],
                    )
                  ),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                              "Feedback and Reviews: Any feedback, ratings, or comments you provide about our services.",
                            style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                          ),
                        ],
                      )
                  ),
                  Gap(10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '3.How We Use Your Information',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'Nunito'),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'We use the collected information for:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                            "Processing reservations, orders, and payments.",
                          style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                        ),
                      ],
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                            "Improving customer experience and tailoring our services.",
                          style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                        ),
                      ],
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                            "Sending promotional offers, newsletters, or restaurant updates (with your consent)",
                          style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                        ),
                      ],
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                            "Ensuring security and preventing fraud.",
                          style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                        ),
                      ],
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                            "Complying with legal and regulatory obligations",
                          style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                        ),
                      ],
                    )
                  ),
                  Gap(10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '4. Sharing of Information :',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'Nunito'),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'We do not sell, rent, or trade your personal data. However, we may share your information with',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14),
                          // textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Service Providers:',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'Third-party vendors for payment processing, delivery services,or email marketing',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15),
                          // textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Legal Authorities:',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'If required by law or to protect our rights and interests.',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15),
                          // textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Gap(10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '5.Data Security ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'Nunito'),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        "We take reasonable security measures to protect your personal   information from unauthorized access, disclosure, or loss. However, no method of transmission over the Internet is 100% secure.",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                    ),
                  ),
                  Gap(10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '6.Cookies and Tracking Technologies',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'Nunito'),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        "Our website may use cookies and similar technologies to improve user experience, analyze website traffic, and remember preferences. You can manage your cookie preferences through your browser settings.",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                    ),
                  ),
                  const Gap(10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '7. Your Rights',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'Nunito'),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'You have the right to:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                            "Request access to the personal data we hold about you..",
                          style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                        ),
                      ],
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                            "Correct or update your personal information.",
                          style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                        ),
                      ],
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                            "Opt-out of marketing communications.",
                          style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                        ),
                      ],
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                            "Request deletion of your personal data, subject to legal obligations.",
                          style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                        ),
                      ],
                    )
                  ),
                  const Gap(10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '8. Third-Party Links',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'Nunito'),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                            "Request deletion of your personal data, subject to legal obligations.",
                          style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                        ),
                      ],
                    )
                  ),
                  const Gap(10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '9. Changes to This Policy',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'Nunito'),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                            "We may update this Privacy Policy from time to time. Any changes will be posted on our website with an updated effective date.",
                          style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                        )
                      ],
                    ),
                  ),
                ],
              ) :
              Column(
                children: [
                  // const Gap(10),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        // Text(
                        //   'Privacy Policy For $appName',
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'Nunito'),
                        //   textAlign: TextAlign.left,
                        // ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: QuillEditor.basic(
                  //     controller: _controller,
                  //     configurations: const QuillEditorConfigurations(),
                  //   ),
                  // ),
                  Gap(10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '1.Introduction ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'Nunito'),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Le Pondy Kitchen values your privacy and is committed to protecting your personal information. This Privacy Policy outlines how we collect, use, and safeguard your data when you visit our restaurant, website, or use our services.",
                        style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),)

                  ),
                  Gap(10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                        Row(
                          children: [
                            Text(
                              '2.Information We collect',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'Nunito'),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        )
                        // Text(
                        //   'We may collect the following types of information:',
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.bold, fontSize: 17),
                        //   textAlign: TextAlign.left,
                        // ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                          Text(
                            "Personal Information: Name, contact details (phone number, email address), and  payment details when making reservations, placing orders, or subscribing to newsletters.",
                            style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                          ),

                  ),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                          Text(
                            "Transaction Information: Orders placed, payment methods, and billing details.",
                            style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                          ),

                  ),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                          Text(
                            "Technical Information: IP address, browser type, and website usage data when accessing our online services.",
                            style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                          ),

                  ),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                          Text(
                            "Feedback and Reviews: Any feedback, ratings, or comments you provide about our services.",
                            style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                          ),
                  ),
                  Gap(10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '3.How We Use Your Information',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'Nunito'),
                          textAlign: TextAlign.left,
                        ),
                        // Text(
                        //   'We use the collected information for:',
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.bold, fontSize: 17),
                        //   textAlign: TextAlign.left,
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                         Row(
                           children: [
                             Text(
                               "Processing reservations, orders, and payments.",
                               style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                             ),
                           ],
                         )

                  ),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child:Row(
                        children: [
                          Text(
                            "Improving customer experience and tailoring our services.",
                            style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                          ),
                        ],
                      )


                  ),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                          Text(
                            "Sending promotional offers, newsletters, or restaurant updates (with your consent)",
                            style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                          ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Improving customer experience and tailoring our services.",
                            style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                          ),
                        ],
                      )


                  ),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                         Row(
                           children: [
                             Text(
                               "Complying with legal and regulatory obligations",
                               style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                             ),
                           ],
                         )
                  ),
                  Gap(10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '4. Sharing of Information :',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'Nunito'),
                          textAlign: TextAlign.left,
                        ),
                        // Text(
                        //   'We do not sell, rent, or trade your personal data. However, we may share your information with',
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.w500, fontSize: 14),
                        //   // textAlign: TextAlign.left,
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                       Row(
                         children: [
                           Text(
                             'Service Providers:',
                             style: TextStyle(
                                 fontWeight: FontWeight.w600, fontSize: 16),
                             textAlign: TextAlign.left,
                           ),
                         ],
                       ),
                        Gap(8),
                        Text(
                          'Third-party vendors for payment processing, delivery services,or email marketing',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15),
                          // textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Legal Authorities:',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        Gap(8),
                      Row(
                        children: [
                          Text(
                            'If required by law or to protect our rights and interests.',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15),
                            // textAlign: TextAlign.left,
                          ),
                        ],
                      )
                      ],
                    ),
                  ),
                  Gap(10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '5.Data Security ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'Nunito'),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "We take reasonable security measures to protect your personal   information from unauthorized access, disclosure, or loss. However, no method of transmission over the Internet is 100% secure.",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                    ),
                  ),
                  Gap(10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '6.Cookies and Tracking Technologies',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'Nunito'),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Our website may use cookies and similar technologies to improve user experience, analyze website traffic, and remember preferences. You can manage your cookie preferences through your browser settings.",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                    ),
                  ),
                  const Gap(10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '7. Your Rights',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'Nunito'),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'You have the right to:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Request access to the personal data we hold about you..",
                            style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                          ),
                        ],
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Correct or update your personal information.",
                            style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                          ),
                        ],
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Opt-out of marketing communications.",
                            style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                          ),
                        ],
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                          Text(
                            "Request deletion of your personal data, subject to legal obligations.",
                            style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                          ),

                  ),
                  const Gap(10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '8. Third-Party Links',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'Nunito'),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                          Text(
                            "Request deletion of your personal data, subject to legal obligations.",
                            style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                          ),

                  ),
                  const Gap(10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '9. Changes to This Policy',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'Nunito'),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                        Text(
                          "We may update this Privacy Policy from time to time. Any changes will be posted on our website with an updated effective date.",
                          style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                        )
                  ),
                ],
              )
            ),
            const Gap(20),
            const FooterWidget()
          ],
        ),
      ),
    );
  }
}
