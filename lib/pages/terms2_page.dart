import 'dart:convert';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:user_web/widgets/footer_widget.dart';
import 'package:user_web/providers/legal_page_provider.dart';

class TermssPage extends ConsumerStatefulWidget {
  const TermssPage({super.key});

  @override
  ConsumerState<TermssPage> createState() => _TermsPageState();
}

class _TermsPageState extends ConsumerState<TermssPage> {
  final QuillController _controller = QuillController.basic();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final about = ref.watch(getTermsAndConditionsDetailsProvider).value;
    // if (about != null) {
    //   _controller.document = Document.fromJson(jsonDecode(about));
    //   _controller.readOnly = true;
    // }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions',style: TextStyle(fontFamily: 'Nunito'),),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // ⬅️ goes back to signup
        ),
      ),
      // backgroundColor: const Color(0xFFDF7EB).withOpacity(1.0),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              width: double.infinity,
              decoration: BoxDecoration(
                  // color: const Color(0x5E5656).withOpacity(0.5),
                  image: const DecorationImage(
                    opacity: 0.6,
                    image:
                    AssetImage('assets/image/t & c.png',),
                    fit: BoxFit.cover,
                  )),
              child: Center(
                child: const Text(
                  'Terms & Conditions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30,color: Colors.white),
                ).tr(),
              ),
            ),

            // ignore: prefer_const_constructors
            Padding(
              padding: MediaQuery.of(context).size.width >= 1100
                  ? const EdgeInsets.only(left: 100, right: 100)
                  : const EdgeInsets.all(8),
              child:
              MediaQuery.of(context).size.width >= 1100 ?
              Column(
                children: [
                  const Gap(10),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        // Text(
                        //   'Terms & Conditons',
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.bold, fontSize: 20),
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
                  const Gap(10),
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
                          '2.Reservations and Walk-ins',
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
                            "Reservations can be made online, via phone, or in person",
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
                  Gap(10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '3. Ordering and Payment',
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
                            "All prices listed on our menu are in [Dollars] and inclusive/exclusive of taxes, as applicable.",
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
                            "Payments can be made via cash, credit/debit cards, or digital payment methods accepted by the restaurant.",
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
                            "Split bills may be accommodated upon request, subject to availability",
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
                            "Tips and gratuities are optional and at the customer’s discretion.",
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
                          '4. Food Allergies and Special Requests',
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
                            "Customers with food allergies should inform the staff before placing an order.",
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
                            "While we take precautions to avoid cross-contamination, we cannot guarantee an  allergen-free environment",
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
                            "Special dietary requests will be accommodated to the best of our ability but are not guaranteed",
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
                          '5. Cancellations and Refunds',
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
                            "Orders once placed cannot be canceled, except in cases where the restaurant agrees.",
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
                            "Refunds for incorrect or unsatisfactory orders will be provided at the restaurant’s  discretion.",
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
                            "Prepaid reservations or event bookings may have a cancellation policy, which will be communicated at the time of booking.",
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
                          '6. Conduct and Behavior',
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
                            "Customers are expected to behave respectfully toward staff and other guests",
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
                            "The restaurant reserves the right to refuse service or ask a guest to leave in case of   misconduct.",
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
                            "Any damage caused to restaurant property by a guest will be chargeable.",
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
                          '7. Takeaway and Delivery',
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
                            "Takeaway and delivery services are available as per the restaurant’s policy",
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
                            "Delivery times are estimates and may vary due to external factors",
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
                            "The restaurant is not responsible for any damages to food items once they leave the premises.",
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
                          '8.Liability and Indemnity',
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
                            "The restaurant shall not be held liable for any injuries, allergic reactions, or damages resulting from dining at the restaurant",
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
                            "Customers agree to indemnify the restaurant against any claims arising from misuse of its services.",
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
                          '9.Privacy Policy',
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
                            "Customer information is collected only for service purposes and will not be shared with third parties without consent.",
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
                            "Payment and personal details are securely processed in compliance with data  protection laws.",
                            style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                          ),
                        ],
                      )
                  ),

                  const Gap(20),
                ],
              ) :
              Column(
                children: [
                  const Gap(10),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        // Text(
                        //   'Terms & Conditons',
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.bold, fontSize: 20),
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
                  const Gap(10),
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
                          '2.Reservations and Walk-ins',
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
                            "Reservations can be made online, via phone, or in person",
                            style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                          ),
                        ],
                      )
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
                  Gap(10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '3. Ordering and Payment',
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
                      "All prices listed on our menu are in [Dollars] and inclusive/exclusive of taxes, as applicable.",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                    Text(
                      "Payments can be made via cash, credit/debit cards, or digital payment methods accepted by the restaurant.",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                    Text(
                      "Split bills may be accommodated upon request, subject to availability",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                    Text(
                      "Tips and gratuities are optional and at the customer’s discretion.",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                    ),
                  ),
                  Gap(10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '4. Food Allergies and Special Requests',
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
                      "Customers with food allergies should inform the staff before placing an order.",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                    Text(
                      "While we take precautions to avoid cross-contamination, we cannot guarantee an  allergen-free environment",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                    Text(
                      "Special dietary requests will be accommodated to the best of our ability but are not guaranteed",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                    ),
                  ),
                  Gap(10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '5. Cancellations and Refunds',
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
                      "Orders once placed cannot be canceled, except in cases where the restaurant agrees.",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                    Text(
                      "Refunds for incorrect or unsatisfactory orders will be provided at the restaurant’s  discretion.",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                    Text(
                      "Prepaid reservations or event bookings may have a cancellation policy, which will be communicated at the time of booking.",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                    ),

                  ),
                  Gap(10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '6. Conduct and Behavior',
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
                      "Customers are expected to behave respectfully toward staff and other guests",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                    Text(
                      "The restaurant reserves the right to refuse service or ask a guest to leave in case of   misconduct.",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                    Text(
                      "Any damage caused to restaurant property by a guest will be chargeable.",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                    ),

                  ),
                  Gap(10),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                      Row(
                        children: [
                          Text(
                            '7. Takeaway and Delivery',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'Nunito'),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      )
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                    Text(
                      "Takeaway and delivery services are available as per the restaurant’s policy",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                    Text(
                      "Delivery times are estimates and may vary due to external factors",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                    Text(
                      "The restaurant is not responsible for any damages to food items once they leave the premises.",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                    ),

                  ),
                  Gap(10),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                      Row(
                        children: [
                          Text(
                            '8.Liability and Indemnity',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'Nunito'),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      )

                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                    Text(
                      "The restaurant shall not be held liable for any injuries, allergic reactions, or damages resulting from dining at the restaurant",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                    Text(
                      "Customers agree to indemnify the restaurant against any claims arising from misuse of its services.",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                    ),
                  ),
                  Gap(10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '9.Privacy Policy',
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
                      "Customer information is collected only for service purposes and will not be shared with third parties without consent.",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                    Text(
                      "Payment and personal details are securely processed in compliance with data  protection laws.",
                      style: TextStyle(fontFamily: 'Nunito',fontSize: 16,),
                    ),
                  ),
                  const Gap(20),
                ],
              ),
            ),
            const FooterWidget()
          ],
        ),
      ),
    );
  }
}
