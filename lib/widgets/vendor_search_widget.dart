import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:user_web/constant.dart';
import 'package:user_web/model/user.dart';

class VendorSearchWidget extends StatefulWidget {
  final bool autoFocus;
  const VendorSearchWidget({super.key, required this.autoFocus});

  @override
  State<VendorSearchWidget> createState() => _VendorSearchWidgetState();
}

class _VendorSearchWidgetState extends State<VendorSearchWidget> {
  final TextEditingController _controller = TextEditingController();
  final _suggestionBoxController = SuggestionsController<UserModel>();
  final ValueNotifier<bool> _showClear = ValueNotifier(false);
  bool isTypeOpened = false;

  @override
  void initState() {
    _controller.addListener(() {
      _showClear.value = _controller.text.isNotEmpty;
    });

    _suggestionBoxController.addListener(() {
      if (_suggestionBoxController.isOpen == true) {
        isTypeOpened = true;
        // ignore: avoid_print
        print('type is open $isTypeOpened');
      } else {
        isTypeOpened = false;
      }
    });
    getProducts();
    super.initState();
  }

  List<UserModel> products = [];
  // List<UserModel> productsFilter = [];
  bool isLoaded = false;

  // getProducts() async {
  //   setState(() {
  //     isLoaded = true;
  //   });
  //   FirebaseFirestore.instance
  //       .collection('vendors')
  //       .where('approval', isEqualTo: true)
  //       .snapshots()
  //       .listen((event) {
  //     setState(() {
  //       isLoaded = false;
  //     });
  //     products.clear();
  //     for (var element in event.docs) {
  //       var prods = UserModel.fromMap(element.data(), element.id);
  //       setState(() {
  //         products.add(prods);
  //       });
  //     }
  //   });
  // }

  getProducts() async {
    setState(() {
      isLoaded = true;
    });

    FirebaseFirestore.instance
        .collection('vendors')
        .where('approval', isEqualTo: true)
        .snapshots()
        .listen((event) {
      setState(() {
        isLoaded = false;
      });

      // Check if products is initialized
      if (products == null) {
        products = [];
      }

      products.clear();
      for (var element in event.docs) {
        var prods = UserModel.fromMap(element.data(), element.id);
        setState(() {
          products.add(prods);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String search = "Search for a vendor".tr();
    return TypeAheadField<UserModel>(
      controller: _controller,
      suggestionsController: _suggestionBoxController,
      // textFieldConfiguration: TextFieldConfiguration(
      //   autofocus: true,
      //   controller: _controller,
      //   decoration: const InputDecoration(
      //     hintText: 'Search country...',
      //   ),
      // ),
      emptyBuilder: (context) {
        if (_controller.text.isEmpty) {
          return const Text('');
        } else {
          return const Text('No result found');
        }
      },
      builder: (context, controller, focusNode) => Container(
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: widget.autoFocus,
          decoration: InputDecoration(
            filled: true,
            // fillColor: Theme.of(context).primaryColor.withAlpha(25),
            fillColor:AdaptiveTheme.of(context).mode.isDark == true
                ? null
                : Theme.of(context).primaryColor.withAlpha(25),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(context).size.width >= 1100 ? 20 : 20),
              ),
            ),
            hintText: search,
            hintStyle: TextStyle(
              fontSize: MediaQuery.of(context).size.width >= 1100 ? null : 13,
            ),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: ValueListenableBuilder<bool>(
              valueListenable: _showClear,
              builder: (context, showClear, child) {
                return showClear
                    ? IconButton(
                  onPressed: () {
                    print('suffix is $isTypeOpened');
                    _suggestionBoxController.close();
                    _controller.clear();
                  },
                  icon: const Icon(Icons.close, color: Colors.black),
                )
                    : const SizedBox.shrink(); // Always return a Widget
              },
            ),
          ),
        ),
      ),
      suggestionsCallback: (pattern) {
        if (pattern.isNotEmpty) {
          return products
              .where((country) => country.displayName
                  .toLowerCase()
                  .contains(pattern.toLowerCase()))
              .toList();
        } else {
          return [];
        }
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(
            suggestion.displayName,
            style: TextStyle(
                fontSize:
                    MediaQuery.of(context).size.width >= 1100 ? null : 13),
          ),
        );
      },
      onSelected: (UserModel value) {
        _controller.text = value.displayName;
        if (value.isOpened == false || value.isOpened == null) {
          // Fluttertoast.showToast(
          //   msg: "Vendor is closed".tr(),
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.TOP,
          //   timeInSecForIosWeb: 6,
          //   fontSize: 14.0,
          // );
          showAlertDialog(context,"Note","Vendor is closed");
        } else {
          if (value.module == 'Ecommerce') {
            context.go('/ecommerce/vendor-detail/${value.uid}');
          } else if (value.module == 'Restaurant') {
            context.go('/restaurant/vendor-detail/${value.uid}');
          } else if (value.module == 'Pharmacy') {
            context.go('/pharmacy/vendor-detail/${value.uid}');
          } else {
            context.go('/grocery/vendor-detail/${value.uid}');
          }
          if (MediaQuery.of(context).size.width <= 1100) {
            context.pop();
          }
        }
      },
    );
  }
}
