import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/model/formatter.dart';
import 'package:user_web/model/order_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:user_web/constant.dart';
import 'package:user_web/providers/currency_provider.dart';
import 'package:user_web/providers/orders_list_provider.dart';

class OrdersWidget extends ConsumerStatefulWidget {
  const OrdersWidget({super.key});

  @override
  ConsumerState<OrdersWidget> createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends ConsumerState<OrdersWidget> {
  String? selectedValue;
  int itemsPerPage = 10;
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    var orders = ref.watch(ordersListNotifierProvider).value;
    var currency = ref.watch(currencySymbolProvider).value;

    int totalPages = orders == null ? 0 : (orders.length / itemsPerPage).ceil();

    return  Column(
        children: [
          if (MediaQuery.of(context).size.width >= 1100) const Gap(10),
          _buildHeader(),
          if (MediaQuery.of(context).size.width >= 1100)
            const Divider(
              color: Color.fromARGB(255, 237, 235, 235),
              thickness: 1,
            ),
          const Gap(20),
          _buildOrdersList(orders, currency),
          const Gap(20),
          if (orders != null && orders.isNotEmpty)
            _buildPaginationControls(totalPages),
        ],
      );
  }

  Widget _buildHeader() {
    return Align(
      alignment: MediaQuery.of(context).size.width >= 1100
          ? Alignment.bottomLeft
          : Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width >= 1100 ? 20 : 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Text(
              selectedValue == null ? "All Orders" : '$selectedValue Orders',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:
                      MediaQuery.of(context).size.width >= 1100 ? 15 : 18),
            ).tr(),
            _buildFilterDropdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          dropdownStyleData: const DropdownStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16),
            width: 140,
          ),
          isExpanded: true,
          customButton: const Icon(Icons.sort),
          items: [
            'All',
            'Pending',
            "Parcel Delivery",
            'Scheduled',
            'Confirmed',
            'Pickup',
            'Processing',
            'On the way',
            'Delivered',
            'Cancelled'
          ]
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value as String;
              currentPage = 0; // Reset to first page when filter changes
              ref
                  .read(ordersListNotifierProvider.notifier)
                  .filterOrders(selectedValue!);
            });
          },
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<OrderModel2>? orders, String? currency) {
    if (orders == null) {
      return _buildShimmerList();
    } else if (orders.isEmpty) {
      return _buildEmptyState();
    } else {
      return _buildPaginatedOrdersList(orders, currency);
    }
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300]!,
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 20,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 8),
                Container(
                  width: 100,
                  height: 16,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Icon(
            Icons.list,
            color: appColor,
            size: MediaQuery.of(context).size.width >= 1100
                ? MediaQuery.of(context).size.width / 5
                : MediaQuery.of(context).size.width / 1.5,
          ),
        ),
        const Gap(10),
        const Text('No order has been made').tr(),
        const Gap(20),
      ],
    );
  }

  Widget _buildPaginatedOrdersList(List<OrderModel2> orders, String? currency) {
    int startIndex = currentPage * itemsPerPage;
    int endIndex = (startIndex + itemsPerPage < orders.length)
        ? startIndex + itemsPerPage
        : orders.length;
    List<OrderModel2> paginatedOrders = orders.sublist(startIndex, endIndex);

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: paginatedOrders.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        OrderModel2 orderModel2 = paginatedOrders[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 215, 214, 214))),
            child: ListTile(
              subtitle: Text(timeago.format(orderModel2.timeCreated)),
              leading: Text(
                '$currency${Formatter().converter(orderModel2.total.toDouble())}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              title: Text(
                'Order: ${orderModel2.orderID}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: InkWell(
                onTap: () {
                  if (orderModel2.module == 'Parcel Delivery') {
                    context.go('/parcel-order-detail/${orderModel2.uid}');
                  } else {
                    context.go('/order-detail/${orderModel2.uid}');
                  }
                },
                child: Text(
                  'SEE DETAILS',
                  style: TextStyle(color: Colors.orange.shade700,fontFamily: 'Nunito',fontSize: 14),
                ).tr(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaginationControls(int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: currentPage > 0
              ? () {
                  setState(() {
                    currentPage--;
                  });
                }
              : null,
        ),
        Text('Page ${currentPage + 1} of $totalPages'),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: currentPage < totalPages - 1
              ? () {
                  setState(() {
                    currentPage++;
                  });
                }
              : null,
        ),
      ],
    );
  }
}
