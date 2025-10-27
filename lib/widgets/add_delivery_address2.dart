import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:osm_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:user_web/widgets/footer_widget.dart';
import 'package:user_web/widgets/web_menu.dart';
import 'package:user_web/model/address.dart';
import 'package:user_web/constant.dart';

class AddDeliveryAddress2 extends StatefulWidget {
  const AddDeliveryAddress2({super.key});

  @override
  State<AddDeliveryAddress2> createState() => _AddDeliveryAddress2State();
}

class _AddDeliveryAddress2State extends State<AddDeliveryAddress2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Addresses',style: TextStyle(fontFamily: 'Nunito'),),
        backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
            ? Colors.black87
            : Color(0xCCCCCC).withOpacity(1.0),
        leadingWidth: MediaQuery.of(context).size.width >= 1100 ? 150 : 100,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // ⬅️ goes back to signup
        ),
      ),
      backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
          ? null
          :  Color(0xFFDF7EB).withOpacity(1.0),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width < 600
                      ? MediaQuery.of(context).size.width * 0.9 // 90% width on mobile
                      : 800, // Fixed width on larger screens
                  child: Card(
                    shape: const BeveledRectangleBorder(),
                    color:  AdaptiveTheme.of(context).mode.isDark == true
                        ? null : Colors.white,
                    surfaceTintColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: AddWidget(),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }
}



class AddWidget extends StatefulWidget {
  const AddWidget({super.key});

  @override
  State<AddWidget> createState() => _AddWidgetState();
}

class _AddWidgetState extends State<AddWidget> {
  final _formKey = GlobalKey<FormState>();
  String address = '';
  String state = '';
  String city = '';
  String zipCode = '';
  DocumentReference? userDetails;
  String id = '';

  Future<void> _getUserDetails() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    setState(() {
      id = user!.uid;
    });
  }

  bool useMap = false;
  @override
  void initState() {
    _getUserDetails();
    super.initState();
  }

  addNewDeliveryAddress(AddressModel addressModel) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('DeliveryAddress')
        .add(addressModel.toMap())
        .then((value) {
      FirebaseFirestore.instance.collection('users').doc(id).update({
        'DeliveryAddress': addressModel.address,
        'HouseNumber': addressModel.houseNumber,
        'ClosestBustStop': addressModel.closestbusStop,
        'state': addressModel.state,
        'DeliveryAddressID': addressModel.id,
      });

      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'.tr(), style: TextStyle(fontFamily: 'Nunito')),
              content: Text('Address has been added'.tr(), style: TextStyle(fontFamily: 'Nunito')),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // close dialog
                    Navigator.of(context).pop(); // go back to previous screen
                  },
                  child: Text('OK'.tr()),
                ),
              ],
            );
          },
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // const SizedBox(height: 48),
              const Gap(10),
              //  if (MediaQuery.of(context).size.width >= 1100)
              Align(
                alignment: MediaQuery.of(context).size.width >= 1100
                    ? Alignment.bottomLeft
                    : Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width >= 1100 ? 20 : 0),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back)),
                      const Gap(20),
                      Text(
                        'Add a new delivery address',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,fontFamily: 'Nunito',
                            fontSize: MediaQuery.of(context).size.width >= 1100
                                ? 15
                                : 15),
                      ).tr(),
                    ],
                  ),
                ),
              ),
              if (MediaQuery.of(context).size.width >= 1100)
                const Divider(
                  color: Color.fromARGB(255, 237, 235, 235),
                  thickness: 1,
                ),
              const Gap(20),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // const Flexible(
                    //     flex: 1,
                    //     child: Icon(
                    //       Icons.location_on,
                    //       size: 25,
                    //       color: Colors.grey,
                    //     )),
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    // Flexible(
                    //     flex: 6,
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //         border: Border(
                    //           bottom:
                    //               BorderSide(width: 2, color: Colors.grey.shade400),
                    //         ),
                    //       ),
                    //       child: ListTile(
                    //         onTap: () async {
                    //           var result = await Navigator.push(context,
                    //               MaterialPageRoute(builder: (context) {
                    //             return const OpenStreet();
                    //           }));
                    //           // _navigateAndDisplaySelection(context);
                    //           setState(() {
                    //             address = result;
                    //           });
                    //         },
                    //         title: Text(address == '' ? 'Address'.tr() : address,
                    //             style: TextStyle(fontFamily: 'Nunito',fontSize: 16))
                    //             .tr(),
                    //       ),
                    //     ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                     Flexible(
                        flex: 1,
                        child: Icon(
                          Icons.home,
                          size: 25,
                          color: appColor,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 6,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Required field'.tr();
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            hintText: 'Address'.tr(), focusColor: Colors.grey,
                            hintStyle: TextStyle(fontFamily: 'Nunito',fontSize: 16)
                        ),

                        onChanged: (value) {
                          setState(() {
                            address = value;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                     Flexible(
                        flex: 1,
                        child: Icon(
                          Icons.location_on,
                          size: 25,
                          color: appColor,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 6,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Required field'.tr();
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            hintText: 'City'.tr(), focusColor: Colors.grey,
                            hintStyle: TextStyle(fontFamily: 'Nunito',fontSize: 16)
                        ),

                        onChanged: (value) {
                          setState(() {
                            city = value;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                     Flexible(
                        flex: 1,
                        child: Icon(
                          Icons.location_on,
                          size: 25,
                          color:appColor,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 6,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Required field'.tr();
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            hintText: 'State'.tr(), focusColor: Colors.grey,
                            hintStyle: TextStyle(fontFamily: 'Nunito',fontSize: 16)
                        ),

                        onChanged: (value) {
                          setState(() {
                            state = value;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                     Flexible(
                        flex: 1,
                        child: Icon(
                          Icons.location_on,
                          size: 25,
                          color: appColor,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 6,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Required field'.tr();
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            hintText: 'Zip code'.tr(),
                            focusColor: Colors.grey,
                            hintStyle: TextStyle(fontFamily: 'Nunito',fontSize: 16)
                        ),
                        onChanged: (value) {
                          setState(() {
                            zipCode = value;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  // child: SizedBox(
                  //     // height: 50,
                  //     width: MediaQuery.of(context).size.width / 1.2,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(210, 35),
                          shape: const BeveledRectangleBorder(),
                          backgroundColor: appColor),
                      onPressed: () async {
                        if (_formKey.currentState!.validate() && address != '') {
                          addNewDeliveryAddress(AddressModel(
                            address: address,
                            houseNumber: city,
                            closestbusStop: zipCode,
                            state: state,
                            id: '$address , $city , $state , $zipCode',
                          ));
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please Select Your Address".tr(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 3,
                              backgroundColor:  const Color(0xFFFFD581),
                              textColor: Colors.black,
                              webBgColor: "#FFD581",
                              webPosition: "center",
                              fontSize: 14.0);
                        }
                      },
                      child: const Text('Save',
                          style: TextStyle(fontSize: 20, color: Colors.black,fontFamily: 'Nunito',))
                          .tr())
                // ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ));
  }
}






class OpenStreet extends StatefulWidget {
  const OpenStreet({super.key});

  @override
  State<OpenStreet> createState() => _OpenStreetState();
}

class _OpenStreetState extends State<OpenStreet> {
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
            Navigator.pop(context, pickedData.addressName);
          }),
    );
  }
}
