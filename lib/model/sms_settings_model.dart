class SmsSettingsState {
  final String selectedPlatform;
  final String twilioNumber;
  final String authToken;
  final String nexmoApiKey;
  final String nexmoNumber;
  final String nexmoSecretKey;
  final String accountSID;
  final String telesignApiKey;
  final String telesignCustomerID;
  final bool enableWhatsapp;
  final bool enableSms;

  SmsSettingsState({
    this.selectedPlatform = '',
    this.twilioNumber = '',
    this.authToken = '',
    this.nexmoApiKey = '',
    this.nexmoNumber = '',
    this.nexmoSecretKey = '',
    this.accountSID = '',
    this.telesignApiKey = '',
    this.telesignCustomerID = '',
    this.enableWhatsapp = false,
    this.enableSms = false,
  });

  SmsSettingsState copyWith({
    String? selectedPlatform,
    String? twilioNumber,
    String? authToken,
    String? nexmoApiKey,
    String? nexmoNumber,
    String? nexmoSecretKey,
    String? accountSID,
    String? telesignApiKey,
    String? telesignCustomerID,
    bool? enableWhatsapp,
    bool? enableSms,
  }) {
    return SmsSettingsState(
      selectedPlatform: selectedPlatform ?? this.selectedPlatform,
      twilioNumber: twilioNumber ?? this.twilioNumber,
      authToken: authToken ?? this.authToken,
      nexmoApiKey: nexmoApiKey ?? this.nexmoApiKey,
      nexmoNumber: nexmoNumber ?? this.nexmoNumber,
      nexmoSecretKey: nexmoSecretKey ?? this.nexmoSecretKey,
      accountSID: accountSID ?? this.accountSID,
      telesignApiKey: telesignApiKey ?? this.telesignApiKey,
      telesignCustomerID: telesignCustomerID ?? this.telesignCustomerID,
      enableWhatsapp: enableWhatsapp ?? this.enableWhatsapp,
      enableSms: enableSms ?? this.enableSms,
    );
  }
}
