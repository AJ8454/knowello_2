import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:knowello_ui/models/reel_model/knowello_reel_model.dart';
import 'package:knowello_ui/utils/global_keys.dart';

class KnowelloReelProvider with ChangeNotifier {
  Future getReelVideos(
      {String? url, int? newPageToken, String? videoId}) async {
    try {
      final body1 = {"page_token": newPageToken, "user_id": appDBUserId};
      final body2 = {"video_id": videoId, "user_id": appDBUserId};

      final response = await http.post(Uri.parse(url!),
          body: jsonEncode(videoId == null ? body1 : body2));
      if (response.statusCode == 200) {
        KnowelloReelModel knowelloReelModel =
            KnowelloReelModel.fromJson(json.decode(response.body));
        notifyListeners();
        return knowelloReelModel;
      } else {
        notifyListeners();
        log('no vido data found');
      }
    } catch (e) {
      log('video get = $e');
    }
  }

  Future getVideoComments({String? url, int? videoId}) async {
    try {
      final body = {'video_id': videoId};
      final response = await http.post(Uri.parse(url!), body: jsonEncode(body));
      if (response.statusCode == 200) {
        var extractedData = json.decode(response.body);
        if (extractedData != []) {
          VideoComments videoComments = VideoComments.fromJson(extractedData);
          notifyListeners();
          return videoComments;
        } else {
          notifyListeners();
          return null;
        }
      } else {
        notifyListeners();
        log('no vido data found');
      }
    } catch (e) {
      log('video coment get = $e');
    }
  }
}
