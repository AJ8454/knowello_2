import 'package:flutter/material.dart';
import 'package:knowello_ui/models/reel_model/knowello_reel_model.dart';
import 'package:knowello_ui/widgets/clip_ui.dart';

class YoutubeList extends StatefulWidget {
  final List<VResult> videoDetails;
  final int startIndex;
  final Function? loadMoreData;
  const YoutubeList(this.videoDetails,
      {this.startIndex = 0, this.loadMoreData, Key? key})
      : super(key: key);

  @override
  State<YoutubeList> createState() => _YoutubeListState();
}

class _YoutubeListState extends State<YoutubeList> {
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.startIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.startIndex > widget.videoDetails.length - 7) {
      widget.loadMoreData!(widget.startIndex);
      setState(() {});
    }
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: PageView.builder(
            controller: _pageController,
            itemBuilder: (context, index) => ClipUI(
              videoDetail: widget.videoDetails[index],
            ),
            itemCount: widget.videoDetails.length,
            scrollDirection: Axis.vertical,
            onPageChanged: (i) {
              widget.loadMoreData!(i);
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}
