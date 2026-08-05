import 'course_model.dart';
import 'single_course_model.dart';
import 'user_model.dart';

class ProfileModel {
  int accessContent = 1;
  int? id;
  int? organId;
  String? fullName;
  String? roleName;
  String? bio;
  int? offline;
  String? offlineMessage;
  int? verified;
  String? rate;
  String? avatar;
  String? meetingStatus;
  UserGroup? userGroup;
  String? address;
  String? status;
  String? email;
  String? mobile;
  String? timezone;
  String? language;
  bool? newsletter;
  int? publicMessage;
  var activeSubscription;
  var headline;
  int? coursesCount;
  int? reviewsCount;
  int? appointmentsCount;
  int? studentsCount;
  int? followersCount;
  int? followingCount;
  List<Badge>? badges;
  List<UserModel>? students;
  bool? authUserIsFollower;
  List<String>? education;
  List<String>? experience;
  List<String>? occupations;
  String? about;
  List<CourseModel>? webinars;
  Meeting? meeting;
  List<UserModel>? organizationTeachers;
  int? countryId;
  int? provinceId;
  int? cityId;
  int? districtId;
  String? accountType;
  String? iban;
  String? accountId;
  String? identityScan;
  String? certificate;

  List<CashbackRules> cashbackRules = [];

  ProfileModel({
    this.id,
    this.fullName,
    this.roleName,
    this.bio,
    this.offline,
    this.offlineMessage,
    this.verified,
    this.rate,
    this.avatar,
    this.meetingStatus,
    this.userGroup,
    this.address,
    this.status,
    this.email,
    this.mobile,
    this.language,
    this.newsletter,
    this.publicMessage,
    this.activeSubscription,
    this.headline,
    this.coursesCount,
    this.reviewsCount,
    this.appointmentsCount,
    this.studentsCount,
    this.followersCount,
    this.followingCount,
    this.badges,
    this.students,
    this.authUserIsFollower,
    this.education,
    this.experience,
    this.occupations,
    this.about,
    this.webinars,
    this.meeting,
    this.organizationTeachers,
    this.countryId,
    this.provinceId,
    this.cityId,
    this.districtId,
    this.accountType,
    this.iban,
    this.accountId,
    this.identityScan,
    this.certificate,
  });

  ProfileModel.fromJson(Map<String, dynamic> json, {var cashback}) {
    // Handle cashback rules with null check
    if (cashback != null && cashback is List) {
      cashbackRules = <CashbackRules>[];
      cashback.forEach((v) {
        try {
          cashbackRules.add(CashbackRules.fromJson(v));
        } catch (e) {
          print('Error parsing cashback rule: $e');
        }
      });
    }

    accessContent = _parseInt(json['access_content']) ?? 1;
    organId = _parseInt(json['organ_id']);
    id = _parseInt(json['id']);
    fullName = _parseString(json['full_name']);
    roleName = _parseString(json['role_name']);
    bio = _parseString(json['bio']);
    offline = _parseInt(json['offline']);
    offlineMessage = _parseString(json['offline_message']);
    verified = _parseInt(json['verified']);
    rate = _parseRate(json['rate']);
    avatar = _parseString(json['avatar']);
    meetingStatus = _parseString(json['meeting_status']);

    // Handle userGroup with null and type check
    userGroup = (json['user_group'] != null &&
            json['user_group'] is Map<String, dynamic>)
        ? UserGroup.fromJson(json['user_group'])
        : null;

    address = _parseString(json['address']);
    status = _parseString(json['status']);
    email = _parseString(json['email']);
    mobile = _parseString(json['mobile']);
    language = _parseString(json['language']);
    newsletter = _parseBool(json['newsletter']);
    publicMessage = _parseInt(json['public_message']);
    activeSubscription = json['active_subscription'];
    headline = json['headline'];
    coursesCount = _parseInt(json['courses_count']);
    reviewsCount = _parseInt(json['reviews_count']);
    appointmentsCount = _parseInt(json['appointments_count']);
    studentsCount = _parseInt(json['students_count']);
    followersCount = _parseInt(json['followers_count']);
    followingCount = _parseInt(json['following_count']);

    // Handle badges list with null and type check
    if (json['badges'] != null && json['badges'] is List) {
      badges = <Badge>[];
      for (var item in json['badges']) {
        try {
          if (item is Map<String, dynamic>) {
            badges!.add(Badge.fromJson(item));
          }
        } catch (e) {
          print('Error parsing badge: $e');
        }
      }
    }

    // Handle students list with null and type check
    if (json['students'] != null && json['students'] is List) {
      students = <UserModel>[];
      for (var item in json['students']) {
        try {
          if (item is Map<String, dynamic>) {
            students!.add(UserModel.fromJson(item));
          }
        } catch (e) {
          print('Error parsing student: $e');
        }
      }
    }

    authUserIsFollower = _parseBool(json['auth_user_is_follower']);

    // Handle string lists with null checks
    education = _parseStringList(json['education']);
    experience = _parseStringList(json['experience']);
    occupations = _parseStringList(json['occupations']);

    about = _parseString(json['about']);

    // Handle webinars list with null and type check
    if (json['webinars'] != null && json['webinars'] is List) {
      webinars = <CourseModel>[];
      for (var item in json['webinars']) {
        try {
          if (item is Map<String, dynamic>) {
            webinars!.add(CourseModel.fromJson(item));
          }
        } catch (e) {
          print('Error parsing webinar: $e');
        }
      }
    }

    // Handle meeting with null and type check
    meeting =
        (json['meeting'] != null && json['meeting'] is Map<String, dynamic>)
            ? Meeting.fromJson(json['meeting'])
            : null;

    // Handle organization teachers list with null and type check
    if (json['organization_teachers'] != null &&
        json['organization_teachers'] is List) {
      organizationTeachers = <UserModel>[];
      for (var item in json['organization_teachers']) {
        try {
          if (item is Map<String, dynamic>) {
            organizationTeachers!.add(UserModel.fromJson(item));
          }
        } catch (e) {
          print('Error parsing organization teacher: $e');
        }
      }
    }

    countryId = _parseInt(json['country_id']);
    provinceId = _parseInt(json['province_id']);
    cityId = _parseInt(json['city_id']);
    districtId = _parseInt(json['district_id']);
    accountType = _parseString(json['account_type']);
    iban = _parseString(json['iban']);
    accountId = _parseString(json['account_id']);
    identityScan = _parseString(json['identity_scan']);
    certificate = _parseString(json['certificate']);
    timezone = _parseString(json['timezone']);
  }

  // Helper methods for safe parsing
  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }

  String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value.isEmpty ? null : value;
    return value.toString();
  }

  String? _parseRate(dynamic value) {
    if (value == null) return null;
    if (value is String) return value.isEmpty ? '0' : value;
    if (value is int || value is double) return value.toString();
    return '0';
  }

  bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return null;
  }

  List<String>? _parseStringList(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      try {
        return value.cast<String>();
      } catch (e) {
        print('Error casting string list: $e');
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['role_name'] = roleName;
    data['bio'] = bio;
    data['offline'] = offline;
    data['offline_message'] = offlineMessage;
    data['verified'] = verified;
    data['rate'] = rate;
    data['avatar'] = avatar;
    data['meeting_status'] = meetingStatus;
    if (userGroup != null) {
      data['user_group'] = userGroup!.toJson();
    }
    data['address'] = address;
    data['status'] = status;
    data['email'] = email;
    data['mobile'] = mobile;
    data['language'] = language;
    data['newsletter'] = newsletter;
    data['public_message'] = publicMessage;
    data['active_subscription'] = activeSubscription;
    data['headline'] = headline;
    data['courses_count'] = coursesCount;
    data['reviews_count'] = reviewsCount;
    data['appointments_count'] = appointmentsCount;
    data['students_count'] = studentsCount;
    data['followers_count'] = followersCount;
    data['following_count'] = followingCount;
    if (badges != null) {
      data['badges'] = badges!.map((v) => v.toJson()).toList();
    }
    if (students != null) {
      data['students'] = students!.map((v) => v.toJson()).toList();
    }
    data['auth_user_is_follower'] = authUserIsFollower;
    data['education'] = education;
    data['experience'] = experience;
    data['occupations'] = occupations;
    data['about'] = about;
    if (webinars != null) {
      data['webinars'] = webinars!.map((v) => v.toJson()).toList();
    }
    if (meeting != null) {
      data['meeting'] = meeting!.toJson();
    }
    if (organizationTeachers != null) {
      data['organization_teachers'] =
          organizationTeachers!.map((v) => v.toJson()).toList();
    }
    data['country_id'] = countryId;
    data['province_id'] = provinceId;
    data['city_id'] = cityId;
    data['district_id'] = districtId;
    data['account_type'] = accountType;
    data['iban'] = iban;
    data['account_id'] = accountId;
    data['identity_scan'] = identityScan;
    data['certificate'] = certificate;
    return data;
  }
}

class Badge {
  int? id;
  String? title;
  String? type;
  String? condition;
  String? image;
  String? locale;
  String? description;
  int? createdAt;

  Badge(
      {this.id,
      this.title,
      this.type,
      this.condition,
      this.image,
      this.locale,
      this.description,
      this.createdAt});

  Badge.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    condition = json['condition'];
    image = json['image'];
    locale = json['locale'];
    description = json['description'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['condition'] = condition;
    data['image'] = image;
    data['locale'] = locale;
    data['description'] = description;
    data['created_at'] = createdAt;
    return data;
  }
}

class Sales {
  int? count;
  int? amount;

  Sales({this.count, this.amount});

  Sales.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['amount'] = amount;
    return data;
  }
}

class Meeting {
  String? timeZone;
  String? gmt;
  int? id;
  int? disabled;
  int? discount;
  int? price;
  int? priceWithDiscount;
  int? inPerson;
  int? inPersonPrice;
  int? inPersonPriceWithDiscount;
  int? inPersonGroupMinStudent;
  int? inPersonGroupMaxStudent;
  int? inPersonGroupAmount;
  int? groupMeeting;
  int? onlineGroupMinStudent;
  int? onlineGroupMaxStudent;
  int? onlineGroupAmount;
  List<DayModel>? timing;
  TimingGroupByDay? timingGroupByDay;

  // Time? time;
  // UserModel? user;
  // String? date;
  // String? link;
  // String? day;
  // String? description;
  // int? studentCount;

  Meeting(
      {this.timeZone,
      this.gmt,
      this.id,
      this.disabled,
      this.discount,
      this.price,
      this.priceWithDiscount,
      this.inPerson,
      this.inPersonPrice,
      this.inPersonPriceWithDiscount,
      this.inPersonGroupMinStudent,
      this.inPersonGroupMaxStudent,
      this.inPersonGroupAmount,
      this.groupMeeting,
      this.onlineGroupMinStudent,
      this.onlineGroupMaxStudent,
      this.onlineGroupAmount,
      this.timing,
      this.timingGroupByDay});

  Meeting.fromJson(Map<String, dynamic> json) {
    timeZone = json['time_zone'];
    gmt = json['gmt'];
    // date = json['date'];
    // link = json['link'];
    // day = json['day'];
    // studentCount = json['student_count'];
    // description = json['description'];

    id = json['id'];
    disabled = json['disabled'];
    discount = json['discount']?.toInt();
    price = json['price']?.toInt();
    priceWithDiscount = json['price_with_discount']?.toInt();
    inPerson = json['in_person']?.toInt();
    inPersonPrice = json['in_person_price']?.toInt();
    inPersonPriceWithDiscount = json['in_person_price_with_discount']?.toInt();
    inPersonGroupMinStudent = json['in_person_group_min_student']?.toInt();
    inPersonGroupMaxStudent = json['in_person_group_max_student']?.toInt();
    inPersonGroupAmount = json['in_person_group_amount ']?.toInt();
    groupMeeting = json['group_meeting'];
    onlineGroupMinStudent = json['online_group_min_student'];
    onlineGroupMaxStudent = json['online_group_max_student'];
    onlineGroupAmount = json['online_group_amount']?.toInt();
    if (json['timing'] != null) {
      timing = <DayModel>[];
      json['timing'].forEach((v) {
        timing!.add(DayModel.fromJson(v));
      });
    }

    // time = json['time'] != null ? Time.fromJson(json['time']) : null;
    // user = json['user'] != null ? UserModel.fromJson(json['user']) : null;

    timingGroupByDay = json['timing_group_by_day'] != null
        ? TimingGroupByDay.fromJson(json['timing_group_by_day'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    // if (time != null) {
    //   data['time'] = time!.toJson();
    // }

    // if (user != null) {
    //   data['user'] = user!.toJson();
    // }

    data['time_zone'] = timeZone;
    data['gmt'] = gmt;
    data['id'] = id;
    data['disabled'] = disabled;
    data['discount'] = discount;
    data['price'] = price;
    data['price_with_discount'] = priceWithDiscount;
    data['in_person'] = inPerson;
    data['in_person_price'] = inPersonPrice;
    data['in_person_price_with_discount'] = inPersonPriceWithDiscount;
    data['in_person_group_min_student'] = inPersonGroupMinStudent;
    data['in_person_group_max_student'] = inPersonGroupMaxStudent;
    data['in_person_group_amount '] = inPersonGroupAmount;
    data['group_meeting'] = groupMeeting;
    data['online_group_min_student'] = onlineGroupMinStudent;
    data['online_group_max_student'] = onlineGroupMaxStudent;
    data['online_group_amount'] = onlineGroupAmount;
    if (timing != null) {
      data['timing'] = timing!.map((v) => v.toJson()).toList();
    }
    if (timingGroupByDay != null) {
      data['timing_group_by_day'] = timingGroupByDay!.toJson();
    }
    return data;
  }
}

class TimingGroupByDay {
  List<DayModel>? saturday;
  List<DayModel>? sunday;
  List<DayModel>? monday;
  List<DayModel>? tuesday;
  List<DayModel>? wednesday;
  List<DayModel>? thursday;
  List<DayModel>? friday;

  TimingGroupByDay(
      {this.saturday,
      this.sunday,
      this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday});

  TimingGroupByDay.fromJson(Map<String, dynamic> json) {
    if (json['saturday'] != null) {
      saturday = <DayModel>[];
      json['saturday'].forEach((v) {
        saturday!.add(DayModel.fromJson(v));
      });
    }
    if (json['sunday'] != null) {
      sunday = <DayModel>[];
      json['sunday'].forEach((v) {
        sunday!.add(DayModel.fromJson(v));
      });
    }
    if (json['monday'] != null) {
      monday = <DayModel>[];
      json['monday'].forEach((v) {
        monday!.add(DayModel.fromJson(v));
      });
    }
    if (json['tuesday'] != null) {
      tuesday = <DayModel>[];
      json['tuesday'].forEach((v) {
        tuesday!.add(DayModel.fromJson(v));
      });
    }
    if (json['wednesday'] != null) {
      wednesday = <DayModel>[];
      json['wednesday'].forEach((v) {
        wednesday!.add(DayModel.fromJson(v));
      });
    }
    if (json['thursday'] != null) {
      thursday = <DayModel>[];
      json['thursday'].forEach((v) {
        thursday!.add(DayModel.fromJson(v));
      });
    }
    if (json['friday'] != null) {
      friday = <DayModel>[];
      json['friday'].forEach((v) {
        friday!.add(DayModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (saturday != null) {
      data['saturday'] = saturday!.map((v) => v.toJson()).toList();
    }
    if (sunday != null) {
      data['sunday'] = sunday!.map((v) => v.toJson()).toList();
    }
    if (monday != null) {
      data['monday'] = monday!.map((v) => v.toJson()).toList();
    }
    if (tuesday != null) {
      data['tuesday'] = tuesday!.map((v) => v.toJson()).toList();
    }
    if (wednesday != null) {
      data['wednesday'] = wednesday!.map((v) => v.toJson()).toList();
    }
    if (thursday != null) {
      data['thursday'] = thursday!.map((v) => v.toJson()).toList();
    }
    if (friday != null) {
      data['friday'] = friday!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DayModel {
  int? id;
  String? dayLabel;
  String? time;

  DayModel({this.id, this.dayLabel, this.time});

  DayModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dayLabel = json['day_label'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['day_label'] = dayLabel;
    data['time'] = time;
    return data;
  }
}

class Time {
  String? start;
  String? end;

  Time({this.start, this.end});

  Time.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start'] = start;
    data['end'] = end;
    return data;
  }
}
