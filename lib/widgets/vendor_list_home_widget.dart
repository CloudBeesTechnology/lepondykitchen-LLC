import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:user_web/constant.dart';
import 'package:user_web/model/user.dart';
import 'package:user_web/widgets/cat_image_widget.dart';
import 'package:user_web/widgets/vendor_favorite_button.dart';

import '../providers/selected_provider.dart';

class VendorListHomeWidget extends ConsumerStatefulWidget {
  final UserModel vendor;
  final bool showModule;
  final bool isNewWidget;
  final UserModel? selectedVendor;
  final Function(UserModel)? onVendorSelected;
  const VendorListHomeWidget(
      {super.key,
      required this.vendor,
      required this.showModule,
      required this.isNewWidget,
        this.selectedVendor,
        this.onVendorSelected,
      });

  @override
  ConsumerState<VendorListHomeWidget> createState() => _VendorListHomeWidgetState();
}

class _VendorListHomeWidgetState extends ConsumerState<VendorListHomeWidget> {
  bool isHovered = false;
  String openingTimeString = '';

  getVendorOpenTime() {
    FirebaseFirestore.instance
        .collection('vendors')
        .doc(widget.vendor.uid)
        .get()
        .then((v) {
      if (mounted) {
        setState(() {
          openingTimeString = v['opening Time'];
        });
      }
    });
  }



  Future<void> _handleVendorTap() async {

    final selectedVendor = ref.read(selectedVendorProvider);
    final isSelected = selectedVendor?.uid == widget.vendor.uid;

    if (widget.vendor.isOpened == false || widget.vendor.isOpened == null) {
      showAlertDialog(context, 'Note', 'Vendor is Closed');
      return;
    }

    if (isSelected) {
      _navigateToVendorDetail();
      return;
    }

    if (selectedVendor == null && widget.vendor.module?.toLowerCase() == 'restaurant') {
      _navigateToVendorDetail();
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AdaptiveTheme.of(context).mode.isDark
            ? Colors.grey[900]
            : Colors.white,
        title: Text('Confirm Vendor'),
        content: Text('Do you want to pick ${widget.vendor.displayName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(selectedVendorProvider.notifier).state = widget.vendor;
      ref.read(selectedVendorModuleProvider.notifier).state = widget.vendor.module;
    }
  }


  void _navigateToVendorDetail() {
    final module = widget.vendor.module?.toLowerCase() ?? 'restaurant';
    context.go('/$module/vendor-detail/${widget.vendor.uid}');
  }

  @override
  void initState() {
    getVendorOpenTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final selectedVendor = ref.watch(selectedVendorProvider);
    final selectedModule = ref.watch(selectedVendorModuleProvider);

    final currentModule = selectedModule ?? 'Restaurant';

    final bool shouldHighlight = selectedVendor?.uid == widget.vendor.uid ||
        (selectedVendor == null &&
            widget.vendor.module?.toLowerCase() == currentModule.toLowerCase() &&
            widget.vendor.module?.toLowerCase() == 'restaurant');


    return Container(
      decoration: BoxDecoration(
        border: shouldHighlight ? Border.all(color: Colors.orange, width: 2) : null,
        borderRadius: BorderRadius.circular(2),
        color: Colors.white,
      ),

      child: InkWell(
        // hoverColor: Colors.transparent,
        onTap: _handleVendorTap,
        // onTap: widget.vendor.isOpened == false || widget.vendor.isOpened == null
        //     ? () {
        //         Fluttertoast.showToast(
        //           msg: "Vendor is closed".tr(),
        //           toastLength: Toast.LENGTH_SHORT,
        //           gravity: ToastGravity.TOP,
        //           timeInSecForIosWeb: 2,
        //           fontSize: 14.0,
        //         );
        //       }
        //     : () {
        //         if (widget.vendor.module == 'Ecommerce') {
        //           context.go('/ecommerce/vendor-detail/${widget.vendor.uid}');
        //         } else if (widget.vendor.module == 'Restaurant') {
        //           context.go('/restaurant/vendor-detail/${widget.vendor.uid}');
        //         } else if (widget.vendor.module == 'Pharmacy') {
        //           context.go('/pharmacy/vendor-detail/${widget.vendor.uid}');
        //         } else {
        //           context.go('/grocery/vendor-detail/${widget.vendor.uid}');
        //         }
        //       },
        // // onHover: (value) {
        // //   setState(() {
        // //     isHovered = value;
        // //   });
        // },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 6,
                child:
                Transform.scale(
                  scale: MediaQuery.of(context).size.width >= 1100
                      ? (isHovered
                      ? widget.isNewWidget == true
                      ? 1.03
                      : 1.02
                      : 1.0)
                      : (isHovered ? 1 : 1.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                          borderRadius: widget.isNewWidget == true
                              ? const BorderRadius.only(
                              topLeft: Radius.circular(2),
                              topRight: Radius.circular(2))
                              : BorderRadius.circular(2),
                          child: CatImageWidgets(
                              url: widget.vendor.photoUrl, boxFit: 'cover')),
                      if (widget.showModule == true)
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: MediaQuery.of(context).size.width >= 1100
                                ? const EdgeInsets.all(8.0)
                                : const EdgeInsets.all(5.0),
                            child: Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width >= 1100
                                  ? 100
                                  : 80,
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(8),
                                  color: Colors.black.withValues(alpha: 0.4)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    widget.vendor.module!,
                                    style: TextStyle(
                                      fontSize:
                                      MediaQuery.of(context).size.width >=
                                          1100
                                          ? 12.r
                                          : 10.r,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (widget.vendor.isOpened == false ||
                          widget.vendor.isOpened == null)
                      // Align(
                      //   alignment: Alignment.center,
                      //   child: Container(
                      //     height: MediaQuery.of(context).size.height,
                      //     width: double.infinity,
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(8),
                      //         color: Colors.black.withValues(alpha: 0.4)),
                      //     child: Center(
                      //       child: Padding(
                      //         padding: const EdgeInsets.all(5.0),
                      //         child: Column(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             Text(
                      //               'Closed',
                      //               style: TextStyle(
                      //                 fontSize:
                      //                     MediaQuery.of(context).size.width >=
                      //                             1100
                      //                         ? 12.r
                      //                         : 10.r,
                      //                 color: Colors.white,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //             Text(
                      //               'Opens at $openingTimeString',
                      //               style: TextStyle(
                      //                 fontSize:
                      //                     MediaQuery.of(context).size.width >=
                      //                             1100
                      //                         ? 12.r
                      //                         : 10.r,
                      //                 color: Colors.white,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                        if (widget.vendor.totalRating != null)
                        // Align(
                        //   alignment: Alignment.topRight,
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8),
                        //     child: Container(
                        //         // width: 50,
                        //         height: 30,
                        //         decoration: BoxDecoration(
                        //             color: appColor,
                        //             borderRadius: BorderRadius.circular(5)),
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(8.0),
                        //           child: Text(
                        //             '★${((widget.vendor.totalRating! / widget.vendor.totalNumberOfUserRating!) * 10).roundToDouble() / 10}',
                        //             style: const TextStyle(
                        //                 color: Colors.white,
                        //                 // fontSize: 15,
                        //                 fontWeight: FontWeight.bold),
                        //           ),
                        //         )),
                        //   ),
                        // ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              // child: VendorFavoriteButton(
                              //     vendorId: widget.vendor.uid, isWhite: true),
                            ),
                          )
                    ],
                  ),
                )),
            Container(
              width: double.infinity,
              color: AdaptiveTheme.of(context).mode.isDark == true
                  ? Colors.black87
                  :  Colors.white,
              // color: Colors.white,
              child: Padding(
                padding: MediaQuery.of(context).size.width >= 1100 ?
                const EdgeInsets.only(left: 12) :
                const EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Gap(10),
                    Text(
                      widget.vendor.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width <= 1100
                            ? 14.r
                            : 16.r,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      widget.vendor.address!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.r,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(2),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
