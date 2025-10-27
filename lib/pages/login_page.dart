import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:user_web/widgets/login_form_widget.dart';
import 'package:user_web/constant.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    context.loaderOverlay.hide();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: MediaQuery.of(context).size.width >= 1100
      //     ? null
      //     : AppBar(actions: [
      //         Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: RichText(
      //             text: TextSpan(
      //                 text: 'Don\'t have an account?',
      //                 style: TextStyle(
      //                   color: AdaptiveTheme.of(context).mode.isDark == true
      //                       ? Colors.white
      //                       : Colors.black,
      //                 ),
      //                 children: <TextSpan>[
      //                   TextSpan(
      //                       text: ' Sign up',
      //                       style: TextStyle(
      //                         color: Colors.orange.shade900,
      //                       ),
      //                       recognizer: TapGestureRecognizer()
      //                         ..onTap = () {
      //                           // ignore: avoid_print
      //                           print('Working');
      //                           context.go('/signup');
      //                         })
      //                 ]),
      //           ),
      //         ),
      //       ]),
      body: MediaQuery.of(context).size.width >= 1100
          ? Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: CarouselSlider(
                            options: CarouselOptions(
                                viewportFraction: 1,
                                aspectRatio: 1,
                                autoPlay: true,
                                enlargeCenterPage: false),
                            items: [
                              Image.network(
                                'https://i.pinimg.com/736x/2f/2b/b2/2f2bb28e6d3cc3f5bebf037c70b06b22.jpg',
                                fit: BoxFit.cover,
                                height: double.infinity,
                                width: double.infinity,
                                scale: 1,
                              ),
                              Image.network(
                                'https://static.vecteezy.com/system/resources/previews/036/325/513/non_2x/ai-generated-vibrant-assortment-of-spicy-ethnic-dishes-and-condiments-free-photo.jpg',
                                fit: BoxFit.cover,
                                height: double.infinity,
                                width: double.infinity,
                                scale: 1,
                              ),
                              Image.network(
                                'https://i.pinimg.com/736x/63/58/52/635852cfd29d63b1b9abc6cbc9e4a36a.jpg',
                                fit: BoxFit.cover,
                                height: double.infinity,
                                width: double.infinity,
                                scale: 1,
                              ),
                              Image.network(
                                'https://i.pinimg.com/736x/f8/a7/01/f8a70144eb881afe78df0164e657e966.jpg',
                                fit: BoxFit.cover,
                                height: double.infinity,
                                width: double.infinity,
                                scale: 1,
                              ),
                              Image.network(
                                'https://img.freepik.com/premium-photo/young-courier-delivery-man-uniform-moped-isolated-yellow-background-created-with-generative-ai-technology_132358-13456.jpg?w=1060',
                                fit: BoxFit.cover,
                                height: double.infinity,
                                width: double.infinity,
                                scale: 1,
                              )
                            ],
                          ),
                        ),
                      ),
                      const Expanded(
                          flex: 7, child: SizedBox(child: LoginFormWidget()))
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      context.go('/restaurant');
                    },
                    // child: Image.asset(
                    //   onlyLogo,
                    //   scale: 5,
                    //   color: AdaptiveTheme.of(context).mode.isDark == true
                    //       ? Colors.white
                    //       : null,
                    // ),
                  ),
                ),
                // Align(
                //   alignment: Alignment.topRight,
                //   child: Padding(
                //     padding: const EdgeInsets.only(top: 15, right: 15),
                //     child: RichText(
                //       text: TextSpan(
                //           text: 'Don\'t have an account?',
                //           style: TextStyle(
                //             color: AdaptiveTheme.of(context).mode.isDark == true
                //                 ? Colors.white
                //                 : Colors.black,
                //           ),
                //           children: <TextSpan>[
                //             TextSpan(
                //                 text: ' Sign up',
                //                 style: TextStyle(
                //                   color: Colors.orange.shade900,
                //                 ),
                //                 recognizer: TapGestureRecognizer()
                //                   ..onTap = () {
                //                     context.go('/signup');
                //                   })
                //           ]),
                //     ),
                //   ),
                // )
              ],
            )
          : const Center(child: LoginFormWidget()),
    );
  }
}
