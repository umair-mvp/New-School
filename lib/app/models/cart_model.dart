import 'profile_model.dart';
import 'user_model.dart';

class CartModel {
  List<Items>? items;
  Amounts? amounts;
  dynamic totalCashbackAmount;
  UserGroup? userGroup;

  CartModel(
      {this.items, this.amounts, this.totalCashbackAmount, this.userGroup});

  CartModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null && json['items'] is List) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    } else {
      items = [];
    }

    totalCashbackAmount = json['totalCashbackAmount'];

    if (json['amounts'] != null && json['amounts'] is Map) {
      amounts = Amounts.fromJson(json['amounts']);
    }

    if (json['user_group'] != null && json['user_group'] is Map) {
      userGroup = UserGroup.fromJson(json['user_group']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (amounts != null) {
      data['amounts'] = amounts!.toJson();
    }
    if (totalCashbackAmount != null) {
      data['totalCashbackAmount'] = totalCashbackAmount;
    }
    if (userGroup != null) {
      data['user_group'] = userGroup!.toJson();
    }
    return data;
  }
}

class Items {
  int? id;
  String? type;
  String? image;
  String? title;
  String? teacherName;
  String? rate;
  String? day;
  String? timezone;
  int? price;
  int? discount;
  int? quantity;
  Time? time;
  Time? timeUser;

  Items({
    this.id,
    this.type,
    this.image,
    this.title,
    this.teacherName,
    this.rate,
    this.price,
    this.discount,
    this.quantity,
    this.day,
    this.timezone,
    this.time,
    this.timeUser,
  });

  Items.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    type = json['type']?.toString();
    image = json['image']?.toString();
    title = json['title']?.toString();
    day = json['day']?.toString();
    timezone = json['timezone']?.toString();
    teacherName = json['teacher_name']?.toString();
    rate = json['rate']?.toString();
    price = _parseInt(json['price']);
    discount = _parseInt(json['discount']);
    quantity = _parseInt(json['quantity']);

    if (json['time'] != null && json['time'] is Map) {
      time = Time.fromJson(json['time']);
    }

    if (json['time_user'] != null && json['time_user'] is Map) {
      timeUser = Time.fromJson(json['time_user']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['image'] = image;
    data['title'] = title;
    data['teacher_name'] = teacherName;
    data['rate'] = rate;
    data['price'] = price;
    data['discount'] = discount;
    data['quantity'] = quantity;

    if (day != null) {
      data['day'] = day;
    }

    if (timezone != null) {
      data['timezone'] = timezone;
    }

    if (time != null) {
      data['time'] = time!.toJson();
    }

    if (timeUser != null) {
      data['time_user'] = timeUser!.toJson();
    }

    return data;
  }
}

class Amounts {
  int? subTotal;
  int? totalDiscount;
  String? tax;
  int? taxPrice;
  int? commission;
  int? commissionPrice;
  int? total;
  int? productDeliveryFee;
  bool? taxIsDifferent;

  Amounts({
    this.subTotal,
    this.totalDiscount,
    this.tax,
    this.taxPrice,
    this.commission,
    this.commissionPrice,
    this.total,
    this.productDeliveryFee,
    this.taxIsDifferent,
  });

  Amounts.fromJson(Map<String, dynamic> json) {
    subTotal = _parseInt(json['sub_total']);
    totalDiscount = _parseInt(json['total_discount']);
    tax = json['tax']?.toString();
    taxPrice = _parseInt(json['tax_price']);
    commission = _parseInt(json['commission']);
    commissionPrice = _parseInt(json['commission_price']);
    total = _parseInt(json['total']);
    productDeliveryFee = _parseInt(json['product_delivery_fee']);
    taxIsDifferent = json['tax_is_different'] is bool
        ? json['tax_is_different']
        : json['tax_is_different']?.toString().toLowerCase() == 'true';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sub_total'] = subTotal;
    data['total_discount'] = totalDiscount;
    data['tax'] = tax;
    data['tax_price'] = taxPrice;
    data['commission'] = commission;
    data['commission_price'] = commissionPrice;
    data['total'] = total;
    data['product_delivery_fee'] = productDeliveryFee;
    data['tax_is_different'] = taxIsDifferent;
    return data;
  }
}

// Helper function to safely parse integers
int? _parseInt(dynamic value) {
  if (value == null) return null;

  if (value is int) return value;

  if (value is double) return value.toInt();

  if (value is String) {
    try {
      // Handle string with decimal points
      if (value.contains('.')) {
        return double.parse(value).toInt();
      }
      return int.parse(value);
    } catch (e) {
      return null;
    }
  }

  return null;
}
