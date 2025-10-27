class ParcelCategoriesModel {
  final String? uid;
  final num chargePerKm;
  final num adminCommission;
  final String description;
  final String category;
  final String image;
  ParcelCategoriesModel({
    required this.description,
    required this.adminCommission,
    required this.chargePerKm,
    required this.category,
    this.uid,
    required this.image,
  });
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'chargePerKm': chargePerKm,
      'adminCommission': adminCommission,
      'category': category,
      'image': image,
    };
  }

  ParcelCategoriesModel.fromMap(data, this.uid)
      : category = data['category'],
        description = data['description'],
        chargePerKm = data['chargePerKm'],
        adminCommission = data['adminCommission'],
        image = data['image'];
}
