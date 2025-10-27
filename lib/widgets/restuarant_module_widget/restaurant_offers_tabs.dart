import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RestaurantOffersTabs extends StatefulWidget {
  const RestaurantOffersTabs({
    super.key,
  });

  @override
  State<RestaurantOffersTabs> createState() => _RestaurantOffersTabsState();
}

class _RestaurantOffersTabsState extends State<RestaurantOffersTabs> {
  String? selectedValue;
  bool isHovered = false;
  final List<String> dropdownItems = ['Flash sales', "Hot deals"];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        dropdownStyleData: const DropdownStyleData(width: 200),
        isExpanded: true,
        customButton: Row(
          children: [
            Text(
              'Offers',
              style: TextStyle(
                  // color: appColor,
                  fontSize: 4.sp,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              width: 4,
            ),
            const Icon(
              Icons.arrow_drop_down_outlined,
              //  color: Color.fromRGBO(48, 30, 2, 1),
            ),
          ],
        ),
        items: dropdownItems
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                    title: Text(
                      item,
                      style: TextStyle(
                          fontSize: 4.sp, fontWeight: FontWeight.w200),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (value) {
          if (value == 'Hot deals') {
            context.go('/restaurant/hot-deals');
          } else {
            context.go('/restaurant/flash-sales');
          }
        },
      ),
    );
  }
}
