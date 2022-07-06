import 'dart:convert';
import 'dart:developer';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:knowello_ui/models/story_model/story_model.dart';
import 'package:knowello_ui/providers/api_endpoints.dart';
import 'package:knowello_ui/providers/local_pref/store_local_preference.dart';
import 'package:knowello_ui/providers/network_service.dart';
import 'package:knowello_ui/providers/story_provider/story_provider.dart';
import 'package:knowello_ui/widgets/carosule_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged? update;
  const HomeScreen({
    Key? key,
    this.update,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  late Future<List<PostData>?> dataload;
  bool? isOnline = true;
  bool isLoading = true;

  int cardScrollIndex = 0;
  int pageToken = 0;

  List<PostData> postdata = [];

  @override
  void initState() {
    super.initState();
    dataload = fetchAllStories();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  update() {
    setState(() => isLoading = true);
    postdata.clear();
    fetchAllStories(token: 0);
  }

  Future<List<PostData>?> fetchAllStories({int? token}) async {
    final provider = Provider.of<StoryProvider>(context, listen: false);

    await APICacheManager().isAPICacheKeyExist("exploreStoriesData");
    log('${LocalPreference.getStoredIsOnline()}');
    isOnline = LocalPreference.getStoredIsOnline() ?? true;
    try {
      if (isOnline!) {
        print("from API data");
        StoryModel data = await provider.getallStories(
            url: mainStoryUrl, newPageToken: token ?? pageToken);
        pageToken = data.pageToken!;
        setState(() {
          postdata.addAll(data.data!);
          isLoading = false;
        });
        return postdata;
      } else {
        print('from cache data');
        postdata.clear();
        var cacheData =
            await APICacheManager().getCacheData('exploreStoriesData');
        StoryModel storyModel =
            StoryModel.fromJson(json.decode(cacheData.syncData));
        pageToken = storyModel.pageToken!;
        setState(() {
          if (token == 0 || token == null) {
            postdata.addAll(storyModel.data!);
          }
          isLoading = false;
        });
        return postdata;
      }
    } catch (e) {
      log('Error while fetching stories $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<ConnectivityProvider>(builder: (context, model, child) {
              if (model.isOnline != null) {
                LocalPreference.setIsOnline(model.isOnline!);
                return FutureBuilder<List<PostData>?>(
                  future: dataload,
                  builder: (context, snapshot) {
                    if (snapshot.hasError && snapshot.data!.isEmpty) {
                      return const Center(child: Text('No Data Found'));
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: snapshot.data!.length + 1,
                        itemBuilder: (context, index) {
                          if (index == snapshot.data!.length - 3 &&
                              isOnline == true) {
                            dataload = fetchAllStories();
                          }
                          if (index < snapshot.data!.length) {
                            return CarouselCard(
                              postdata: snapshot.data![index],
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.black,
                                color: Colors.white,
                                strokeWidth: 1,
                              ),
                            );
                          }
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
    );
  }
}
