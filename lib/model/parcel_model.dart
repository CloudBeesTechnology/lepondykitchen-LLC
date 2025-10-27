import 'package:flutter/foundation.dart';

@immutable
class ParcelModel {
  final String? parcelCategory;
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
  final double? senderLat;
  final double? senderLong;
  final double? receiverLat;
  final double? receiverLong;
  final String? instruction;

  const ParcelModel({
    this.senderLat,
    this.senderLong,
    this.receiverLat,
    this.receiverLong,
    this.parcelCategory,
  this.instruction,
    this.senderEmail,
    this.senderPhone,
    this.senderAddress,
    this.senderName,
    this.senderHouseNumber,
    this.senderStreetNumber,
    this.senderFloorNumber,
    this.receiverPhone,
    this.receiverEmail,
    this.receiverAddress,
    this.receiverHouseNumber,
    this.receiverStreetNumber,
    this.receiverFloorNumber,
    this.receiverName,
    this.parcelAdminCommission,
    this.parcelPayer,
  });

  ParcelModel copyWith({
    double? senderLat,
    String? instruction,
    double? receiverLong,
    double? receiverLat,
    double? senderLong,
    String? parcelCategory,
    String? vendorId,
    String? senderEmail,
    String? senderPhone,
    String? senderAddress,
    String? senderName,
    String? senderHouseNumber,
    String? senderStreetNumber,
    String? senderFloorNumber,
    String? receiverPhone,
    String? receiverEmail,
    String? receiverAddress,
    String? receiverHouseNumber,
    String? receiverStreetNumber,
    String? receiverFloorNumber,
    String? receiverName,
    num? parcelAdminCommission,
    String? parcelPayer,
  }) {
    return ParcelModel(
      instruction: instruction ?? this.instruction,
      senderLat: senderLat ?? this.senderLat,
      senderLong: senderLong ?? this.senderLong,
      receiverLat: receiverLat ?? this.receiverLat,
      receiverLong: receiverLong ?? this.receiverLong,
      parcelCategory: parcelCategory ?? this.parcelCategory,
  
      senderEmail: senderEmail ?? this.senderEmail,
      senderPhone: senderPhone ?? this.senderPhone,
      senderAddress: senderAddress ?? this.senderAddress,
      senderName: senderName ?? this.senderName,
      senderHouseNumber: senderHouseNumber ?? this.senderHouseNumber,
      senderStreetNumber: senderStreetNumber ?? this.senderStreetNumber,
      senderFloorNumber: senderFloorNumber ?? this.senderFloorNumber,
      receiverPhone: receiverPhone ?? this.receiverPhone,
      receiverEmail: receiverEmail ?? this.receiverEmail,
      receiverAddress: receiverAddress ?? this.receiverAddress,
      receiverHouseNumber: receiverHouseNumber ?? this.receiverHouseNumber,
      receiverStreetNumber: receiverStreetNumber ?? this.receiverStreetNumber,
      receiverFloorNumber: receiverFloorNumber ?? this.receiverFloorNumber,
      receiverName: receiverName ?? this.receiverName,
      parcelAdminCommission:
          parcelAdminCommission ?? this.parcelAdminCommission,
      parcelPayer: parcelPayer ?? this.parcelPayer,
    );
  }
}
