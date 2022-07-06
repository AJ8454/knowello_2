import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:knowello_ui/models/story_model/story_model.dart';
import 'package:knowello_ui/providers/story_provider/story_provider.dart';
import 'package:knowello_ui/screens/single_feeds/single_post.dart';
import 'package:knowello_ui/utils/constant.dart';
import 'package:knowello_ui/utils/global_keys.dart';
import 'package:knowello_ui/widgets/web_view_widget.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:validators/validators.dart';

class CarouselCard extends StatefulWidget {
  const CarouselCard({this.postdata, Key? key}) : super(key: key);
  final PostData? postdata;

  @override
  State<CarouselCard> createState() => _CarouselCardState();
}

class _CarouselCardState extends State<CarouselCard> {
  final TextEditingController _commentTextcontroller = TextEditingController();
  int activeIndex = 0;
  bool showSourceContainer = false;
  bool isTextExp = false;
  double? aRatio;
  bool showTags = false, enableCommentPostButton = false;
  bool isLikePress = false, isBookMarkPress = false;
  late Stream loadCommentStreamAgain;
  List allComments = [];

  @override
  void initState() {
    super.initState();

    if (widget.postdata!.isLike == "1") {
      setState(() => isLikePress = true);
    }
    if (widget.postdata!.isBookmark == "1") {
      setState(() => isBookMarkPress = true);
    }
    cardSize();
  }

  @override
  void dispose() {
    imageCache.clear();
    imageCache.clearLiveImages();
    super.dispose();
  }

  likeAndBookmarkpost({String? type}) async {
    final provider = Provider.of<StoryProvider>(context, listen: false);
    await provider.postlikeAndBookmarkStories(
      storyId: widget.postdata!.id,
      type: type,
      loginUID: 442,
      status: type == 'like'
          ? isLikePress
              ? 1
              : 0
          : isBookMarkPress
              ? 1
              : 0,
    );
    // toastView(message: "$result  ${widget.postdata!.id}");
  }

  Stream getComments() async* {
    allComments = await Provider.of<StoryProvider>(context, listen: false)
        .getallStoriesComments(
      storyId: widget.postdata!.id,
    );
    yield allComments;
  }

  Future postComment() async {
    await Provider.of<StoryProvider>(context, listen: false)
        .postStoriesComments(
      storyId: widget.postdata!.id,
      commentText: _commentTextcontroller.text,
    );
    // toastView(message: result);
  }

  showCommentBox() async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              children: [
                Dialog(
                  backgroundColor:
                      Theme.of(context).appBarTheme.backgroundColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 4,
                        child: StreamBuilder(
                          stream: loadCommentStreamAgain,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (allComments.isEmpty) {
                              return Center(
                                child: Text(
                                  'No Comments yet...',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              );
                            } else {
                              return ListView.builder(
                                reverse: true,
                                itemCount: allComments.length,
                                itemBuilder: (context, index) {
                                  int itemCount = allComments.length;
                                  int reversedIndex = itemCount - 1 - index;
                                  return allComments[reversedIndex]
                                              ['user_id'] ==
                                          appDBUserId
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 100),
                                          child: Bubble(
                                            margin:
                                                const BubbleEdges.only(top: 10),
                                            nip: BubbleNip.rightTop,
                                            color: const Color.fromRGBO(
                                                225, 255, 199, 1.0),
                                            child: Text(
                                                allComments[reversedIndex]
                                                    ['comments']!,
                                                textAlign: TextAlign.right),
                                          ),
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(right: 100),
                                          child: Bubble(
                                            margin:
                                                const BubbleEdges.only(top: 10),
                                            nip: BubbleNip.leftTop,
                                            color: const Color.fromRGBO(
                                                225, 255, 199, 1.0),
                                            child: Text(
                                                allComments[index]['comments']!,
                                                textAlign: TextAlign.right),
                                          ),
                                        );
                                },
                              );
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 9,
                                  child: TextFormField(
                                    controller: _commentTextcontroller,
                                    decoration: InputDecoration(
                                      hintText: "Add a comment...",
                                      hintStyle: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        borderSide: const BorderSide(
                                          color: Colors.blue,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      if (value.isEmpty || value == " ") {
                                        _commentTextcontroller.clear();
                                        setState(() =>
                                            enableCommentPostButton = false);
                                      } else {
                                        setState(() =>
                                            enableCommentPostButton = true);
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                    flex: 2,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(13),
                                      onTap: enableCommentPostButton
                                          ? () {
                                              if (_commentTextcontroller
                                                  .text.isEmpty) {
                                                toastView(
                                                    message:
                                                        'Please enter something');
                                              } else {
                                                postComment().then((_) {
                                                  _commentTextcontroller
                                                      .clear();
                                                  loadCommentStreamAgain =
                                                      getComments();
                                                  setState(() {});
                                                });
                                              }
                                            }
                                          : null,
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: enableCommentPostButton
                                              ? Colors.blue
                                              : Colors.grey,
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 14,
                  top: 0.0,
                  child: ElevatedButton(
                    onPressed: () {
                      _commentTextcontroller.clear();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      primary: Colors.blue, // <-- Button color
                      onPrimary: Colors.red, // <-- Splash color
                    ),
                    child: Icon(
                      Icons.cancel,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  cardSize() {
    // for (var element in widget.postdata!.media!) {
    //   Image image = Image.network(element.mediaName!);
    //   image.image
    //       .resolve(const ImageConfiguration())
    //       .addListener(ImageStreamListener((ImageInfo info, bool isSync) {
    //     aRatio = info.image.width / info.image.height;
    //   }));
    // }
    // print(aRatio);

    if (widget.postdata!.sizeType == 'l') {
      return 0.5625; // large
    } else if (widget.postdata!.sizeType == 'm') {
      return 1.0; // mid
    } else {
      return 2.0; // small
    }
  }

  showHotwordMediaDialog({String? hotUrl}) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: SizedBox(
                child: CachedNetworkImage(
                  imageUrl: hotUrl!,
                  width: double.infinity,
                  fit: BoxFit.fill,
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
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Card(
        shadowColor: Colors.black,
        elevation: 3.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        color: Theme.of(context).secondaryHeaderColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: CarouselSlider(
                items: widget.postdata!.media!
                    .map((p) => Stack(
                          children: [
                            InkWell(
                              onTap: p.tappableLink == null
                                  ? null
                                  : () async {
                                      if (isURL(p.tappableLink!)) {
                                        Navigator.pushNamed(
                                            context, '/webViewPage',
                                            arguments: p.tappableLink);
                                      } else if (p.tappableLink!
                                          .startsWith('s')) {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SinglePostFeed(
                                                    storyId: p.tappableLink!
                                                        .replaceAll('s', '')),
                                          ),
                                        ).then((_) {
                                          // setState(() {});
                                          // homeStateglobalKey.currentState
                                          //     ?.update();
                                        });
                                      }
                                    },
                              child: CachedNetworkImage(
                                imageUrl: p.mediaName!,
                                width: double.infinity,
                                fit: BoxFit.fill,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.black,
                                    color: Colors.white,
                                    strokeWidth: 1,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                  child: Text(
                                    "Couldn't load image.",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0.0,
                              bottom: 0.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  p.relatedLink != null
                                      ? IconButton(
                                          onPressed: () async {
                                            if (isURL(p.relatedLink!)) {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      WebViewWidget(
                                                    url: Uri.parse(
                                                            p.relatedLink!)
                                                        .toString(),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SinglePostFeed(
                                                          storyId:
                                                              p.relatedLink!),
                                                ),
                                              ).then((_) {
                                                // setState(() {});
                                                homeStateglobalKey.currentState
                                                    ?.update();
                                              });
                                            }
                                          },
                                          icon: Icon(
                                            Icons.link,
                                            size: width(context)! * 0.05,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  p.hotwordMedia != ''
                                      ? IconButton(
                                          onPressed: () async {
                                            await showHotwordMediaDialog(
                                                hotUrl: p.hotwordMedia);
                                          },
                                          icon: Icon(
                                            Icons.fireplace,
                                            size: width(context)! * 0.05,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  IconButton(
                                    onPressed: () {
                                      setState(() =>
                                          isBookMarkPress = !isBookMarkPress);
                                      likeAndBookmarkpost(type: 'bookmark');
                                    },
                                    icon: Icon(
                                      Icons.bookmark_border,
                                      color: isBookMarkPress
                                          ? Colors.blue
                                          : Theme.of(context).primaryColor,
                                      size: width(context)! * 0.05,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            showSourceContainer
                                ? Positioned(
                                    bottom: 0.0,
                                    child: AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: const Duration(seconds: 1),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: Container(
                                            width: width(context)! * 0.4,
                                            height: 90,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .appBarTheme
                                                  .backgroundColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                            ),
                                            child: widget
                                                    .postdata!.sources!.isEmpty
                                                ? Center(
                                                    child: Text(
                                                      'Empty',
                                                      style: themeTextStyle(
                                                          context: context),
                                                    ),
                                                  )
                                                : Scrollbar(
                                                    thumbVisibility: true,
                                                    thickness: 5,
                                                    interactive: true,
                                                    radius:
                                                        const Radius.circular(
                                                            50),
                                                    child: ListView.builder(
                                                      itemCount: widget
                                                          .postdata!
                                                          .sources!
                                                          .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return TextButton.icon(
                                                          onPressed: () async {
                                                            Navigator.pushNamed(
                                                                context,
                                                                '/webViewPage',
                                                                arguments: widget
                                                                    .postdata!
                                                                    .sources![
                                                                        index]
                                                                    .sourceLink);
                                                          },
                                                          icon: const Icon(
                                                              Icons.link),
                                                          label: SizedBox(
                                                            width: width(
                                                                    context)! *
                                                                0.27,
                                                            child: Text(
                                                              '${widget.postdata!.sources![index].sourceTitle}',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontSize: fontSize(
                                                                        context)! *
                                                                    12,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ))
                    .toList(),
                options: CarouselOptions(
                  // height: cardSize(),
                  aspectRatio: cardSize(),
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  initialPage: 0,
                  scrollDirection: Axis.horizontal,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() => activeIndex = index);
                  },
                ),
              ),
            ),
            widget.postdata!.showCTA == 0
                ? const SizedBox.shrink()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                showSourceContainer = !showSourceContainer;
                              });
                            },
                            icon: Icon(
                              Icons.travel_explore,
                              size: width(context)! * 0.05,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            DateFormat("MMMM d").format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    widget.postdata!.publishOn! * 1000)),
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Theme.of(context).primaryColor,
                              fontSize: fontSize(context)! * 12,
                            ),
                          ),
                          const Spacer(),
                          const Spacer(),
                          widget.postdata!.media!.length == 1
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AnimatedSmoothIndicator(
                                    activeIndex: activeIndex,
                                    count: widget.postdata!.media!.length,
                                    effect: const ExpandingDotsEffect(
                                      dotHeight: 6,
                                      dotWidth: 6,
                                      spacing: 2,
                                      activeDotColor: Colors.grey,
                                      dotColor: Colors.grey,
                                    ),
                                  ),
                                ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              setState(() => isLikePress = !isLikePress);
                              likeAndBookmarkpost(type: 'like');
                            },
                            icon: Icon(
                              Icons.thumb_up_alt_outlined,
                              color: isLikePress
                                  ? Colors.blue
                                  : Theme.of(context).primaryColor,
                              size: width(context)! * 0.05,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              loadCommentStreamAgain = getComments();
                              await showCommentBox();
                            },
                            icon: Icon(
                              Icons.chat_bubble_outline,
                              size: width(context)! * 0.05,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.share_outlined,
                              size: width(context)! * 0.05,
                            ),
                          ),
                        ],
                      ),
                      widget.postdata!.caption != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: widget.postdata!.caption!.length <= 100
                                      ? Text(
                                          widget.postdata!.caption!,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: fontSize(context)! * 16,
                                          ),
                                        )
                                      : Wrap(
                                          children: [
                                            Text(
                                              widget.postdata!.caption!,
                                              maxLines: showTags ? null : 2,
                                              softWrap: true,
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize:
                                                    fontSize(context)! * 16,
                                              ),
                                            ),
                                            showTags
                                                ? const SizedBox.shrink()
                                                : InkWell(
                                                    onTap: () {
                                                      setState(() =>
                                                          showTags = true);
                                                    },
                                                    child: Text(
                                                      '...More',
                                                      style: TextStyle(
                                                        color: Colors.lightBlue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            fontSize(context)! *
                                                                16,
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                ),
                                const SizedBox(height: 7),
                                widget.postdata!.caption!.length <= 100
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Wrap(
                                          spacing: 12,
                                          runSpacing: 5,
                                          children: [
                                            ...widget.postdata!.hashtags!.map(
                                              (e) => InkWell(
                                                onTap: () {
                                                  toastView(
                                                      message:
                                                          '#${e.hashtagName!}');
                                                },
                                                child: Text(
                                                  '#${e.hashtagName!}',
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize:
                                                        fontSize(context)! * 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          showTags
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: Wrap(
                                                      spacing: 8,
                                                      runSpacing: 5,
                                                      children: [
                                                        ...widget
                                                            .postdata!.hashtags!
                                                            .map(
                                                          (e) => InkWell(
                                                            onTap: () {
                                                              toastView(
                                                                  message:
                                                                      '#${e.hashtagName!}');
                                                            },
                                                            child: Text(
                                                              '#${e.hashtagName!}',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontSize: fontSize(
                                                                        context)! *
                                                                    16,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() =>
                                                                showTags =
                                                                    false);
                                                          },
                                                          child: Text(
                                                            'Less',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .lightBlue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: fontSize(
                                                                      context)! *
                                                                  16,
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                )
                                              : const SizedBox.shrink(),
                                        ],
                                      ),
                              ],
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 8),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
