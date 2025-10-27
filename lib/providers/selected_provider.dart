import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import '../model/user.dart';

final getStorageProvider = Provider<GetStorage>((ref) {
  return GetStorage();
});

// Update selectedVendorProvider to support persistence with GetStorage
final selectedVendorProvider = StateNotifierProvider<SelectedVendorNotifier, UserModel?>((ref) {
  final storage = ref.watch(getStorageProvider);
  return SelectedVendorNotifier(storage);
});

// Update selectedVendorModuleProvider to support persistence with GetStorage
final selectedVendorModuleProvider = StateNotifierProvider<SelectedVendorModuleNotifier, String?>((ref) {
  final storage = ref.watch(getStorageProvider);
  return SelectedVendorModuleNotifier(storage);
});

// Notifier for selected vendor using GetStorage
class SelectedVendorNotifier extends StateNotifier<UserModel?> {
  final GetStorage _storage;

  // Pass the storage parameter to the static method
  SelectedVendorNotifier(this._storage) : super(_loadVendorFromStorage(_storage));

  static UserModel? _loadVendorFromStorage(GetStorage storage) {
    final vendorMap = storage.read('selectedVendor');
    if (vendorMap != null && vendorMap is Map<String, dynamic>) {
      try {
        return UserModel.fromJson(vendorMap);
      } catch (e) {
        print('Error loading vendor from storage: $e');
        storage.remove('selectedVendor');
        return null;
      }
    }
    return null;
  }

  @override
  set state(UserModel? value) {
    super.state = value;
    if (value == null) {
      _storage.remove('selectedVendor');
    } else {
      _storage.write('selectedVendor', value.toJson());
    }
  }
}

// Notifier for selected vendor module using GetStorage
class SelectedVendorModuleNotifier extends StateNotifier<String?> {
  final GetStorage _storage;

  // Pass the storage parameter to the static method
  SelectedVendorModuleNotifier(this._storage) : super(_loadModuleFromStorage(_storage));

  static String? _loadModuleFromStorage(GetStorage storage) {
    return storage.read('selectedVendorModule');
  }

  @override
  set state(String? value) {
    super.state = value;
    if (value == null) {
      _storage.remove('selectedVendorModule');
    } else {
      _storage.write('selectedVendorModule', value);
    }
  }
}