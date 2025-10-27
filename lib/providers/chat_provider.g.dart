// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authStateHash() => r'758ae4e4e34de70fe2d743034d78a541d9de3f05';

/// See also [authState].
@ProviderFor(authState)
final authStateProvider = AutoDisposeStreamProvider<User?>.internal(
  authState,
  name: r'authStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthStateRef = AutoDisposeStreamProviderRef<User?>;
String _$userDetailsHash() => r'eb3e7c50b67c051de5bf9c0ad6321e7278306b99';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [userDetails].
@ProviderFor(userDetails)
const userDetailsProvider = UserDetailsFamily();

/// See also [userDetails].
class UserDetailsFamily extends Family<AsyncValue<DocumentSnapshot>> {
  /// See also [userDetails].
  const UserDetailsFamily();

  /// See also [userDetails].
  UserDetailsProvider call(
    String uid,
  ) {
    return UserDetailsProvider(
      uid,
    );
  }

  @override
  UserDetailsProvider getProviderOverride(
    covariant UserDetailsProvider provider,
  ) {
    return call(
      provider.uid,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userDetailsProvider';
}

/// See also [userDetails].
class UserDetailsProvider extends AutoDisposeStreamProvider<DocumentSnapshot> {
  /// See also [userDetails].
  UserDetailsProvider(
    String uid,
  ) : this._internal(
          (ref) => userDetails(
            ref as UserDetailsRef,
            uid,
          ),
          from: userDetailsProvider,
          name: r'userDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userDetailsHash,
          dependencies: UserDetailsFamily._dependencies,
          allTransitiveDependencies:
              UserDetailsFamily._allTransitiveDependencies,
          uid: uid,
        );

  UserDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Override overrideWith(
    Stream<DocumentSnapshot> Function(UserDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserDetailsProvider._internal(
        (ref) => create(ref as UserDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<DocumentSnapshot> createElement() {
    return _UserDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserDetailsProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserDetailsRef on AutoDisposeStreamProviderRef<DocumentSnapshot> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _UserDetailsProviderElement
    extends AutoDisposeStreamProviderElement<DocumentSnapshot>
    with UserDetailsRef {
  _UserDetailsProviderElement(super.provider);

  @override
  String get uid => (origin as UserDetailsProvider).uid;
}

String _$chatMessagesHash() => r'23d982a5212198b5c54f23f05bc60b41115aac7e';

/// See also [chatMessages].
@ProviderFor(chatMessages)
const chatMessagesProvider = ChatMessagesFamily();

/// See also [chatMessages].
class ChatMessagesFamily extends Family<AsyncValue<List<ChatModel>>> {
  /// See also [chatMessages].
  const ChatMessagesFamily();

  /// See also [chatMessages].
  ChatMessagesProvider call(
    String userId,
    String riderId,
  ) {
    return ChatMessagesProvider(
      userId,
      riderId,
    );
  }

  @override
  ChatMessagesProvider getProviderOverride(
    covariant ChatMessagesProvider provider,
  ) {
    return call(
      provider.userId,
      provider.riderId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chatMessagesProvider';
}

/// See also [chatMessages].
class ChatMessagesProvider extends AutoDisposeStreamProvider<List<ChatModel>> {
  /// See also [chatMessages].
  ChatMessagesProvider(
    String userId,
    String riderId,
  ) : this._internal(
          (ref) => chatMessages(
            ref as ChatMessagesRef,
            userId,
            riderId,
          ),
          from: chatMessagesProvider,
          name: r'chatMessagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatMessagesHash,
          dependencies: ChatMessagesFamily._dependencies,
          allTransitiveDependencies:
              ChatMessagesFamily._allTransitiveDependencies,
          userId: userId,
          riderId: riderId,
        );

  ChatMessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
    required this.riderId,
  }) : super.internal();

  final String userId;
  final String riderId;

  @override
  Override overrideWith(
    Stream<List<ChatModel>> Function(ChatMessagesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatMessagesProvider._internal(
        (ref) => create(ref as ChatMessagesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
        riderId: riderId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<ChatModel>> createElement() {
    return _ChatMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatMessagesProvider &&
        other.userId == userId &&
        other.riderId == riderId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, riderId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChatMessagesRef on AutoDisposeStreamProviderRef<List<ChatModel>> {
  /// The parameter `userId` of this provider.
  String get userId;

  /// The parameter `riderId` of this provider.
  String get riderId;
}

class _ChatMessagesProviderElement
    extends AutoDisposeStreamProviderElement<List<ChatModel>>
    with ChatMessagesRef {
  _ChatMessagesProviderElement(super.provider);

  @override
  String get userId => (origin as ChatMessagesProvider).userId;
  @override
  String get riderId => (origin as ChatMessagesProvider).riderId;
}

String _$postMessageHash() => r'54535b96c4e1bdd469f2460dd69787fa6f45819d';

/// See also [postMessage].
@ProviderFor(postMessage)
const postMessageProvider = PostMessageFamily();

/// See also [postMessage].
class PostMessageFamily extends Family<AsyncValue<void>> {
  /// See also [postMessage].
  const PostMessageFamily();

  /// See also [postMessage].
  PostMessageProvider call(
    String chatUID,
    String message,
  ) {
    return PostMessageProvider(
      chatUID,
      message,
    );
  }

  @override
  PostMessageProvider getProviderOverride(
    covariant PostMessageProvider provider,
  ) {
    return call(
      provider.chatUID,
      provider.message,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'postMessageProvider';
}

/// See also [postMessage].
class PostMessageProvider extends AutoDisposeFutureProvider<void> {
  /// See also [postMessage].
  PostMessageProvider(
    String chatUID,
    String message,
  ) : this._internal(
          (ref) => postMessage(
            ref as PostMessageRef,
            chatUID,
            message,
          ),
          from: postMessageProvider,
          name: r'postMessageProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postMessageHash,
          dependencies: PostMessageFamily._dependencies,
          allTransitiveDependencies:
              PostMessageFamily._allTransitiveDependencies,
          chatUID: chatUID,
          message: message,
        );

  PostMessageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chatUID,
    required this.message,
  }) : super.internal();

  final String chatUID;
  final String message;

  @override
  Override overrideWith(
    FutureOr<void> Function(PostMessageRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostMessageProvider._internal(
        (ref) => create(ref as PostMessageRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chatUID: chatUID,
        message: message,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _PostMessageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostMessageProvider &&
        other.chatUID == chatUID &&
        other.message == message;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chatUID.hashCode);
    hash = _SystemHash.combine(hash, message.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PostMessageRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `chatUID` of this provider.
  String get chatUID;

  /// The parameter `message` of this provider.
  String get message;
}

class _PostMessageProviderElement extends AutoDisposeFutureProviderElement<void>
    with PostMessageRef {
  _PostMessageProviderElement(super.provider);

  @override
  String get chatUID => (origin as PostMessageProvider).chatUID;
  @override
  String get message => (origin as PostMessageProvider).message;
}

String _$createOrUpdateChatHash() =>
    r'b5beffd2bd976aaae5eac793085c4366fdf914a9';

/// See also [createOrUpdateChat].
@ProviderFor(createOrUpdateChat)
const createOrUpdateChatProvider = CreateOrUpdateChatFamily();

/// See also [createOrUpdateChat].
class CreateOrUpdateChatFamily extends Family<AsyncValue<void>> {
  /// See also [createOrUpdateChat].
  const CreateOrUpdateChatFamily();

  /// See also [createOrUpdateChat].
  CreateOrUpdateChatProvider call(
    UserModel rider,
  ) {
    return CreateOrUpdateChatProvider(
      rider,
    );
  }

  @override
  CreateOrUpdateChatProvider getProviderOverride(
    covariant CreateOrUpdateChatProvider provider,
  ) {
    return call(
      provider.rider,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'createOrUpdateChatProvider';
}

/// See also [createOrUpdateChat].
class CreateOrUpdateChatProvider extends AutoDisposeFutureProvider<void> {
  /// See also [createOrUpdateChat].
  CreateOrUpdateChatProvider(
    UserModel rider,
  ) : this._internal(
          (ref) => createOrUpdateChat(
            ref as CreateOrUpdateChatRef,
            rider,
          ),
          from: createOrUpdateChatProvider,
          name: r'createOrUpdateChatProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createOrUpdateChatHash,
          dependencies: CreateOrUpdateChatFamily._dependencies,
          allTransitiveDependencies:
              CreateOrUpdateChatFamily._allTransitiveDependencies,
          rider: rider,
        );

  CreateOrUpdateChatProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.rider,
  }) : super.internal();

  final UserModel rider;

  @override
  Override overrideWith(
    FutureOr<void> Function(CreateOrUpdateChatRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateOrUpdateChatProvider._internal(
        (ref) => create(ref as CreateOrUpdateChatRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        rider: rider,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _CreateOrUpdateChatProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateOrUpdateChatProvider && other.rider == rider;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, rider.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateOrUpdateChatRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `rider` of this provider.
  UserModel get rider;
}

class _CreateOrUpdateChatProviderElement
    extends AutoDisposeFutureProviderElement<void> with CreateOrUpdateChatRef {
  _CreateOrUpdateChatProviderElement(super.provider);

  @override
  UserModel get rider => (origin as CreateOrUpdateChatProvider).rider;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
