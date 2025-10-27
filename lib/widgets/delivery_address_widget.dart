import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/model/address.dart';
import 'package:user_web/constant.dart';
import 'package:user_web/providers/addresses_page_provider.dart';
import 'package:user_web/widgets/add_delivery_address.dart';

class DeliveryAddressWidget extends ConsumerStatefulWidget {
  const DeliveryAddressWidget({super.key});

  @override
  ConsumerState<DeliveryAddressWidget> createState() =>
      _DeliveryAddressWidgetState();
}

class _DeliveryAddressWidgetState extends ConsumerState<DeliveryAddressWidget> {
  @override
  void initState() {
    super.initState();
  }
var logger = Logger();
  @override
  Widget build(BuildContext context) {
    var addresses = ref.watch(getDeliveryAddressesProvider).value;
    logger.d(addresses);
    var addressID = ref.watch(getUserDeliveryAddressIDProvider).value ?? '';
    if (addressID.isEmpty) {
      logger.e("Warning: Address ID is empty or null");
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //
          //   ],
          // ),
          // const Gap(4),
          Padding(
            padding: MediaQuery.of(context).size.width >= 1100 ?
            const EdgeInsets.only(bottom: 5,right: 20) :
            const EdgeInsets.only(top: 15,right: 20,bottom: 5) ,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const AddDeliveryAddress(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber, // Set background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  icon: const Icon(Icons.add, color: Colors.black), // Add icon
                  label:  Text(
                    'Add',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width >= 1100 ? 18 : 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Nunito',
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
          // const Divider(
          //   color: Color.fromARGB(255, 237, 235, 235),
          //   thickness: 1,
          // ),
          // const Gap(20),
          addresses != null
              ? addresses.isEmpty
              ? Center(
            child: Icon(
              Icons.delivery_dining_outlined,
              color: appColor,
              size: MediaQuery.of(context).size.width / 5,
            ),
          )
              : GridView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: addresses.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1.6,
              crossAxisCount: MediaQuery.of(context).size.width >= 1100 ? 2 : 1,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemBuilder: (context, index) {
              AddressModel addressModel = addresses[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.white,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              addressID == addressModel.id ? 'Default Address' : 'Set As Default',
                              style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 18,fontFamily: 'Nunito'),
                            ).tr(),
                            if (addressID != addressModel.id)
                              InkWell(
                                onTap: () {
                                  final FirebaseAuth auth = FirebaseAuth.instance;
                                  User? user = auth.currentUser;
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user!.uid)
                                      .update({
                                    'DeliveryAddress': addressModel.address,
                                    'HouseNumber': addressModel.houseNumber,
                                    'ClosestBustStop': addressModel.closestbusStop,
                                    'DeliveryAddressID': addressModel.id,
                                  });
                                  // Fluttertoast.showToast(msg: "Address has been set as default".tr(), timeInSecForIosWeb: 6,);
                                  showAlertDialog(context,"Note","Address has been set as default");
                                },
                                child: const Icon(Icons.delete, color: Colors.black),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ListTile(
                          dense: true,
                          visualDensity: const VisualDensity(vertical: -4),
                          leading: const Icon(Icons.room, color: Colors.grey),
                          title: Text(
                            addressModel.address.isNotEmpty ? addressModel.address : "No Address Provided",
                            style: const TextStyle(fontSize: 13,fontFamily: 'Nunito',fontWeight: FontWeight.w500),
                          ),
                        ),
                        const Divider(indent: 20, endIndent: 20),
                        ListTile(
                          dense: true,
                          visualDensity: const VisualDensity(vertical: -4),
                          leading: const Icon(Icons.home, color: Colors.grey),
                          title: Text(
                            addressModel.houseNumber,
                            style: const TextStyle(fontSize: 13,fontFamily: 'Nunito',fontWeight: FontWeight.w500),
                          ),
                        ),
                        const Divider(indent: 20, endIndent: 20),
                        ListTile(
                          dense: true,
                          visualDensity: const VisualDensity(vertical: -4),
                          leading: const Icon(Icons.directions_bus, color: Colors.grey),
                          title: Text(
                            addressModel.closestbusStop,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
              : const Center(child: CircularProgressIndicator(color: Colors.amber,)),
        ],
      ),
    );

  }
}
