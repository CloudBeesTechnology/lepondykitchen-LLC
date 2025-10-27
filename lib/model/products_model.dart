import 'dart:typed_data';

class ProductsModel {
  String uid;
  String module;
  String vendorName;
  String name;
  String category;
  String collection;
  String subCollection;
  String image1;
  String image2;
  String image3;
  String unitname1;
  String unitname2;
  String unitname3;
  String unitname4;
  String unitname5;
  String unitname6;
  String unitname7;
  num? unitPrice1;
  num? unitPrice2;
  num? unitPrice3;
  num? unitPrice4;
  num? unitPrice5;
  num? unitPrice6;
  num? unitPrice7;
  num? unitOldPrice1;
  num? unitOldPrice2;
  num? unitOldPrice3;
  num? unitOldPrice4;
  num? unitOldPrice5;
  num? unitOldPrice6;
  num? unitOldPrice7;
  num? percantageDiscount;
  String vendorId;
  String brand;

  // String marketID;
  // String marketName;
  String description;
  String productID;
  num? totalRating;
  num? totalNumberOfUserRating;
  int? quantity;
  String? endFlash;
  int? returnDuration;
  DateTime timeCreated;
  Uint8List? imageFile1;
  Uint8List? imageFile2;
  Uint8List? imageFile3;
  bool? isLoading;
  String? extraname1;
  String? extraname2;
  String? extraname3;
  String? extraname4;
  String? extraname5;
  num? extraPrice1;
  num? extraPrice2;
  num? extraPrice3;
  num? extraPrice4;
  num? extraPrice5;
  String? extraTitle;
  bool? isPrescription;

  ProductsModel({
    this.isPrescription,
    this.extraname1,
    this.extraname2,
    this.extraname3,
    this.extraname4,
    this.extraname5,
    this.extraPrice1,
    this.extraPrice2,
    this.extraPrice3,
    this.extraPrice4,
    this.extraPrice5,
    this.extraTitle,
    this.isLoading,
    required this.module,
    this.endFlash,
    this.imageFile1,
    required this.vendorName,
    this.imageFile2,
    this.imageFile3,
    required this.returnDuration,
    required this.totalRating,
    required this.timeCreated,
    required this.quantity,
    required this.totalNumberOfUserRating,
    required this.productID,
    required this.description,
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

  // Named constructor for creating an instance with default values
  ProductsModel.empty()
      : uid = '',
        module = '',
        isPrescription = false,
        extraTitle = '',
        extraname1 = '',
        extraname2 = '',
        extraname3 = '',
        extraname4 = '',
        extraname5 = '',
        extraPrice1 = 0,
        extraPrice2 = 0,
        extraPrice3 = 0,
        extraPrice4 = 0,
        extraPrice5 = 0,
        name = '',
        category = '',
        vendorName = '',
        collection = '',
        subCollection = '',
        image1 = '',
        image2 = '',
        image3 = '',
        unitname1 = '',
        unitname2 = '',
        unitname3 = '',
        unitname4 = '',
        unitname5 = '',
        unitname6 = '',
        unitname7 = '',
        unitPrice1 = 0,
        unitPrice2 = 0,
        unitPrice3 = 0,
        unitPrice4 = 0,
        unitPrice5 = 0,
        unitPrice6 = 0,
        unitPrice7 = 0,
        unitOldPrice1 = 0,
        unitOldPrice2 = 0,
        unitOldPrice3 = 0,
        unitOldPrice4 = 0,
        unitOldPrice5 = 0,
        unitOldPrice6 = 0,
        unitOldPrice7 = 0,
        percantageDiscount = 0,
        vendorId = '',
        brand = '',
        // marketID = '',
        // marketName = '',
        description = '',
        productID = '',
        totalRating = 0,
        totalNumberOfUserRating = 0,
        quantity = 0,
        endFlash = null,
        isLoading = null,
        imageFile1 = null,
        imageFile2 = null,
        imageFile3 = null,
        returnDuration = 0,
        timeCreated = DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'isPrescription':isPrescription,
      'extraTitle': extraTitle,
      'extraname1': extraname1,
      'extraname2': extraname2,
      'extraname3': extraname3,
      'extraname4': extraname4,
      'extraname5': extraname5,
      'extraPrice1': extraPrice1,
      'extraPrice2': extraPrice2,
      'extraPrice3': extraPrice3,
      'extraPrice4': extraPrice4,
      'extraPrice5': extraPrice5,
      'module': module,
      'vendorName': vendorName,
      'timeCreated': timeCreated,
      'returnDuration': returnDuration,
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

  ProductsModel.fromMap(data, this.uid)
      : name = data['name'],
        module = data['module'],
        isPrescription = data['isPrescription'],
        extraTitle = data['extraTitle'],
        extraname1 = data['extraname1'],
        extraname2 = data['extraname2'],
        extraname3 = data['extraname3'],
        extraname4 = data['extraname4'],
        extraname5 = data['extraname5'],
        extraPrice1 = data['extraPrice1'],
        extraPrice2 = data['extraPrice2'],
        extraPrice3 = data['extraPrice3'],
        extraPrice4 = data['extraPrice4'],
        extraPrice5 = data['extraPrice5'],
        // isLoading=data['isLoading'],
        returnDuration = data['returnDuration'],
        totalNumberOfUserRating = data['totalNumberOfUserRating'],
        totalRating = data['totalRating'],
        timeCreated = data['timeCreated'].toDate(),
        vendorName = data['vendorName'],
        description = data['description'],
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

  ProductsModel copyWith({
    String? extraname1,
    bool? isPrescription,
    String? extraname2,
    String? extraname3,
    String? extraname4,
    String? extraname5,
    num? extraPrice1,
    num? extraPrice2,
    num? extraPrice3,
    num? extraPrice4,
    num? extraPrice5,
    String? extraTitle,
    String? uid,
    String? module,
    bool? isLoading,
    Uint8List? imageFile1,
    Uint8List? imageFile2,
    Uint8List? imageFile3,
    String? vendorName,
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
    // String? marketID,
    // String? marketName,
    String? description,
    String? productID,
    num? totalRating,
    num? totalNumberOfUserRating,
    int? quantity,
    String? endFlash,
    int? returnDuration,
    DateTime? timeCreated,
  }) {
    return ProductsModel(
      isPrescription: isPrescription?? this.isPrescription,
      extraname1: extraname1 ?? this.extraname1,
      extraname2: extraname2 ?? this.extraname2,
      extraname3: extraname3 ?? this.extraname3,
      extraname4: extraname3 ?? this.extraname3,
      extraname5: extraname5 ?? this.extraname5,
      extraPrice1: extraPrice1 ?? this.extraPrice1,
      extraPrice2: extraPrice2 ?? this.extraPrice2,
      extraPrice3: extraPrice3 ?? this.extraPrice3,
      extraPrice4: extraPrice4 ?? this.extraPrice4,
      extraPrice5: extraPrice5 ?? this.extraPrice5,
      extraTitle: extraTitle ?? this.extraTitle,
      module: module ?? this.module,
      vendorName: vendorName ?? this.vendorName,
      imageFile1: imageFile1 ?? this.imageFile1,
      imageFile2: imageFile2 ?? this.imageFile2,
      imageFile3: imageFile3 ?? this.imageFile3,
      uid: uid ?? this.uid,
      isLoading: isLoading ?? this.isLoading,
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
      // marketID: marketID ?? this.marketID,
      // marketName: marketName ?? this.marketName,
      description: description ?? this.description,
      productID: productID ?? this.productID,
      totalRating: totalRating ?? this.totalRating,
      totalNumberOfUserRating:
          totalNumberOfUserRating ?? this.totalNumberOfUserRating,
      quantity: quantity ?? this.quantity,
      endFlash: endFlash ?? this.endFlash,
      returnDuration: returnDuration ?? this.returnDuration,
      timeCreated: timeCreated ?? this.timeCreated,
    );
  }
}
