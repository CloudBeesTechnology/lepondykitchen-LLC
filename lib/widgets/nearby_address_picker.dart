import 'package:flutter/material.dart';
import 'package:osm_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:user_web/constant.dart';

class NearbyAddressPicker extends StatefulWidget {
  const NearbyAddressPicker({super.key});

  @override
  State<NearbyAddressPicker> createState() => _NearbyAddressPickerState();
}

class _NearbyAddressPickerState extends State<NearbyAddressPicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map'),
      ),
      body: OpenStreetMapSearchAndPick(

          // center: LatLong(23, 89),
          buttonColor: appColor,
          buttonTextStyle: const TextStyle(fontSize: 15, color: Colors.white),
          buttonText: 'Set Current Location',
          onPicked: (pickedData) {
            Navigator.pop(context, {
              'address': pickedData.addressName,
              'lat': pickedData.latLong.latitude,
              'long': pickedData.latLong.longitude
            });
          }),
    );
  }
}
