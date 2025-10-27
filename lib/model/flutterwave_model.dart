class FlutterwaveModel {
  final List<dynamic> data;
  final List<dynamic> cardDetails;
  final String flwRef;
  String pin;
  final String cardType;
  final bool status;
  final String lastDigits;
  final String firstDigits;
  final String publicKey;
  final String secretKey;
  final String enckey;

  FlutterwaveModel({
    this.data = const [],
    this.enckey = '',
    this.cardDetails = const [],
    this.flwRef = '',
    this.pin = '',
    this.cardType = '',
    this.status = false,
    this.lastDigits = '',
    this.firstDigits = '',
    this.publicKey = '',
    this.secretKey = '',
  });

  FlutterwaveModel copyWith({
    List<dynamic>? data,
    String? enckey,
    List<dynamic>? cardDetails,
    String? flwRef,
    String? pin,
    String? cardType,
    bool? status,
    String? lastDigits,
    String? firstDigits,
    String? publicKey,
    String? secretKey,
  }) {
    return FlutterwaveModel(
      data: data ?? this.data,
      enckey: enckey ?? this.enckey,
      cardDetails: cardDetails ?? this.cardDetails,
      flwRef: flwRef ?? this.flwRef,
      pin: pin ?? this.pin,
      cardType: cardType ?? this.cardType,
      status: status ?? this.status,
      lastDigits: lastDigits ?? this.lastDigits,
      firstDigits: firstDigits ?? this.firstDigits,
      publicKey: publicKey ?? this.publicKey,
      secretKey: secretKey ?? this.secretKey,
    );
  }
}
