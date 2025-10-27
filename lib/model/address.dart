class AddressModel {
  final String address;
  final String houseNumber;
  final String closestbusStop;
  final String state;
  final String id;
  final String? uid;

  AddressModel({
    required this.address,
    required this.houseNumber,
    required this.id,
    required this.closestbusStop,
    required this.state,
    this.uid,
  });

  AddressModel.fromMap(Map<String, dynamic> data, this.uid)
      : address = data['Addresses'] ?? "No Address Provided",
        houseNumber = data['houseNumber'] ?? "No House Number",
        closestbusStop = data['closestbusStop'] ?? "No Bus Stop",
        state = data['state'] ?? "No state",
        id = data['id'] ?? "";

  Map<String, dynamic> toMap() {
    return {
      'Addresses': address,
      'houseNumber': houseNumber,
      'closestbusStop': closestbusStop,
      'state':state ,
      'id': id
    };
  }
}
