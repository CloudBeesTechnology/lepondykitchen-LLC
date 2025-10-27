import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:user_web/widgets/delivery_address_widget.dart';
import 'package:user_web/widgets/footer_widget.dart';
import 'package:user_web/widgets/web_menu.dart';

import '../widgets/delivery_address_widget2.dart';

class DeliveryAddressPages2 extends StatefulWidget {
  const DeliveryAddressPages2({super.key});

  @override
  State<DeliveryAddressPages2> createState() => _DeliveryAddressPages2State();
}

class _DeliveryAddressPages2State extends State<DeliveryAddressPages2> {
  @override
  void initState() {
    // getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Addresses',style: TextStyle(fontFamily: 'Nunito'),),
        // backgroundColor: Colors.grey.shade400,
        backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
            ? Colors.black87
            : Color(0xCCCCCC).withOpacity(1.0),
        leadingWidth: MediaQuery.of(context).size.width >= 1100 ? 150 : 100,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // ⬅️ goes back to signup
        ),
      ),
      backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
          ? null
          : const Color(0xFFDF7EB).withOpacity(1.0),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            if (MediaQuery.of(context).size.width >= 1100)
              Padding(
                padding: MediaQuery.of(context).size.width >= 1100
                    ? const EdgeInsets.only(left: 60, right: 50)
                    : const EdgeInsets.all(0),
                child: Column(
                  children: [
                    const Gap(20),
                    if (MediaQuery.of(context).size.width >= 1100)
                    // Align(
                    //   alignment: MediaQuery.of(context).size.width >= 1100
                    //       ? Alignment.centerLeft
                    //       : Alignment.center,
                    //   child: Row(
                    //     children: [
                    //       InkWell(
                    //         onTap: () {
                    //           context.go('/restaurant');
                    //         },
                    //         child: const Text(
                    //           'Home',
                    //           style: TextStyle(fontSize: 10),
                    //         ).tr(),
                    //       ),
                    //       const Text(
                    //         '/ Saved Address',
                    //         style: TextStyle(fontSize: 10),
                    //       ).tr(),
                    //     ],
                    //   ),
                    // ),
                      Align(
                        alignment: MediaQuery.of(context).size.width >= 1100
                            ? Alignment.centerLeft
                            : Alignment.center,
                        child: const Text(
                          'Saved Addresses',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ).tr(),
                      ),
                    const Gap(20),
                  ],
                ),
              ),
            if (MediaQuery.of(context).size.width >= 1100)
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 2,
                        child: Padding(padding: EdgeInsets.only(top: 25),
                          child: Card(
                              shape: const BeveledRectangleBorder(),
                              color: AdaptiveTheme.of(context).mode.isDark == true
                                  ? Colors.black87
                                  : Colors.white,
                              surfaceTintColor: Colors.white,
                              child: const WebMenu(path: '/delivery-addresses')),
                        )
                    ),
                    const Gap(20),
                    Expanded(
                      flex: 6,
                      child: const Padding(
                          padding: EdgeInsets.only(bottom: 30),
                          child: DeliveryAddressWidget2()),
                      // ),
                    )
                  ],
                ),
              ),
            if (MediaQuery.of(context).size.width <= 1100)
              const DeliveryAddressWidget2(),
            const Gap(20),
            const FooterWidget()
          ],
        ),
      ),
    );
  }
}