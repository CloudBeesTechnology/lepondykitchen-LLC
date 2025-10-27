import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
part 'uuid_provider.g.dart';

@riverpod
String uuidProvider(Ref ref) {
  var uuid = const Uuid();
  return uuid.v1();
}
