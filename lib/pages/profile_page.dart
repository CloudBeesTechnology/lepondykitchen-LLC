import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:user_web/widgets/web_menu.dart';

import '../widgets/footer_widget.dart';
import '../widgets/profile_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
          ? null
          : const Color(0xFFDF7EB).withOpacity(1.0),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: MediaQuery.of(context).size.width >= 1100
                  ? const EdgeInsets.only(left: 60, right: 50)
                  : const EdgeInsets.all(0),
              child: Column(
                children: [
                  const Gap(20),
                  if (MediaQuery.of(context).size.width >= 1100)
                    Align(
                      alignment: MediaQuery.of(context).size.width >= 1100
                          ? Alignment.centerLeft
                          : Alignment.center,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              context.go('/restaurant');
                            },
                            child: const Text(
                              'Home',
                              style: TextStyle(fontSize: 14,fontFamily: 'Nunito',
                              ),
                            ).tr(),
                          ),
                          const Text(
                            '/ My Profile',
                            style: TextStyle(fontSize: 14,fontFamily: 'Nunito',),
                          ).tr(),
                        ],
                      ),
                    ),
                  Align(
                    alignment: MediaQuery.of(context).size.width >= 1100
                        ? Alignment.centerLeft
                        : Alignment.center,
                    child: const Text(
                      'Account Information',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20,fontFamily: 'Nunito'),
                    ).tr(),
                  ),
                  const Gap(20),
                ],
              ),
            ),
            MediaQuery.of(context).size.width >= 1100
                ? Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Card(
                              shape: const BeveledRectangleBorder(),
                              color:
                                  AdaptiveTheme.of(context).mode.isDark == true
                                      ? Colors.black87
                                      : Colors.white,
                              surfaceTintColor: Colors.white,
                              child: const WebMenu(path: '/profile')),
                        ),
                        const Gap(20),
                        Expanded(
                            flex: 6,
                            child: Card(
                              shape: const BeveledRectangleBorder(),
                              color:
                                  AdaptiveTheme.of(context).mode.isDark == true
                                      ? Colors.black87
                                      : Colors.white,
                              surfaceTintColor: Colors.white,
                                child:  ProfileWidget(),
                            ))
                      ],
                    ),
                  )
                :  Padding(
                    padding: EdgeInsets.all(8.0),
                        child: ProfileWidget()
                  ),
            const Gap(20),
            const FooterWidget()
          ],
        ),
      ),
    );
  }
}
