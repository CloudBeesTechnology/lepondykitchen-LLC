import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/model/user.dart';
import 'package:user_web/providers/vendors_list_home_provider.dart';
import 'package:user_web/widgets/footer_widget.dart';
import 'package:user_web/widgets/vendor_list_home_widget.dart';

class FavoriteVendorsPage extends ConsumerStatefulWidget {
  const FavoriteVendorsPage({super.key});

  @override
  ConsumerState<FavoriteVendorsPage> createState() =>
      _FavoriteVendorsPageState();
}

class _FavoriteVendorsPageState extends ConsumerState<FavoriteVendorsPage> {
  @override
  Widget build(BuildContext context) {
    final vendors = ref.watch(getFavoriteVendorsListProvider);

    return Scaffold(
      backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
          ? null
          : const Color(0xFFDF7EB).withOpacity(1.0),
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(), // 🚫 No bounce on iOS
        slivers: [
          const SliverToBoxAdapter(child: Gap(20)),

          SliverPadding(
            padding: MediaQuery.of(context).size.width >= 1100
                ? const EdgeInsets.symmetric(horizontal: 50)
                : const EdgeInsets.all(8.0),
            sliver: vendors.when(
              data: (vendorsList) {
                if (vendorsList.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text('No Favorite vendors'),
                    ),
                  );
                }
                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                    MediaQuery.of(context).size.width >= 1100 ? 4 : 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio:
                    MediaQuery.of(context).size.width >= 1100 ? 1.3 : 1.2,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final UserModel vendor = vendorsList[index];
                      return VendorListHomeWidget(
                        isNewWidget: false,
                        showModule: true,
                        vendor: vendor,
                      );
                    },
                    childCount: vendorsList.length,
                  ),
                );
              },
              error: (error, _) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text('Error: $error',
                        style: const TextStyle(color: Colors.red)),
                  ),
                );
              },
              loading: () {
                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                    MediaQuery.of(context).size.width >= 1100 ? 4 : 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1.3,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
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
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(height: 16, color: Colors.grey),
                          ],
                        ),
                      );
                    },
                    childCount: 8,
                  ),
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: Gap(20)),
          const SliverToBoxAdapter(child: FooterWidget()),
        ],
      ),
    );
  }
}

