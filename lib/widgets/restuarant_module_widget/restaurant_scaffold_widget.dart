// ignore_for_file: avoid_print
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:user_web/model/formatter.dart';
import 'package:user_web/model/menu_model.dart';
import 'package:user_web/providers/profile_provider.dart';
import 'package:user_web/widgets/mobile_menu.dart';
import 'package:user_web/widgets/restuarant_module_widget/restaurant_cart_widget.dart';
import 'package:user_web/widgets/search_widget.dart';
import 'package:user_web/model/categories.dart';
import 'package:user_web/constant.dart';
import '../../providers/currency_provider.dart';
import '../../providers/restuarant_providers/restaurant_carts_state_provider.dart';
import '../../providers/restuarant_providers/restaurant_category_providers.dart';
import '../../providers/selected_provider.dart';
import '../cat_image_widget.dart';
import '../vendor_search_widget.dart';
import 'restaurant_cats_tabs.dart';
import 'restaurant_collections_expanded_tile.dart';
import '../language_widget.dart';
// ignore: library_prefixes
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

class RestaurantScaffoldWidget extends ConsumerStatefulWidget {
  final Widget body;
  final String path;
  const RestaurantScaffoldWidget(
      {super.key, required this.body, required this.path});

  @override
  ConsumerState<RestaurantScaffoldWidget> createState() =>
      _RestaurantScaffoldWidgetState();
}

class _RestaurantScaffoldWidgetState
    extends ConsumerState<RestaurantScaffoldWidget> {
  String? selectedValue;

  // openDrawerHome() {
  //   // _scaffoldHome.currentState!.openDrawer();
  //   if (_scaffoldHome.currentState != null) {
  //     _scaffoldHome.currentState!.openDrawer();
  //   }
  // }

  void openDrawerHome() {
    if (_scaffoldHome.currentState != null) {
      _scaffoldHome.currentState!.openDrawer();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scaffoldHome.currentState?.openDrawer();
      });
    }
  }


  final GlobalKey<ScaffoldState> _scaffoldHome = GlobalKey<ScaffoldState>();

  int currentIndex = 1;

  moveToOrder() {
    context.go('/orders');
    context.pop();
    setState(() {
      currentIndex = 3;
    });
  }

  routeName() {
    if (widget.path == '/about') {
      return 'About'.tr();
    } else if (widget.path == '/profile') {
      return 'Profile'.tr();
    } else if (widget.path == '/favorite-vendors') {
      return 'Favorite Vendors'.tr();
    } else if (widget.path == '/terms') {
      return 'Terms'.tr();
    } else if (widget.path == '/policy') {
      return 'Policy'.tr();
    } else if (widget.path == '/wallet') {
      return 'Wallet'.tr();
    } else if (widget.path == '/orders') {
      return "Orders".tr();
    } else if (widget.path == '/restaurant/favorites') {
      return 'Favorites'.tr();
    } else if (widget.path == '/voucher') {
      return 'Coupons'.tr();
    } else if (widget.path == '/inbox') {
      return 'Inbox'.tr();
    } else if (widget.path == '/delivery-addresses') {
      return 'Delivery Addresses'.tr();
    } else if (widget.path.contains('/order-detail') == true) {
      return 'Order Detail'.tr();
    } else if (widget.path.contains('/faq') == true) {
      return 'FAQ'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    //print('Path is ${widget.path}');
    String hi = 'Hi'.tr();
    String account = 'Account'.tr();
    String items = 'items'.tr();
    final cartPriceQuantity = ref.watch(cartStateRestaurantProvider);
    final selectedVendor = ref.watch(selectedVendorModuleProvider);
    final module = selectedVendor ??  'Restaurant';
    final getCatsByModel =
        ref.watch(getCategoriesByModelRestaurantProvider(module)).valueOrNull;
    final getCatsByString =
        ref.watch(getCategoriesStringRestaurantProvider(module)).valueOrNull;

    final currency = ref.watch(currencySymbolProvider).valueOrNull;
    final getAuthListener = ref.watch(getAuthListenerProvider).value;
    final getFullName = getAuthListener == true
        ? ref.watch(getFullNameProvider).valueOrNull
        : '';

    bool isLoggedIn = getAuthListener == true;
    return Scaffold(
      // backgroundColor: Color(0xCCCCCC).withOpacity(1.0),
      backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
          ? Colors.black87
          : Color(0xCCCCCC).withOpacity(1.0),
      bottomNavigationBar: MediaQuery.of(context).size.width >= 1100 ||
          widget.path != '/restaurant'
          ? null
          : BottomNavigationBar(
        selectedItemColor: appColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 0) {
            // showBottomSheetTab();
            openDrawerHome();
          } else if (index == 2) {
            _scaffoldHome.currentState!.openEndDrawer();
          } else if (index == 1) {
            setState(() {
              context.go('/restaurant');
              currentIndex = index;
            });
          } else {
            modalSheet.showBarModalBottomSheet(
                expand: true,
                bounce: true,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => Scaffold(
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Gap(20),
                        Row(
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 15),
                              child: const Text(
                                'Categories',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ).tr(),
                            ),
                          ],
                        ),
                        const Gap(10),
                        if (getCatsByModel != null)
                          ListView.builder(
                              physics:
                              const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: getCatsByModel.length,
                              itemBuilder: (context, index) {
                                CategoriesModel categoriesModel =
                                getCatsByModel[index];
                                return ExpansionTile(
                                  leading: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.all(5.0),
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(5),
                                        child: CatImageWidget(
                                          url: categoriesModel.image,
                                          boxFit: 'cover',
                                        ),
                                      ),
                                    ),
                                  ),
                                  title:
                                  Text(categoriesModel.category),
                                  children: [
                                    RestaurantCollectionsExpandedTile(
                                      cat: categoriesModel.category,
                                    )
                                  ],
                                );
                              }),
                      ],
                    ),
                  ),
                ));
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.sort),
            label: 'Menu'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            label: 'Home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart_outlined),
            label: 'Cart'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu),
            label: 'Categories'.tr(),
          ),
        ],
      ),
      key: _scaffoldHome,
      endDrawer: Drawer(
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.zero)),
        width: MediaQuery.of(context).size.width >= 1100
            ? MediaQuery.of(context).size.width / 3
            : double.infinity,
        child: const RestaurantCartWidget(),
      ),
      drawer: MediaQuery.of(context).size.width >= 1100
          ? null
          : Drawer(
          shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero)),
          width: double.infinity,
          child: MobileMenuWidget(
            module: 'restaurant',
            moveToOrder: moveToOrder,
            isLogged: getAuthListener ?? false,
            cats: getCatsByModel ?? [],
          )),
      appBar: AppBar(
        elevation: MediaQuery.of(context).size.width >= 1100 ? 0 : 10,
        forceMaterialTransparency: true,
        toolbarHeight: MediaQuery.of(context).size.width >= 1100 ? 65 : null,

        automaticallyImplyLeading: false,
        centerTitle: MediaQuery.of(context).size.width >= 1100 ? false : true,
        leadingWidth: MediaQuery.of(context).size.width >= 1100
            ? 250
            : (MediaQuery.of(context).size.width <= 1100 &&
            widget.path == '/about') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/profile') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/favorite-vendors') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/terms') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/policy') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/wallet') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/orders') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/restaurant/favorites') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/voucher') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/inbox') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/delivery-addresses') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path.contains('/order-detail') == true) ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path.contains('/faq') == true) ||
            widget.path.contains('/checkout') == true
            ? null
            : 150,
        leading: MediaQuery.of(context).size.width >= 1100
            ? InkWell(
            hoverColor: Colors.transparent,
            onTap: () {
              context.go('/restaurant');
            },
            child: Image.asset(
              AdaptiveTheme.of(context).mode.isDark == true ? horizontalWhite : logo,
              scale: 5,
            ))
        // :
        // InkWell(
        //     onTap: () {
        //       openDrawerHome();
        //     },
        //     child: Icon(Icons.sort)),
            : (MediaQuery.of(context).size.width <= 1100 &&
            widget.path == '/about') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/favorite-vendors') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/profile') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/terms') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/policy') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/wallet') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/orders') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/restaurant/favorites') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/voucher') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/inbox') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/delivery-addresses') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path.contains('/order-detail') == true) ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path.contains('/faq') == true) ||
            widget.path.contains('/checkout') == true
            ? InkWell(
            onTap: () {
              if (widget.path.contains('/order-detail')) {
                context.push('/orders');
              } else {
                context.push('/restaurant');
              }
            },
            child: const Icon(Icons.arrow_back))
            : Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
              hoverColor: Colors.transparent,
              onTap: () {
                context.go('/restaurant');
              },
              child: Image.asset(
                AdaptiveTheme.of(context).mode.isDark == true ? horizontalWhite :logo,
                scale: 3,
              )),
        ),
        title: MediaQuery.of(context).size.width >= 1100
            ? SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          // height: 40,
          child: Row(
            children: [
              const Gap(15),
                      InkWell(
                        onTap: () {
                          context.go('/restaurant');
                        },
                        child: Text(
                          'Home',
                          style: TextStyle(
                              // color: Colors.black,
                              fontFamily: 'Nunito',
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          ),
                        ).tr(),
                      ),
              const Gap(18),
              RestaurantCatsTabs(items: getCatsByString ?? []),
              // const Gap(18),
                      // InkWell(
                      //   onTap: () {
                      //     context.go('/restaurant');
                      //   },
                      //   child: Text(
                      //     'Contact Us',
                      //     style: TextStyle(
                      //         color: Colors.black,
                      //         fontFamily: 'Nunito',
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.w600
                      //     ),
                      //   ).tr(),
                      // ),
              Gap(90),
              Expanded(
                flex: 4,
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: widget.path.contains('/restaurant/vendor')
                      ? VendorSearchWidget(
                    autoFocus: true,
                  )
                      : SearchWidget(
                    module: module,
                    autoFocus: false,
                  ),
                ),
              ),
            ]
          ),
        )
            : (MediaQuery.of(context).size.width <= 1100 &&
            widget.path == '/about') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/profile') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/terms') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/policy') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/wallet') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/orders') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/restaurant/favorites') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/favorite-vendors') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/voucher') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/inbox') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/delivery-addresses') ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path.contains('/order-detail') == true) ||
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path.contains('/faq') == true) ||
            widget.path.contains('/checkout') == true
            ? Text(routeName())
            : null,
        // SizedBox(
        //     height: 40,
        //     child: const SearchWidget(
        //       autoFocus: false,
        //     ),
        //   ),
        actions: [
          if (MediaQuery.of(context).size.width <= 1100)
            (MediaQuery.of(context).size.width <= 1100 &&
                widget.path == '/about') ||
                (MediaQuery.of(context).size.width <= 1100 &&
                    widget.path == '/profile') ||
                (MediaQuery.of(context).size.width <= 1100 &&
                    widget.path == '/favorite-vendors') ||
                (MediaQuery.of(context).size.width <= 1100 &&
                    widget.path == '/terms') ||
                (MediaQuery.of(context).size.width <= 1100 &&
                    widget.path == '/policy') ||
                (MediaQuery.of(context).size.width <= 1100 &&
                    widget.path == '/wallet') ||
                (MediaQuery.of(context).size.width <= 1100 &&
                    widget.path == '/orders') ||
                (MediaQuery.of(context).size.width <= 1100 &&
                    widget.path == '/restaurant/favorites') ||
                (MediaQuery.of(context).size.width <= 1100 &&
                    widget.path == '/voucher') ||
                (MediaQuery.of(context).size.width <= 1100 &&
                    widget.path == '/inbox') ||
                (MediaQuery.of(context).size.width <= 1100 &&
                    widget.path == '/delivery-addresses') ||
                (MediaQuery.of(context).size.width <= 1100 &&
                    widget.path.contains('/order-detail') == true) ||
                (MediaQuery.of(context).size.width <= 1100 &&
                    widget.path.contains('/faq') == true) ||
                widget.path.contains('/checkout') == true
                ? const SizedBox.shrink()
                : IconButton(
                onPressed: () {
                  modalSheet.showBarModalBottomSheet(
                      expand: true,
                      bounce: true,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return Scaffold(
                            body: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: widget.path.contains('/restaurant/vendor')
                                  ? VendorSearchWidget(
                                autoFocus: true,
                              )
                                  : SearchWidget(
                                autoFocus: true,
                                module: module,
                              ),
                            ));
                      });
                },
                icon:  Icon(Icons.search,color: AdaptiveTheme.of(context).mode.isDark == true
                    ? Colors.white // Color for dark mode
                    : Colors.black,)),
                Gap(5),
          // IconButton(
          //     onPressed: () {
          //       if (MediaQuery.of(context).size.width >= 1100) {
          //         showDialog(
          //             context: context,
          //             builder: (context) {
          //               return AlertDialog(
          //                 content: SizedBox(
          //                     width: MediaQuery.of(context).size.width >= 1100
          //                         ? MediaQuery.of(context).size.width / 3
          //                         : MediaQuery.of(context).size.width / 1.3,
          //                     height: MediaQuery.of(context).size.height / 1.5,
          //                     child: const LanguageWidget()),
          //               );
          //             });
          //       } else {
          //         modalSheet.showBarModalBottomSheet(
          //             expand: true,
          //             bounce: true,
          //             context: context,
          //             backgroundColor: Colors.transparent,
          //             builder: (context) {
          //               return const Scaffold(body: LanguageWidget());
          //             });
          //       }
          //     },
          //     icon: const Icon(Icons.language)),
          // if (MediaQuery.of(context).size.width >= 1100)
          // IconButton(onPressed: (){},  icon: const Icon(Icons.search)),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {
                  _scaffoldHome.currentState!.openEndDrawer();
                },
                icon: const Icon(Icons.shopping_cart_outlined),
              ),
              if (cartPriceQuantity.cartQuantity > 0)
                Positioned(
                  // Adjust these values as needed
                  top: MediaQuery.of(context).size.width >= 1100 ? 0 : 1,
                  right: MediaQuery.of(context).size.width >= 1100 ? 0 : 1,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: appColor,
                      shape: BoxShape.circle,
                    ),
                    constraints:  BoxConstraints(
                      minWidth:   MediaQuery.of(context).size.width >= 1100 ? 18 : 18,
                      minHeight:  MediaQuery.of(context).size.width >= 1100 ? 18 : 18,
                    ),
                    child: Text(
                      '${cartPriceQuantity.cartQuantity}',
                      style:  TextStyle(
                        color: Colors.black,
                        fontSize:  MediaQuery.of(context).size.width >= 1100 ?  10 : 9,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
              Gap(3),

          // IconButton(
          //     onPressed: () {
          //       if (MediaQuery.of(context).size.width >= 1100) {
          //         showDialog(
          //             context: context,
          //             builder: (context) {
          //               return AlertDialog(
          //                 content: SizedBox(
          //                     width: MediaQuery.of(context).size.width >= 1100
          //                         ? MediaQuery.of(context).size.width / 3
          //                         : MediaQuery.of(context).size.width / 1.3,
          //                     height: MediaQuery.of(context).size.height / 1.5,
          //                     child: const LanguageWidget()),
          //               );
          //             });
          //       } else {
          //         modalSheet.showBarModalBottomSheet(
          //             expand: true,
          //             bounce: true,
          //             context: context,
          //             backgroundColor: Colors.transparent,
          //             builder: (context) {
          //               return const Scaffold(body: LanguageWidget());
          //             });
          //       }
          //     },
          //     icon: const Icon(Icons.language)),

          // IconButton(onPressed: (){},  icon: const Icon(Icons.notifications_none)),

          if (MediaQuery.of(context).size.width >= 1100) const Gap(10),
          MediaQuery.of(context).size.width >= 1100
              ? DropdownButtonHideUnderline(
            child: DropdownButton2(
              dropdownStyleData: const DropdownStyleData(width: 200),
              isExpanded: true,
              customButton: Row(
                children: [
                  Badge(
                    largeSize: 0,
                    smallSize: 0,
                    // padding: EdgeInsets.all(10),
                    isLabelVisible:
                    getAuthListener == true ? true : false,
                    //   padding: EdgeInsets.only(top: 3),
                    // backgroundColor: appColor,
                    alignment: Alignment.centerRight,
                    // label: const Icon(
                    //   Icons.check,
                    //   color: Colors.white,
                    //   size: 6,
                    // ),
                    child:  Icon(
                      Icons.person_outline_outlined,
                      color: AdaptiveTheme.of(context).mode.isDark == true ? Colors.white : Colors.black ,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    getAuthListener == true
                        ? '$hi, ${getFullName ?? ''}'
                        : account,
                    style: TextStyle(
                        color:  AdaptiveTheme.of(context).mode.isDark == true ? Colors.white : Colors.black ,
                      fontFamily: 'Nunito',
                        fontSize: 14, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                   Icon(
                    Icons.arrow_drop_down_outlined,
                    color: AdaptiveTheme.of(context).mode.isDark == true ? Colors.white : Colors.black ,
                    //  color: Color.fromRGBO(48, 30, 2, 1),
                  ),
                ],
              ),
              items: [
                ...MenuItems.firstItems.map(
                      (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
                const DropdownMenuItem<Divider>(
                    enabled: false, child: Divider()),
                if (getAuthListener == true)
                  ...MenuItems.secondItems.map(
                        (item) => DropdownMenuItem<MenuItem>(
                      value: item,
                      child: MenuItems.buildItem(item),
                    ),
                  ),
                if (getAuthListener == false)
                  ...MenuItems.secondItems2.map(
                        (item) => DropdownMenuItem<MenuItem>(
                      value: item,
                      child: MenuItems.buildItem(item),
                    ),
                  ),
              ],
              value: selectedValue,
              onChanged: (value) {
                MenuItems.onChanged(
                    context, value! as MenuItem, '/restaurant');
              },
            ),
          )
              : Row(
            children: [
              Badge(
                largeSize: 0,
                smallSize: 0,
                isLabelVisible: getAuthListener == true ? true : false,
                // backgroundColor: appColor,
                alignment: Alignment.topRight,
                // label: const Icon(
                //   Icons.check,
                //   color: Colors.white,
                //   size: 8,
                // ),
                child: IconButton(
                  onPressed: () {
                    if (getAuthListener == true) {
                      context.go('/profile');
                    } else {
                      context.go('/login');
                    }
                  },
                  icon:  Icon(Icons.person_outline,  color: AdaptiveTheme.of(context).mode.isDark == true ? Colors.white : Colors.black ,),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                getAuthListener == true ? '${getFullName ?? ''}' : account,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const Gap(10),
          // MediaQuery.of(context).size.width >= 1100
              // ? TextButton.icon(
              // onPressed: () {
              //   _scaffoldHome.currentState!.openEndDrawer();
              // },
              // icon: Icon(
              //   Icons.shopping_cart_outlined,
              //   color: AdaptiveTheme.of(context).mode.isDark == true
              //       ? Colors.white
              //       : Colors.black,
              // ),
              // label: Text(
              //   'Cart',
              //   style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //       fontFamily: 'Nunito',
              //       fontSize: 4.sp,
              //       color: AdaptiveTheme.of(context).mode.isDark == true
              //           ? Colors.white
              //           : Colors.black),
              // ).tr())
              // : const SizedBox.shrink(),
          // if (MediaQuery.of(context).size.width >= 1100)
          //   AdaptiveTheme.of(context).mode.isDark == true
          //       ? InkWell(
          //       onTap: () {
          //         AdaptiveTheme.of(context).setLight();
          //       },
          //       child: const Icon(Icons.light_mode))
          //       : InkWell(
          //       onTap: () {
          //         AdaptiveTheme.of(context).setDark();
          //       },
          //       child: const Icon(Icons.dark_mode)),
          if (MediaQuery.of(context).size.width >= 1100) const Gap(100)
        ],
        // bottom: MediaQuery.of(context).size.width >= 1100
        //     ? null
        //     : const PreferredSize(
        //         preferredSize: Size.fromHeight(50),
        //         child: Center(
        //           child: Padding(
        //             padding: EdgeInsets.only(left: 8, right: 8, bottom: 5),
        //             child: SizedBox(
        //                 height: 40, child: SearchWidget(autoFocus: false)),
        //           ),
        //         ))
      ),
      body: Stack(
        children: [
          widget.body,
          // widget.path == '/restaurant' ||
          //     widget.path.contains('/product-detail') ||
          //     widget.path.contains('/restaurant/products/') ||
          //     widget.path.contains('/restaurant/collection/') ||
          //     widget.path.contains('/restaurant/flash-sales') ||
          //     widget.path.contains('/restaurant/hot-deals') ||
          //     widget.path.contains('/vendor-detail') ||
          //     widget.path.contains('/vendors')
          //     ? Padding(
          //   padding: const EdgeInsets.only(top: 200),
          //   child: Align(
          //     alignment: Alignment.centerRight,
          //     child: InkWell(
          //       onTap: () {
          //         _scaffoldHome.currentState!.openEndDrawer();
          //       },
          //       child: Container(
          //         height: 80,
          //         width: 80,
          //         decoration: BoxDecoration(
          //             color: appColor,
          //             borderRadius: const BorderRadius.only(
          //                 topLeft: Radius.circular(5),
          //                 bottomLeft: Radius.circular(5))),
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceAround,
          //               children: [
          //                 Padding(
          //                   padding: const EdgeInsets.only(bottom: 5),
          //                   child: Icon(
          //                     Icons.shopping_bag,
          //                     color:
          //                     AdaptiveTheme.of(context).mode.isDark ==
          //                         true
          //                         ? Colors.black
          //                         : Colors.white,
          //                     size: 14,
          //                   ),
          //                 ),
          //                 Text(
          //                   '${cartPriceQuantity.cartQuantity} $items',
          //                   style: TextStyle(
          //                       color: AdaptiveTheme.of(context)
          //                           .mode
          //                           .isDark ==
          //                           true
          //                           ? Colors.black
          //                           : Colors.white,
          //                       fontSize: 10),
          //                 ),
          //               ],
          //             ),
          //             const Gap(10),
          //             Padding(
          //               padding: const EdgeInsets.only(left: 8),
          //               child: Container(
          //                 decoration: BoxDecoration(
          //                     color:
          //                     AdaptiveTheme.of(context).mode.isDark ==
          //                         true
          //                         ? Colors.black87
          //                         : Colors.white,
          //                     borderRadius: const BorderRadius.all(
          //                         Radius.circular(5))),
          //                 child: Padding(
          //                   padding: const EdgeInsets.all(8.0),
          //                   child: cartPriceQuantity.price == 0
          //                       ? Text(
          //                     currency == null
          //                         ? '0.00'
          //                         : '$currency 0.00',
          //                     maxLines: 1,
          //                     overflow: TextOverflow.ellipsis,
          //                     style: const TextStyle(
          //                         fontWeight: FontWeight.bold,
          //                         fontSize: 10),
          //                   )
          //                       : Text(
          //                     currency == null
          //                         ? '0.00'
          //                         : '$currency${Formatter().converter(cartPriceQuantity.price.toDouble())}',
          //                     maxLines: 1,
          //                     overflow: TextOverflow.ellipsis,
          //                     style: const TextStyle(
          //                         fontWeight: FontWeight.bold,
          //                         fontSize: 10),
          //                   ),
          //                 ),
          //               ),
          //             )
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // )
          //     :
          const SizedBox.shrink()
        ],
      ),
    );
  }
}
