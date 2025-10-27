import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:user_web/constant.dart';
import '../../model/user.dart';

class RestaurantVendorWidgetMain extends StatefulWidget {
  final UserModel productsModel;
  final bool fromHome;
  const RestaurantVendorWidgetMain(
      {super.key, required this.productsModel, required this.fromHome});

  @override
  State<RestaurantVendorWidgetMain> createState() =>
      _RestaurantVendorWidgetMainState();
}

class _RestaurantVendorWidgetMainState
    extends State<RestaurantVendorWidgetMain> {
  String currency = '';
  @override
  void initState() {
    // getCurrency();
    getAuth();
    super.initState();
  }

  bool isLogged = false;
  getAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        setState(() {
          isLogged = false;
        });
      } else {
        setState(() {
          isLogged = true;
        });
      }
    });
  }

  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // context.go('/product-detail/${widget.productsModel.uid}');
      },
      onHover: (value) {
        // ignore: avoid_print
        print('is hovering $value');
        setState(() {
          isHovered = value;
        });
      },
      child: Transform.scale(
        scale: MediaQuery.of(context).size.width >= 1100
            ? (isHovered == true ? 1.05 : 1.0)
            : (isHovered == true ? 1 : 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: AdaptiveTheme.of(context).mode.isDark == true
                ? Colors.black87
                : Colors.white,
            borderRadius: BorderRadius.circular(10),
            // border: Border.all(
            //     color: const Color.fromARGB(255, 214, 212, 212),
            //     width: isHovered == true ? 1.5 : 0.8,
            //     style: BorderStyle.solid)
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black38,
            //     offset: const Offset(
            //       1.0,
            //       1.0,
            //     ),
            //     blurRadius: 1.0,
            //     spreadRadius: 0.0,
            //   ), //BoxShadow
            //   BoxShadow(
            //     color: Colors.white,
            //     offset: const Offset(0.0, 0.0),
            //     blurRadius: 0.0,
            //     spreadRadius: 0.0,
            //   ), //BoxShadow
            // ],
          ),
          child: SizedBox(
            // height: 320,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Gap(10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipOval(
                      child: Image.network(
                        widget.productsModel.photoUrl == ''
                            ? "https://cdn-icons-png.flaticon.com/512/2981/2981313.png"
                            : widget.productsModel.photoUrl,
                        height: widget.fromHome == true ? 50 : 80,
                        fit: BoxFit.cover,
                        width: widget.fromHome == true ? 50 : 80,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    child: Text(
                      widget.productsModel.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'LilitaOne',
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width >= 1100
                              ? 25
                              : widget.fromHome == true
                                  ? 18
                                  : 20),
                    ),
                  ),
                  if (widget.fromHome == false)
                    ListTile(
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -2),
                      title: Text(
                        widget.productsModel.email,
                      ),
                      leading: const Icon(Icons.email),
                    ),
                  if (widget.fromHome == false)
                    ListTile(
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -2),
                      title: Text(
                        widget.productsModel.phonenumber,
                      ),
                      leading: const Icon(Icons.phone),
                    ),
                  if (widget.fromHome == false)
                    ListTile(
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -2),
                      title: Text(
                        widget.productsModel.address!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: const Icon(Icons.home),
                    ),
                  const Divider(
                    color: Colors.grey,
                    endIndent: 20,
                    indent: 20,
                  ),
                  // const Gap(10),
                  Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: ElevatedButton.icon(
                        style:
                            ElevatedButton.styleFrom(backgroundColor: appColor),
                        onPressed: () {
                          context.go(
                              '/restaurant/vendor-detail/${widget.productsModel.uid}');
                        },
                        icon: const Icon(
                          Icons.storefront,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Visit Store",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  const Gap(10)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
