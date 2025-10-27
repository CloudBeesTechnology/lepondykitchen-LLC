class OrderModel {
  /////// Schedule ////////
  final String? scheduleDate;
  final String? scheduleTime;
  final num? tipRider;
  /////// Parcel ////////////
  final double? senderLat;
  final double? senderLong;
  final double? receiverLat;
  final double? receiverLong;
  final String? parcelCategory;
  final String vendorId;
  final String? senderEmail;
  final String? senderPhone;
  final String? senderAddress;
  final String? senderName;
  final String? senderHouseNumber;
  final String? senderStreetNumber;
  final String? senderFloorNumber;
  final String? receiverPhone;
  final String? receiverEmail;
  final String? receiverAddress;
  final String? receiverHouseNumber;
  final String? receiverStreetNumber;
  final String? receiverFloorNumber;
  final String? receiverName;
  final num? parcelAdminCommission;
  final String? parcelPayer;
  ////////////////////////////////////
  final bool? isPos;
  final int weekNumber;
  final String date;
  final String day;
  final String module;
  final bool? prescription;
  final String? prescriptionPic;
  final List<String>? vendorIDs;
  final String userID;
  final String? deliveryAddress;
  final String? houseNumber;
  final String? closesBusStop;
  final String deliveryBoyID;
  final String status;
  final bool accept;
  final String orderID;
  final DateTime timeCreated;
  final num total;
  final num? deliveryFee;
  final bool acceptDelivery;
  final bool? confirmationStatus;
  final String paymentType;
  final List<Map<dynamic, dynamic>>? orders;
  final String uid;
  final String? pickupAddress;
  final String? pickupPhone;
  final String? pickupStorename;
  final String? instruction;
  final bool? useCoupon;
  final num? couponPercentage;
  final String? couponTitle;
  final int? pointsRedeemed;
  final int? pointsUsed;

  OrderModel({
    this.tipRider,
    this.receiverLat,
    this.receiverLong,
    this.senderLat,
    this.senderLong,
    this.scheduleDate,
    this.scheduleTime,
    this.senderName,
    this.isPos,
    required this.vendorId,
    this.receiverName,
    this.parcelCategory,
    this.senderEmail,
    this.senderPhone,
    this.senderAddress,
    this.senderHouseNumber,
    this.senderStreetNumber,
    this.senderFloorNumber,
    this.receiverPhone,
    this.receiverEmail,
    this.receiverAddress,
    this.receiverHouseNumber,
    this.receiverStreetNumber,
    this.receiverFloorNumber,
    this.parcelAdminCommission,
    this.parcelPayer,
    this.prescription,
    this.prescriptionPic,
    this.couponTitle,
    required this.module,
    this.couponPercentage,
    this.useCoupon,
    required this.day,
    this.instruction,
    this.pickupAddress,
    this.pickupPhone,
    this.pickupStorename,
    required this.weekNumber,
    required this.date,
    required this.orderID,
    this.orders,
    required this.uid,
    required this.acceptDelivery,
    this.deliveryFee,
    required this.total,
    this.vendorIDs,
    required this.paymentType,
    this.confirmationStatus,
    required this.userID,
    required this.timeCreated,
    this.deliveryAddress,
    this.houseNumber,
    this.closesBusStop,
    required this.deliveryBoyID,
    required this.status,
    required this.accept,
    this.pointsRedeemed,
    this.pointsUsed
  });

  Map<String, dynamic> toMap() {
    return {
      'tipRider': tipRider,
      'senderLat': senderLat,
      'senderLong': senderLong,
      'receiverLong': receiverLong,
      'receiverLat': receiverLat,
      'scheduleDate': scheduleDate,
      'scheduleTime': scheduleTime,
      'vendorId': vendorId,
      'isPos': isPos,
      'senderName': senderName,
      'parcelCategory': parcelCategory,
      'senderEmail': senderEmail,
      'receiverName': receiverName,
      'senderPhone': senderPhone,
      'senderAddress': senderAddress,
      'senderHouseNumber': senderHouseNumber,
      'senderStreetNumber': senderStreetNumber,
      'senderFloorNumber': senderFloorNumber,
      'receiverPhone': receiverPhone,
      'receiverEmail': receiverEmail,
      'receiverAddress': receiverAddress,
      'receiverHouseNumber': receiverHouseNumber,
      'receiverStreetNumber': receiverStreetNumber,
      'receiverFloorNumber': receiverFloorNumber,
      'parcelAdminCommission': parcelAdminCommission,
      'parcelPayer': parcelPayer,
      'prescription': prescription,
      'prescriptionPic': prescriptionPic,
      'module': module,
      'couponTitle': couponTitle,
      'useCoupon': useCoupon,
      'couponPercentage': couponPercentage,
      'pickupAddress': pickupAddress,
      'pickupStorename': pickupStorename,
      'pickupPhone': pickupPhone,
      'instruction': instruction,
      'weekNumber': weekNumber,
      'date': date,
      'day': day,
      'paymentType': paymentType,
      'orderID': orderID,
      'orders': orders,
      'acceptDelivery': acceptDelivery,
      'deliveryFee': deliveryFee,
      'total': total,
      'vendorIDs': vendorIDs,
      'userID': userID,
      'timeCreated': timeCreated,
      'deliveryAddress': deliveryAddress,
      'houseNumber': houseNumber,
      'closesBusStop': closesBusStop,
      'deliveryBoyID': deliveryBoyID,
      'status': status,
      'confirmationStatus': confirmationStatus,
      'accept': accept,
      'uid': uid,
      'pointsRedeemed':pointsRedeemed,
      'pointsUsed':pointsUsed
    };
  }
}

class OrderModel2 {
  final num? tipRider;
  //////////Schedule/////////
  final String? scheduleDate;
  final String? scheduleTime;
  /////// Parcel ////////////

  final double? senderLat;
  final double? senderLong;
  final double? receiverLat;
  final double? receiverLong;
  final String? parcelCategory;
  final String vendorId;
  final String? senderName;
  final String? senderEmail;
  final String? senderPhone;
  final String? senderAddress;
  final String? senderHouseNumber;
  final String? senderStreetNumber;
  final String? senderFloorNumber;
  final String? receiverPhone;
  final String? receiverName;
  final String? receiverEmail;
  final String? receiverAddress;
  final String? receiverHouseNumber;
  final String? receiverStreetNumber;
  final String? receiverFloorNumber;
  final num? parcelAdminCommission;
  final String? parcelPayer;
  ////////////////////////////////////

  final String module;
  final String? couponTitle;
  final bool? confirmationStatus;
  final List<String>? vendorIDs;
  final String userID;
  final String? deliveryAddress;
  final String? houseNumber;
  final String? closesBusStop;
  final String deliveryBoyID;
  final String status;
  final bool? prescription;
  final String? prescriptionPic;
  final bool accept;
  final String orderID;
  final DateTime timeCreated;
  final num total;
  final String uid;
  final num? deliveryFee;
  final bool acceptDelivery;
  final List<OrdersList>? orders;
  final String paymentType;
  final String? pickupAddress;
  final String? pickupPhone;
  final String? pickupStorename;
  final String? instruction;
  final bool? useCoupon;
  final num? couponPercentage;
  final bool? isPos;
  final int? pointsRedeemed;
  final int? pointsUsed;

  OrderModel2({
    this.tipRider,
    this.receiverLat,
    this.receiverLong,
    this.senderLat,
    this.senderLong,
    this.scheduleDate,
    this.scheduleTime,
    this.senderName,
    required this.vendorId,
    this.receiverName,
    this.parcelCategory,
    this.senderEmail,
    this.isPos,
    this.senderPhone,
    this.senderAddress,
    this.senderHouseNumber,
    this.senderStreetNumber,
    this.senderFloorNumber,
    this.receiverPhone,
    this.receiverEmail,
    this.receiverAddress,
    this.receiverHouseNumber,
    this.receiverStreetNumber,
    this.receiverFloorNumber,
    this.parcelAdminCommission,
    this.parcelPayer,
    this.prescription,
    this.prescriptionPic,
    this.couponTitle,
    required this.module,
    this.useCoupon,
    this.couponPercentage,
    this.instruction,
    this.pickupAddress,
    this.pickupPhone,
    this.pickupStorename,
    required this.uid,
    required this.orderID,
    this.orders,
    required this.acceptDelivery,
    this.deliveryFee,
    required this.total,
    this.vendorIDs,
    required this.paymentType,
    required this.userID,
    required this.timeCreated,
    this.confirmationStatus,
    this.deliveryAddress,
    this.houseNumber,
    this.closesBusStop,
    required this.deliveryBoyID,
    required this.status,
    required this.accept,
    this.pointsRedeemed,
    this.pointsUsed
  });

  OrderModel2.fromMap(Map<String, dynamic> data, String uid)
      : instruction = data['instruction'],
        tipRider = data['tipRider'],
        senderLat = data['senderLat'],
        senderLong = data['senderLong'],
        receiverLat = data['receiverLat'],
        receiverLong = data['receiverLong'],
        scheduleDate = data['scheduleDate'],
        scheduleTime = data['scheduleTime'],
        isPos = data['isPos'],
        senderName = data['senderName'],
        receiverName = data['receiverName'],
        vendorId = data['vendorId'],
        parcelCategory = data['parcelCategory'],
        senderEmail = data['senderEmail'],
        senderPhone = data['senderPhone'],
        senderAddress = data['senderAddress'],
        senderHouseNumber = data['senderHouseNumber'],
        senderStreetNumber = data['senderStreetNumber'],
        senderFloorNumber = data['senderFloorNumber'],
        receiverPhone = data['receiverPhone'],
        receiverEmail = data['receiverEmail'],
        receiverAddress = data['receiverAddress'],
        receiverHouseNumber = data['receiverHouseNumber'],
        receiverStreetNumber = data['receiverStreetNumber'],
        receiverFloorNumber = data['receiverFloorNumber'],
        parcelAdminCommission = data['parcelAdminCommission'],
        parcelPayer = data['parcelPayer'],
        module = data['module'],
        prescription = data['prescription'],
        prescriptionPic = data['prescriptionPic'],
        couponTitle = data['couponTitle'],
        couponPercentage = data['couponPercentage'],
        useCoupon = data['usedCoupon'],
        pickupAddress = data['pickupAddress'],
        pickupPhone = data['pickupPhone'],
        pickupStorename = data['pickupStorename'],
        orderID = data['orderID'],
        confirmationStatus = data['confirmationStatus'],
        orders = (data['orders'] as List)
            .map((order) => OrdersList.fromMap(order))
            .toList(),
        acceptDelivery = data['acceptDelivery'],
        deliveryFee = data['deliveryFee'],
        total = data['total'],
        vendorIDs = List<String>.from(data['vendorIDs']),
        paymentType = data['paymentType'],
        userID = data['userID'],
        timeCreated = DateTime.parse(data['timeCreated']).toLocal(),
        deliveryAddress = data['deliveryAddress'],
        houseNumber = data['houseNumber'],
        closesBusStop = data['closesBusStop'],
        deliveryBoyID = data['deliveryBoyID'],
        status = data['status'],
        accept = data['accept'],
        pointsRedeemed = data['pointsRedeemed'],
        pointsUsed = data['pointsUsed'],
        uid = data['uid'];
}


class OrdersList {
  final int returnDuration;
  final String productName;
  final String selected;
  num quantity;
  final String image;
  // final int price;
  final String category;
  final dynamic id;
  final num selectedPrice;
  final String productID;
  final num totalRating;
  final num totalNumberOfUserRating;
  final String status;
  // final DateTime? receivedDate;
  final String vendorId;
  final String vendorName;

  final String? selectedExtra1;
  final num? selectedExtraPrice1;
  final String? selectedExtra2;
  final num? selectedExtraPrice2;
  final String? selectedExtra3;
  final num? selectedExtraPrice3;
  final String? selectedExtra4;
  final num? selectedExtraPrice4;
  final String? selectedExtra5;
  final num? selectedExtraPrice5;

  OrdersList(
      {required this.productName,
      required this.status,
      required this.id,
      //  this.receivedDate,
      required this.vendorId,
      required this.vendorName,
      required this.returnDuration,
      required this.selected,
      required this.productID,
      required this.image,
      required this.totalRating,
      required this.totalNumberOfUserRating,
      this.selectedExtra1,
      this.selectedExtraPrice1,
      this.selectedExtra2,
      this.selectedExtraPrice2,
      this.selectedExtra3,
      this.selectedExtraPrice3,
      this.selectedExtra4,
      this.selectedExtraPrice4,
      this.selectedExtra5,
      this.selectedExtraPrice5,

      // required this.price,
      required this.selectedPrice,
      required this.category,
      required this.quantity});
  OrdersList.fromMap(Map<dynamic, dynamic> data)
      : productName = data['name'],
        selected = data['selected'],
        selectedExtra1 = data['selectedExtra1'],
        selectedExtraPrice1 = data['selectedExtraPrice1'],
        selectedExtra2 = data['selectedExtra2'],
        selectedExtraPrice2 = data['selectedExtraPrice2'],
        selectedExtra3 = data['selectedExtra3'],
        selectedExtraPrice3 = data['selectedExtraPrice3'],
        selectedExtra4 = data['selectedExtra4'],
        selectedExtraPrice4 = data['selectedExtraPrice4'],
        selectedExtra5 = data['selectedExtra5'],
        selectedExtraPrice5 = data['selectedExtraPrice5'],
        // receivedDate = DateTime.parse(data['receivedDate']).toLocal(),
        status = data['status'],
        vendorId = data['vendorId'],
        vendorName = data['vendorName'],
        returnDuration = data['returnDuration'],
        productID = data['productID'],
        totalNumberOfUserRating = data['totalNumberOfUserRating'],
        totalRating = data['totalRating'],
        image = data['image'],
        // price = data['newPrice'],
        quantity = data['quantity'],
        category = data['category'],
        selectedPrice = data['selectedPrice'],
        id = data['id'];
}
