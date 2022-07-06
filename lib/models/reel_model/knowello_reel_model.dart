// To parse this JSON data, do
//
//     final knowelloReelModel = knowelloReelModelFromJson(jsonString);

import 'dart:async';
import 'dart:convert';

KnowelloReelModel knowelloReelModelFromJson(String str) =>
    KnowelloReelModel.fromJson(json.decode(str));

String knowelloReelModelToJson(KnowelloReelModel data) =>
    json.encode(data.toJson());

class KnowelloReelModel {
  KnowelloReelModel({
    this.pageToken,
    this.vResult,
  });

  int? pageToken;
  List<VResult>? vResult;

  factory KnowelloReelModel.fromJson(Map<String, dynamic> json) =>
      KnowelloReelModel(
        pageToken: json["page_token"],
        vResult:
            List<VResult>.from(json["vResult"].map((x) => VResult.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "page_token": pageToken,
        "vResult": List<dynamic>.from(vResult!.map((x) => x.toJson())),
      };
}

class VResult {
  VResult({
    this.id,
    this.caption,
    this.description,
    this.link,
    this.hotlink,
    this.thumbnail,
    this.isLive,
    this.hotword,
    this.pushNotification,
    this.notificationTitle,
    this.likesCount,
    this.commentsCounts,
    this.viewsCounts,
    this.insertDate,
    this.publishDate,
    this.isActive,
    this.hotwordurl,
    this.isLiked,
    // this.comments,
    this.sourceList,
    this.videoThumbnail,
  });

  int? id;
  String? caption;
  String? description;
  String? link;
  String? hotlink;
  String? thumbnail;
  int? isLive;
  String? hotword;
  int? pushNotification;
  String? notificationTitle;
  int? likesCount;
  int? commentsCounts;
  int? viewsCounts;
  String? insertDate;
  String? publishDate;
  int? isActive;
  String? hotwordurl;
  String? isLiked;
  // List<Comment>? comments;
  List<SourceList>? sourceList;
  StreamController<bool> isPaused = StreamController.broadcast();
  StreamController<bool> isMuted = StreamController.broadcast();
  StreamController<bool> showPlayerControls = StreamController.broadcast();
  StreamController<double> videoPositionStreamController =
      StreamController.broadcast();
  final String? videoThumbnail;

  factory VResult.fromJson(Map<String, dynamic> json) => VResult(
        id: json["id"],
        caption: json["caption"],
        description: json["description"],
        link: json["link"],
        hotlink: json["hotlink"],
        thumbnail: json["thumbnail"],
        isLive: json["is_live"],
        hotword: json["hotword"],
        pushNotification: json["push_notification"],
        notificationTitle: json["notification_title"],
        likesCount: json["likes_count"],
        commentsCounts: json["comments_counts"],
        viewsCounts: json["views_counts"],
        insertDate: json["insert_date"].toString(),
        publishDate: json["publish_date"].toString(),
        isActive: json["is_active"],
        hotwordurl: json["hotwordurl"],
        isLiked: json["is_liked"],
        // comments: List<Comment>.from(
        //     json["comments"].map((x) => Comment.fromJson(x))),
        sourceList: List<SourceList>.from(
            json["sourceList"].map((x) => SourceList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "caption": caption,
        "description": description,
        "link": link,
        "hotlink": hotlink,
        "thumbnail": thumbnail,
        "is_live": isLive,
        "hotword": hotword,
        "push_notification": pushNotification,
        "notification_title": notificationTitle,
        "likes_count": likesCount,
        "comments_counts": commentsCounts,
        "views_counts": viewsCounts,
        "insert_date": insertDate,
        "publish_date": publishDate,
        "is_active": isActive,
        "hotwordurl": hotwordurl,
        "is_liked": isLiked,
        // "comments": List<dynamic>.from(comments!.map((x) => x.toJson())),
        "sourceList": List<dynamic>.from(sourceList!.map((x) => x.toJson())),
      };
}

List<VideoComments> videoCommentsFromJson(String str) =>
    List<VideoComments>.from(
        json.decode(str).map((x) => VideoComments.fromJson(x)));

String videoCommentsToJson(List<VideoComments> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoComments {
  VideoComments({
    this.id,
    this.videoId,
    this.userId,
    this.comment,
    this.isActive,
    this.insertAt,
    this.name,
  });

  int? id;
  int? videoId;
  int? userId;
  String? comment;
  int? isActive;
  DateTime? insertAt;
  String? name;

  factory VideoComments.fromJson(Map<String, dynamic> json) => VideoComments(
        id: json["id"],
        videoId: json["video_id"],
        userId: json["user_id"],
        comment: json["comment"],
        isActive: json["is_active"],
        insertAt: json["insert_at"] == null
            ? null
            : DateTime.parse(json["insert_at"]),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "video_id": videoId,
        "user_id": userId,
        "comment": comment,
        "is_active": isActive,
        "insert_at": insertAt == null ? null : insertAt!.toIso8601String(),
        "name": name,
      };
}

class SourceList {
  SourceList({
    this.title,
    this.source,
  });

  String? title;
  String? source;

  factory SourceList.fromJson(Map<String, dynamic> json) => SourceList(
        title: json["title"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "source": source,
      };
}
