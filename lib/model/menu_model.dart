import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:user_web/Providers/auth.dart';

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [
    profile,
    // wallet,
    order,
    // address,
    favoriteVendors,
    favorite,
    trackOrder
  ];
  static const List<MenuItem> homeItems = [
    profile,
    // wallet,
    order,
    favoriteVendors,
    // address,
    trackOrder
  ];
  static const List<MenuItem> secondItems = [
    // login,
    signup,
    logout,
  ];
  static const List<MenuItem> secondItems2 = [
    login,
    signup,
    // logout,
  ];
  static const profile = MenuItem(text: 'Profile', icon: Icons.person);
  // static const wallet = MenuItem(text: 'Wallet', icon: Icons.wallet);
  static const order = MenuItem(text: 'Order', icon: Icons.list);
  // static const address = MenuItem(text: 'Saved Address', icon: Icons.room);
  static const favorite = MenuItem(text: 'Favorite', icon: Icons.favorite);
  static const favoriteVendors =
      MenuItem(text: 'Favorite Vendors', icon: Icons.favorite);
  static const trackOrder = MenuItem(text: 'Track Order', icon: Icons.room);
  static const login = MenuItem(text: 'Login', icon: Icons.login);
  static const signup = MenuItem(text: 'Signup', icon: Icons.how_to_reg);
  static const logout = MenuItem(text: 'Log Out', icon: Icons.logout);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, size: 18),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text.tr(),
            style: TextStyle(fontSize: 15.r),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item, String module) {
    switch (item) {
      case MenuItems.profile:
        //Do something
        context.go('/profile');
        break;
      case MenuItems.order:
        //Do something
        context.go('/orders');
        break;
      // case MenuItems.wallet:
      //   //Do something
      //   context.go('/wallet');
      //   break;
      case MenuItems.favoriteVendors:
        //Do something
        context.go('/favorite-vendors');
        break;
      // case MenuItems.address:
      //   //Do something
      //   context.go('/delivery-addresses');
      //   break;
      case MenuItems.logout:
        //Do something
        AuthService().signOut(context);
        // context.go('/login');
        break;
      case MenuItems.login:
        context.go('/login');
        break;

      case MenuItems.signup:
        context.go('/signup');
        break;
      case MenuItems.favorite:
        context.go('$module/favorites');
        break;
      case MenuItems.trackOrder:
        context.go('/track-order');
        break;
    }
  }
}
