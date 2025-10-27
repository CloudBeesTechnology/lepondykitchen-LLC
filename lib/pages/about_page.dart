import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:user_web/widgets/footer_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:user_web/widgets/guides.dart';
import 'package:user_web/providers/legal_page_provider.dart';

class AboutPage extends ConsumerStatefulWidget {
  const AboutPage({super.key});

  @override
  ConsumerState<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends ConsumerState<AboutPage> {
  final QuillController _controller = QuillController.basic();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final about = ref.watch(getAboutUsDetailsProvider).value;
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
                    AssetImage('assets/image/As.png',),
                    fit: BoxFit.cover,
                  )),
              child: Center(
                child: const Text(
                  'About Us',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30,color: Colors.white),
                ).tr(),
              ),
            ),
            Padding(
              padding: MediaQuery.of(context).size.width >= 1100
                  ? const EdgeInsets.only(left: 100, right: 100)
                  : const EdgeInsets.all(8),
              child: Column(
                children: [
                  const Gap(50),
                  Text('About Us',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 30,fontFamily: 'Nunito'),),
                  Text('Welcome to Le pondy Kitchen,Where great food meets hospitality',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,fontFamily: 'Nunito'),),
                  const Gap(30),
                  MediaQuery.of(context).size.width >= 1100
                      ?
                  Row(
                          children: [
                            Expanded(
                                flex: 6,
                                child: Image.asset(
                                  'assets/image/delivery man.png',
                                  height: 300,
                                  width: double.infinity,
                                )),
                            Expanded(
                              flex: 6,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20.0), // Adds spacing
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // Align text left
                                  children: [
                                    const Text(
                                      'At Le Pondy Kitchen, we take pride in serving delicious, high-quality dishes made with the freshest ingredients. Our chefs craft each meal with passion, ensuring that every bite is a delightful experience. Whether you’re craving traditional flavors or contemporary cuisine, we have something for everyone.',
                                      style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,fontFamily: 'Nunito'),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 16), // Adds spacing
                                    const Text(
                                      'Our inviting ambiance, friendly staff, and dedication to exceptional service make us the perfect spot for family gatherings, romantic dinners, business meetings, and celebrations.',
                                      style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Nunito'),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Image.asset(
                              'assets/image/delivery man.png',
                              height: 300,
                              width: double.infinity,
                            ),
                            Column(
                              children: [
                                const SizedBox(height: 18),
                                const Text(
                                  'At Le Pondy Kitchen, we take pride in serving delicious, high-quality dishes made with the freshest ingredients. Our chefs craft each meal with passion, ensuring that every bite is a delightful experience. Whether you’re craving traditional flavors or contemporary cuisine, we have something for everyone.',
                                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,fontFamily: 'Nunito'),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 16), // Adds spacing
                                const Text(
                                  'Our inviting ambiance, friendly staff, and dedication to exceptional service make us the perfect spot for family gatherings, romantic dinners, business meetings, and celebrations.',
                                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Nunito'),
                                  textAlign: TextAlign.left,
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: QuillEditor.basic(
                                //     controller: _controller,
                                //     configurations:
                                //         const QuillEditorConfigurations(),
                                //   ),
                                // ),

                              ],
                            ),
                          ],
                        ),
                  const Gap(20),
                  MediaQuery.of(context).size.width >= 1100
                      ?
                Container(
                  width: double.infinity,
                  // color: Colors.white,
                  child: Column(
                    children: [
                      Text(
                        'Our Mission',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12), // Spacing
                      SizedBox(
                        width: 800, // Restrict width to avoid text spreading too much
                        child: Text(
                          'At Le Pondy Kitchen, we’re not just serving food—we’re creating moments. Our mission is simple: to bring people together over unforgettable flavors, heartwarming hospitality, and a dining experience that feels like home.',
                          style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Nunito'), // Center align paragraph
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Image.asset(
                                'assets/image/our mission.png',
                                height: 300,
                                width: double.infinity,
                              )),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20.0), // Adds spacing
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start, // Align text left
                                children: [
                                  const Text(
                                    'Quality First – Every bite is packed with rich flavors and premium ingredients.',
                                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Nunito'),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(height: 16), // Adds spacing
                                  const Text(
                                    'Crafted with Passion – Every dish tells a story, made with love and the freshest ingredients.',
                                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Nunito'),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(height: 16), // Adds spacing
                                  const Text(
                                    'Beyond Dining – A place to celebrate, connect, and create memories that last',
                                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Nunito'),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(height: 16), // Adds spacing
                                  const Text(
                                    'Locally Inspired, Globally Loved – Supporting local farmers while embracing global flavors.',
                                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Nunito'),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(height: 16), // Adds spacing
                                  const Text(
                                    'Your Happy Place – Whether it’s a casual bite or a grand feast, we make every visit special.',
                                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Nunito'),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
                      : Container(
                    // color: Colors.white,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              'assets/image/our mission.png',
                              height: 300,
                              width: double.infinity,
                            ),
                            const Gap(10),
                            const Text(
                              'Our Mission',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                              textAlign: TextAlign.left,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                  "Quality First – Every bite is packed with rich flavors and premium ingredients."),
                            ),
                            const Gap(6),
                            const Text(
                              'Crafted with Passion – Every dish tells a story, made with love and the freshest ingredients.',
                              style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Nunito'),
                              textAlign: TextAlign.left,
                            ),
                            const Gap(6),
                            const Text(
                              'Locally Inspired, Globally Loved – Supporting local farmers while embracing global flavors.',
                              style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Nunito'),
                              textAlign: TextAlign.left,
                            ),
                            const Gap(6),
                            const Text(
                              'Your Happy Place – Whether it’s a casual bite or a grand feast, we make every visit special.',
                              style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Nunito'),
                              textAlign: TextAlign.left,
                            ),
                            const Gap(6),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // const Gap(50),
                  // const Text(
                  //   'Our Core Values',
                  //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  //   textAlign: TextAlign.left,
                  // ).tr(),
                  // const GuidesWIdget(),
                  const Gap(50),
                  Text('Our Core Values – The Heart of Le Pondy Kitchen', style: TextStyle(fontWeight: FontWeight.w600,fontSize: 22,fontFamily: 'Nunito'),),
                  const Gap(20),
                  MediaQuery.of(context).size.width >= 1100
                      ? Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20.0), // Adds spacing
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // Align text left
                                  children: [
                                    const Text(
                                      'Trust – We build lasting relationships with our customers by delivering consistent quality, honest service, and a dining experience they can always count on',
                                      style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Nunito'),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 12), // Adds spacing
                                    const Text(
                                      'At Le Pondy Kitchen, our values define who we are and shape every  experience we create for our guests.',
                                      style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Nunito'),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 12), // Adds spacing
                                    const Text(
                                      'At Le Pondy Kitchen, these values are not just words—they are the foundation    of everything we do. Come experience it for yourself!',
                                      style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Nunito'),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20.0), // Adds spacing
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // Align text left
                                  children: [
                                    const Text(
                                      'Flexibility – Whether it’s dietary preferences, special requests, or custom       dining experiences, we adapt to meet the needs of our guests with ease and care.',
                                      style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Nunito'),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 16), // Adds spacing
                                    const Text(
                                      'Credibility – Our reputation is built on excellence. From fresh ingredients to top-tier service, we uphold the highest standards in everything we do',
                                      style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Nunito'),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            // SvgPicture.asset(
                            //   'assets/image/undraw_mobile_payments_re_7udl.svg',
                            //   height: 300,
                            //   width: double.infinity,
                            // ),
                            const Column(
                              children: [
                                // Text(
                                //   'Final Word',
                                //   style: TextStyle(
                                //       fontWeight: FontWeight.bold,
                                //       fontSize: 20),
                                //   textAlign: TextAlign.left,
                                // ),
                                // Padding(
                                //   padding: EdgeInsets.all(8.0),
                                //   child: Text(
                                //       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
                                // ),
                                const Text(
                                  'Trust – We build lasting relationships with our customers by delivering consistent quality, honest service, and a dining experience they can always count on',
                                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Nunito'),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 12), // Adds spacing
                                const Text(
                                  'At Le Pondy Kitchen, our values define who we are and shape every  experience we create for our guests.',
                                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Nunito'),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 12), // Adds spacing
                                const Text(
                                  'At Le Pondy Kitchen, these values are not just words—they are the foundation    of everything we do. Come experience it for yourself!',
                                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Nunito'),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Flexibility – Whether it’s dietary preferences, special requests, or custom       dining experiences, we adapt to meet the needs of our guests with ease and care.',
                                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Nunito'),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 16), // Adds spacing
                                const Text(
                                  'Credibility – Our reputation is built on excellence. From fresh ingredients to top-tier service, we uphold the highest standards in everything we do',
                                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,fontFamily: 'Nunito'),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ],
                        ),
                  const Gap(50)
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
