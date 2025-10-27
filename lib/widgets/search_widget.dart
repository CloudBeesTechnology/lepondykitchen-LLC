import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:user_web/model/products_model.dart';

class SearchWidget extends StatefulWidget {
  final bool autoFocus;
  final String module;
  const SearchWidget(
      {super.key, required this.autoFocus, required this.module});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _controller = TextEditingController();
  final SuggestionsController<ProductsModel> _suggestionBoxController =
  SuggestionsController<ProductsModel>();
  final ValueNotifier<bool> _showClear = ValueNotifier(false);
  bool isTypeOpened = false;
  String currentModule = 'Restaurant';

  @override
  void initState() {
    _controller.addListener(() {
      _showClear.value = _controller.text.isNotEmpty;
    });

    _suggestionBoxController.addListener(() {
      isTypeOpened = _suggestionBoxController.isOpen;
      print('type is open $isTypeOpened');
    });
    currentModule = widget.module;

    getProducts();
    super.initState();
  }


  void updateModule(String newModule) {
    if (newModule != currentModule) {
      setState(() {
        currentModule = newModule;
      });
      getProducts(); // Refresh products with new module
    }
  }


  List<ProductsModel> products = [];
  // List<ProductsModel> productsFilter = [];
  bool isLoaded = false;

  getProducts() async {
    setState(() {
      isLoaded = true;
    });
    FirebaseFirestore.instance
        .collection('Products')
        .where('module', isEqualTo: currentModule)
        .snapshots()
        .listen((event) {
      setState(() {
        isLoaded = false;
      });
      products.clear();
      for (var element in event.docs) {
        var prods = ProductsModel.fromMap(element, element.id);
        setState(() {
          products.add(prods);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String search = "Search for a product".tr();
    return TypeAheadField<ProductsModel>(
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
                  icon: const Icon(Icons.close),
                )
                    : const SizedBox.shrink(); // Return empty widget instead of null
              },
            ),
          ),
        ),
      ),
      suggestionsCallback: (pattern) {
        if (pattern.isNotEmpty) {
          return products
              .where((product) =>
              product.name.toLowerCase().contains(pattern.toLowerCase()))
              .toList();
        } else {
          return [];
        }
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(
            suggestion.name,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width >= 1100 ? null : 13),
          ),
        );
      },
      onSelected: (ProductsModel value) {
        _controller.text = value.name;
        // Always use restaurant path regardless of product module
        context.go('/restaurant/product-detail/${value.uid}');
        if (MediaQuery.of(context).size.width <= 1100) {
          context.pop();
        }
      },
    );
  }
}