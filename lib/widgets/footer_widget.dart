import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_web/constant.dart';
import 'package:user_web/providers/socials_provider.dart';

import '../constant.dart';

class FooterWidget extends ConsumerStatefulWidget {
  const FooterWidget({super.key});

  @override
  ConsumerState<FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends ConsumerState<FooterWidget> {
  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _makePhoneCall(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    // final faceBook = ref.watch(getFacebookDetailsProvider).value ?? '';
    // final instagram = ref.watch(getInstagramDetailsProvider).value ?? '';
    final faceBook = 'https://www.facebook.com/profile.php?id=61575876041431';
    final instagram = 'https://www.instagram.com/lepondycloudkitchen';
    final twitter = ref.watch(getTwitterDetailsProvider).value ?? '';
    return Container(
      color: AdaptiveTheme.of(context).mode.isDark == true
          ? null
          : primary,
      // color: const Color.fromARGB(255, 6, 25, 49),
      height: MediaQuery.of(context).size.width >= 1100 ? 300 : 650,
      width: double.infinity,
      child: Column(
        children: [
          const Gap(40),
          MediaQuery.of(context).size.width >= 1100
              ? Padding(
                  padding: const EdgeInsets.only(left: 60, right: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text('Company',
                              style: TextStyle(fontFamily: 'Nunito',fontWeight: FontWeight.w700,fontSize: 20,)).tr(),
                          const Gap(2),
                          SizedBox(
                            width: 80, // Adjust this based on text width
                            child: Divider(
                              color: Colors.grey,
                              thickness: 2, // Reduced thickness for better appearance
                            ),
                          ),
                          const Gap(3),
                          InkWell(
                            onTap: () {
                              context.go('/about');
                            },
                              child: Text('About Us',style: TextStyle(fontFamily: 'Nunito',fontSize: 18,fontWeight: FontWeight.bold,),)
                          ),
                          const Gap(30)
                        ],
                      ),
                      // const Gap(2),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // const Gap(20),
                           Text('Get in touch',  style: TextStyle(fontFamily: 'Nunito',fontWeight: FontWeight.w700,fontSize: 20,)).tr(),
                          // const Gap(10),
                          const Gap(2),
                          SizedBox(
                            width: 80, // Adjust this based on text width
                            child: Divider(
                              color: Colors.grey,
                              thickness: 2, // Reduced thickness for better appearance
                            ),
                          ),
                          const Gap(3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  _launchURL(faceBook);
                                },
                                child: Image.asset(
                                  'assets/image/facebook.png',
                                  color: AdaptiveTheme.of(context).mode.isDark == true
                                            ? Colors.white
                                            : null,
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                              const Gap(10),
                              InkWell(
                                onTap: () {
                                  _launchURL(instagram);
                                },
                                child: Image.asset(
                                  'assets/image/instagram.png',
                                  color: AdaptiveTheme.of(context).mode.isDark == true
                                      ? Colors.white
                                      : null,
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                              const Gap(10),
                              // InkWell(
                              //   onTap: () {
                              //     _launchURL(twitter);
                              //   },
                              //   child: Image.asset(
                              //     'assets/image/twitter x.png',
                              //     height: 30,
                              //     width: 20,
                              //     //
                              //   ),
                              // )
                            ],
                          ),
                          const Gap(10),
                          Center(
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    _makePhoneCall(email);
                                  },
                                  child: Text(
                                    email,
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      // color: lightGrey,
                                    ),
                                  ).tr(),
                                ),
                                // Text(
                                //   appName,
                                //   style: TextStyle(
                                //     fontFamily: 'Nunito',
                                //     fontWeight: FontWeight.w600,
                                //     fontSize: 14,
                                //     color: lightGrey,
                                //   ),
                                // ).tr(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Have A Question?',  style: TextStyle(fontFamily: 'Nunito',fontWeight: FontWeight.w700,fontSize: 20,)).tr(),
                          const Gap(2),
                          SizedBox(
                            width: 110, // Adjust this based on text width
                            child: Divider(
                              color: Colors.grey,
                              thickness: 2, // Reduced thickness for better appearance
                            ),
                          ),
                          const Gap(3),
                          InkWell(
                              onTap: () {
                                context.go('/faq');
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: 35),
                                child: Text(
                                  'FAQ',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontWeight:FontWeight.w600,
                                    fontSize: 15,
                                    // color: lightGrey,
                                  ),
                                ).tr(),
                              )
                          ),
                          const Gap(30)
                        ],
                      ),
                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     // const Gap(10),
                      //      Text('Download Now',  style: TextStyle(fontFamily: 'Nunito',fontWeight: FontWeight.w700,color: lightGrey,fontSize: 20,)).tr(),
                      //     const Gap(2),
                      //     SizedBox(
                      //       width: 70, // Adjust this based on text width
                      //       child: Divider(
                      //         color: Colors.black,
                      //         thickness: 2, // Reduced thickness for better appearance
                      //       ),
                      //     ),
                      //     const Gap(3),
                      //     InkWell(
                      //       onTap: () {
                      //         _launchURL(playstoreUrl);
                      //       },
                      //       child: SvgPicture.asset(
                      //         'assets/image/playstore.svg',
                      //         //
                      //         height: 30,
                      //         // width: 20,
                      //       ),
                      //     ),
                      //     const Gap(2),
                      //     InkWell(
                      //       onTap: () {
                      //         _launchURL(appStoreUrl);
                      //       },
                      //       child: SvgPicture.asset(
                      //         'assets/image/appstore.svg',
                      //         //
                      //         height: 30,
                      //         // width: 20,
                      //       ),
                      //     ),
                      //     //     const Gap(10),
                      //   ],
                      // )
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Company',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              )).tr(),
                          const Gap(10),
                          // SizedBox(
                          //   width: 70, // Adjust this based on text width
                          //   child: Divider(
                          //     color: Colors.black,
                          //     thickness: 2, // Reduced thickness for better appearance
                          //   ),
                          // ),
                          // const Gap(3),
                          InkWell(
                              onTap: () {
                                context.go('/about');
                              },
                                child: Text('About Us',style: TextStyle(fontFamily: 'Nunito',fontSize: 16,fontWeight: FontWeight.bold,),)
                                // child:Image.asset(onlyLogo,scale: 5,)

                          ),
                          const Gap(30)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Have A Question?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              )).tr(),
                          const Gap(10),
                          InkWell(
                            onTap: () {
                              context.go('/faq');
                            },
                            child: const Text(
                              'FAQ',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ).tr(),
                          ),
                          const Gap(30)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const Gap(10),
                          const Text('Get in touch',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              )).tr(),
                          // const Gap(10),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  _launchURL(faceBook);
                                },
                                child: Image.asset(
                                  'assets/image/facebook.png',
                                  height: 20,
                                  width: 20,
                                  color: AdaptiveTheme.of(context).mode.isDark == true
                                      ? Colors.white
                                      : null,
                                ),
                              ),
                              const Gap(10),
                              InkWell(
                                onTap: () {
                                  _launchURL(instagram);
                                },
                                child: Image.asset(
                                  'assets/image/instagram.png',
                                  height: 20,
                                  width: 20,
                                  color: AdaptiveTheme.of(context).mode.isDark == true
                                      ? Colors.white
                                      : null,
                                ),
                              ),
                              const Gap(10),
                              // InkWell(
                              //   onTap: () {
                              //     _launchURL(twitter);
                              //   },
                              //   child: Image.asset(
                              //     'assets/image/twitter x.png',
                              //     height: 30,
                              //     width: 20,
                              //     //
                              //   ),
                              // )
                            ],
                          ),
                          const Gap(5),
                          InkWell(
                            onTap: () {
                              _makePhoneCall(email);
                            },
                            child:  Text(
                              email,
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ).tr(),
                          ),
                          // const Gap(3),
                          // const Text(
                          //   '$appName',
                          //   style: TextStyle(
                          //     fontSize: 10,
                          //   ),
                          // ).tr()
                        ],
                      ),
                    ),
                    const Gap(20),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       // const Gap(10),
                    //       const Text('Download Now',
                    //           style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 15,
                    //           )).tr(),
                    //       const Gap(10),
                    //       InkWell(
                    //         onTap: () {
                    //           _launchURL(faceBook);
                    //         },
                    //         child: SvgPicture.asset(
                    //           'assets/image/playstore.svg',
                    //           //
                    //           height: 30,
                    //           // width: 20,
                    //         ),
                    //       ),
                    //       const Gap(10),
                    //       InkWell(
                    //         onTap: () {
                    //           _launchURL(instagram);
                    //         },
                    //         child: SvgPicture.asset(
                    //           'assets/image/appstore.svg',
                    //           //
                    //           height: 30,
                    //           // width: 20,
                    //         ),
                    //       ),
                    //       //     const Gap(10),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
          // const Gap(7),
          // const Divider(
          //   thickness: 1,
          //   indent: 20,
          //   endIndent: 20,
          // ),
          const Gap(45),
          // Column(
          //   children: [
          //     Image.asset(
          //       color: AdaptiveTheme.of(context).mode.isDark == true
          //           ? Colors.white
          //           : null,
          //       onlyLogo,
          //       scale: 20,
          //     ),
          //     Text('Lepondy Kitchen LLC',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),)
          //   ],
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                appName,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  // color: lightGrey,
                ),
              ).tr(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  context.go('/terms');
                },
                child:  Text(
                  'Terms Of Services',
                  style: TextStyle(fontSize: 16, fontFamily: 'Nunito',fontWeight: FontWeight.w600),
                ),
              ),
              const Text(
                '  |  ',
                style: TextStyle(fontSize: 16),
              ),
              InkWell(
                onTap: () {
                  context.go('/policy');
                },
                child:  Text(
                  'Privacy Policy',
                  style: TextStyle(fontSize: 16, fontFamily: 'Nunito',fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
          const Gap(5),
           Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              footerDescription,
              style: TextStyle(fontSize: MediaQuery.of(context).size.width >= 1100 ? 13 : 12, fontFamily: 'Nunito',fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
