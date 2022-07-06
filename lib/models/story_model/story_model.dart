// To parse this JSON data, do
//
//     final storyModel = storyModelFromJson(jsonString);

import 'dart:convert';

StoryModel storyModelFromJson(String str) =>
    StoryModel.fromJson(json.decode(str));

String storyModelToJson(StoryModel data) => json.encode(data.toJson());

class StoryModel {
  StoryModel({
    this.pageToken,
    this.data,
  });

  int? pageToken;
  List<PostData>? data;

  factory StoryModel.fromJson(Map<String, dynamic> json) => StoryModel(
        pageToken: json["page_token"],
        data:
            List<PostData>.from(json["data"].map((x) => PostData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "page_token": pageToken,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class PostData {
  PostData({
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
    this.showCTA,
    this.likes,
    this.media,
    this.sources,
    // this.comments,
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
  int? showCTA;
  int? likes;
  List<Media>? media;
  List<Sources>? sources;
  // List<Comment>? comments;
  List<Hashtag>? hashtags;

  factory PostData.fromJson(Map<String, dynamic> json) => PostData(
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
        showCTA: json["show_cta"],
        likes: json["likes"],
        media: List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
        sources:
            List<Sources>.from(json["sources"].map((x) => Sources.fromJson(x))),
        // comments: List<Comment>.from(
        //     json["comments"].map((x) => Comment.fromJson(x))),
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
        "show_cta": showCTA,
        "likes": likes,
        "media": List<dynamic>.from(media!.map((x) => x.toJson())),
        "sources": List<dynamic>.from(sources!.map((x) => x.toJson())),
        // "comments": List<dynamic>.from(comments!.map((x) => x.toJson())),
        "hashtags": List<dynamic>.from(hashtags!.map((x) => x.toJson())),
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

// To parse this JSON data, do
//
//     final sources = sourcesFromJson(jsonString);

List<Sources> sourcesFromJson(String str) =>
    List<Sources>.from(json.decode(str).map((x) => Sources.fromJson(x)));

String sourcesToJson(List<Sources> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Sources {
  Sources({
    this.sourceId,
    this.sourceTitle,
    this.sourceLink,
  });

  int? sourceId;
  String? sourceTitle;
  String? sourceLink;

  factory Sources.fromJson(Map<String, dynamic> json) => Sources(
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

class Media {
  Media({
    this.mediaId,
    this.mediaName,
    this.mediaType,
    this.relatedLink,
    this.hotWord,
    this.hotwordMedia,
    this.tappableLink,
  });

  int? mediaId;
  String? mediaName;
  String? mediaType;
  String? relatedLink;
  String? hotWord;
  String? hotwordMedia;
  String? tappableLink;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        mediaId: json["media_id"],
        mediaName: json["media_name"],
        mediaType: json["media_type"],
        relatedLink: json["related_link"],
        hotWord: json["hot_word"],
        hotwordMedia: json["hotword_media"],
        tappableLink: json["tappable_link"],
      );

  Map<String, dynamic> toJson() => {
        "media_id": mediaId,
        "media_name": mediaName,
        "media_type": mediaType,
        "related_link": relatedLink,
        "hot_word": hotWord,
        "hotword_media": hotwordMedia,
        "tappable_link": tappableLink,
      };
}

// To parse this JSON data, do
//
//     final storyCommentModel = storyCommentModelFromJson(jsonString);

List<StoryCommentModel> storyCommentModelFromJson(String str) =>
    List<StoryCommentModel>.from(
        json.decode(str).map((x) => StoryCommentModel.fromJson(x)));

String storyCommentModelToJson(List<StoryCommentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoryCommentModel {
  StoryCommentModel({
    this.storyId,
    this.userId,
    this.comments,
    this.name,
  });

  int? storyId;
  int? userId;
  String? comments;
  String? name;

  factory StoryCommentModel.fromJson(Map<String, dynamic> json) =>
      StoryCommentModel(
        storyId: json["story_id"],
        userId: json["user_id"],
        comments: json["comments"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "story_id": storyId,
        "user_id": userId,
        "comments": comments,
        "name": name,
      };
}
