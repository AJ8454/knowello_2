// To parse this JSON data, do
//
//     final appBarBannerModel = appBarBannerModelFromJson(jsonString);

import 'dart:convert';

AppBarBannerModel appBarBannerModelFromJson(String str) =>
    AppBarBannerModel.fromJson(json.decode(str));

String appBarBannerModelToJson(AppBarBannerModel data) =>
    json.encode(data.toJson());

class AppBarBannerModel {
  AppBarBannerModel({
    this.whatToShow,
    this.autoplay,
    this.bannerName,
    this.data,
  });

  int? whatToShow;
  bool? autoplay;
  String? bannerName;
  List? data;

  factory AppBarBannerModel.fromJson(Map<String, dynamic> json) =>
      AppBarBannerModel(
        whatToShow: json["what_to_show"],
        autoplay: json["autoplay"],
        bannerName: json["banner_name"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "what_to_show": whatToShow,
        "autoplay": autoplay,
        "banner_name": bannerName,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.title,
    this.link = '',
  });

  String? title;
  String? link;

  factory Datum.fromJson(Map<String, dynamic> json) =>
      Datum(title: json["title"], link: json["link"]);

  Map<String, dynamic> toJson() => {
        "title": title,
        "link": link,
      };
}
