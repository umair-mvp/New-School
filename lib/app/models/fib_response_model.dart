class SubscriptionResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  SubscriptionResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}