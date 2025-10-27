class EmailSettingsModel {
  final String selectedPlatform;
  final String sendGridApi;
  final String mailGunApi;
  final String mailGunDomain;
  final bool disableEmail;

  EmailSettingsModel({
    this.selectedPlatform = '',
    this.sendGridApi = '',
    this.mailGunApi = '',
    this.mailGunDomain = '',
    this.disableEmail = false,
  });

  EmailSettingsModel copyWith({
    String? selectedPlatform,
    String? sendGridApi,
    String? mailGunApi,
    String? mailGunDomain,
    bool? disableEmail,
  }) {
    return EmailSettingsModel(
      selectedPlatform: selectedPlatform ?? this.selectedPlatform,
      sendGridApi: sendGridApi ?? this.sendGridApi,
      mailGunApi: mailGunApi ?? this.mailGunApi,
      mailGunDomain: mailGunDomain ?? this.mailGunDomain,
      disableEmail: disableEmail ?? this.disableEmail,
    );
  }
}
