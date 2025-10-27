import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/model/user.dart';
import 'package:user_web/providers/vendors_list_home_provider.dart';
import 'vendor_list_home_widget.dart';

class VendorsListHome extends ConsumerStatefulWidget {
  const VendorsListHome({super.key});

  @override
  ConsumerState<VendorsListHome> createState() => _VendorsListHomeState();
}

class _VendorsListHomeState extends ConsumerState<VendorsListHome> {
  @override
  Widget build(BuildContext context) {
    final vendors = ref.watch(getVendorsListProvider);
    return vendors.when(
      data: (vendorsList) {
        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width >= 1100 ? 4 : 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: MediaQuery.of(context).size.width >= 1100
                ? 1.3
                : 1.2, // Adjust to fit image and text well
          ),
          itemCount: vendorsList.length,
          itemBuilder: (context, index) {
            final UserModel vendor = vendorsList[index];
            return VendorListHomeWidget(
              isNewWidget: false,
              showModule: true,
              vendor: vendor,
            );
          },
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
        );
      },
      loading: () {
        return GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width >= 1100 ? 4 : 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.3,
          ),
          itemCount: 8, // Placeholder shimmer items
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
