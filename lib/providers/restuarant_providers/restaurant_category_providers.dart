import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_web/model/categories.dart';
part 'restaurant_category_providers.g.dart';

@riverpod
Future<List<String>> getCategoriesStringRestaurant(Ref ref,String module) async {
  const List<String> customCategoryOrder = [
    'Veg Appetizer',
    'Non-veg Appetizer',
    'Biriyani',
    'Pulav',
    'Veg Curry',
    'Non-Veg Curry',
    'Rotti',
    'Dosa',
    'Desserts',
    'Drinks',
    'Nutrition',
    'Millets',
  ];

  final snapshot = await FirebaseFirestore.instance
      .collection('Categories')
      .where('module', isEqualTo: module)
      .get();

  List<String> fetchedCategories = snapshot.docs
      .map((doc) => doc['category'] as String)
      .toList();

  // Sort based on the custom order
  fetchedCategories.sort((a, b) {
    int indexA = customCategoryOrder.indexOf(a);
    int indexB = customCategoryOrder.indexOf(b);

    if (indexA == -1) indexA = 999; // Unlisted categories go to the end
    if (indexB == -1) indexB = 999;

    return indexA.compareTo(indexB);
  });

  return fetchedCategories;
}


@riverpod
Future<List<CategoriesModel>> getCategoriesByModelRestaurant(Ref ref,String module) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('Categories')
      .where('module', isEqualTo: module)
      .get();

  final List<CategoriesModel> categories = snapshot.docs
      .map((e) => CategoriesModel.fromMap(e.data(), e.id))
      .toList();

  const List<String> customCategoryOrder = [
    'Veg Appetizer',
    'Non-veg Appetizer',
    'Biriyani',
    'Pulav',
    'Veg Curry',
    'Non-Veg Curry',
    'Rotti',
    'Dosa',
    'Desserts',
    'Drinks',
    'Nutrition',
    'Millets',
  ];

  categories.sort((a, b) {
    int indexA = customCategoryOrder.indexOf(a.category);
    int indexB = customCategoryOrder.indexOf(b.category);

    if (indexA == -1) indexA = 999;
    if (indexB == -1) indexB = 999;

    return indexA.compareTo(indexB);
  });

  return categories;
}


