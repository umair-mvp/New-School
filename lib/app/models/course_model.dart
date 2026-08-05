import 'dart:typed_data';

import 'can_model.dart';
import 'single_course_model.dart';
import 'user_model.dart';
import '../../common/data/app_language.dart';
import '../../locator.dart';

class CourseModel {
  String? thumbnail;
  String? image;
  bool? auth;
  Can? can;
  var canViewError;
  int? id;
  String? status;
  String? label;
  String? title;
  String? description;
  String? type;
  String? link;
  int? accessDays;
  int? salesCountNumber;
  String? liveWebinarStatus;
  bool? authHasBought;
  Sales? sales;
  bool? isFavorite;
  bool? expired;
  int? expireOn;
  String? priceString;
  String? bestTicketString;
  var price;
  var tax;
  var taxWithDiscount;
  var bestTicketPrice;
  var discountPercent;
  int? coursePageTax;
  var priceWithDiscount;
  var discountAmount;
  ActiveSpecialOffer? activeSpecialOffer;
  int? duration;
  UserModel? teacher;
  int? studentsCount;
  String? rate;
  RateType? rateType;
  int? createdAt;
  int? startDate;
  int? purchasedAt;
  int? reviewsCount;
  int? points;
  int? progress;
  int? progressPercent;
  String? category;
  int? capacity;

  String? reservedMeeting;
  String? reservedMeetingUserTimeZone;

  String isPrivate = '0';
  List<Translations>? translations;

  List<CustomBadges>? badges;

  CourseModel(
      {this.image,
      this.auth,
      this.can,
      this.canViewError,
      this.id,
      this.status,
      this.label,
      this.title,
      this.type,
      this.link,
      this.reservedMeeting,
      this.reservedMeetingUserTimeZone,
      this.accessDays,
      this.liveWebinarStatus,
      this.authHasBought,
      this.sales,
      this.isFavorite,
      this.priceString,
      this.bestTicketString,
      this.price,
      this.tax,
      this.taxWithDiscount,
      this.bestTicketPrice,
      this.discountPercent,
      this.coursePageTax,
      this.priceWithDiscount,
      this.discountAmount,
      this.activeSpecialOffer,
      this.duration,
      this.teacher,
      this.studentsCount,
      this.rate,
      this.rateType,
      this.createdAt,
      this.startDate,
      this.purchasedAt,
      this.reviewsCount,
      this.points,
      this.progress,
      this.progressPercent,
      this.category,
      this.capacity});

  CourseModel.fromJson(Map<String, dynamic> json) {
    salesCountNumber = _parseInt(json['sales_count_number']);

    if (json['badges'] != null) {
      badges = <CustomBadges>[];
      json['badges'].forEach((v) {
        if (v is Map<String, dynamic>) {
          badges!.add(CustomBadges.fromJson(v));
        }
      });
    }

    isPrivate = json['isPrivate']?.toString() ?? '0';

    if (json['translations'] != null) {
      translations = <Translations>[];
      json['translations'].forEach((v) {
        translations!.add(Translations.fromJson(v));
      });
    }

    thumbnail = json['thumbnail']?.toString();
    image = json['image']?.toString();
    auth = json['auth'] is bool ? json['auth'] : null;
    can = json['can'] != null ? Can.fromJson(json['can']) : null;
    canViewError = json['can_view_error'];
    id = _parseInt(json['id']);
    status = json['status']?.toString();
    label = json['label']?.toString();
    title = json['title']?.toString();
    description = json['description']?.toString();
    type = json['type']?.toString();
    link = json['link']?.toString();
    accessDays = _parseInt(json['access_days']);
    expired = json['expired'] is bool ? json['expired'] : null;
    expireOn = _parseInt(json['expire_on']);
    liveWebinarStatus = json['live_webinar_status']?.toString();
    authHasBought = json['auth_has_bought'] is bool ? json['auth_has_bought'] : null;
    sales = json['sales'] != null ? Sales.fromJson(json['sales']) : null;
    isFavorite = json['is_favorite'] is bool ? json['is_favorite'] : null;
    priceString = json['price_string']?.toString();
    bestTicketString = json['best_ticket_string']?.toString();
    price = json['price'];
    tax = json['tax'];
    taxWithDiscount = json['tax_with_discount'];
    bestTicketPrice = json['best_ticket_price'];
    discountPercent = json['discount_percent'] ?? 0;
    coursePageTax = _parseInt(json['course_page_tax']);
    priceWithDiscount = json['price_with_discount'];
    discountAmount = json['discount_amount'];
    activeSpecialOffer = json['active_special_offer'] != null
        ? ActiveSpecialOffer.fromJson(json['active_special_offer'])
        : null;
    duration = _parseInt(json['duration']);

    teacher =
        json['teacher'] != null ? UserModel.fromJson(json['teacher']) : null;

    studentsCount = _parseInt(json['students_count']);
    rate = json['rate']?.toString();
    rateType =
        json['rate_type'] != null ? RateType.fromJson(json['rate_type']) : null;
    createdAt = _parseInt(json['created_at']);
    startDate = _parseInt(json['start_date']);
    purchasedAt = _parseInt(json['purchased_at']);
    reviewsCount = _parseInt(json['reviews_count']);
    points = _parseInt(json['points']);
    progress = _parseInt(json['progress']) ?? 0;
    progressPercent = _parseInt(json['progress_percent']);

    category = json['category']?.runtimeType == String
        ? json['category']?.toString()
        : json['category']?['slug']?.toString();
    capacity = _parseInt(json['capacity']);
  }

  // Helper method to parse integers safely
  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    if (value is num) return value.toInt();
    return null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sales_count_number'] = salesCountNumber;
    data['image'] = image;
    data['auth'] = auth;
    if (can != null) {
      data['can'] = can!.toJson();
    }
    data['can_view_error'] = canViewError;
    data['id'] = id;
    data['status'] = status;
    data['label'] = label;
    data['title'] = title;
    data['description'] = description;
    data['type'] = type;
    data['link'] = link;
    data['access_days'] = accessDays;
    data['live_webinar_status'] = liveWebinarStatus;
    data['auth_has_bought'] = authHasBought;
    if (sales != null) {
      data['sales'] = sales!.toJson();
    }
    data['is_favorite'] = isFavorite;
    data['price_string'] = priceString;
    data['best_ticket_string'] = bestTicketString;
    data['price'] = price;
    data['tax'] = tax;
    data['tax_with_discount'] = taxWithDiscount;
    data['best_ticket_price'] = bestTicketPrice;
    data['discount_percent'] = discountPercent;
    data['course_page_tax'] = coursePageTax;
    data['price_with_discount'] = priceWithDiscount;
    data['discount_amount'] = discountAmount;
    if (activeSpecialOffer != null) {
      data['active_special_offer'] = activeSpecialOffer!.toJson();
    }
    data['duration'] = duration;
    if (teacher != null) {
      data['teacher'] = teacher!.toJson();
    }
    data['students_count'] = studentsCount;
    data['rate'] = rate;
    if (rateType != null) {
      data['rate_type'] = rateType!.toJson();
    }
    data['created_at'] = createdAt;
    data['start_date'] = startDate;
    data['purchased_at'] = purchasedAt;
    data['reviews_count'] = reviewsCount;
    data['points'] = points;
    data['progress'] = progress;
    data['progress_percent'] = progressPercent;
    data['category'] = category;
    data['capacity'] = capacity;
    return data;
  }

  String getTitle() {
    String title = '';

    for (Translations element in translations ?? []) {
      if (element.locale == locator<AppLanguage>().currentLanguage) {
        title = element.title ?? '';
      }
    }

    if (title.isEmpty) {
      for (Translations element in translations ?? []) {
        if (element.locale == 'en') {
          title = element.title ?? '';
        }
      }
    }

    return title;
  }
}

class Sales {
  int? count;
  int? amount;

  Sales({this.count, this.amount});

  Sales.fromJson(Map<String, dynamic> json) {
    count = _parseInt(json['count']);
    amount = _parseInt(json['amount']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['amount'] = amount;
    return data;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    if (value is num) return value.toInt();
    return null;
  }
}

class CustomBadges {
  int? id;
  int? productBadgeId;
  int? targetableId;
  String? targetableType;
  Badge? badge;

  CustomBadges(
      {this.id,
      this.productBadgeId,
      this.targetableId,
      this.targetableType,
      this.badge});

  CustomBadges.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    productBadgeId = _parseInt(json['product_badge_id']);
    targetableId = _parseInt(json['targetable_id']);
    targetableType = json['targetable_type']?.toString() ?? '';
    badge = json['badge'] != null ? Badge.fromJson(json['badge']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_badge_id'] = productBadgeId;
    data['targetable_id'] = targetableId;
    data['targetable_type'] = targetableType;
    if (badge != null) {
      data['badge'] = badge!.toJson();
    }
    return data;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    if (value is num) return value.toInt();
    return null;
  }
}

class Badge {
  int? id;
  String? icon;
  String? color;
  String? background;
  int? startAt;
  int? endAt;
  int? enable;
  int? createdAt;
  String? title;
  List<Translations>? translations;

  Badge(
      {this.id,
      this.icon,
      this.color,
      this.background,
      this.startAt,
      this.endAt,
      this.enable,
      this.createdAt,
      this.title,
      this.translations});

  Badge.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    icon = json['icon']?.toString();
    color = json['color']?.toString();
    background = json['background']?.toString();
    startAt = _parseInt(json['start_at']);
    endAt = _parseInt(json['end_at']);
    enable = _parseInt(json['enable']);
    createdAt = _parseInt(json['created_at']);
    title = json['title']?.toString();
    if (json['translations'] != null) {
      translations = <Translations>[];
      json['translations'].forEach((v) {
        translations!.add(Translations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['icon'] = icon;
    data['color'] = color;
    data['background'] = background;
    data['start_at'] = startAt;
    data['end_at'] = endAt;
    data['enable'] = enable;
    data['created_at'] = createdAt;
    data['title'] = title;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    if (value is num) return value.toInt();
    return null;
  }
}

class ActiveSpecialOffer {
  int? id;
  int? creatorId;
  int? webinarId;
  var bundleId;
  var subscribeId;
  int? registrationPackageId;
  String? name;
  int? percent;
  String? status;
  int? createdAt;
  int? fromDate;
  int? toDate;

  ActiveSpecialOffer(
      {this.id,
      this.creatorId,
      this.webinarId,
      this.bundleId,
      this.subscribeId,
      this.registrationPackageId,
      this.name,
      this.percent,
      this.status,
      this.createdAt,
      this.fromDate,
      this.toDate});

  ActiveSpecialOffer.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    creatorId = _parseInt(json['creator_id']);
    webinarId = _parseInt(json['webinar_id']);
    bundleId = json['bundle_id'];
    subscribeId = json['subscribe_id'];
    registrationPackageId = _parseInt(json['registration_package_id']);
    name = json['name']?.toString();
    percent = _parseInt(json['percent']);
    status = json['status']?.toString();
    createdAt = _parseInt(json['created_at']);
    fromDate = _parseInt(json['from_date']);
    toDate = _parseInt(json['to_date']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['creator_id'] = creatorId;
    data['webinar_id'] = webinarId;
    data['bundle_id'] = bundleId;
    data['subscribe_id'] = subscribeId;
    data['registration_package_id'] = registrationPackageId;
    data['name'] = name;
    data['percent'] = percent;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['from_date'] = fromDate;
    data['to_date'] = toDate;
    return data;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    if (value is num) return value.toInt();
    return null;
  }
}

class RateType {
  double? contentQuality;
  double? instructorSkills;
  double? purchaseWorth;
  double? supportQuality;

  RateType(
      {this.contentQuality,
      this.instructorSkills,
      this.purchaseWorth,
      this.supportQuality});

  RateType.fromJson(Map<String, dynamic> json) {
    contentQuality =
        double.tryParse(json['content_quality']?.toString() ?? '0');
    instructorSkills =
        double.tryParse(json['instructor_skills']?.toString() ?? '0');
    purchaseWorth = double.tryParse(json['purchase_worth']?.toString() ?? '0');
    supportQuality =
        double.tryParse(json['support_quality']?.toString() ?? '0');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content_quality'] = contentQuality;
    data['instructor_skills'] = instructorSkills;
    data['purchase_worth'] = purchaseWorth;
    data['support_quality'] = supportQuality;
    return data;
  }
}
