import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:user_web/model/products_model.dart';
import 'package:user_web/widgets/footer_widget.dart';
import 'package:user_web/constant.dart';
import '../../providers/restuarant_providers/restaurant_flashsales_provider.dart';
import '../../widgets/restuarant_module_widget/restaurant_product_widget_main.dart';

class RestaurantFlashSalesPage extends ConsumerStatefulWidget {
  const RestaurantFlashSalesPage({super.key});

  @override
  ConsumerState<RestaurantFlashSalesPage> createState() => _RestaurantFlashSalesPageState();
}

class _RestaurantFlashSalesPageState extends ConsumerState<RestaurantFlashSalesPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> deleteAllDocumentsInCollection(String collectionPath) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(collectionPath);

    QuerySnapshot querySnapshot = await collectionReference.get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      await collectionReference.doc(documentSnapshot.id).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final flashSalesList = ref.watch(flashsalesPageStreamRestaurantProvider);
    final timer = ref.watch(flashSalesTimeStreamRestaurantProvider);

    return Scaffold(
      backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
          ? null
          : const Color.fromARGB(255, 247, 240, 240),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.width >= 1100 ? 200 : 150,
              width: double.infinity,
              decoration: BoxDecoration(
                  // color: Color.fromARGB(255, 230, 224, 237),
                  image: DecorationImage(
                      // opacity: 0.3,
                      fit: MediaQuery.of(context).size.width >= 1100
                          ? BoxFit.cover
                          : BoxFit.fill,
                      image: const AssetImage('assets/image/flash sales.png'))),
            ),
            Padding(
              padding: MediaQuery.of(context).size.width >= 1100
                  ? const EdgeInsets.only(left: 60, right: 100)
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
                              style: TextStyle(fontSize: 10),
                            ).tr(),
                          ),
                          const Text(
                            '/ Flash Sales',
                            style: TextStyle(fontSize: 10),
                          ).tr(),
                        ],
                      ),
                    ),
                  MediaQuery.of(context).size.width >= 1100
                      ? timer.when(data: (v) {
                          DateTime targetDate = DateTime.parse(v);

                          // Calculate the difference between the target date and the current date
                          DateTime currentDate = DateTime.now();
                          Duration difference =
                              targetDate.difference(currentDate);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    MediaQuery.of(context).size.width >= 1100
                                        ? const EdgeInsets.all(0)
                                        : const EdgeInsets.all(8.0),
                                child: const Text(
                                  'Flash Sales',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ).tr(),
                              ),
                              if (v.isNotEmpty)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SlideCountdownSeparated(
                                      separatorStyle: TextStyle(
                                        color: AdaptiveTheme.of(context)
                                                    .mode
                                                    .isDark ==
                                                true
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      separatorType: SeparatorType.title,
                                      decoration: BoxDecoration(
                                          color: appColor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5))),
                                      style: const TextStyle(fontSize: 18),
                                      duration: difference,
                                      onDone: () {
                                        deleteAllDocumentsInCollection(
                                            'Flash Sales');
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }, error: (e, r) {
                          return Text('$e');
                        }, loading: () {
                          return const SizedBox();
                        })
                      : timer.when(data: (v) {
                          DateTime targetDate = DateTime.parse(v);

                          // Calculate the difference between the target date and the current date
                          DateTime currentDate = DateTime.now();
                          Duration difference =
                              targetDate.difference(currentDate);
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    MediaQuery.of(context).size.width >= 1100
                                        ? const EdgeInsets.all(0)
                                        : const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    'Flash Sales',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ).tr(),
                                ),
                              ),
                              const Gap(20),
                              if (v.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SlideCountdownSeparated(
                                    separatorType: SeparatorType.title,
                                    separatorStyle: TextStyle(
                                      color: AdaptiveTheme.of(context)
                                                  .mode
                                                  .isDark ==
                                              true
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    decoration: BoxDecoration(
                                        color: appColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5))),
                                    style: const TextStyle(fontSize: 14),
                                    duration: difference,
                                    onDone: () {
                                      deleteAllDocumentsInCollection(
                                          'Flash Sales');
                                    },
                                  ),
                                ),
                            ],
                          );
                        }, error: (e, r) {
                          return Text(e.toString());
                        }, loading: () {
                          return const SizedBox();
                        }),
                  const Gap(10),
                ],
              ),
            ),
            flashSalesList.when(data: (v) {
              return Padding(
                padding: MediaQuery.of(context).size.width >= 1100
                    ? const EdgeInsets.only(left: 50, right: 50)
                    : const EdgeInsets.all(0),
                child: AnimationLimiter(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: v.length,
                    itemBuilder: (context, index) {
                      ProductsModel productsModel = v[index];
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        columnCount:
                            MediaQuery.of(context).size.width >= 1100 ? 5 : 2,
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          curve: Curves.easeInOut,
                          child: FadeInAnimation(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RestaurantProductWidgetMain(
                                  index: index, productsModel: productsModel),
                            ),
                          ),
                        ),
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio:
                            MediaQuery.of(context).size.width >= 1100
                                ? 0.7
                                : 0.57,
                        crossAxisCount:
                            MediaQuery.of(context).size.width >= 1100 ? 5 : 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5),
                  ),
                ),
              );
            }, error: (c, e) {
              return Text(e.toString());
            }, loading: () {
              return Padding(
                padding: MediaQuery.of(context).size.width >= 1100
                    ? const EdgeInsets.only(left: 100, right: 100)
                    : const EdgeInsets.all(0),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width >= 1100 ? 5 : 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: 20,
                  itemBuilder: (BuildContext context, int index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              color: Colors.grey[300],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 16,
                                  width: 120,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  height: 16,
                                  width: 80,
                                  color: Colors.grey[300],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
            const Gap(20),
            const FooterWidget()
          ],
        ),
      ),
    );
  }
}
