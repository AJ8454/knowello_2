import 'package:flutter/material.dart';
import 'package:knowello_ui/models/story_model/story_model.dart';
import 'package:knowello_ui/providers/story_provider/story_provider.dart';
import 'package:knowello_ui/utils/constant.dart';
import 'package:knowello_ui/widgets/carosule_card.dart';
import 'package:provider/provider.dart';

class SinglePostFeed extends StatefulWidget {
  const SinglePostFeed({Key? key, this.storyId}) : super(key: key);
  final String? storyId;
  @override
  State<SinglePostFeed> createState() => _SinglePostFeedState();
}

class _SinglePostFeedState extends State<SinglePostFeed> {
  bool isLoading = true;
  PostData? postData;
  @override
  void initState() {
    fetchSingleStory();
    super.initState();
  }

  fetchSingleStory() async {
    postData = await Provider.of<StoryProvider>(context, listen: false)
        .getSingleStories(storyId: widget.storyId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : postData == null
              ? Center(
                  child: Text(
                    'No Data found..',
                    style: themeTextStyle(context: context),
                  ),
                )
              : CarouselCard(
                  postdata: postData,
                ),
    );
  }
}
