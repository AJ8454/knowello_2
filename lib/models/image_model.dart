import 'dart:convert';

KnowelloGramModel knowelloGramModelFromJson(String str) =>
    KnowelloGramModel.fromJson(json.decode(str));

String knowelloGramModelToJson(KnowelloGramModel data) =>
    json.encode(data.toJson());

class KnowelloGramModel {
  KnowelloGramModel({
    required this.posts,
  });

  List<Post>? posts = [
    
  ];

  factory KnowelloGramModel.fromJson(Map<String, dynamic> json) =>
      KnowelloGramModel(
        posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "posts": List<dynamic>.from(posts!.map((x) => x.toJson())),
      };
}

class Post {
  Post({
    required this.images,
    required this.description,
    required this.postedBy,
    required this.profileImage,
    required this.imageSize,
  });

  List images;
  String? description;
  String? postedBy;
  String? profileImage;
  String? imageSize;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        images: List<String>.from(json["images"].map((x) => x)),
        description: json["description"],
        postedBy: json["postedBy"],
        profileImage: json["profileImage"],
        imageSize: json["profileImage"],
      );

  Map<String, dynamic> toJson() => {
        "images": List<dynamic>.from(images.map((x) => x)),
        "description": description,
        "postedBy": postedBy,
        "profileImage": profileImage,
      };
}

class Interactions {
  Interactions({
    required this.likes,
    required this.comments,
    required this.bookmarked,
  });

  int? likes;
  int? comments;
  bool? bookmarked;

  factory Interactions.fromJson(Map<String, dynamic> json) => Interactions(
        likes: json["likes"],
        comments: json["comments"],
        bookmarked: json["bookmarked"],
      );

  Map<String, dynamic> toJson() => {
        "likes": likes,
        "comments": comments,
        "bookmarked": bookmarked,
      };
}
