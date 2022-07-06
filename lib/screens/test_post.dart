import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:knowello_ui/models/post_model.dart';
import 'package:http/http.dart' as http;

class TestPost extends StatefulWidget {
  const TestPost({Key? key}) : super(key: key);

  @override
  State<TestPost> createState() => _TestPostState();
}

class _TestPostState extends State<TestPost> {
  final controller = ScrollController();
  Dio dio = Dio();
  bool isLoading = true;
  List<Datum> items = [];
  int pageToken = 0;

  bool firstload = true;

  @override
  void initState() {
    if (firstload) {
      fetch();
    }
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future fetch() async {
    const url = 'http://15.206.178.102:9004/api/v3/home/main_stories';
    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode({"login_user_id": 442, "page_token": pageToken}));
      var extractedData = json.decode(response.body);
      List<Datum> postsData;
      postsData = List.generate(
        extractedData['data'].length,
        (index) => Datum(
          type: extractedData['data'][index]['type'],
          id: extractedData['data'][index]['id'],
          headline: extractedData['data'][index]['headline'],
          description: extractedData['data'][index]['description'],
          caption: extractedData['data'][index]['caption'],
          sizeType: extractedData['data'][index]['sizeType'],
          featureId: extractedData['data'][index]['featureId'],
          publishOn: extractedData['data'][index]['publishOn'],
          isBookmark: extractedData['data'][index]['isBookmark'],
          isLike: extractedData['data'][index]['isLike'],
          likes: extractedData['data'][index]['likes'],
          media: extractedData['data'][index]['media'],
          sources: extractedData['data'][index]['sources'],
          comments: extractedData['data'][index]['comments'],
          hashtags: extractedData['data'][index]['hashtags'],
        ),
      );

      pageToken = extractedData['page_token'];
      items.addAll(postsData);
      await loadImage();
    } catch (e) {
      log('$e');
    }
  }

  List allImages = [];
  loadImage() async {
    allImages.clear();
    for (var element in items) {
      for (var melement in element.media!) {
        if (melement["media_type"] == "image") {
          allImages.add(melement['media_name']);
        }
      }
    }
    setState(() {
      isLoading = false;
      firstload = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: controller,
              scrollDirection: Axis.vertical,
              itemCount: allImages.length + 1,
              itemBuilder: (context, index) {
                if (index < allImages.length) {
                  return CachedNetworkImage(
                    imageUrl: allImages[index],
                    width: double.infinity,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.black,
                        color: Colors.white,
                        strokeWidth: 1,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Text(
                        "Couldn't load image.",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
            ),
    );
  }
}
