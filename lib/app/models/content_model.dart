import 'can_model.dart';

class ContentModel {
  String? type;
  int? id;
  String? title;
  int? topicsCount;
  int? createdAt;
  int? checkAllContentsPass;
  List<ContentItem>? items;
  bool isOpen = false;

  ContentModel({
    this.type,
    this.id,
    this.title,
    this.topicsCount,
    this.createdAt,
    this.checkAllContentsPass,
    this.items,
  });

  ContentModel.fromJson(Map<String, dynamic> json) {
    type = json['type']?.toString();
    id = _parseInt(json['id']);
    title = json['title']?.toString();
    topicsCount = _parseInt(json['topics_count']);
    createdAt = _parseInt(json['created_at']);
    checkAllContentsPass = _parseInt(json['check_all_contents_pass']);
    if (json['items'] != null) {
      items = <ContentItem>[];
      json['items'].forEach((v) {
        items!.add(ContentItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['id'] = id;
    data['title'] = title;
    data['topics_count'] = topicsCount;
    data['created_at'] = createdAt;
    data['check_all_contents_pass'] = checkAllContentsPass;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
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

class ContentItem {
  Can? can;
  var canViewError;
  bool? authHasRead;
  String? type;
  int? createdAt;
  String? link;
  int? id;
  String? title;
  String? fileType;
  String? storage;
  String? volume;
  String? summary;
  int? downloadable;
  int? time;
  int? questionCount;
  int? date;

  ContentItem({
    this.can,
    this.canViewError,
    this.authHasRead,
    this.type,
    this.createdAt,
    this.link,
    this.id,
    this.title,
    this.fileType,
    this.storage,
    this.volume,
    this.summary,
    this.downloadable,
    this.time,
    this.questionCount,
    this.date,
  });

  ContentItem.fromJson(Map<String, dynamic> json) {
    can = json['can'] != null ? Can.fromJson(json['can']) : null;
    canViewError = json['can_view_error'];
    authHasRead = json['auth_has_read'] is bool ? json['auth_has_read'] : null;
    type = json['type']?.toString();
    createdAt = _parseInt(json['created_at']);
    link = json['link']?.toString();
    id = _parseInt(json['id']);
    title = json['title']?.toString();
    fileType = json['file_type']?.toString();
    storage = json['storage']?.toString();
    volume = json['volume']?.toString();
    summary = json['summary']?.toString();
    downloadable = _parseInt(json['downloadable']);
    time = _parseInt(json['time']);
    questionCount = _parseInt(json['question_count']);
    date = _parseInt(json['date']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (can != null) {
      data['can'] = can!.toJson();
    }
    data['can_view_error'] = canViewError;
    data['auth_has_read'] = authHasRead;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['link'] = link;
    data['id'] = id;
    data['title'] = title;
    data['file_type'] = fileType;
    data['storage'] = storage;
    data['volume'] = volume;
    data['summary'] = summary;
    data['downloadable'] = downloadable;
    data['time'] = time;
    data['question_count'] = questionCount;
    data['date'] = date;
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