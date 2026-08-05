class SingleContentModel {
  int? id;
  String? title;
  String? canViewError;
  bool? authHasRead;
  bool? authHasAccess;
  bool? userHasAccess;
  String? fileType;
  String? volume;
  String? storage;
  String? downloadLink;
  String? file;
  int? studyTime;
  int? createdAt;
  String? description;
  String? summary;
  String? content;
  String? locale;
  List<Attachments>? attachments;
  int? attachmentsCount;

  int checkPreviousParts = 0;
  int? date;
  int? duration;
  bool? isFinished;
  bool? isStarted;
  bool? canJoin;
  String? link;
  String? sessionApi;
  String? zoomStartLink;

  String? assignmentStatus;
  bool? passed;

  SingleContentModel(
      {this.id,
      this.title,
      this.canViewError,
      this.authHasRead,
      this.authHasAccess,
      this.userHasAccess,
      this.fileType,
      this.volume,
      this.storage,
      this.downloadLink,
      this.file,
      this.studyTime,
      this.createdAt,
      this.description,
      this.summary,
      this.content,
      this.locale,
      this.attachments,
      this.attachmentsCount});

  SingleContentModel.fromJson(Map<String, dynamic> json) {
    // Use safe parsing with null checks
    checkPreviousParts = _parseInt(json['check_previous_parts']) ?? 0;
    assignmentStatus = json['assignmentStatus'] ?? json['assignment_status'];
    passed = json['passed'] == true ||
        json['passed'] == '1' ||
        json['passed'] == 'true';

    id = _parseInt(json['id']);
    title = json['title']?.toString();
    canViewError = json['can_view_error']?.toString();
    authHasRead = json['auth_has_read'] == true ||
        json['auth_has_read'] == '1' ||
        json['auth_has_read'] == 'true';
    authHasAccess = json['auth_has_access'] == true ||
        json['auth_has_access'] == '1' ||
        json['auth_has_access'] == 'true';
    userHasAccess = json['user_has_access'] == true ||
        json['user_has_access'] == '1' ||
        json['user_has_access'] == 'true';
    fileType = json['file_type']?.toString();
    volume = json['volume']?.toString();
    storage = json['storage']?.toString();
    downloadLink = json['download_link']?.toString();
    file = json['file']?.toString();
    studyTime = _parseInt(json['study_time']);
    createdAt = _parseInt(json['created_at']);
    description = json['description']?.toString();
    summary = json['summary']?.toString();
    content = json['content']?.toString();
    locale = json['locale']?.toString();

    // Safe attachments parsing
    if (json['attachments'] != null && json['attachments'] is List) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        attachments!.add(Attachments.fromJson(v));
      });
    } else {
      attachments = [];
    }

    attachmentsCount = _parseInt(json['attachments_count']) ?? 0;

    // Session-specific data
    date = _parseInt(json['date']);
    duration = _parseInt(json['duration']);
    isFinished = json['is_finished'] == true ||
        json['is_finished'] == '1' ||
        json['is_finished'] == 'true';
    isStarted = json['is_started'] == true ||
        json['is_started'] == '1' ||
        json['is_started'] == 'true';
    canJoin = json['can_join'] == true ||
        json['can_join'] == '1' ||
        json['can_join'] == 'true';
    link = json['link']?.toString();
    sessionApi = json['session_api']?.toString();
    zoomStartLink = json['zoom_start_link']?.toString();
  }

// Helper method to safely parse integers from both string and int
  int? _parseInt(dynamic value) {
    if (value == null) return null;

    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    if (value is double) {
      return value.toInt();
    }
    return null;
  }
}

class Attachments {
  int? id;
  String? title;
  bool? authHasRead;
  String? status;
  int? order;
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
  var interactiveType;
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
    id = _parseInt(json['id']);
    title = json['title']?.toString();
    authHasRead = json['auth_has_read'] == true ||
        json['auth_has_read'] == '1' ||
        json['auth_has_read'] == 'true';
    status = json['status']?.toString();
    order = _parseInt(json['order']);
    downloadable = _parseInt(json['downloadable']);
    accessibility = json['accessibility']?.toString();
    description = json['description']?.toString();
    storage = json['storage']?.toString();
    downloadLink = json['download_link']?.toString();
    authHasAccess = json['auth_has_access'] == true ||
        json['auth_has_access'] == '1' ||
        json['auth_has_access'] == 'true';
    userHasAccess = json['user_has_access'] == true ||
        json['user_has_access'] == '1' ||
        json['user_has_access'] == 'true';
    file = json['file']?.toString();
    volume = json['volume']?.toString();
    fileType = json['file_type']?.toString();
    isVideo = json['is_video'] == true ||
        json['is_video'] == '1' ||
        json['is_video'] == 'true';
    interactiveType = json['interactive_type']?.toString();
    interactiveFileName = json['interactive_file_name']?.toString();
    interactiveFilePath = json['interactive_file_path']?.toString();
    createdAt = _parseInt(json['created_at']);
    updatedAt = _parseInt(json['updated_at']);
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

  int? _parseInt(dynamic value) {
    if (value == null) return null;

    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    if (value is double) {
      return value.toInt();
    }
    return null;
  }
}
