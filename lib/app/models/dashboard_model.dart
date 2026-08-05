class DashboardModel {
  int? offline;
  int? spentPoints;
  int? totalPoints;
  int? availablePoints;
  String? roleName;
  String? fullName;
  int? financialApproval;
  UnreadNotifications? unreadNotifications;
  List<UnreadNoticeboards>? unreadNoticeboards;
  double? balance;
  bool? canDrawable;
  Badges? badges;
  int? countCartItems;
  int? pendingAppointments;
  int? monthlySalesCount;
  MonthlyChart? monthlyChart;
  int? webinarsCount;
  int? reserveMeetingsCount;
  int? supportsCount;
  int? commentsCount;

  DashboardModel({
    this.offline,
    this.spentPoints,
    this.totalPoints,
    this.availablePoints,
    this.roleName,
    this.fullName,
    this.financialApproval,
    this.unreadNotifications,
    this.unreadNoticeboards,
    this.balance,
    this.canDrawable,
    this.badges,
    this.countCartItems,
    this.pendingAppointments,
    this.monthlySalesCount,
    this.monthlyChart,
    this.webinarsCount,
    this.reserveMeetingsCount,
    this.supportsCount,
    this.commentsCount,
  });

  DashboardModel.fromJson(Map<String, dynamic> json) {
    offline = _parseInt(json['offline']);
    spentPoints = _parseInt(json['spent_points']);
    totalPoints = _parseInt(json['total_points']);
    availablePoints = _parseInt(json['available_points']);
    roleName = json['role_name']?.toString();
    fullName = json['full_name']?.toString();
    financialApproval = _parseInt(json['financial_approval']);

    unreadNotifications = json['unread_notifications'] != null &&
            json['unread_notifications'] is Map
        ? UnreadNotifications.fromJson(json['unread_notifications'])
        : null;

    if (json['unread_noticeboards'] != null &&
        json['unread_noticeboards'] is List) {
      unreadNoticeboards = <UnreadNoticeboards>[];
      json['unread_noticeboards'].forEach((v) {
        if (v != null) {
          unreadNoticeboards!.add(UnreadNoticeboards.fromJson(v));
        }
      });
    } else {
      unreadNoticeboards = null;
    }

    // Safe balance parsing with null check and default value
    final balanceValue = json['balance']?.toString();
    balance = balanceValue != null ? double.tryParse(balanceValue) ?? 0.0 : 0.0;

    canDrawable = json['can_drawable'] is bool ? json['can_drawable'] : false;
    badges = json['badges'] != null && json['badges'] is Map
        ? Badges.fromJson(json['badges'])
        : null;

    countCartItems = _parseInt(json['count_cart_items']);
    pendingAppointments = _parseInt(json['pendingAppointments']);
    monthlySalesCount = _parseInt(json['monthlySalesCount']);

    monthlyChart = json['monthlyChart'] != null && json['monthlyChart'] is Map
        ? MonthlyChart.fromJson(json['monthlyChart'])
        : null;

    webinarsCount = _parseInt(json['webinarsCount']);
    reserveMeetingsCount = _parseInt(json['reserveMeetingsCount']);
    supportsCount = _parseInt(json['supportsCount']);
    commentsCount = _parseInt(json['commentsCount']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offline'] = offline;
    data['spent_points'] = spentPoints;
    data['total_points'] = totalPoints;
    data['available_points'] = availablePoints;
    data['role_name'] = roleName;
    data['full_name'] = fullName;
    data['financial_approval'] = financialApproval;

    if (unreadNotifications != null) {
      data['unread_notifications'] = unreadNotifications!.toJson();
    } else {
      data['unread_notifications'] = null;
    }

    if (unreadNoticeboards != null) {
      data['unread_noticeboards'] =
          unreadNoticeboards!.map((v) => v.toJson()).toList();
    } else {
      data['unread_noticeboards'] = null;
    }

    data['balance'] = balance;
    data['can_drawable'] = canDrawable;

    if (badges != null) {
      data['badges'] = badges!.toJson();
    } else {
      data['badges'] = null;
    }

    data['count_cart_items'] = countCartItems;
    data['pendingAppointments'] = pendingAppointments;
    data['monthlySalesCount'] = monthlySalesCount;

    if (monthlyChart != null) {
      data['monthlyChart'] = monthlyChart!.toJson();
    } else {
      data['monthlyChart'] = null;
    }

    data['webinarsCount'] = webinarsCount;
    data['reserveMeetingsCount'] = reserveMeetingsCount;
    data['supportsCount'] = supportsCount;
    data['commentsCount'] = commentsCount;
    return data;
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
}

class UnreadNotifications {
  int? count;
  List<Notifications>? notifications;

  UnreadNotifications({this.count, this.notifications});

  UnreadNotifications.fromJson(Map<String, dynamic> json) {
    count = _parseInt(json['count']);
    if (json['notifications'] != null && json['notifications'] is List) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        if (v != null) {
          notifications!.add(Notifications.fromJson(v));
        }
      });
    } else {
      notifications = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (notifications != null) {
      data['notifications'] = notifications!.map((v) => v.toJson()).toList();
    } else {
      data['notifications'] = null;
    }
    return data;
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
}

class Notifications {
  int? id;
  int? userId;
  int? senderId;
  int? groupId;
  int? webinarId;
  String? title;
  String? message;
  String? sender;
  String? type;
  int? createdAt;

  Notifications({
    this.id,
    this.userId,
    this.senderId,
    this.groupId,
    this.webinarId,
    this.title,
    this.message,
    this.sender,
    this.type,
    this.createdAt,
  });

  Notifications.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    userId = _parseInt(json['user_id']);
    senderId = _parseInt(json['sender_id']);
    groupId = _parseInt(json['group_id']);
    webinarId = _parseInt(json['webinar_id']);
    title = json['title']?.toString();
    message = json['message']?.toString();
    sender = json['sender']?.toString();
    type = json['type']?.toString();
    createdAt = _parseInt(json['created_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['sender_id'] = senderId;
    data['group_id'] = groupId;
    data['webinar_id'] = webinarId;
    data['title'] = title;
    data['message'] = message;
    data['sender'] = sender;
    data['type'] = type;
    data['created_at'] = createdAt;
    return data;
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
}

class UnreadNoticeboards {
  int? id;
  int? organId;
  int? instructorId;
  int? webinarId;
  int? userId;
  String? type;
  String? sender;
  String? title;
  String? message;
  int? createdAt;

  UnreadNoticeboards({
    this.id,
    this.organId,
    this.instructorId,
    this.webinarId,
    this.userId,
    this.type,
    this.sender,
    this.title,
    this.message,
    this.createdAt,
  });

  UnreadNoticeboards.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    organId = _parseInt(json['organ_id']);
    instructorId = _parseInt(json['instructor_id']);
    webinarId = _parseInt(json['webinar_id']);
    userId = _parseInt(json['user_id']);
    type = json['type']?.toString();
    sender = json['sender']?.toString();
    title = json['title']?.toString();
    message = json['message']?.toString();
    createdAt = _parseInt(json['created_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['organ_id'] = organId;
    data['instructor_id'] = instructorId;
    data['webinar_id'] = webinarId;
    data['user_id'] = userId;
    data['type'] = type;
    data['sender'] = sender;
    data['title'] = title;
    data['message'] = message;
    data['created_at'] = createdAt;
    return data;
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
}

class Badges {
  String? nextBadge;
  dynamic percent;
  String? earned;

  Badges({this.nextBadge, this.percent, this.earned});

  Badges.fromJson(Map<String, dynamic> json) {
    nextBadge = json['next_badge']?.toString();
    percent = json['percent'];
    earned = json['earned']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['next_badge'] = nextBadge;
    data['percent'] = percent;
    data['earned'] = earned;
    return data;
  }
}

class MonthlyChart {
  List<String>? months;
  List<int>? data;

  MonthlyChart({this.months, this.data});

  MonthlyChart.fromJson(Map<String, dynamic> json) {
    if (json['months'] != null && json['months'] is List) {
      months = (json['months'] as List).cast<String>();
    } else {
      months = null;
    }

    if (json['data'] != null && json['data'] is List) {
      data = (json['data'] as List)
          .map((item) => _parseInt(item) ?? 0)
          .toList()
          .cast<int>();
    } else {
      data = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['months'] = months;
    data['data'] = this.data;
    return data;
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
}