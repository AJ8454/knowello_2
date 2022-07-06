import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:knowello_ui/models/reel_model/knowello_reel_model.dart';
import 'package:knowello_ui/providers/api_endpoints.dart';
import 'package:knowello_ui/providers/reel_provider/knowello_reel_provider.dart';
import 'package:knowello_ui/widgets/youtube_videos.dart';
import 'package:provider/provider.dart';

class WatchScreen extends StatefulWidget {
  const WatchScreen({Key? key}) : super(key: key);

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  final _scrollController = ScrollController();
  List<VResult> allVideoThumb = [];
  bool isLoading = true;
  int pageToken = 0;

  @override
  void initState() {
    fetchdata(token: 0);
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        fetchdata();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  updategrid() {
    setState(() => isLoading = true);
    allVideoThumb.clear();
    fetchdata(token: 0);
  }

  fetchdata({int? token}) async {
    KnowelloReelModel reelModel =
        await Provider.of<KnowelloReelProvider>(context, listen: false)
            .getReelVideos(
      newPageToken: token ?? pageToken,
      url: reelVideoUrl,
    );
    pageToken = reelModel.pageToken!;
    allVideoThumb.addAll(reelModel.vResult!);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              backgroundColor: Colors.black,
              color: Colors.white,
              strokeWidth: 1,
            ))
          : allVideoThumb.isEmpty
              ? const Center(child: Text('No videos yet..'))
              : GridView.builder(
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    childAspectRatio: 1 / 2,
                  ),
                  itemCount: allVideoThumb.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index < allVideoThumb.length) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => YoutubeList(
                                    allVideoThumb,
                                    startIndex: index,
                                    loadMoreData: (value) {
                                      if (value > allVideoThumb.length - 7) {
                                        fetchdata();
                                      }
                                    },
                                  )));
                          //  _setSelectedVideo((baseIndex * 2) + baseIndex + i)
                        },
                        child: CachedNetworkImage(
                          imageUrl: allVideoThumb[index].thumbnail!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.black,
                                color: Colors.white,
                                strokeWidth: 1),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      );
                    } else {
                      return const Center(
                          child: CircularProgressIndicator(
                        backgroundColor: Colors.black,
                        color: Colors.white,
                        strokeWidth: 1,
                      ));
                    }
                  }),
    );
  }
}
