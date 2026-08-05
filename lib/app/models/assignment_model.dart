import 'user_model.dart';

import 'can_model.dart';

class AssignmentModel {
  int? id;
  String? title;
  String? deadline;
  UserModel? student;
  int? deadlineTime;
  Can? can;
  String? description;
  String? webinarTitle;
  String? webinarImage;
  int? firstSubmission;
  int? lastSubmission;
  int? attempts;
  int? usedAttemptsCount;
  int? grade;
  int? totalGrade;
  int? passGrade;
  int? purchaseDate;
  String? userStatus;
  List<Attachments>? attachments;

  String? status;
  int? minGrade;
  int? avgGrade;
  int? pendingCount;
  int? passedCount;
  int? failedCount;
  int? submissionsCount;

  AssignmentModel(
      {this.id,
      this.title,
      this.deadline,
      this.student,
      this.deadlineTime,
      this.can,
      this.description,
      this.webinarTitle,
      this.webinarImage,
      this.firstSubmission,
      this.lastSubmission,
      this.attempts,
      this.usedAttemptsCount,
      this.grade,
      this.totalGrade,
      this.passGrade,
      this.purchaseDate,
      this.userStatus,
      this.attachments});

  AssignmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title']?.toString();
    deadline = json['deadline']?.toString();
    student = json['student'] != null ? UserModel.fromJson(json['student']) : null;
    deadlineTime = json['deadline_time'];
    can = json['can'] != null ? Can.fromJson(json['can']) : null;
    description = json['description']?.toString();
    webinarTitle = json['webinar_title']?.toString();
    webinarImage = json['webinar_image']?.toString();
    firstSubmission = json['first_submission'];
    lastSubmission = json['last_submission'];
    attempts = json['attempts'];
    usedAttemptsCount = json['used_attempts_count'];
    grade = json['grade'];
    totalGrade = json['total_grade'];
    passGrade = json['pass_grade'];
    purchaseDate = json['purchase_date'];
    userStatus = json['user_status']?.toString();
    
    // Statistics fields
    status = json['status']?.toString();
    minGrade = json['min_grade'];
    avgGrade = json['avg_grade'];
    pendingCount = json['pending_count'];
    passedCount = json['passed_count'];
    failedCount = json['failed_count'];
    submissionsCount = json['submissions_count'];

    // Attachments list
    if (json['attachments'] != null && json['attachments'] is List) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        if (v != null) {
          attachments!.add(Attachments.fromJson(v));
        }
      });
    } else {
      attachments = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['deadline'] = deadline;
    if (student != null) {
      data['student'] = student!.toJson();
    } else {
      data['student'] = null;
    }
    data['deadline_time'] = deadlineTime;
    if (can != null) {
      data['can'] = can!.toJson();
    } else {
      data['can'] = null;
    }
    data['description'] = description;
    data['webinar_title'] = webinarTitle;
    data['webinar_image'] = webinarImage;
    data['first_submission'] = firstSubmission;
    data['last_submission'] = lastSubmission;
    data['attempts'] = attempts;
    data['used_attempts_count'] = usedAttemptsCount;
    data['grade'] = grade;
    data['total_grade'] = totalGrade;
    data['pass_grade'] = passGrade;
    data['purchase_date'] = purchaseDate;
    data['user_status'] = userStatus;
    
    // Statistics fields
    data['status'] = status;
    data['min_grade'] = minGrade;
    data['avg_grade'] = avgGrade;
    data['pending_count'] = pendingCount;
    data['passed_count'] = passedCount;
    data['failed_count'] = failedCount;
    data['submissions_count'] = submissionsCount;

    if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v.toJson()).toList();
    } else {
      data['attachments'] = null;
    }
    return data;
  }
}

class Attachments {
  String? url;
  String? title;
  String? size;

  Attachments({this.url, this.title, this.size});

  Attachments.fromJson(Map<String, dynamic> json) {
    url = json['url']?.toString();
    title = json['title']?.toString();
    size = json['size']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['title'] = title;
    data['size'] = size;
    return data;
  }
}