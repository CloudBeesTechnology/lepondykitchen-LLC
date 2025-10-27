import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';


class RestaurantCatsTabs extends StatefulWidget {
  final List<String> items;

  const RestaurantCatsTabs({super.key, required this.items});

  @override
  State<RestaurantCatsTabs> createState() => _RestaurantCatsTabsState();
}

class _RestaurantCatsTabsState extends State<RestaurantCatsTabs> {
  String? selectedValue;
  bool isHovered = false;


  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        dropdownStyleData: const DropdownStyleData(width: 200),
        isExpanded: true,
        customButton: Row(
          children: [
            Text(
              'Categories',
              style: TextStyle(
                  // color: appColor,
                  fontFamily: 'Nunito',
                  fontSize: 16,
                  fontWeight: FontWeight.w600
              ),
              overflow: TextOverflow.ellipsis,
            ).tr(),
            const SizedBox(
              width: 4,
            ),
             Icon(
              Icons.arrow_drop_down_outlined,
              // color: Colors.white,
                color: AdaptiveTheme.of(context).mode.isDark == true ? Colors.white : Colors.black
              //  color: Color.fromRGBO(48, 30, 2, 1),
            ),
          ],
        ),
        items: widget.items
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
          context.go('/restaurant/products/$value');
        },
      ),
    );
  }
}
