class CouponDetails {
  final String title;
  final int percentage;
  final DateTime? validTo;

  CouponDetails({
    required this.title,
    required this.percentage,
    this.validTo,
  });
}