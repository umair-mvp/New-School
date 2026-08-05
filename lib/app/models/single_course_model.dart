import 'blog_model.dart';
import 'can_model.dart';
import 'user_model.dart';

import 'course_model.dart';

class SingleCourseModel {
  int? forum;
  int? isPrivate;

  String? image;
  bool? auth;
  Can? can;
  var canViewError;
  int? id;
  String? status;
  String? label;
  String? title;
  String? type;
  String? link;
  int? accessDays;
  int? salesCountNumber;
  String? liveWebinarStatus;
  bool? authHasBought;
  Sales? sales;
  bool? isFavorite;
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
  int? duration;
  UserModel? teacher;
  int? studentsCount;
  String? rate;
  RateType? rateType;
  int? createdAt;
  int? startDate;
  int? purchasedAt;
  int? reviewsCount;
  ActiveSpecialOffer? activeSpecialOffer;
  int? points;
  var progress;
  var progressPercent;
  String? category;
  int? capacity;
  bool? support;
  bool? subscribe;
  String? description;
  List<Faqs>? faqs;
  List<Comments> comments = [];

  List<BuyTicketsModel> tickets = [];
  List<CertificateModel> certificates = [];
  List<QuizzesModel> quizzes = [];
  List<PrerequisitesModel> prerequisites = [];

  List<SessionChapters> sessionChapters = [];
  List<TextLessonChapters> textLessonChapters = [];
  List<FilesChapters> filesChapters = [];
  List<ReviewModel>? reviews;

  int? filesCount;
  int? sessionsCount;
  int? textLessonsCount;
  int? quizzesCount;

  String? videoDemo;
  String? videoDemoSource;
  String? imageCover;
  bool? isDownloadable;
  bool? teacherIsOffline;
  List<Tags>? tags;
  bool? authHasSubscription;
  var canAddToCart;
  bool? canBuyWithPoints;

  List<CashbackRules> cashbackRules = [];

  SingleCourseModel(
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
      this.capacity,
      this.support,
      this.subscribe,
      this.description,
      this.faqs,
      this.sessionsCount,
      this.filesCount,
      this.textLessonsCount,
      this.quizzesCount,
      this.reviews,
      this.videoDemo,
      this.videoDemoSource,
      this.imageCover,
      this.isDownloadable,
      this.teacherIsOffline,
      this.tags,
      this.authHasSubscription,
      this.canAddToCart,
      this.canBuyWithPoints});

  SingleCourseModel.fromJson(Map<String, dynamic> json) {
    if (_isList(json['cashbackRules'])) {
      cashbackRules = <CashbackRules>[];
      json['cashbackRules'].forEach((v) {
        if (v != null) {
          cashbackRules.add(CashbackRules.fromJson(v));
        }
      });
    } else {
      cashbackRules = [];
    }

    salesCountNumber = _parseInt(json['sales_count_number']) ?? 0;
    isPrivate = _parseInt(json['isPrivate']);
    forum = _parseInt(json['forum']);

    image = _parseString(json['image']);
    auth = _parseBool(json['auth']);
    can = _isMap(json['can']) ? Can.fromJson(json['can']) : null;
    canViewError = json['can_view_error'];
    id = _parseInt(json['id']);
    status = _parseString(json['status']);
    label = _parseString(json['label']);
    title = _parseString(json['title']);
    type = _parseString(json['type']);
    link = _parseString(json['link']);
    accessDays = _parseInt(json['access_days']);
    liveWebinarStatus = _parseString(json['live_webinar_status']);
    authHasBought = _parseBool(json['auth_has_bought']);
    sales = _isMap(json['sales']) ? Sales.fromJson(json['sales']) : null;
    isFavorite = _parseBool(json['is_favorite']);
    priceString = _parseString(json['price_string']);
    bestTicketString = _parseString(json['best_ticket_string']);
    price = json['price'];
    tax = json['tax'];
    taxWithDiscount = json['tax_with_discount'];
    bestTicketPrice = json['best_ticket_price'];
    discountPercent = json['discount_percent'];
    coursePageTax = _parseInt(json['course_page_tax']);
    priceWithDiscount = json['price_with_discount'];
    discountAmount = json['discount_amount'];

    activeSpecialOffer = _isMap(json['active_special_offer'])
        ? ActiveSpecialOffer.fromJson(json['active_special_offer'])
        : null;

    duration = _parseInt(json['duration']) ?? 0;
    teacher =
        _isMap(json['teacher']) ? UserModel.fromJson(json['teacher']) : null;
    studentsCount = _parseInt(json['students_count']);
    rate = _parseString(json['rate']);
    rateType =
        _isMap(json['rate_type']) ? RateType.fromJson(json['rate_type']) : null;
    createdAt = _parseInt(json['created_at']);
    startDate = _parseInt(json['start_date']);
    purchasedAt = _parseInt(json['purchased_at']);
    reviewsCount = _parseInt(json['reviews_count']);
    points = _parseInt(json['points']);
    progress = json['progress'];
    progressPercent = json['progress_percent'];
    category = _parseString(json['category']);
    capacity = _parseInt(json['capacity']);
    support = _parseBool(json['support']) ?? false;
    subscribe = _parseBool(json['subscribe']) ?? false;
    description = _parseString(json['description']);

    if (_isList(json['faqs'])) {
      faqs = <Faqs>[];
      json['faqs'].forEach((v) {
        if (v != null) {
          faqs!.add(Faqs.fromJson(v));
        }
      });
    } else {
      faqs = null;
    }

    if (_isList(json['comments'])) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        if (v != null) {
          comments.add(Comments.fromJson(v));
        }
      });
    } else {
      comments = [];
    }

    sessionsCount = _parseInt(json['sessions_count']);
    if (_isList(json['session_chapters'])) {
      sessionChapters = <SessionChapters>[];
      json['session_chapters'].forEach((v) {
        if (v != null) {
          sessionChapters.add(SessionChapters.fromJson(v));
        }
      });
    } else {
      sessionChapters = [];
    }

    if (_isList(json['files_chapters'])) {
      filesChapters = <FilesChapters>[];
      json['files_chapters'].forEach((v) {
        if (v != null) {
          filesChapters.add(FilesChapters.fromJson(v));
        }
      });
    } else {
      filesChapters = [];
    }

    if (_isList(json['text_lesson_chapters'])) {
      textLessonChapters = <TextLessonChapters>[];
      json['text_lesson_chapters'].forEach((v) {
        if (v != null) {
          textLessonChapters.add(TextLessonChapters.fromJson(v));
        }
      });
    } else {
      textLessonChapters = [];
    }

    filesCount = _parseInt(json['files_count']);
    textLessonsCount = _parseInt(json['text_lessons_count']);
    quizzesCount = _parseInt(json['quizzes_count']);

    if (_isList(json['reviews'])) {
      reviews = <ReviewModel>[];
      json['reviews'].forEach((v) {
        if (v != null) {
          reviews!.add(ReviewModel.fromJson(v));
        }
      });
    } else {
      reviews = null;
    }

    if (_isList(json['tickets'])) {
      tickets = <BuyTicketsModel>[];
      json['tickets'].forEach((v) {
        if (v != null) {
          tickets.add(BuyTicketsModel.fromJson(v));
        }
      });
    } else {
      tickets = [];
    }

    if (_isList(json['certificate'])) {
      certificates = <CertificateModel>[];
      json['certificate'].forEach((v) {
        if (v != null) {
          certificates.add(CertificateModel.fromJson(v));
        }
      });
    } else {
      certificates = [];
    }

    if (_isList(json['quizzes'])) {
      quizzes = <QuizzesModel>[];
      json['quizzes'].forEach((v) {
        if (v != null) {
          quizzes.add(QuizzesModel.fromJson(v));
        }
      });
    } else {
      quizzes = [];
    }

    if (_isList(json['prerequisites'])) {
      prerequisites = <PrerequisitesModel>[];
      json['prerequisites'].forEach((v) {
        if (v != null) {
          prerequisites.add(PrerequisitesModel.fromJson(v));
        }
      });
    } else {
      prerequisites = [];
    }

    videoDemo = _parseString(json['video_demo']);
    videoDemoSource = _parseString(json['video_demo_source']);
    imageCover = _parseString(json['image_cover']);
    isDownloadable = _parseBool(json['isDownloadable']) ?? false;
    teacherIsOffline = _parseBool(json['teacher_is_offline']) ?? false;

    if (_isList(json['tags'])) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        if (v != null) {
          tags!.add(Tags.fromJson(v));
        }
      });
    } else {
      tags = null;
    }

    authHasSubscription = _parseBool(json['auth_has_subscription']) ?? false;
    canAddToCart = json['can_add_to_cart'];
    canBuyWithPoints = _parseBool(json['can_buy_with_points']) ?? false;
  }

  // Helper methods for safe parsing
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    if (value is bool) return value ? 1 : 0;
    return null;
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return null;
  }

  static bool _isMap(dynamic value) {
    return value != null && value is Map;
  }

  static bool _isList(dynamic value) {
    return value != null && value is List;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['cashbackRules'] = cashbackRules.map((v) => v.toJson()).toList();

    data['sales_count_number'] = salesCountNumber;
    data['image'] = image;
    data['auth'] = auth;
    if (can != null) {
      data['can'] = can!.toJson();
    } else {
      data['can'] = null;
    }
    data['can_view_error'] = canViewError;
    data['id'] = id;
    data['status'] = status;
    data['label'] = label;
    data['title'] = title;
    data['type'] = type;
    data['link'] = link;
    data['access_days'] = accessDays;
    data['live_webinar_status'] = liveWebinarStatus;
    data['auth_has_bought'] = authHasBought;
    if (sales != null) {
      data['sales'] = sales!.toJson();
    } else {
      data['sales'] = null;
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
    } else {
      data['active_special_offer'] = null;
    }
    data['duration'] = duration;
    if (teacher != null) {
      data['teacher'] = teacher!.toJson();
    } else {
      data['teacher'] = null;
    }
    data['students_count'] = studentsCount;
    data['rate'] = rate;
    if (rateType != null) {
      data['rate_type'] = rateType!.toJson();
    } else {
      data['rate_type'] = null;
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
    data['support'] = support;
    data['subscribe'] = subscribe;
    data['description'] = description;
    if (faqs != null) {
      data['faqs'] = faqs!.map((v) => v.toJson()).toList();
    } else {
      data['faqs'] = null;
    }

    data['comments'] = comments.map((v) => v.toJson()).toList();

    data['sessions_count'] = sessionsCount;
    data['files_chapters'] = filesChapters.map((v) => v.toJson()).toList();
    data['quizzes'] = quizzes.map((v) => v.toJson()).toList();
    data['certificate'] = certificates.map((v) => v.toJson()).toList();
    data['tickets'] = tickets.map((v) => v.toJson()).toList();
    data['prerequisites'] = prerequisites.map((v) => v.toJson()).toList();
    data['session_chapters'] = sessionChapters.map((v) => v.toJson()).toList();

    data['files_count'] = filesCount;
    data['text_lessons_count'] = textLessonsCount;
    data['quizzes_count'] = quizzesCount;
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    } else {
      data['reviews'] = null;
    }
    data['video_demo'] = videoDemo;
    data['video_demo_source'] = videoDemoSource;
    data['image_cover'] = imageCover;
    data['isDownloadable'] = isDownloadable;
    data['teacher_is_offline'] = teacherIsOffline;
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    } else {
      data['tags'] = null;
    }
    data['auth_has_subscription'] = authHasSubscription;
    data['can_add_to_cart'] = canAddToCart;
    data['can_buy_with_points'] = canBuyWithPoints;
    return data;
  }
}

class BuyTicketsModel {
  int? id;
  String? title;
  String? subTitle;
  var discount;
  var priceWithTicketDiscount;
  bool? isValid;

  BuyTicketsModel(
      {this.id,
      this.title,
      this.subTitle,
      this.discount,
      this.priceWithTicketDiscount,
      this.isValid});

  BuyTicketsModel.fromJson(Map<String, dynamic> json) {
    id = SingleCourseModel._parseInt(json['id']);
    title = SingleCourseModel._parseString(json['title']);
    subTitle = SingleCourseModel._parseString(json['sub_title']);
    discount = json['discount'];
    priceWithTicketDiscount = json['price_with_ticket_discount'];
    isValid = SingleCourseModel._parseBool(json['is_valid']) ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['sub_title'] = subTitle;
    data['discount'] = discount;
    data['price_with_ticket_discount'] = priceWithTicketDiscount;
    data['is_valid'] = isValid;
    return data;
  }
}

class ActiveSpecialOffer {
  int? id;
  int? creatorId;
  int? webinarId;
  int? bundleId;
  int? subscribeId;
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
    id = SingleCourseModel._parseInt(json['id']);
    creatorId = SingleCourseModel._parseInt(json['creator_id']);
    webinarId = SingleCourseModel._parseInt(json['webinar_id']);
    bundleId = SingleCourseModel._parseInt(json['bundle_id']);
    subscribeId = SingleCourseModel._parseInt(json['subscribe_id']);
    registrationPackageId =
        SingleCourseModel._parseInt(json['registration_package_id']);
    name = SingleCourseModel._parseString(json['name']);
    percent = SingleCourseModel._parseInt(json['percent']);
    status = SingleCourseModel._parseString(json['status']);
    createdAt = SingleCourseModel._parseInt(json['created_at']);
    fromDate = SingleCourseModel._parseInt(json['from_date']);
    toDate = SingleCourseModel._parseInt(json['to_date']);
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
}

class Faqs {
  int? id;
  String? title;
  String? answer;
  int? createdAt;
  int? updatedAt;
  bool isOpen = false;

  Faqs({this.id, this.title, this.answer, this.createdAt, this.updatedAt});

  Faqs.fromJson(Map<String, dynamic> json) {
    id = SingleCourseModel._parseInt(json['id']);
    title = SingleCourseModel._parseString(json['title']);
    answer = SingleCourseModel._parseString(json['answer']);
    createdAt = SingleCourseModel._parseInt(json['created_at']);
    updatedAt = SingleCourseModel._parseInt(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['answer'] = answer;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class FilesChapters {
  int? id;
  String? title;
  int? topicsCount;
  String? duration;
  String? status;
  var order;
  String? type;
  int? createdAt;
  List? textLessons;
  List? sessions;
  List<Files>? files;
  List? quizzes;
  bool isOpen = false;

  FilesChapters(
      {this.id,
      this.title,
      this.topicsCount,
      this.duration,
      this.status,
      this.order,
      this.type,
      this.createdAt,
      this.textLessons,
      this.sessions,
      this.files,
      this.quizzes});

  FilesChapters.fromJson(Map<String, dynamic> json) {
    id = SingleCourseModel._parseInt(json['id']);
    title = SingleCourseModel._parseString(json['title']);
    topicsCount = SingleCourseModel._parseInt(json['topics_count']);
    duration = SingleCourseModel._parseString(json['duration']);
    status = SingleCourseModel._parseString(json['status']);
    order = json['order'];
    type = SingleCourseModel._parseString(json['type']);
    createdAt = SingleCourseModel._parseInt(json['created_at']);

    if (SingleCourseModel._isList(json['files'])) {
      files = <Files>[];
      json['files'].forEach((v) {
        if (v != null) {
          files!.add(Files.fromJson(v));
        }
      });
    } else {
      files = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['topics_count'] = topicsCount;
    data['duration'] = duration;
    data['status'] = status;
    data['order'] = order;
    data['type'] = type;
    data['created_at'] = createdAt;
    if (textLessons != null) {
      data['textLessons'] = textLessons!.map((v) => v.toJson()).toList();
    } else {
      data['textLessons'] = null;
    }
    if (sessions != null) {
      data['sessions'] = sessions!.map((v) => v.toJson()).toList();
    } else {
      data['sessions'] = null;
    }
    if (files != null) {
      data['files'] = files!.map((v) => v.toJson()).toList();
    } else {
      data['files'] = null;
    }
    if (quizzes != null) {
      data['quizzes'] = quizzes!.map((v) => v.toJson()).toList();
    } else {
      data['quizzes'] = null;
    }
    return data;
  }
}

class Files {
  int? id;
  String? title;
  var authHasRead;
  String? status;
  var order;
  int? downloadable;
  String? accessibility;
  String? description;
  String? storage;
  String? downloadLink;
  var authHasAccess;
  bool? userHasAccess;
  String? file;
  String? volume;
  String? fileType;
  bool? isVideo;
  var interactiveType;
  var interactiveFileName;
  var interactiveFilePath;
  int? createdAt;
  int? updatedAt;

  Files(
      {this.id,
      this.title,
      this.authHasRead,
      this.status,
      this.order,
      this.downloadable,
      this.accessibility,
      this.description,
      this.storage,
      this.downloadLink,
      this.authHasAccess,
      this.userHasAccess,
      this.file,
      this.volume,
      this.fileType,
      this.isVideo,
      this.interactiveType,
      this.interactiveFileName,
      this.interactiveFilePath,
      this.createdAt,
      this.updatedAt});

  Files.fromJson(Map<String, dynamic> json) {
    id = SingleCourseModel._parseInt(json['id']);
    title = SingleCourseModel._parseString(json['title']);
    authHasRead = json['auth_has_read'];
    status = SingleCourseModel._parseString(json['status']);
    order = json['order'];
    downloadable = SingleCourseModel._parseInt(json['downloadable']);
    accessibility = SingleCourseModel._parseString(json['accessibility']);
    description = SingleCourseModel._parseString(json['description']);
    storage = SingleCourseModel._parseString(json['storage']);
    downloadLink = SingleCourseModel._parseString(json['download_link']);
    authHasAccess = json['auth_has_access'];
    userHasAccess =
        SingleCourseModel._parseBool(json['user_has_access']) ?? false;
    file = SingleCourseModel._parseString(json['file']);
    volume = SingleCourseModel._parseString(json['volume']);
    fileType = SingleCourseModel._parseString(json['file_type']);
    isVideo = SingleCourseModel._parseBool(json['is_video']) ?? false;
    interactiveType = json['interactive_type'];
    interactiveFileName = json['interactive_file_name'];
    interactiveFilePath = json['interactive_file_path'];
    createdAt = SingleCourseModel._parseInt(json['created_at']);
    updatedAt = SingleCourseModel._parseInt(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['auth_has_read'] = authHasRead;
    data['status'] = status;
    data['order'] = order;
    data['downloadable'] = downloadable;
    data['accessibility'] = accessibility;
    data['description'] = description;
    data['storage'] = storage;
    data['download_link'] = downloadLink;
    data['auth_has_access'] = authHasAccess;
    data['user_has_access'] = userHasAccess;
    data['file'] = file;
    data['volume'] = volume;
    data['file_type'] = fileType;
    data['is_video'] = isVideo;
    data['interactive_type'] = interactiveType;
    data['interactive_file_name'] = interactiveFileName;
    data['interactive_file_path'] = interactiveFilePath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Tags {
  int? id;
  String? title;

  Tags({this.id, this.title});

  Tags.fromJson(Map<String, dynamic> json) {
    id = SingleCourseModel._parseInt(json['id']);
    title = SingleCourseModel._parseString(json['title']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}

class CertificateModel {
  int? id;
  String? title;
  int? time;
  var authStatus;
  int? questionCount;
  int? totalMark;
  int? passMark;
  int? averageGrade;
  int? studentCount;
  int? certificatesCount;
  int? successRate;
  String? status;
  int? attempt;
  int? createdAt;
  int? certificate;
  UserModel? teacher;
  int? authAttemptCount;
  String? attemptState;
  bool? authCanStart;
  CourseModel? webinar;

  CertificateModel(
      {this.id,
      this.title,
      this.time,
      this.authStatus,
      this.questionCount,
      this.totalMark,
      this.passMark,
      this.averageGrade,
      this.studentCount,
      this.certificatesCount,
      this.successRate,
      this.status,
      this.attempt,
      this.createdAt,
      this.certificate,
      this.teacher,
      this.authAttemptCount,
      this.attemptState,
      this.authCanStart,
      this.webinar});

  CertificateModel.fromJson(Map<String, dynamic> json) {
    id = SingleCourseModel._parseInt(json['id']);
    title = SingleCourseModel._parseString(json['title']);
    time = SingleCourseModel._parseInt(json['time']);
    authStatus = json['auth_status'];
    questionCount = SingleCourseModel._parseInt(json['question_count']);
    totalMark = SingleCourseModel._parseInt(json['total_mark']);
    passMark = SingleCourseModel._parseInt(json['pass_mark']);
    averageGrade = SingleCourseModel._parseInt(json['average_grade']) ?? 0;
    studentCount = SingleCourseModel._parseInt(json['student_count']);
    certificatesCount = SingleCourseModel._parseInt(json['certificates_count']);
    successRate = SingleCourseModel._parseInt(json['success_rate']);
    status = SingleCourseModel._parseString(json['status']);
    attempt = SingleCourseModel._parseInt(json['attempt']);
    createdAt = SingleCourseModel._parseInt(json['created_at']);
    certificate = SingleCourseModel._parseInt(json['certificate']);
    teacher = SingleCourseModel._isMap(json['teacher'])
        ? UserModel.fromJson(json['teacher'])
        : null;
    authAttemptCount = SingleCourseModel._parseInt(json['auth_attempt_count']);
    attemptState = SingleCourseModel._parseString(json['attempt_state']);
    authCanStart =
        SingleCourseModel._parseBool(json['auth_can_start']) ?? false;
    webinar = SingleCourseModel._isMap(json['webinar'])
        ? CourseModel.fromJson(json['webinar'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['time'] = time;
    data['auth_status'] = authStatus;
    data['question_count'] = questionCount;
    data['total_mark'] = totalMark;
    data['pass_mark'] = passMark;
    data['average_grade'] = averageGrade;
    data['student_count'] = studentCount;
    data['certificates_count'] = certificatesCount;
    data['success_rate'] = successRate;
    data['status'] = status;
    data['attempt'] = attempt;
    data['created_at'] = createdAt;
    data['certificate'] = certificate;
    if (teacher != null) {
      data['teacher'] = teacher!.toJson();
    } else {
      data['teacher'] = null;
    }
    data['auth_attempt_count'] = authAttemptCount;
    data['attempt_state'] = attemptState;
    data['auth_can_start'] = authCanStart;
    if (webinar != null) {
      data['webinar'] = webinar!.toJson();
    } else {
      data['webinar'] = null;
    }
    return data;
  }
}

class QuizzesModel {
  int? id;
  String? title;
  int? time;
  var authStatus;
  int? questionCount;
  int? totalMark;
  int? passMark;
  String? averageGrade;
  int? studentCount;
  int? certificatesCount;
  int? successRate;
  String? status;
  int? attempt;
  int? createdAt;
  int? certificate;
  UserModel? teacher;
  int? authAttemptCount;
  String? attemptState;
  var authCanStart;
  CourseModel? webinar;

  QuizzesModel(
      {this.id,
      this.title,
      this.time,
      this.authStatus,
      this.questionCount,
      this.totalMark,
      this.passMark,
      this.averageGrade,
      this.studentCount,
      this.certificatesCount,
      this.successRate,
      this.status,
      this.attempt,
      this.createdAt,
      this.certificate,
      this.teacher,
      this.authAttemptCount,
      this.attemptState,
      this.authCanStart,
      this.webinar});

  QuizzesModel.fromJson(Map<String, dynamic> json) {
    id = SingleCourseModel._parseInt(json['id']);
    title = SingleCourseModel._parseString(json['title']);
    time = SingleCourseModel._parseInt(json['time']);
    authStatus = json['auth_status'];
    questionCount = SingleCourseModel._parseInt(json['question_count']);
    totalMark = SingleCourseModel._parseInt(json['total_mark']);
    passMark = SingleCourseModel._parseInt(json['pass_mark']);
    averageGrade = SingleCourseModel._parseString(json['average_grade']);
    studentCount = SingleCourseModel._parseInt(json['student_count']);
    certificatesCount = SingleCourseModel._parseInt(json['certificates_count']);
    successRate = SingleCourseModel._parseInt(json['success_rate']);
    status = SingleCourseModel._parseString(json['status']);
    attempt = SingleCourseModel._parseInt(json['attempt']);
    createdAt = SingleCourseModel._parseInt(json['created_at']);
    certificate = SingleCourseModel._parseInt(json['certificate']);
    teacher = SingleCourseModel._isMap(json['teacher'])
        ? UserModel.fromJson(json['teacher'])
        : null;
    authAttemptCount = SingleCourseModel._parseInt(json['auth_attempt_count']);
    attemptState = SingleCourseModel._parseString(json['attempt_state']);
    authCanStart = json['auth_can_start'];
    webinar = SingleCourseModel._isMap(json['webinar'])
        ? CourseModel.fromJson(json['webinar'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['time'] = time;
    data['auth_status'] = authStatus;
    data['question_count'] = questionCount;
    data['total_mark'] = totalMark;
    data['pass_mark'] = passMark;
    data['average_grade'] = averageGrade;
    data['student_count'] = studentCount;
    data['certificates_count'] = certificatesCount;
    data['success_rate'] = successRate;
    data['status'] = status;
    data['attempt'] = attempt;
    data['created_at'] = createdAt;
    data['certificate'] = certificate;
    if (teacher != null) {
      data['teacher'] = teacher!.toJson();
    } else {
      data['teacher'] = null;
    }
    data['auth_attempt_count'] = authAttemptCount;
    data['attempt_state'] = attemptState;
    data['auth_can_start'] = authCanStart;
    if (webinar != null) {
      data['webinar'] = webinar!.toJson();
    } else {
      data['webinar'] = null;
    }
    return data;
  }
}

class PrerequisitesModel {
  int? isRequired;
  CourseModel? webinar;

  PrerequisitesModel({this.isRequired, this.webinar});

  PrerequisitesModel.fromJson(Map<String, dynamic> json) {
    isRequired = SingleCourseModel._parseInt(json['required']);
    webinar = SingleCourseModel._isMap(json['webinar'])
        ? CourseModel.fromJson(json['webinar'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['required'] = isRequired;
    if (webinar != null) {
      data['webinar'] = webinar!.toJson();
    } else {
      data['webinar'] = null;
    }
    return data;
  }
}

class SessionChapters {
  int? id;
  String? title;
  int? topicsCount;
  String? duration;
  String? status;
  var order;
  String? type;
  int? createdAt;
  List<TextLessonChapters>? textLessons;
  List<Sessions>? sessions;
  List<Files>? files;
  List<QuizzesModel>? quizzes;
  bool isOpen = false;

  SessionChapters(
      {this.id,
      this.title,
      this.topicsCount,
      this.duration,
      this.status,
      this.order,
      this.type,
      this.createdAt,
      this.textLessons,
      this.sessions,
      this.files,
      this.quizzes});

  SessionChapters.fromJson(Map<String, dynamic> json) {
    id = SingleCourseModel._parseInt(json['id']);
    title = SingleCourseModel._parseString(json['title']);
    topicsCount = SingleCourseModel._parseInt(json['topics_count']);
    duration = SingleCourseModel._parseString(json['duration']);
    status = SingleCourseModel._parseString(json['status']);
    order = json['order'];
    type = SingleCourseModel._parseString(json['type']);
    createdAt = SingleCourseModel._parseInt(json['created_at']);
    if (SingleCourseModel._isList(json['textLessons'])) {
      textLessons = <TextLessonChapters>[];
      json['textLessons'].forEach((v) {
        if (v != null) {
          textLessons!.add(TextLessonChapters.fromJson(v));
        }
      });
    } else {
      textLessons = null;
    }
    if (SingleCourseModel._isList(json['sessions'])) {
      sessions = <Sessions>[];
      json['sessions'].forEach((v) {
        if (v != null) {
          sessions!.add(Sessions.fromJson(v));
        }
      });
    } else {
      sessions = null;
    }
    if (SingleCourseModel._isList(json['files'])) {
      files = <Files>[];
      json['files'].forEach((v) {
        if (v != null) {
          files!.add(Files.fromJson(v));
        }
      });
    } else {
      files = null;
    }
    if (SingleCourseModel._isList(json['quizzes'])) {
      quizzes = <QuizzesModel>[];
      json['quizzes'].forEach((v) {
        if (v != null) {
          quizzes!.add(QuizzesModel.fromJson(v));
        }
      });
    } else {
      quizzes = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['topics_count'] = topicsCount;
    data['duration'] = duration;
    data['status'] = status;
    data['order'] = order;
    data['type'] = type;
    data['created_at'] = createdAt;
    if (textLessons != null) {
      data['textLessons'] = textLessons!.map((v) => v.toJson()).toList();
    } else {
      data['textLessons'] = null;
    }
    if (sessions != null) {
      data['sessions'] = sessions!.map((v) => v.toJson()).toList();
    } else {
      data['sessions'] = null;
    }
    if (files != null) {
      data['files'] = files!.map((v) => v.toJson()).toList();
    } else {
      data['files'] = null;
    }
    if (quizzes != null) {
      data['quizzes'] = quizzes!.map((v) => v.toJson()).toList();
    } else {
      data['quizzes'] = null;
    }
    return data;
  }
}

class Sessions {
  int? id;
  String? title;
  bool? authHasRead;
  bool? userHasAccess;
  bool? isFinished;
  bool? isStarted;
  String? status;
  var order;
  String? moderatorSecret;
  int? date;
  int? duration;
  String? link;
  String? joinLink;
  bool? canJoin;
  String? sessionApi;
  String? zoomStartLink;
  String? apiSecret;
  String? description;
  int? createdAt;
  int? updatedAt;
  var agoraSettings;

  Sessions(
      {this.id,
      this.title,
      this.authHasRead,
      this.userHasAccess,
      this.isFinished,
      this.isStarted,
      this.status,
      this.order,
      this.moderatorSecret,
      this.date,
      this.duration,
      this.link,
      this.joinLink,
      this.canJoin,
      this.sessionApi,
      this.zoomStartLink,
      this.apiSecret,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.agoraSettings});

  Sessions.fromJson(Map<String, dynamic> json) {
    id = SingleCourseModel._parseInt(json['id']);
    title = SingleCourseModel._parseString(json['title']);
    authHasRead = SingleCourseModel._parseBool(json['auth_has_read']) ?? false;
    userHasAccess =
        SingleCourseModel._parseBool(json['user_has_access']) ?? false;
    isFinished = SingleCourseModel._parseBool(json['is_finished']) ?? false;
    isStarted = SingleCourseModel._parseBool(json['is_started']) ?? false;
    status = SingleCourseModel._parseString(json['status']);
    order = json['order'];
    moderatorSecret = SingleCourseModel._parseString(json['moderator_secret']);
    date = SingleCourseModel._parseInt(json['date']);
    duration = SingleCourseModel._parseInt(json['duration']);
    link = SingleCourseModel._parseString(json['link']);
    joinLink = SingleCourseModel._parseString(json['join_link']);
    canJoin = SingleCourseModel._parseBool(json['can_join']) ?? false;
    sessionApi = SingleCourseModel._parseString(json['session_api']);
    zoomStartLink = SingleCourseModel._parseString(json['zoom_start_link']);
    apiSecret = SingleCourseModel._parseString(json['api_secret']);
    description = SingleCourseModel._parseString(json['description']);
    createdAt = SingleCourseModel._parseInt(json['created_at']);
    updatedAt = SingleCourseModel._parseInt(json['updated_at']);
    agoraSettings = json['agora_settings '];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['auth_has_read'] = authHasRead;
    data['user_has_access'] = userHasAccess;
    data['is_finished'] = isFinished;
    data['is_started'] = isStarted;
    data['status'] = status;
    data['order'] = order;
    data['moderator_secret'] = moderatorSecret;
    data['date'] = date;
    data['duration'] = duration;
    data['link'] = link;
    data['join_link'] = joinLink;
    data['can_join'] = canJoin;
    data['session_api'] = sessionApi;
    data['zoom_start_link'] = zoomStartLink;
    data['api_secret'] = apiSecret;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['agora_settings '] = agoraSettings;
    return data;
  }
}

class TextLessonChapters {
  int? id;
  String? title;
  int? topicsCount;
  String? duration;
  String? status;
  var order;
  String? type;
  int? createdAt;
  List<TextLessons>? textLessons;
  List<SessionChapters>? sessions;
  List<Files>? files;
  List<QuizzesModel>? quizzes;
  bool isOpen = false;

  TextLessonChapters(
      {this.id,
      this.title,
      this.topicsCount,
      this.duration,
      this.status,
      this.order,
      this.type,
      this.createdAt,
      this.textLessons,
      this.sessions,
      this.files,
      this.quizzes});

  TextLessonChapters.fromJson(Map<String, dynamic> json) {
    id = SingleCourseModel._parseInt(json['id']);
    title = SingleCourseModel._parseString(json['title']);
    topicsCount = SingleCourseModel._parseInt(json['topics_count']);
    duration = SingleCourseModel._parseString(json['duration']);
    status = SingleCourseModel._parseString(json['status']);
    order = json['order'];
    type = SingleCourseModel._parseString(json['type']);
    createdAt = SingleCourseModel._parseInt(json['created_at']);
    if (SingleCourseModel._isList(json['textLessons'])) {
      textLessons = <TextLessons>[];
      json['textLessons'].forEach((v) {
        if (v != null) {
          textLessons!.add(TextLessons.fromJson(v));
        }
      });
    } else {
      textLessons = null;
    }
    if (SingleCourseModel._isList(json['sessions'])) {
      sessions = <SessionChapters>[];
      json['sessions'].forEach((v) {
        if (v != null) {
          sessions!.add(SessionChapters.fromJson(v));
        }
      });
    } else {
      sessions = null;
    }
    if (SingleCourseModel._isList(json['files'])) {
      files = <Files>[];
      json['files'].forEach((v) {
        if (v != null) {
          files!.add(Files.fromJson(v));
        }
      });
    } else {
      files = null;
    }
    if (SingleCourseModel._isList(json['quizzes'])) {
      quizzes = <QuizzesModel>[];
      json['quizzes'].forEach((v) {
        if (v != null) {
          quizzes!.add(QuizzesModel.fromJson(v));
        }
      });
    } else {
      quizzes = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['topics_count'] = topicsCount;
    data['duration'] = duration;
    data['status'] = status;
    data['order'] = order;
    data['type'] = type;
    data['created_at'] = createdAt;
    if (textLessons != null) {
      data['textLessons'] = textLessons!.map((v) => v.toJson()).toList();
    } else {
      data['textLessons'] = null;
    }
    if (sessions != null) {
      data['sessions'] = sessions!.map((v) => v.toJson()).toList();
    } else {
      data['sessions'] = null;
    }
    if (files != null) {
      data['files'] = files!.map((v) => v.toJson()).toList();
    } else {
      data['files'] = null;
    }
    if (quizzes != null) {
      data['quizzes'] = quizzes!.map((v) => v.toJson()).toList();
    } else {
      data['quizzes'] = null;
    }
    return data;
  }
}

class TextLessons {
  int? id;
  String? title;
  bool? authHasRead;
  bool? authHasAccess;
  bool? userHasAccess;
  int? studyTime;
  var order;
  int? createdAt;
  String? accessibility;
  String? status;
  int? updatedAt;
  String? summary;
  String? content;
  String? locale;
  List<Attachments>? attachments;
  int? attachmentsCount;

  TextLessons(
      {this.id,
      this.title,
      this.authHasRead,
      this.authHasAccess,
      this.userHasAccess,
      this.studyTime,
      this.order,
      this.createdAt,
      this.accessibility,
      this.status,
      this.updatedAt,
      this.summary,
      this.content,
      this.locale,
      this.attachments,
      this.attachmentsCount});

  TextLessons.fromJson(Map<String, dynamic> json) {
    id = SingleCourseModel._parseInt(json['id']);
    title = SingleCourseModel._parseString(json['title']);
    authHasRead = SingleCourseModel._parseBool(json['auth_has_read']) ?? false;
    authHasAccess =
        SingleCourseModel._parseBool(json['auth_has_access']) ?? false;
    userHasAccess =
        SingleCourseModel._parseBool(json['user_has_access']) ?? false;
    studyTime = SingleCourseModel._parseInt(json['study_time']);
    order = json['order'];
    createdAt = SingleCourseModel._parseInt(json['created_at']);
    accessibility = SingleCourseModel._parseString(json['accessibility']);
    status = SingleCourseModel._parseString(json['status']);
    updatedAt = SingleCourseModel._parseInt(json['updated_at']);
    summary = SingleCourseModel._parseString(json['summary']);
    content = SingleCourseModel._parseString(json['content']);
    locale = SingleCourseModel._parseString(json['locale']);
    if (SingleCourseModel._isList(json['attachments'])) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        if (v != null) {
          attachments!.add(Attachments.fromJson(v));
        }
      });
    } else {
      attachments = null;
    }
    attachmentsCount = SingleCourseModel._parseInt(json['attachments_count']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['auth_has_read'] = authHasRead;
    data['auth_has_access'] = authHasAccess;
    data['user_has_access'] = userHasAccess;
    data['study_time'] = studyTime;
    data['order'] = order;
    data['created_at'] = createdAt;
    data['accessibility'] = accessibility;
    data['status'] = status;
    data['updated_at'] = updatedAt;
    data['summary'] = summary;
    data['content'] = content;
    data['locale'] = locale;
    if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v.toJson()).toList();
    } else {
      data['attachments'] = null;
    }
    data['attachments_count'] = attachmentsCount;
    return data;
  }
}

class Attachments {
  int? id;
  String? title;
  bool? authHasRead;
  String? status;
  var order;
  int? downloadable;
  String? accessibility;
  String? description;
  String? storage;
  String? downloadLink;
  bool? authHasAccess;
  bool? userHasAccess;
  String? file;
  String? volume;
  String? fileType;
  bool? isVideo;
  String? interactiveType;
  String? interactiveFileName;
  String? interactiveFilePath;
  int? createdAt;
  int? updatedAt;

  Attachments(
      {this.id,
      this.title,
      this.authHasRead,
      this.status,
      this.order,
      this.downloadable,
      this.accessibility,
      this.description,
      this.storage,
      this.downloadLink,
      this.authHasAccess,
      this.userHasAccess,
      this.file,
      this.volume,
      this.fileType,
      this.isVideo,
      this.interactiveType,
      this.interactiveFileName,
      this.interactiveFilePath,
      this.createdAt,
      this.updatedAt});

  Attachments.fromJson(Map<String, dynamic> json) {
    id = SingleCourseModel._parseInt(json['id']);
    title = SingleCourseModel._parseString(json['title']);
    authHasRead = SingleCourseModel._parseBool(json['auth_has_read']) ?? false;
    status = SingleCourseModel._parseString(json['status']);
    order = json['order'];
    downloadable = SingleCourseModel._parseInt(json['downloadable']);
    accessibility = SingleCourseModel._parseString(json['accessibility']);
    description = SingleCourseModel._parseString(json['description']);
    storage = SingleCourseModel._parseString(json['storage']);
    downloadLink = SingleCourseModel._parseString(json['download_link']);
    authHasAccess =
        SingleCourseModel._parseBool(json['auth_has_access']) ?? false;
    userHasAccess =
        SingleCourseModel._parseBool(json['user_has_access']) ?? false;
    file = SingleCourseModel._parseString(json['file']);
    volume = SingleCourseModel._parseString(json['volume']);
    fileType = SingleCourseModel._parseString(json['file_type']);
    isVideo = SingleCourseModel._parseBool(json['is_video']) ?? false;
    interactiveType = SingleCourseModel._parseString(json['interactive_type']);
    interactiveFileName =
        SingleCourseModel._parseString(json['interactive_file_name']);
    interactiveFilePath =
        SingleCourseModel._parseString(json['interactive_file_path']);
    createdAt = SingleCourseModel._parseInt(json['created_at']);
    updatedAt = SingleCourseModel._parseInt(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['auth_has_read'] = authHasRead;
    data['status'] = status;
    data['order'] = order;
    data['downloadable'] = downloadable;
    data['accessibility'] = accessibility;
    data['description'] = description;
    data['storage'] = storage;
    data['download_link'] = downloadLink;
    data['auth_has_access'] = authHasAccess;
    data['user_has_access'] = userHasAccess;
    data['file'] = file;
    data['volume'] = volume;
    data['file_type'] = fileType;
    data['is_video'] = isVideo;
    data['interactive_type'] = interactiveType;
    data['interactive_file_name'] = interactiveFileName;
    data['interactive_file_path'] = interactiveFilePath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ReviewModel {
  int? id;
  UserModel? user;
  int? createdAt;
  String? description;
  String? rate;
  RateType? rateType;

  ReviewModel(
      {this.id,
      this.user,
      this.createdAt,
      this.description,
      this.rate,
      this.rateType});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    id = SingleCourseModel._parseInt(json['id']);
    user = SingleCourseModel._isMap(json['user'])
        ? UserModel.fromJson(json['user'])
        : null;
    createdAt = SingleCourseModel._parseInt(json['created_at']);
    description = SingleCourseModel._parseString(json['description']);
    rate = SingleCourseModel._parseString(json['rate']);
    rateType = SingleCourseModel._isMap(json['rate_type'])
        ? RateType.fromJson(json['rate_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    } else {
      data['user'] = null;
    }
    data['created_at'] = createdAt;
    data['description'] = description;
    data['rate'] = rate;
    if (rateType != null) {
      data['rate_type'] = rateType!.toJson();
    } else {
      data['rate_type'] = null;
    }
    return data;
  }
}

class CashbackRules {
  int? id;
  String? targetType;
  int? startDate;
  int? endDate;
  int? amount;
  String? amountType;
  int? applyCashbackPerItem;
  int? maxAmount;
  int? minAmount;
  int? enable;
  int? createdAt;
  String? title;
  List<Translations>? translations;

  CashbackRules(
      {this.id,
      this.targetType,
      this.startDate,
      this.endDate,
      this.amount,
      this.amountType,
      this.applyCashbackPerItem,
      this.maxAmount,
      this.minAmount,
      this.enable,
      this.createdAt,
      this.title,
      this.translations});

  CashbackRules.fromJson(Map<String, dynamic> json) {
    id = SingleCourseModel._parseInt(json['id']);
    targetType = SingleCourseModel._parseString(json['target_type']);
    startDate = SingleCourseModel._parseInt(json['start_date']);
    endDate = SingleCourseModel._parseInt(json['end_date']);
    amount = SingleCourseModel._parseInt(json['amount']);
    amountType = SingleCourseModel._parseString(json['amount_type']);
    applyCashbackPerItem =
        SingleCourseModel._parseInt(json['apply_cashback_per_item']);
    maxAmount = SingleCourseModel._parseInt(json['max_amount']);
    minAmount = SingleCourseModel._parseInt(json['min_amount']);
    enable = SingleCourseModel._parseInt(json['enable']);
    createdAt = SingleCourseModel._parseInt(json['created_at']);
    title = SingleCourseModel._parseString(json['title']);
    if (SingleCourseModel._isList(json['translations'])) {
      translations = <Translations>[];
      json['translations'].forEach((v) {
        if (v != null) {
          translations!.add(Translations.fromJson(v));
        }
      });
    } else {
      translations = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['target_type'] = targetType;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['amount'] = amount;
    data['amount_type'] = amountType;
    data['apply_cashback_per_item'] = applyCashbackPerItem;
    data['max_amount'] = maxAmount;
    data['min_amount'] = minAmount;
    data['enable'] = enable;
    data['created_at'] = createdAt;
    data['title'] = title;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    } else {
      data['translations'] = null;
    }
    return data;
  }
}

class Translations {
  int? id;
  int? cashbackRuleId;
  String? locale;
  String? title;

  Translations({this.id, this.cashbackRuleId, this.locale, this.title});

  Translations.fromJson(Map<String, dynamic> json) {
    id = SingleCourseModel._parseInt(json['id']);
    cashbackRuleId = SingleCourseModel._parseInt(json['cashback_rule_id']);
    locale = SingleCourseModel._parseString(json['locale']);
    title = SingleCourseModel._parseString(json['title']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cashback_rule_id'] = cashbackRuleId;
    data['locale'] = locale;
    data['title'] = title;
    return data;
  }
}
