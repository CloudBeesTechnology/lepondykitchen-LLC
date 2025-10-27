import 'dart:math';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'model/module_model.dart';

// 🔐 Secure constants loaded from .env
final String projectID = dotenv.env['PROJECT_ID'] ?? '';
final String googleApiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
final String serverUrl = dotenv.env['SERVER_URL'] ?? '';
final String domainUrl = dotenv.env['DOMAIN_URL'] ?? '';
final String email = dotenv.env['EMAIL'] ?? '';
final String appName = dotenv.env['APP_NAME'] ?? '';
final String playstoreUrl = dotenv.env['PLAYSTORE_URL'] ?? '';
final String appStoreUrl = dotenv.env['APPSTORE_URL'] ?? '';

// 🎨 Colors
Color appColor = const Color(0xFFFB623).withOpacity(1.0);
Color darkGrey = const Color(0xF303030).withOpacity(1.0);
Color primary = const Color(0xFFFB623).withOpacity(1.0);
Color lightGrey = const Color(0xF675252).withOpacity(1.0);

// 🖼️ Assets
const String logo = "assets/image/Logo-Horizontal-1.png";
const String onlyLogo = "assets/image/Logo-Vertical-1.png";
const String horizontalWhite = "assets/image/horizontal logo white.png";
const String verticalWhite = "assets/image/Logo-Vertical-1-white.png";
const String logoLoader = "assets/image/new lepondy.png";

// 🌐 Misc
String loadingText = 'Loading...';
const String networkText = 'Please check internet connection...';
bool loadingBool = false;
const double radiusKM = 10;

const footerDescription =
    'The site is owned and operated by Le Pondy Kitchen LLC- a company registered in Columbus, Ohio. Company Registration No. 202500204632, EIN. 33-2824523 © 2025 LePondy kitchen.web.app All Rights Reserved.';

// 🖼️ Random image selector
List<String> sliderBackgroundImages = [
  'assets/image/2.png',
  'assets/image/2.png',
  "assets/image/3.png",
];

List<Color> groceryFeedsColors = [
  Colors.blue,
  Colors.orange,
  Colors.red,
  Colors.green
];

Color selectgroceryFeedsColors() {
  final random = Random();
  return groceryFeedsColors[random.nextInt(groceryFeedsColors.length)];
}

String selectSlider() {
  final random = Random();
  return sliderBackgroundImages[random.nextInt(sliderBackgroundImages.length)];
}

// 🧱 Dialog utilities
void showAlertDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AdaptiveTheme.of(context).mode.isDark
            ? Colors.grey[900]
            : Colors.white,
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}

Future<void> showAlertsDialog(BuildContext context, String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: AdaptiveTheme.of(context).mode.isDark
            ? Colors.grey[900]
            : Colors.white,
        title: const Text('Success'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
  try {
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  } catch (e) {
    final fallbackUri = Uri(
      scheme: 'https',
      host: 'web.whatsapp.com',
      path: '/send',
      queryParameters: {'phone': phoneNumber.replaceAll(RegExp(r'[^0-9]'), '')},
    );

    if (await canLaunchUrl(fallbackUri)) {
      await launchUrl(fallbackUri);
    } else {
      debugPrint('Could not launch call or WhatsApp: $e');
    }
  }
}

// 📦 Module list
List<ModuleModel> allModule = [
  ModuleModel(
      name: 'Ecommerce',
      image: 'assets/image/ecommerce.png',
      route: '/ecommerce'),
  ModuleModel(
      name: 'Restaurant',
      image: 'assets/image/restaurant.png',
      route: '/restaurant'),
  ModuleModel(
      name: 'Pharmacy',
      image: 'assets/image/pharmacy.png',
      route: '/pharmacy'),
  ModuleModel(
      name: 'Grocery', image: 'assets/image/grocery.png', route: '/grocery'),
  ModuleModel(
      name: 'Parcel Delivery',
      image: 'assets/image/delivery guy.png',
      route: '/parcel-delivery'),
];
