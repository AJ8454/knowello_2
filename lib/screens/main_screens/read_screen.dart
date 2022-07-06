import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:knowello_ui/models/story_model/story_model.dart';
import 'package:knowello_ui/providers/api_endpoints.dart';
import 'package:knowello_ui/providers/story_provider/story_provider.dart';
import 'package:knowello_ui/widgets/carosule_card.dart';
import 'package:provider/provider.dart';

class ReadScreen extends StatefulWidget {
  const ReadScreen({Key? key}) : super(key: key);

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  final ScrollController _scrollController = ScrollController();

  late Future<List<PostData>?> dataload;

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
    try {
      StoryModel data = await Provider.of<StoryProvider>(context, listen: false)
          .getallStories(url: mainStoryUrl, newPageToken: token ?? pageToken);
      pageToken = data.pageToken!;
      setState(() {
        postdata.addAll(data.data!);
        isLoading = false;
      });

      return postdata;
    } catch (e) {
      log('Error while fetching stories');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<PostData>?>(
              future: dataload,
              builder: (context, snapshot) {
                if (snapshot.hasError && snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Data Found'));
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data!.length + 1,
                    itemBuilder: (context, index) {
                      if (index == snapshot.data!.length - 3) {
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
            ),
    );
  }
}
