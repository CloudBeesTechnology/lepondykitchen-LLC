class PickupAddressModel {
  final String address;
  final String storename; // from Firestore: fullname
  final String phonenumber; // from Firestore: phone
  final String module; // added
  final String uid;

  PickupAddressModel({
    required this.address,
    required this.uid,
    required this.storename,
    required this.phonenumber,
    required this.module,
  });

  // ✅ Correct constructor with proper initializer list
  PickupAddressModel.fromMap(Map<String, dynamic> data, this.uid)
      : address = data['address'] ?? '',
        phonenumber = data['phone'] ?? '',
        storename = data['fullname'] ?? '',
        module = data['module'] ?? ''; // ✅ properly initialized here

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'storename': storename,
      'phonenumber': phonenumber,
      'module': module,
    };
  }
}
