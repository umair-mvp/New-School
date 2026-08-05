class SaasPackageModel {
  List<Packages>? packages;
  ActivePackage? activePackage;
  String? authRole;
  String? accountCoursesCount;
  String? accountMeetingCount;
  String? accountCoursesCapacity;
  String? accountInstructorsCount;
  String? accountStudentsCount;
  AccountStatistics? accountStatistics;

  SaasPackageModel({
    this.packages,
    this.activePackage,
    this.authRole,
    this.accountCoursesCount,
    this.accountMeetingCount,
    this.accountCoursesCapacity,
    this.accountInstructorsCount,
    this.accountStudentsCount,
    this.accountStatistics,
  });

  SaasPackageModel.fromJson(Map<String, dynamic> json) {
    if (json['packages'] != null) {
      packages = <Packages>[];
      json['packages'].forEach((v) {
        packages!.add(Packages.fromJson(v));
      });
    }
    activePackage = json['active_package'] != null
        ? ActivePackage.fromJson(json['active_package'])
        : null;

    authRole = json['auth_role']?.toString();
    accountCoursesCount = json['account_courses_count']?.toString();
    accountMeetingCount = json['account_meeting_count']?.toString();
    accountCoursesCapacity = json['account_courses_capacity']?.toString();
    accountInstructorsCount = json['account_instructors_count']?.toString();
    accountStudentsCount = json['account_students_count']?.toString();

    accountStatistics = json['account_statistics'] != null
        ? AccountStatistics.fromJson(json['account_statistics'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (packages != null) {
      data['packages'] = packages!.map((v) => v.toJson()).toList();
    }
    if (activePackage != null) {
      data['active_package'] = activePackage!.toJson();
    }
    data['auth_role'] = authRole;
    data['account_courses_count'] = accountCoursesCount;
    data['account_meeting_count'] = accountMeetingCount;
    data['account_courses_capacity'] = accountCoursesCapacity;
    data['account_instructors_count'] = accountInstructorsCount;
    data['account_students_count'] = accountStudentsCount;
    if (accountStatistics != null) {
      data['account_statistics'] = accountStatistics!.toJson();
    }
    return data;
  }
}

class Packages {
  int? id;
  int? days;
  int? price;
  String? icon;
  String? role;
  String? instructorsCount;
  String? studentsCount;
  String? coursesCapacity;
  String? coursesCount;
  String? meetingCount;
  String? status;
  int? createdAt;
  String? title;
  String? description;
  bool? isActive;

  Packages({
    this.id,
    this.days,
    this.price,
    this.icon,
    this.role,
    this.instructorsCount,
    this.studentsCount,
    this.coursesCapacity,
    this.coursesCount,
    this.meetingCount,
    this.status,
    this.createdAt,
    this.title,
    this.description,
    this.isActive,
  });

  Packages.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    days = _parseInt(json['days']);
    price = _parseInt(json['price']);
    icon = json['icon']?.toString();
    role = json['role']?.toString();
    instructorsCount = json['instructors_count']?.toString();
    studentsCount = json['students_count']?.toString();
    coursesCapacity = json['courses_capacity']?.toString();
    coursesCount = json['courses_count']?.toString();
    meetingCount = json['meeting_count']?.toString();
    status = json['status']?.toString();
    createdAt = _parseInt(json['created_at']);
    title = json['title']?.toString();
    description = json['description']?.toString();
    isActive = json['is_active'] is bool ? json['is_active'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['days'] = days;
    data['price'] = price;
    data['icon'] = icon;
    data['role'] = role;
    data['instructors_count'] = instructorsCount;
    data['students_count'] = studentsCount;
    data['courses_capacity'] = coursesCapacity;
    data['courses_count'] = coursesCount;
    data['meeting_count'] = meetingCount;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['title'] = title;
    data['description'] = description;
    data['is_active'] = isActive;
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

class ActivePackage {
  int? packageId;
  String? instructorsCount;
  String? studentsCount;
  String? meetingCount;
  String? coursesCapacity;
  String? coursesCount;
  String? title;
  int? activationDate;
  String? daysRemained;

  ActivePackage({
    this.packageId,
    this.instructorsCount,
    this.studentsCount,
    this.meetingCount,
    this.coursesCapacity,
    this.coursesCount,
    this.title,
    this.activationDate,
    this.daysRemained,
  });

  ActivePackage.fromJson(Map<String, dynamic> json) {
    packageId = _parseInt(json['package_id']);
    instructorsCount = json['instructors_count']?.toString();
    studentsCount = json['students_count']?.toString();
    meetingCount = json['meeting_count']?.toString();
    coursesCapacity = json['courses_capacity']?.toString();
    coursesCount = json['courses_count']?.toString();
    title = json['title']?.toString();
    activationDate = _parseInt(json['activation_date']);
    daysRemained = json['days_remained']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['package_id'] = packageId;
    data['instructors_count'] = instructorsCount;
    data['students_count'] = studentsCount;
    data['meeting_count'] = meetingCount;
    data['courses_capacity'] = coursesCapacity;
    data['courses_count'] = coursesCount;
    data['title'] = title;
    data['activation_date'] = activationDate;
    data['days_remained'] = daysRemained;
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

class AccountStatistics {
  int? myInstructorsCount;
  int? myStudentsCount;
  int? myCoursesCount;
  int? myMeetingCount;
  int? myProductCount;

  AccountStatistics({
    this.myInstructorsCount,
    this.myStudentsCount,
    this.myCoursesCount,
    this.myMeetingCount,
    this.myProductCount,
  });

  AccountStatistics.fromJson(Map<String, dynamic> json) {
    myInstructorsCount = _parseInt(json['myInstructorsCount']);
    myStudentsCount = _parseInt(json['myStudentsCount']);
    myCoursesCount = _parseInt(json['myCoursesCount']);
    myMeetingCount = _parseInt(json['myMeetingCount']);
    myProductCount = _parseInt(json['myProductCount']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['myInstructorsCount'] = myInstructorsCount;
    data['myStudentsCount'] = myStudentsCount;
    data['myCoursesCount'] = myCoursesCount;
    data['myMeetingCount'] = myMeetingCount;
    data['myProductCount'] = myProductCount;
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