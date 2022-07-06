// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'dart:convert';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  PostModel({
    this.pageToken,
    this.data,
  });

  int? pageToken;
  List<Datum>? data;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        pageToken: json["page_token"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "page_token": pageToken,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.type,
    this.id,
    this.headline,
    this.description,
    this.caption,
    this.sizeType,
    this.featureId,
    this.publishOn,
    this.isBookmark,
    this.isLike,
    this.likes,
    this.media,
    this.sources,
    this.comments,
    this.hashtags,
  });

  String? type;
  int? id;
  String? headline;
  String? description;
  String? caption;
  String? sizeType;
  int? featureId;
  int? publishOn;
  String? isBookmark;
  String? isLike;
  int? likes;
  List? media;
  List? sources;
  List? comments;
  List? hashtags;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        type: json["type"],
        id: json["id"],
        headline: json["headline"],
        description: json["description"],
        caption: json["caption"],
        sizeType: json["size_type"],
        featureId: json["feature_id"],
        publishOn: json["publish_on"],
        isBookmark: json["is_bookmark"],
        isLike: json["is_like"],
        likes: json["likes"],
        media: List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
        sources:
            List<Source>.from(json["sources"].map((x) => Source.fromJson(x))),
        comments: List<Comment>.from(
            json["comments"].map((x) => Comment.fromJson(x))),
        hashtags: List<Hashtag>.from(
            json["hashtags"].map((x) => Hashtag.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "headline": headline,
        "description": description,
        "caption": caption,
        "size_type": sizeType,
        "feature_id": featureId,
        "publish_on": publishOn,
        "is_bookmark": isBookmark,
        "is_like": isLike,
        "likes": likes,
        "media": List<dynamic>.from(media!.map((x) => x.toJson())),
        "sources": List<dynamic>.from(sources!.map((x) => x.toJson())),
        "comments": List<dynamic>.from(comments!.map((x) => x.toJson())),
        "hashtags": List<dynamic>.from(hashtags!.map((x) => x.toJson())),
      };
}

class Comment {
  Comment({
    this.id,
    this.commentsTitle,
    this.storyId,
    this.userId,
    this.name,
  });

  int? id;
  String? commentsTitle;
  int? storyId;
  int? userId;
  String? name;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        commentsTitle: json["comments_title"],
        storyId: json["story_id"],
        userId: json["user_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "comments_title": commentsTitle,
        "story_id": storyId,
        "user_id": userId,
        "name": name,
      };
}

class Hashtag {
  Hashtag({
    this.hashtagName,
  });

  String? hashtagName;

  factory Hashtag.fromJson(Map<String, dynamic> json) => Hashtag(
        hashtagName: json["hashtag_name"],
      );

  Map<String, dynamic> toJson() => {
        "hashtag_name": hashtagName,
      };
}

class Media {
  Media({
    this.mediaId,
    this.mediaName,
    this.mediaType,
    this.relatedLink,
    this.hotWord,
    this.hotwordMedia,
  });

  int? mediaId;
  String? mediaName;
  String? mediaType;
  dynamic relatedLink;
  String? hotWord;
  String? hotwordMedia;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        mediaId: json["media_id"],
        mediaName: json["media_name"],
        mediaType: json["media_type"],
        relatedLink: json["related_link"],
        hotWord: json["hot_word"],
        hotwordMedia: json["hotword_media"],
      );

  Map<String, dynamic> toJson() => {
        "media_id": mediaId,
        "media_name": mediaName,
        "media_type": mediaType,
        "related_link": relatedLink,
        "hot_word": hotWord,
        "hotword_media": hotwordMedia,
      };
}

class Source {
  Source({
    this.sourceId,
    this.sourceTitle,
    this.sourceLink,
  });

  int? sourceId;
  String? sourceTitle;
  String? sourceLink;

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        sourceId: json["source_id"],
        sourceTitle: json["source_title"],
        sourceLink: json["source_link"],
      );

  Map<String, dynamic> toJson() => {
        "source_id": sourceId,
        "source_title": sourceTitle,
        "source_link": sourceLink,
      };
}
