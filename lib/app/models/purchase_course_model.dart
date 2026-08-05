import 'course_model.dart';

class PurchaseCourseModel {
  int? id;
  int? sellerId;
  int? buyerId;
  int? orderId;
  int? webinarId;
  int? bundleId;
  int? meetingId;
  int? meetingTimeId;
  int? subscribeId;
  int? ticketId;
  int? promotionId;
  int? productOrderId;
  int? registrationPackageId;
  int? installmentPaymentId;
  int? giftId;
  String? paymentMethod;
  String? type;
  String? amount;
  String? tax;
  String? commission;
  String? discount;
  String? totalAmount;
  int? productDeliveryFee;
  int? manualAdded;
  int? accessToPurchasedItem;
  int? createdAt;
  int? refundAt;
  bool? expired;
  int? expiredAt;
  CourseModel? webinar;
  CourseModel? bundle;

  PurchaseCourseModel(
      {this.id,
      this.sellerId,
      this.buyerId,
      this.orderId,
      this.webinarId,
      this.bundleId,
      this.meetingId,
      this.meetingTimeId,
      this.subscribeId,
      this.ticketId,
      this.promotionId,
      this.productOrderId,
      this.registrationPackageId,
      this.installmentPaymentId,
      this.giftId,
      this.paymentMethod,
      this.type,
      this.amount,
      this.tax,
      this.commission,
      this.discount,
      this.totalAmount,
      this.productDeliveryFee,
      this.manualAdded,
      this.accessToPurchasedItem,
      this.createdAt,
      this.refundAt,
      this.expired,
      this.expiredAt,
      this.webinar,
      this.bundle});

  PurchaseCourseModel.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    sellerId = _parseInt(json['seller_id']);
    buyerId = _parseInt(json['buyer_id']);
    orderId = _parseInt(json['order_id']);
    webinarId = _parseInt(json['webinar_id']);
    bundleId = _parseInt(json['bundle_id']);
    meetingId = _parseInt(json['meeting_id']);
    meetingTimeId = _parseInt(json['meeting_time_id']);
    subscribeId = _parseInt(json['subscribe_id']);
    ticketId = _parseInt(json['ticket_id']);
    promotionId = _parseInt(json['promotion_id']);
    productOrderId = _parseInt(json['product_order_id']);
    registrationPackageId = _parseInt(json['registration_package_id']);
    installmentPaymentId = _parseInt(json['installment_payment_id']);
    giftId = _parseInt(json['gift_id']);
    paymentMethod = json['payment_method']?.toString();
    type = json['type']?.toString();
    amount = json['amount']?.toString();
    tax = json['tax']?.toString();
    commission = json['commission']?.toString();
    discount = json['discount']?.toString();
    totalAmount = json['total_amount']?.toString();
    productDeliveryFee = _parseInt(json['product_delivery_fee']);
    manualAdded = _parseInt(json['manual_added']);
    accessToPurchasedItem = _parseInt(json['access_to_purchased_item']);
    createdAt = _parseInt(json['created_at']);
    refundAt = _parseInt(json['refund_at']);
    expired = json['expired'] is bool ? json['expired'] : null;
    expiredAt = _parseInt(json['expired_at']);
    webinar =
        json['webinar'] != null ? CourseModel.fromJson(json['webinar']) : null;
    bundle =
        json['bundle'] != null ? CourseModel.fromJson(json['bundle']) : null;
  }

  // Helper method to parse integers safely
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    if (value is num) return value.toInt();
    return null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['seller_id'] = sellerId;
    data['buyer_id'] = buyerId;
    data['order_id'] = orderId;
    data['webinar_id'] = webinarId;
    data['bundle_id'] = bundleId;
    data['meeting_id'] = meetingId;
    data['meeting_time_id'] = meetingTimeId;
    data['subscribe_id'] = subscribeId;
    data['ticket_id'] = ticketId;
    data['promotion_id'] = promotionId;
    data['product_order_id'] = productOrderId;
    data['registration_package_id'] = registrationPackageId;
    data['installment_payment_id'] = installmentPaymentId;
    data['gift_id'] = giftId;
    data['payment_method'] = paymentMethod;
    data['type'] = type;
    data['amount'] = amount;
    data['tax'] = tax;
    data['commission'] = commission;
    data['discount'] = discount;
    data['total_amount'] = totalAmount;
    data['product_delivery_fee'] = productDeliveryFee;
    data['manual_added'] = manualAdded;
    data['access_to_purchased_item'] = accessToPurchasedItem;
    data['created_at'] = createdAt;
    data['refund_at'] = refundAt;
    data['expired'] = expired;
    data['expired_at'] = expiredAt;
    if (webinar != null) {
      data['webinar'] = webinar!.toJson();
    }
    if (bundle != null) {
      data['bundle'] = bundle!.toJson();
    }
    return data;
  }
}