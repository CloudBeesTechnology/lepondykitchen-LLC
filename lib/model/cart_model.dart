class CartModel {
  final bool? isPrescription;
  final String module;
  final String uid;
  final String name;
  final String category;
  final String collection;
  final String subCollection;
  final String image1;
  final String image2;
  final String image3;
  final String unitname1;
  final String unitname2;
  final String unitname3;
  final String unitname4;
  final String unitname5;
  final String unitname6;
  final String unitname7;
  final num unitPrice1;
  final num unitPrice2;
  final num unitPrice3;
  final num unitPrice4;
  final num unitPrice5;
  final num unitPrice6;
  final num unitPrice7;
  final num unitOldPrice1;
  final num unitOldPrice2;
  final num unitOldPrice3;
  final num unitOldPrice4;
  final num unitOldPrice5;
  final num unitOldPrice6;
  final num unitOldPrice7;
  final num percantageDiscount;
  final String vendorId;
  final String brand;
  // final String marketID;
  // final String marketName;
  final String vendorName;
  final String description;
  final String productID;
  final num totalRating;
  final num totalNumberOfUserRating;
  num quantity;
  final String? endFlash;
  num price;
  final String? selectedExtra1;
  final num selectedPrice;
  final String selected;
  final int returnDuration;
  final num? selectedExtraPrice1;
  final String? selectedExtra2;
  final num? selectedExtraPrice2;
  final String? selectedExtra3;
  final num? selectedExtraPrice3;
  final String? selectedExtra4;
  final num? selectedExtraPrice4;
  final String? selectedExtra5;
  final num? selectedExtraPrice5;

  CartModel({
    this.isPrescription,
    this.selectedExtra1,
    this.selectedExtraPrice1,
    required this.module,
    this.selectedExtra2,
    this.selectedExtraPrice2,
    this.selectedExtra3,
    this.selectedExtraPrice3,
    this.selectedExtra4,
    this.selectedExtraPrice4,
    this.selectedExtra5,
    this.selectedExtraPrice5,
    this.endFlash,
    required this.returnDuration,
    required this.price,
    required this.selected,
    required this.selectedPrice,
    required this.totalRating,
    required this.quantity,
    required this.totalNumberOfUserRating,
    required this.productID,
    required this.description,
    required this.vendorName,
    // required this.marketID,
    // required this.marketName,
    required this.uid,
    required this.name,
    required this.category,
    required this.collection,
    required this.subCollection,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.unitname1,
    required this.unitname2,
    required this.unitname3,
    required this.unitname4,
    required this.unitname5,
    required this.unitname6,
    required this.unitname7,
    required this.unitPrice1,
    required this.unitPrice2,
    required this.unitPrice3,
    required this.unitPrice4,
    required this.unitPrice5,
    required this.unitPrice6,
    required this.unitPrice7,
    required this.unitOldPrice1,
    required this.unitOldPrice2,
    required this.unitOldPrice3,
    required this.unitOldPrice4,
    required this.unitOldPrice5,
    required this.unitOldPrice6,
    required this.unitOldPrice7,
    required this.percantageDiscount,
    required this.vendorId,
    required this.brand,
  });
  Map<String, dynamic> toMap() {
    return {
      'module':module,
      'isPrescription': isPrescription,
      'selectedExtra1': selectedExtra1,
      'selectedExtraPrice1': selectedExtraPrice1,
      'selectedExtra2': selectedExtra2,
      'selectedExtraPrice2': selectedExtraPrice2,
      'selectedExtra3': selectedExtra3,
      'selectedExtraPrice3': selectedExtraPrice3,
      'selectedExtra4': selectedExtra4,
      'selectedExtraPrice4': selectedExtraPrice4,
      'selectedExtra5': selectedExtra5,
      'selectedExtraPrice5': selectedExtraPrice5,
      'returnDuration': returnDuration,
      'selected': selected,
      'selectedPrice': selectedPrice,
      'price': price,
      'vendorName': vendorName,
      'endFlash': endFlash,
      'totalRating': totalRating,
      'totalNumberOfUserRating': totalNumberOfUserRating,
      // 'marketName': marketName,
      // 'marketID': marketID,
      'quantity': quantity,
      'name': name,
      'description': description,
      'category': category,
      'collection': collection,
      'subCollection': subCollection,
      'image1': image1,
      'image2': image2,
      'image3': image3,
      'unitname1': unitname1,
      'unitname2': unitname2,
      'unitname3': unitname3,
      'unitname4': unitname4,
      'unitname5': unitname5,
      'unitname6': unitname6,
      'unitname7': unitname7,
      'unitPrice1': unitPrice1,
      'unitPrice2': unitPrice2,
      'unitPrice3': unitPrice3,
      'unitPrice4': unitPrice4,
      'unitPrice5': unitPrice5,
      'unitPrice6': unitPrice6,
      'unitPrice7': unitPrice7,
      'unitOldPrice1': unitOldPrice1,
      'unitOldPrice2': unitOldPrice2,
      'unitOldPrice3': unitOldPrice3,
      'unitOldPrice4': unitOldPrice4,
      'unitOldPrice5': unitOldPrice5,
      'unitOldPrice6': unitOldPrice6,
      'unitOldPrice7': unitOldPrice7,
      'percantageDiscount': percantageDiscount,
      'vendorId': vendorId,
      'brand': brand,
      'productID': productID
    };
  }

  CartModel.fromMap(data, this.uid)
      : selectedExtra1 = data['selectedExtra1'],
      module = data['module'],
        isPrescription = data['isPrescription'],
        selectedExtraPrice1 = data['selectedExtraPrice1'],
        selectedExtra2 = data['selectedExtra2'],
        selectedExtraPrice2 = data['selectedExtraPrice2'],
        selectedExtra3 = data['selectedExtra3'],
        selectedExtraPrice3 = data['selectedExtraPrice3'],
        selectedExtra4 = data['selectedExtra4'],
        selectedExtraPrice4 = data['selectedExtraPrice4'],
        selectedExtra5 = data['selectedExtra5'],
        selectedExtraPrice5 = data['selectedExtraPrice5'],
        name = data['name'],
        returnDuration = data['returnDuration'],
        selected = data['selected'] ?? '',
        price = data['price'] ?? 0,
        selectedPrice = data['selectedPrice'] ?? 0,
        totalNumberOfUserRating = data['totalNumberOfUserRating'],
        totalRating = data['totalRating'],
        description = data['description'],
        vendorName = data['vendorName'],
        // marketName = data['marketName'],
        endFlash = data['endFlash'],
        productID = data['productID'],
        quantity = data['quantity'],
        // marketID = data['marketID'],
        category = data['category'],
        collection = data['collection'],
        subCollection = data['subCollection'],
        image1 = data['image1'],
        image2 = data['image2'],
        image3 = data['image3'],
        unitname1 = data['unitname1'],
        unitname2 = data['unitname2'],
        unitname3 = data['unitname3'],
        unitname4 = data['unitname4'],
        unitname5 = data['unitname5'],
        unitname6 = data['unitname6'],
        unitname7 = data['unitname7'],
        unitPrice1 = data['unitPrice1'],
        unitPrice2 = data['unitPrice2'],
        unitPrice3 = data['unitPrice3'],
        unitPrice4 = data['unitPrice4'],
        unitPrice5 = data['unitPrice5'],
        unitPrice6 = data['unitPrice6'],
        unitPrice7 = data['unitPrice7'],
        unitOldPrice1 = data['unitOldPrice1'],
        unitOldPrice2 = data['unitOldPrice2'],
        unitOldPrice3 = data['unitOldPrice3'],
        unitOldPrice4 = data['unitOldPrice4'],
        unitOldPrice5 = data['unitOldPrice5'],
        unitOldPrice6 = data['unitOldPrice6'],
        unitOldPrice7 = data['unitOldPrice7'],
        percantageDiscount = data['percantageDiscount'],
        vendorId = data['vendorId'],
        brand = data['brand'];

  CartModel copyWith({
    bool? isPrescription,
    String? module,
    String? uid,
    String? name,
    String? category,
    String? collection,
    String? subCollection,
    String? image1,
    String? image2,
    String? image3,
    String? unitname1,
    String? unitname2,
    String? unitname3,
    String? unitname4,
    String? unitname5,
    String? unitname6,
    String? unitname7,
    num? unitPrice1,
    num? unitPrice2,
    num? unitPrice3,
    num? unitPrice4,
    num? unitPrice5,
    num? unitPrice6,
    num? unitPrice7,
    num? unitOldPrice1,
    num? unitOldPrice2,
    num? unitOldPrice3,
    num? unitOldPrice4,
    num? unitOldPrice5,
    num? unitOldPrice6,
    num? unitOldPrice7,
    num? percantageDiscount,
    String? vendorId,
    String? brand,
    String? vendorName,
    String? description,
    String? productID,
    num? totalRating,
    num? totalNumberOfUserRating,
    num? quantity,
    String? endFlash,
    num? price,
    String? selectedExtra1,
    num? selectedPrice,
    String? selected,
    int? returnDuration,
    num? selectedExtraPrice1,
    String? selectedExtra2,
    num? selectedExtraPrice2,
    String? selectedExtra3,
    num? selectedExtraPrice3,
    String? selectedExtra4,
    num? selectedExtraPrice4,
    String? selectedExtra5,
    num? selectedExtraPrice5,
  }) {
    return CartModel(
      isPrescription: isPrescription ?? this.isPrescription,
      module: module ?? this.module,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      category: category ?? this.category,
      collection: collection ?? this.collection,
      subCollection: subCollection ?? this.subCollection,
      image1: image1 ?? this.image1,
      image2: image2 ?? this.image2,
      image3: image3 ?? this.image3,
      unitname1: unitname1 ?? this.unitname1,
      unitname2: unitname2 ?? this.unitname2,
      unitname3: unitname3 ?? this.unitname3,
      unitname4: unitname4 ?? this.unitname4,
      unitname5: unitname5 ?? this.unitname5,
      unitname6: unitname6 ?? this.unitname6,
      unitname7: unitname7 ?? this.unitname7,
      unitPrice1: unitPrice1 ?? this.unitPrice1,
      unitPrice2: unitPrice2 ?? this.unitPrice2,
      unitPrice3: unitPrice3 ?? this.unitPrice3,
      unitPrice4: unitPrice4 ?? this.unitPrice4,
      unitPrice5: unitPrice5 ?? this.unitPrice5,
      unitPrice6: unitPrice6 ?? this.unitPrice6,
      unitPrice7: unitPrice7 ?? this.unitPrice7,
      unitOldPrice1: unitOldPrice1 ?? this.unitOldPrice1,
      unitOldPrice2: unitOldPrice2 ?? this.unitOldPrice2,
      unitOldPrice3: unitOldPrice3 ?? this.unitOldPrice3,
      unitOldPrice4: unitOldPrice4 ?? this.unitOldPrice4,
      unitOldPrice5: unitOldPrice5 ?? this.unitOldPrice5,
      unitOldPrice6: unitOldPrice6 ?? this.unitOldPrice6,
      unitOldPrice7: unitOldPrice7 ?? this.unitOldPrice7,
      percantageDiscount: percantageDiscount ?? this.percantageDiscount,
      vendorId: vendorId ?? this.vendorId,
      brand: brand ?? this.brand,
      vendorName: vendorName ?? this.vendorName,
      description: description ?? this.description,
      productID: productID ?? this.productID,
      totalRating: totalRating ?? this.totalRating,
      totalNumberOfUserRating: totalNumberOfUserRating ?? this.totalNumberOfUserRating,
      quantity: quantity ?? this.quantity,
      endFlash: endFlash ?? this.endFlash,
      price: price ?? this.price,
      selectedExtra1: selectedExtra1 ?? this.selectedExtra1,
      selectedPrice: selectedPrice ?? this.selectedPrice,
      selected: selected ?? this.selected,
      returnDuration: returnDuration ?? this.returnDuration,
      selectedExtraPrice1: selectedExtraPrice1 ?? this.selectedExtraPrice1,
      selectedExtra2: selectedExtra2 ?? this.selectedExtra2,
      selectedExtraPrice2: selectedExtraPrice2 ?? this.selectedExtraPrice2,
      selectedExtra3: selectedExtra3 ?? this.selectedExtra3,
      selectedExtraPrice3: selectedExtraPrice3 ?? this.selectedExtraPrice3,
      selectedExtra4: selectedExtra4 ?? this.selectedExtra4,
      selectedExtraPrice4: selectedExtraPrice4 ?? this.selectedExtraPrice4,
      selectedExtra5: selectedExtra5 ?? this.selectedExtra5,
      selectedExtraPrice5: selectedExtraPrice5 ?? this.selectedExtraPrice5,
    );
  }
}




class CartStateModel {
  final int cartQuantity;
  final num price;

  CartStateModel({
    required this.cartQuantity,
    required this.price,
  });

  CartStateModel copyWith({
    int? cartQuantity,
    num? price,
  }) {
    return CartStateModel(
      cartQuantity: cartQuantity ?? this.cartQuantity,
      price: price ?? this.price,
    );
  }
}
