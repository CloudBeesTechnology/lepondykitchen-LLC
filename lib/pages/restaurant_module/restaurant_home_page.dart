import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:osm_geocoder/osm_geocoder.dart';
// import 'package:go_router/go_router.dart';
// import 'package:user_web/constant.dart';
import 'package:user_web/model/user.dart';
// import 'package:user_web/widgets/cat_image_widget.dart';
import 'package:user_web/widgets/footer_widget.dart';
import 'package:user_web/widgets/nearby_address_picker.dart';
// import '../../widgets/restuarant_module_widget/restaurant_flash_sales_widget_new.dart';
import '../../providers/selected_provider.dart';
import '../../providers/vendors_list_home_provider.dart';
import '../../widgets/blogs_list.dart';
import '../../widgets/nearby_vendors.dart';
import '../../widgets/restuarant_module_widget/new_restaurant_vendo_home_widget.dart';
import '../../widgets/restuarant_module_widget/restaurant_hot_deals_widget_new.dart';
import '../../widgets/restuarant_module_widget/restaurant_last_banner_widget.dart';
import '../../widgets/restuarant_module_widget/restaurant_new_categories_widget.dart';
import '../../widgets/restuarant_module_widget/restaurant_new_offers.dart';
import '../../widgets/restuarant_module_widget/restaurant_new_slider.dart';
import '../../widgets/restuarant_module_widget/restaurant_products_by_cat_home_page_widget.dart';
import '../../widgets/restuarant_module_widget/restaurant_today_menu_widget.dart';
import '../../widgets/restuarant_module_widget/restaurant_top_banner_widget.dart';
import '../../widgets/restuarant_module_widget/restaurant_vendor_mobile_home_widget.dart';
import 'package:geolocator/geolocator.dart';

class RestaurantHomePage extends ConsumerStatefulWidget {
  const RestaurantHomePage({
    super.key,
  });

  @override
  ConsumerState<RestaurantHomePage> createState() => _RestaurantHomePageState();
}

class _RestaurantHomePageState extends ConsumerState<RestaurantHomePage> {
  Position? position;
  String address = '';
  double lat = 0;
  double long = 0;



  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    _initializeLocation();

    super.initState();
  }

  Future<void> _initializeLocation() async {
    try {
      position = await getCurrentLocation();
      Coordinates coordinates =
          Coordinates(lat: position!.latitude, lon: position!.longitude);
      LocationData data = await OSMGeocoder.findDetails(coordinates);
      setState(() {
        address = data.displayName;
      }); // Trigger rebuild to pass location
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleKeyboardScroll(KeyEvent event) {
    if (event is KeyDownEvent) {
      double scrollAmount = MediaQuery.of(context).size.height *
          0.8; // Scroll most of the page height

      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _scrollController.animateTo(
          _scrollController.offset + scrollAmount,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _scrollController.animateTo(
          _scrollController.offset - scrollAmount,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final selectedVendorModule = ref.watch(selectedVendorModuleProvider);
    final moduleToUse = selectedVendorModule ?? 'Restaurant';
    // Add a listener to track vendor state changes
    ref.listen<AsyncValue<List<UserModel>>>(vendorsStreamNotificationProvider,
        (previous, next) {
      next.whenData((vendors) {
        // Compare previous and current states
        if (previous != null && previous.hasValue) {
          final previousVendors = previous.value!;

          for (var vendor in vendors) {
            // Find the corresponding vendor in previous list
            final prevVendor = previousVendors.firstWhere(
              (v) => v.uid == vendor.uid,
              orElse: () => vendor,
            );

            // Check if isOpened state has changed
            if (prevVendor.isOpened != vendor.isOpened) {
              // Show toast for state change
              Fluttertoast.showToast(
                timeInSecForIosWeb: 3,
                msg: vendor.isOpened!
                    ? 'Vendor ${vendor.displayName} is now OPENED'
                    : 'Vendor ${vendor.displayName} is now CLOSED',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                webBgColor: "#FFD581",
                webPosition: "center",
                backgroundColor: vendor.isOpened! ?  const Color(0xFFFFD581) :  const Color(0xFFFFD581),
                textColor: Colors.black,
              );
            }
          }
        }
      });
    });
    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: _handleKeyboardScroll,
      child: Scaffold(
        // floatingActionButtonLocation: MediaQuery.of(context).size.width >= 1100
        //     ? FloatingActionButtonLocation.startTop
        //     : FloatingActionButtonLocation.startFloat,
        // floatingActionButton: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: FloatingActionButton.small(
        //     backgroundColor: appColor,
        //     onPressed: () {
        //       context.go('/restaurant');
        //     },
        //     child: const Icon(
        //       Icons.home,
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
        backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
            ? null
        :
            // : const Color.fromARGB(255, 247, 240, 240),
        Colors.white,
        body: CustomScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  if (MediaQuery.of(context).size.width <= 1100) const Gap(0),
                  if (MediaQuery.of(context).size.width >= 1100) const Gap(0),
                  if (address.isNotEmpty)
                    Padding(
                        padding: MediaQuery.of(context).size.width >= 1100
                            ? const EdgeInsets.only(left: 50, right: 50)
                            : const EdgeInsets.only(left: 12),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: MediaQuery.of(context).size.width >= 1100
                                      ? 2
                                      : 6,
                                  child: InkWell(
                                    hoverColor: Colors.transparent,
                                    onTap: () async {
                                      var result = await Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                            return const NearbyAddressPicker();
                                          }));
                                      // _navigateAndDisplaySelection(context);
                                      setState(() {
                                        address = result['address'];
                                        lat = result['lat'];
                                        long = result['long'];
                                      });
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.room,
                                          color: Colors.red,
                                        ),
                                        Gap(10),
                                        Container(
                                          constraints: BoxConstraints(
                                            // minWidth: 200,
                                              maxWidth:
                                              200), // Adjust width as needed
                                          child: Text(
                                            address,
                                            maxLines: 1,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Gap(5),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          // color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(flex: 5, child: SizedBox())
                              ],
                            ))),
                  // const Gap(2),
                  const NewRestaurantVendorHomeWidget(),
                  Gap(MediaQuery.of(context).size.width >= 1100 ? 0 : 0),
                  if (moduleToUse == 'Restaurant') const RestaurantTodayMenuWidget(),
                  if (MediaQuery.of(context).size.width >= 1100) const Gap(0),
                  if (MediaQuery.of(context).size.width <= 1100) const Gap(0),
                  RestaurantNewCategoriesWidget(module: moduleToUse,),
                  Gap(MediaQuery.of(context).size.width >= 1100 ? 0 : 10),
                  // const RestaurantFlashSalesWidgetNew(),
                  // Gap(MediaQuery.of(context).size.width >= 1100 ? 20 : 10),
                  // const RestaurantLastBannerWidget(),
                  Gap(MediaQuery.of(context).size.width >= 1100 ? 25 : 15),
                  if (position != null)
                    NearbyVendors(
                      lat: lat != 0 ? lat : position!.latitude,
                      long: long != 0 ? long : position!.longitude,
                    ),
                  Gap(MediaQuery.of(context).size.width >= 1100 ? 2 : 2),
                  // const RestaurantHotDealsWidgetNew(),
                  // Gap(MediaQuery.of(context).size.width >= 1100 ? 2 : 10),
                  // const RestaurantProductsByCatHomePageWidget(),
                  // Gap(MediaQuery.of(context).size.width >= 1100 ? 20 : 10),
                  RestaurantNewOffers(module: moduleToUse,),
                  Gap(MediaQuery.of(context).size.width >= 1100 ? 20 : 15),
                  // Gap(MediaQuery.of(context).size.width >= 1100 ? 0 : 0),
                  Padding(
                    padding: MediaQuery.of(context).size.width >= 1100
                        ? const EdgeInsets.only(left: 0, right: 0)
                        : const EdgeInsets.all(0),
                    child: SizedBox(
                        height: MediaQuery.of(context).size.width >= 1100
                            ? MediaQuery.of(context).size.height / 1.5
                            : MediaQuery.of(context).size.height / 1.6,
                        width: double.infinity,
                        child: MediaQuery.of(context).size.width >= 1100
                            ? const Row(
                          children: [
                            Expanded(flex: 1, child: RestaurantNewSlider()),
                            // Gap(20),
                            // Expanded(child: RestaurantTopBannerWidget())
                          ],
                        )
                            : const RestaurantNewSlider()),
                  ),
                  // const RestaurantVendorMobileHomeWidget(),
                  // Gap(MediaQuery.of(context).size.width >= 1100 ? 20 : 10),
                  // Padding(
                  //   padding: MediaQuery.of(context).size.width >= 1100
                  //       ? const EdgeInsets.only(left: 50, right: 50)
                  //       : EdgeInsets.zero,
                  //   child: const GuidesSliderWIdget(),
                  // ),

                  // Gap(MediaQuery.of(context).size.width >= 1100 ? 2 : 10),
                  // BlogList(),
                  // Gap(MediaQuery.of(context).size.width >= 1100 ? 0 : 10),
                  // const FooterWidget()
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: const FooterWidget(), // ✅ footer scrolls smoothly
            ),
          ],
        ),
      ),
    );
  }
}
