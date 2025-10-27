import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../../model/today_menu_model.dart'; // adjust to your actual model path

part 'today_menu_detail_provider.g.dart'; // this will be auto-generated

final logger = Logger();

@riverpod
class TodayMenuDetailProvider extends _$TodayMenuDetailProvider {
  @override
  Future<TodayMenuModel?> build(String menuID) async {
    return getTodayMenuDetail(menuID);
  }

  Future<TodayMenuModel?> getTodayMenuDetail(String menuID) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('Today menu') // adjust your collection name
          .doc(menuID)
          .get();

      if (doc.exists) {
        return TodayMenuModel.fromMap(doc.data(), doc.id);
      }

      return null;
    } catch (e) {
      logger.e('Error fetching TodayMenu detail: $e');
      return null;
    }
  }
}
