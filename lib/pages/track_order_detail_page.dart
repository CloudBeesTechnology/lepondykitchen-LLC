import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:user_web/model/formatter.dart';
import 'package:user_web/constant.dart';
import 'package:user_web/providers/currency_provider.dart';
import 'package:user_web/providers/track_order_provider.dart';

class TrackOrderDetailPage extends StatefulWidget {
  final String orderID;
  const TrackOrderDetailPage({super.key, required this.orderID});

  @override
  State<TrackOrderDetailPage> createState() => _TrackOrderDetailPageState();
}

class _TrackOrderDetailPageState extends State<TrackOrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
          ? null
          : const  Color(0xFFDF7EB).withOpacity(1.0),
      appBar: MediaQuery.of(context).size.width >= 1100 ? null : AppBar(
    backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
    ? null
        : const  Color(0xFFDF7EB).withOpacity(1.0),),
      body: MediaQuery.of(context).size.width >= 1100
          ? Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Image.network(
                          'https://static.vecteezy.com/system/resources/previews/015/541/158/non_2x/man-hand-holds-smartphone-with-city-map-gps-navigator-on-smartphone-screen-mobile-navigation-concept-modern-simple-flat-design-for-web-banners-web-infographics-flat-cartoon-illustration-vector.jpg',
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                          scale: 1,
                        ),
                      ),
                      Expanded(
                          flex: 7,
                          child: SizedBox(
                              child: Track(
                            orderID: widget.orderID,
                          )))
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      context.go('/restaurant');
                    },
                    child: Image.asset(
                      AdaptiveTheme.of(context).mode.isDark == true ? verticalWhite :onlyLogo,
                      scale: 6,
                      // color: AdaptiveTheme.of(context).mode.isDark == true
                      //     ? Colors.white
                      //     : null,
                    ),
                  ),
                ),
              ],
      )
          : Track(
              orderID: widget.orderID,
            ),
    );
  }
}

class Track extends ConsumerStatefulWidget {
  final String orderID;
  const Track({super.key, required this.orderID});

  @override
  ConsumerState<Track> createState() => _TrackState();
}

class _TrackState extends ConsumerState<Track> {
  int _index = 0;
  num quantity = 0;
  String date = '';

  @override
  Widget build(BuildContext context) {
    var orderDetail =
        ref.watch(fetchTrackingOrderDetailProvider(widget.orderID)).value;
    var currency = ref.watch(currencySymbolProvider).value;
    if (orderDetail != null) {
      // Parse the string into a DateTime object
      DateTime dateTime = DateTime.parse(orderDetail.timeCreated.toString());

      // Format the DateTime object to the desired format
      String formattedDate = DateFormat('MMMM d, y').format(dateTime);

      date = formattedDate;
      quantity =
          orderDetail.orders!.fold(0, (e, product) => e + product.quantity);
    }
    return orderDetail == null
        ? Center(
            child: const Text('Loading...').tr(),
          )
        : SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                              onPressed: () {
                                if (orderDetail.module == 'Parcel Delivery') {
                                  context.go('/parcel-delivery');
                                } else {
                                  context.go('/track-order');
                                }
                              },
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.black)),
                        ),
                        const Text('Order Tracking Update',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            )),
                        const SizedBox(),
                      ],
                    ),
                    Text(
                      'Order n° ${orderDetail.orderID}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Gap(5),
                    Text('$quantity items',style: TextStyle(fontFamily: 'Nunito'),),
                    const Gap(5),
                    Text('Placed on $date'),
                    const Gap(5),
                    Text(
                        'Total $currency${Formatter().converter(orderDetail.total.toDouble())}'),
                    const Gap(10),
                    const Divider(
                      color: Color.fromARGB(255, 237, 235, 235),
                      thickness: 1,
                    ),
                    const Gap(10),
                    Stepper(
                      physics: const BouncingScrollPhysics(),
                      onStepTapped: (step) {
                        if (step > _index) {
                          setState(() {
                            _index = step;
                          });
                        }
                      },
                      type: StepperType.vertical,
                      controlsBuilder:
                          (BuildContext context, ControlsDetails controls) {
                        return const SizedBox();
                      },
                      currentStep: _index,
                      steps: <Step>[
                        if (orderDetail.deliveryAddress!.isEmpty)
                          Step(
                            isActive: true,
                            title: const Text('Pickup'),
                            content: Container(),
                          ),
                        Step(
                          isActive:
                              orderDetail.status == 'Pending' ? true : false,
                          title: const Text('Pending'),
                          content: Container(),
                        ),
                        if (orderDetail.status == 'Cancelled')
                          Step(
                            isActive: true,
                            title: const Text('Cancelled'),
                            content: Container(),
                          ),
                        // Step(
                        //   isActive: widget.orderModel.accept == true ? true : false,
                        //   title: const Text('Pending'),
                        //   content: Container(),
                        // ),
                        Step(
                          isActive: orderDetail.accept == true &&
                                  orderDetail.status == 'Confirmed'
                              ? true
                              : false,
                          title: const Text('Confirmed'),
                          content: Container(),
                        ),
                        if (orderDetail.deliveryAddress!.isNotEmpty)
                          Step(
                            isActive: orderDetail.accept == true &&
                                    orderDetail.status == 'Processing'
                                ? true
                                : false,
                            title: const Text('Processing'),
                            content: Container(),
                          ),
                        if (orderDetail.deliveryAddress!.isNotEmpty)
                          Step(
                            isActive: orderDetail.acceptDelivery == true &&
                                    orderDetail.status == 'On the way'
                                ? true
                                : false,
                            title: const Text('On the way'),
                            content: Container(),
                          ),

                        Step(
                          isActive:
                              orderDetail.status == 'Delivered' ? true : false,
                          title: const Text('Delivered'),
                          content: Container(),
                        )
                      ],
                    ),
                  ]),
            ),
          );
  }
}
