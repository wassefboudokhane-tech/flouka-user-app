class PaymentMethodEntity {
  final String paymentMethod;
  final String image;
  final String toAPI;
  final bool isRecommended;
  final String? subtitleKey;

  PaymentMethodEntity({
    required this.paymentMethod,
    required this.image,
    required this.toAPI,
    this.isRecommended = false,
    this.subtitleKey,
  });
}
