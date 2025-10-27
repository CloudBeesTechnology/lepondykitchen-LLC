class RewardPointsState {
  final int availablePoints;
  final int redeemableAmount; // in dollars (1000 points = $10)
  final bool canRedeem;
  final int pointsToRedeem;
  final bool isRedeeming;  // New field
  final int pendingRedemptionAmount; // Amount being redeemed (not yet committed)
  final int pendingPointsUsed;

  RewardPointsState({
    required this.availablePoints,
    required this.redeemableAmount,
    required this.canRedeem,
    this.pointsToRedeem = 0,
    this.isRedeeming = false,
    this.pendingRedemptionAmount  = 0,
    this.pendingPointsUsed = 0,
  });

  RewardPointsState copyWith({
    int? availablePoints,
    int? redeemableAmount,
    bool? canRedeem,
    int? pointsToRedeem,
    bool? isRedeeming,
    int? pendingRedemptionAmount,
    int? pendingPointsUsed,
  }) {
    return RewardPointsState(
        availablePoints: availablePoints ?? this.availablePoints,
        redeemableAmount: redeemableAmount ?? this.redeemableAmount,
        canRedeem: canRedeem ?? this.canRedeem,
        pointsToRedeem: pointsToRedeem ?? this.pointsToRedeem,
        isRedeeming:isRedeeming ?? this.isRedeeming,
        pendingRedemptionAmount: pendingRedemptionAmount ?? this.pendingRedemptionAmount,
        pendingPointsUsed : pendingPointsUsed ?? this.pendingPointsUsed
    );
  }
}