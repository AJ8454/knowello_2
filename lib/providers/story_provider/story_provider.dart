import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:knowello_ui/models/story_model/story_model.dart';
import 'package:knowello_ui/providers/api_endpoints.dart';
import 'package:knowello_ui/utils/constant.dart';
import 'package:knowello_ui/utils/global_keys.dart';

class StoryProvider with ChangeNotifier {
  Dio dio = Dio();

  // setter
  final List<PostData> _items = [];

  // getter
  List<PostData> get items {
    return [..._items];
  }

  PostData findById(int? id) =>
      _items.firstWhere((element) => element.id! == id!);

  Future getallStories(
      {String? url, int? newPageToken, String? storyType}) async {
    try {
      final body = {
        "login_user_id": appDBUserId,
        "page_token": newPageToken ?? 0
      };

      final body2 = {
        "login_user_id": appDBUserId,
        "page_token": 0,
        "kb_type": storyType,
      };

      final response = await http.post(Uri.parse(url!),
          body: jsonEncode(storyType == null ? body : body2));
      if (response.statusCode == 200) {
        if (newPageToken == 0 && storyType == null) {
          APICacheDBModel cacheDBModel = APICacheDBModel(
            key: 'exploreStoriesData',
            syncData: response.body,
          );
          await APICacheManager().addCacheData(cacheDBModel);
        }
        StoryModel storyModel = StoryModel.fromJson(json.decode(response.body));
        notifyListeners();
        return storyModel;
      } else {
        notifyListeners();
        log('no data found in all story');
      }
    } catch (e) {
      if (e is SocketException) {
        toastView(message: "Please check your Internet connection..");
      }
      log('error in all story = $e');
    }
  }

  Future getSingleStories({String? storyId}) async {
    try {
      final body = {
        "login_user_id": appDBUserId,
        "page_token": 0,
        "story_id": storyId
      };

      final response =
          await http.post(Uri.parse(singleStoryUrl), body: jsonEncode(body));
      if (response.statusCode == 200) {
        StoryModel storyModel = StoryModel.fromJson(json.decode(response.body));
        notifyListeners();
        if (storyModel.data!.isNotEmpty) {
          return storyModel.data![0];
        } else {
          return null;
        }
      } else {
        notifyListeners();
        log('no single story data found in all story');
      }
    } catch (e) {
      log('error no single story = $e');
    }
  }

  Future postlikeAndBookmarkStories(
      {String? type, int? status, int? storyId, int? loginUID}) async {
    try {
      final body = {
        "type": type,
        "is_status": status,
        "story_id": storyId,
        "login_user_id": loginUID
      };
      final response = await http.post(Uri.parse(storyBookmarkLikeUrl),
          body: jsonEncode(body));
      if (response.statusCode == 200) {
        notifyListeners();
        return type == 'like' ? 'Like Successfull' : 'BookMark Successfull';
      } else {
        notifyListeners();
        log('Error on like and Bookmark api');
        return 'Error on like and Bookmark api';
      }
    } catch (e) {
      log('error in all story = $e');
    }
  }

  Future getallStoriesComments({int? storyId}) async {
    try {
      final body = {"story_id": storyId};
      final response =
          await http.post(Uri.parse(getAllCommentsUrl), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        notifyListeners();
        return data;
      } else {
        notifyListeners();
        log('no comment data found in all story');
      }
    } catch (e) {
      log('error in all comments = $e');
    }
  }

  Future postStoriesComments({int? storyId, String? commentText}) async {
    try {
      final body = {
        "story_id": storyId,
        "login_user_id": appDBUserId,
        "comment": commentText
      };
      final response = await http.post(Uri.parse(postStoryCommentUrl),
          body: jsonEncode(body));
      if (response.statusCode == 200) {
        notifyListeners();
        return "Comment Success";
      } else {
        notifyListeners();
        return "error Comment Success";
      }
    } catch (e) {
      log('error in post comments = $e');
    }
  }
}
