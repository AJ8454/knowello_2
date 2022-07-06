import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:knowello_ui/models/reel_model/knowello_reel_model.dart';
import 'package:knowello_ui/providers/api_endpoints.dart';
import 'package:knowello_ui/providers/local_pref/store_local_preference.dart';
import 'package:knowello_ui/providers/reel_provider/knowello_reel_provider.dart';
import 'package:knowello_ui/utils/constant.dart';
import 'package:knowello_ui/utils/global_keys.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ClipUI extends StatefulWidget {
  final VResult? videoDetail;
  const ClipUI({Key? key, this.videoDetail}) : super(key: key);

  @override
  State<ClipUI> createState() => _ClipUIState();
}

class _ClipUIState extends State<ClipUI> with TickerProviderStateMixin {
  final TextEditingController _commentTextcontroller = TextEditingController();
  ValueNotifier<int?> commentCount = ValueNotifier(0);
  ValueNotifier<bool> isLike = ValueNotifier(false);
  YoutubePlayerController? _controller;
  AnimationController? _anicontroller;
  Animation<double>? _animation;
  bool isLikedPressed = false;
  bool isPlayingClip = true;
  var player = const YoutubePlayerIFrame();
  var currentState = PlayerState.playing;
  var volumeMuted = false;
  var _sub;
  bool isVolumeMute = false;
  List<VideoComments>? commentsList;
  late Stream<List?> loadCommentStreamAgain;

  @override
  void initState() {
    // isLike.value = widget.videoDetail!.isLikedByLogUser == '1' ? true : false;
    _anicontroller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _animation = CurvedAnimation(
      parent: _anicontroller!,
      curve: Curves.fastLinearToSlowEaseIn,
    );
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoDetail!.link!
          .replaceAll("https://www.youtube.com/watch?v=", "")
          .replaceAll("https://m.youtube.com/watch?v=", ""),
      params: YoutubePlayerParams(
        autoPlay: true,
        showFullscreenButton: true,
        desktopMode: false,
        privacyEnhanced: true,
        useHybridComposition: true,
        mute: LocalPreference.getStoredVolume() ?? false,
        strictRelatedVideos: false,
        showControls: false,
        showVideoAnnotations: true,
      ),
    );
    isVolumeMute = LocalPreference.getStoredVolume() ?? false;
    _controller!.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    };
    _controller!.onExitFullscreen = () {};

    _sub = _controller!.listen((event) {
      if (event.isReady && !event.hasPlayed) {
        widget.videoDetail!.isPaused.add(false);
      }
      if (event.position.inSeconds == 0) {
        widget.videoDetail!.videoPositionStreamController.add(0);
      } else {
        if (event.position.inSeconds >= 3 &&
            event.playerState == PlayerState.playing) {
          // videoDetail.showPlayerControls.add(false);
        }
        widget.videoDetail!.videoPositionStreamController.add(
            event.position.inSeconds /
                _controller!.metadata.duration.inSeconds);
      }
    });
    widget.videoDetail!.isPaused.add(true);
    widget.videoDetail!.isPaused.stream.listen((value) {
      if (value) {
        _controller!.pause();
        widget.videoDetail!.showPlayerControls.add(true);
      } else {
        if (_controller!.value.isReady) {
          _controller!.play();
        }
      }
    });
    widget.videoDetail!.isMuted.stream.listen((value) {
      volumeMuted = value;
    });
    // commentCount.value = widget.videoDetail!.commentsCounts;
    // //  getStreamVideoLikes(widget.videoDetail!.isLikedByLogUser);
    super.initState();
  }

  @override
  void dispose() {
    _controller!.close();
    super.dispose();
  }

  _toggleContainer() {
    if (_animation!.status != AnimationStatus.completed) {
      _anicontroller!.forward();
    } else {
      _anicontroller!.animateBack(0, duration: const Duration(microseconds: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await LocalPreference.setVolume(false);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              YoutubePlayerControllerProvider(
                controller: _controller!,
                child: SizedBox(height: height(context), child: player),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  setState(() => isVolumeMute = !isVolumeMute);
                  isVolumeMute ? _controller!.mute() : _controller!.unMute();
                  await LocalPreference.setVolume(isVolumeMute);
                },
                child: Container(
                  // height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
              ),
              const BackButton(
                color: Colors.white,
              ),
              StreamBuilder<bool>(
                  stream: widget.videoDetail!.showPlayerControls.stream,
                  initialData: true,
                  builder: (context, snapshot) {
                    return (snapshot.hasData ? snapshot.data! : false)
                        ? Positioned(
                            bottom: 0,
                            left: 0,
                            child: SizedBox(
                              // height: 150,
                              width: MediaQuery.of(context).size.width,
                              child: Container(
                                // height: 80,
                                padding: const EdgeInsets.all(8),
                                color: Colors.black.withAlpha(85),
                                child: SliderTheme(
                                  data: const SliderThemeData(
                                      thumbShape: RoundSliderThumbShape(
                                          enabledThumbRadius: 6)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      StreamBuilder<double>(
                                        stream: widget
                                            .videoDetail!
                                            .videoPositionStreamController
                                            .stream,
                                        initialData: 0.toDouble(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
                                          return Slider(
                                            activeColor: Colors.white,
                                            value: snapshot.data,
                                            max: 1,
                                            min: 0,
                                            onChanged: (double value) {
                                              var newPosition = _controller!
                                                      .value
                                                      .metaData
                                                      .duration
                                                      .inSeconds *
                                                  value;
                                              if (_controller!.value.isReady) {
                                                _sub.cancel();
                                                _controller!.seekTo(Duration(
                                                    seconds:
                                                        (newPosition).toInt()));

                                                Future.delayed(
                                                    const Duration(seconds: 1),
                                                    () {
                                                  _sub = _controller!
                                                      .listen((event) {
                                                    widget.videoDetail!
                                                        .videoPositionStreamController
                                                        .add(event.position
                                                                .inSeconds /
                                                            _controller!
                                                                .metadata
                                                                .duration
                                                                .inSeconds);
                                                  });
                                                });
                                              }
                                              // videoDetail.updateVideoPosition(value);
                                            },
                                          );
                                        },
                                      ),
                                      _bottomControls(
                                          widget.videoDetail!, _controller!),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container();
                  }),
              Positioned(
                bottom: 100,
                right: 0.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: isLike,
                        builder: (context, dynamic value, child) => Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Text(
                              //   "IsLiked: ${widget.videoDetail!.isLikedByLogUser} ${isLike.value}",
                              //   style: TextStyle(color: Colors.white),
                              // ),
                              Image.asset(
                                'assets/images/like.png',
                                height: 25,
                                width: 25,
                                color:
                                    isLike.value ? Colors.grey : Colors.white,
                              ),
                              Text(
                                widget.videoDetail!.likesCount != 0
                                    ? "${widget.videoDetail!.likesCount}"
                                    : "",
                                style: themeTextStyle(context: context),
                              ),
                            ]),
                      ),
                      const SizedBox(height: 20),
                      ValueListenableBuilder(
                        valueListenable: commentCount,
                        builder: (context, dynamic value, child) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () async {
                                  setState(() {
                                    isPlayingClip = false;
                                  });
                                  _controller!.pause();
                                  loadCommentStreamAgain =
                                      getStreamVideoCommets();
                                  await showCommentDialog(context)
                                      .then((_) => _controller!.play());
                                },
                                child: Image.asset(
                                  'assets/images/comment.png',
                                  height: 25,
                                  width: 25,
                                  color: commentCount.value != 0
                                      ? Colors.white
                                      : Colors.white,
                                )),
                            Text(
                              commentCount.value != 0
                                  ? "${commentCount.value}"
                                  : "",
                              style: themeTextStyle(context: context),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () async {
                          _controller!.pause();
                          // await generateLink();
                        },
                        child: Image.asset(
                          'assets/images/share.png',
                          color: Colors.white,
                          height: 26,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              widget.videoDetail!.sourceList!.isEmpty
                  ? const SizedBox.shrink()
                  : Positioned(
                      bottom: 130,
                      left: 0.0,
                      child: Row(
                        children: [
                          InkWell(
                              onTap: () => _toggleContainer(),
                              child: const Icon(
                                Icons.south_america_sharp,
                              )),
                          SizeTransition(
                            sizeFactor: _animation!,
                            axis: Axis.vertical,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  widget.videoDetail!.sourceList!.length,
                                  (index) => InkWell(
                                    onTap: () async {
                                      bool isLink = widget.videoDetail!
                                                  .sourceList![index].source ==
                                              ""
                                          ? false
                                          : true;
                                      if (isLink) {
                                        _controller!.pause();
                                        // await navigator!
                                        //     .pushNamed(RouteName.webView,
                                        //         arguments: Map.of({
                                        //           "url": widget.videoDetail!
                                        //                   .sourcedata![index]
                                        //               ['source']
                                        //         }))
                                        //     .then(
                                        //         (value) => _controller!.play());
                                      }
                                    },
                                    child: Container(
                                      width: 180,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8)),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.white,
                                                offset: Offset(0.5, 1.5),
                                                spreadRadius: 1.0)
                                          ]),
                                      child: Text(
                                        widget.videoDetail!.sourceList![index]
                                            .title!,
                                        maxLines: 1,
                                        style: themeTextStyle(context: context),
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  DateFormat dateFormat = DateFormat("dd-MM-yyyy");
  showCommentDialog(context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: StreamBuilder<List?>(
                            stream: loadCommentStreamAgain,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox.shrink();
                              } else if (snapshot.hasData) {
                                return ListView.builder(
                                    reverse: true,
                                    itemCount: commentsList!.length,
                                    itemBuilder: (context, index) {
                                      //  return Text('${snapshot.data![index]['comment']}');
                                      return commentsList![index].id !=
                                              appDBUserId
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 2),
                                                Text(
                                                  commentsList![index].name ??
                                                      "",
                                                  style: themeTextStyle(
                                                      context: context),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(19),
                                                        topRight:
                                                            Radius.circular(19),
                                                        bottomRight:
                                                            Radius.circular(19),
                                                      )),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 14,
                                                          bottom: 10,
                                                          left: 16,
                                                          right: 24),
                                                  child: Text(
                                                    "${commentsList![index].comment}",
                                                    style: themeTextStyle(
                                                        context: context),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      DateFormat.yMMMEd()
                                                          .format(
                                                        commentsList![index]
                                                            .insertAt!,
                                                      ),
                                                      style: themeTextStyle(
                                                          context: context),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                const SizedBox(height: 2),
                                                Text(
                                                  commentsList![index].name ??
                                                      "",
                                                  style: themeTextStyle(
                                                      context: context),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(19),
                                                        topRight:
                                                            Radius.circular(19),
                                                        bottomRight:
                                                            Radius.circular(19),
                                                      )),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 14,
                                                          bottom: 10,
                                                          left: 16,
                                                          right: 24),
                                                  child: Text(
                                                    "${commentsList![index].comment}",
                                                    style: themeTextStyle(
                                                        context: context),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      DateFormat.yMMMEd()
                                                          .format(
                                                        commentsList![index]
                                                            .insertAt!,
                                                      ),
                                                      style: themeTextStyle(
                                                          context: context),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            );
                                    });
                              } else {
                                return const Center(child: Text('No Comments'));
                              }
                            },
                          ),
                        ),
                        // AppTextField(
                        //   filled: false,
                        //   maxLine: 4,
                        //   controller: _commentTextcontroller,
                        //   hint: StringConstant.typeHere,
                        //   suffixIcon: Icon(
                        //     Icons.send,
                        //     color: primaryColor,
                        //   ).addGestureTap(() async {
                        //     print(_commentTextcontroller.text);
                        //     await _comments_list!.postVideoCommentsList(
                        //       userId: appDB!.user!.id,
                        //       videoId: widget.videoDetail!.id,
                        //       comment: _commentTextcontroller.text,
                        //     );
                        //     setState(() {
                        //       _commentTextcontroller.clear();
                        //       loadCommentStreamAgain = getStreamVideoCommets();
                        //     });
                        //   }),
                        //   contentPadding: const EdgeInsets.only(
                        //       left: 12.0, bottom: 10.0, top: 10.0, right: 12.0),
                        // ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          radius: 14.0,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.close, color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((value) {
      _controller!.play();
      setState(() {
        isPlayingClip = true;
      });
    });
  }

  Stream<List?> getStreamVideoCommets() async* {
    VideoComments? videoComments =
        await Provider.of<KnowelloReelProvider>(context, listen: false)
            .getVideoComments(
      url: videoCommentsListUrl,
      videoId: widget.videoDetail!.id,
    );
    if (videoComments != null) {
      setState(() => commentsList!.add(videoComments));
    }

    yield commentsList;
  }

  Widget _muteControl(VResult videoDetail, YoutubePlayerController controller) {
    return IconButton(
      onPressed: () async {
        setState(() => isVolumeMute = !isVolumeMute);
        isVolumeMute ? controller.mute() : controller.unMute();
        await LocalPreference.setVolume(isVolumeMute);
      },
      icon: Icon(
        isVolumeMute ? Icons.volume_off : Icons.volume_down_alt,
        size: 24,
        color: Colors.white,
      ),
    );
  }

  Widget _bottomControls(VResult videoDetail, controller) {
    return Stack(
      children: [
        Row(
          children: [
            _muteControl(videoDetail, controller),
            const Spacer(),
            widget.videoDetail!.hotwordurl == null
                ? const SizedBox.shrink()
                : InkWell(
                    onTap: () async {
                      controller.pause();
                      await showDialog(
                          context: context,
                          barrierDismissible: true,
                          useSafeArea: true,
                          builder: (BuildContext context) {
                            return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                child: Image.network(
                                    widget.videoDetail!.hotwordurl!));
                          }).then((value) => controller.play());
                    },
                    child: Image.asset(
                      'assets/images/hot.png',
                      color: Colors.white,
                      height: 26,
                    ),
                  ),
            widget.videoDetail!.hotlink == ''
                ? const SizedBox.shrink()
                : const SizedBox(width: 20),
            widget.videoDetail!.hotlink == ''
                ? const SizedBox.shrink()
                : InkWell(
                    onTap: () async {
                      controller.pause();
                      var urlPattern =
                          r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';

                      var numPattern = r'\d';

                      var relatedLink = widget.videoDetail!.hotlink ?? '';

                      var emailReg = RegExp(urlPattern, caseSensitive: false)
                          .hasMatch(relatedLink);

                      var numReg = RegExp(numPattern).hasMatch(relatedLink);

                      // if (numReg == true) {}
                      if (emailReg == true) {
                        // await navigator!
                        //     .pushNamed(RouteName.simpleWebview,
                        //         arguments: relatedLink)
                        //     .then((value) => controller.play());

                      } else if (numReg == true) {
                        // await Navigator?.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => SingleFeed(
                        //       id: relatedLink,
                        //     ),
                        //   ),
                        // ).then((value) => controller.play());
                      } else {
                        print("Not a valid parameter");
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image(
                        image: AssetImage("assets/images/link.png"),
                        height: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: IconButton(
            icon: Icon(
              isPlayingClip ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isPlayingClip = !isPlayingClip;
              });
              if (isPlayingClip) {
                controller!.play();
              } else {
                controller!.pause();
              }
            },
          ),
        ),
      ],
    );
  }
}
