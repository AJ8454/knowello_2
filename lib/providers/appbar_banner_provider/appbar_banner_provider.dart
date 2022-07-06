import 'dart:convert';
import 'dart:developer';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:knowello_ui/models/appbar_banner_model.dart';
import 'package:knowello_ui/providers/api_endpoints.dart';

class AppBarBannerProvider with ChangeNotifier {
  Dio dio = Dio();
  // setter
  final List<AppBarBannerModel> _items = [];

  // getter
  List<AppBarBannerModel> get items {
    return [..._items];
  }

  Future getbanners() async {
    try {
      var response = await http.get(Uri.parse(appbarBannerUrl));
      if (response.statusCode == 200) {
        APICacheDBModel cacheDBModel = APICacheDBModel(
          key: 'appBarBannerkey',
          syncData: response.body,
        );
        await APICacheManager().addCacheData(cacheDBModel);
        AppBarBannerModel appBarBannerModel =
            AppBarBannerModel.fromJson(jsonDecode(response.body));
        return appBarBannerModel;
      }
    } catch (e) {
      log('message = $e');
    }
    notifyListeners();
  }
}
