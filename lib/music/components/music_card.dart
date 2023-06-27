import 'package:flutter/material.dart';
import 'package:manager/common/const/data.dart';
import 'package:manager/music/model/music_model.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MusicCard extends StatefulWidget {
  final String id;
  final String title;
  final String artiste;
  final String review;
  final String albumCover;
  final String youtubeLink;

  const MusicCard({
    Key? key,
    required this.id,
    required this.title,
    required this.artiste,
    required this.review,
    required this.albumCover,
    required this.youtubeLink,
  }) : super(key: key);

  factory MusicCard.fromModel({
    required MusicModel model,
  }) {
    return MusicCard(
      id: model.id,
      title: model.title,
      artiste: model.artiste,
      review: model.review,
      albumCover: model.albumCover,
      youtubeLink: model.youtubeLink,
    );
  }

  @override
  State<MusicCard> createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard> {
  WebViewController WVcontroller = WebViewController();
  bool _displayYoutube = false;

  loadVideo() {
    WVcontroller.setBackgroundColor(const Color(0x00000000));
    WVcontroller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {
          setState(() {
            _displayYoutube = !_displayYoutube;
          });
        },
        onWebResourceError: (WebResourceError error) {},

        // onNavigationRequest: (NavigationRequest request) {
        //   // if (request.url.startsWith('https://www.youtube.com/')) {
        //   //   return NavigationDecision.prevent;
        //   // }
        //   // return NavigationDecision.navigate;
        // },
      ),
    );
    WVcontroller.loadRequest(
      Uri.parse('https://www.youtube.com/embed/8mPtiTFzCsA'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final youtubeWidth = MediaQuery.of(context).size.width - 32;
    final youtubeHeight = youtubeWidth * youtubeRatio;
    return SizedBox(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: Colors.black,
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.dstATop,
                    ),
                    image: NetworkImage(widget.albumCover),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (_displayYoutube)
                Positioned(
                  top: 0,
                  left: 0,
                  child: SizedBox(
                    width: youtubeWidth,
                    height: youtubeHeight,
                    child: WebViewWidget(
                      controller: WVcontroller,
                    ),
                  ),
                ),
              const SizedBox(
                width: 200,
                height: 200,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: InkWell(
                  // onTap: () {
                  //   loadVideo();
                  // },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 16,
                    color: Colors.black.withOpacity(0.7),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            Text(
                              widget.artiste,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: Colors.black.withOpacity(0.3),
            ),
            child: Text(
              widget.review,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class YoutubeSlide extends StatefulWidget {
  final bool isActivate;
  final String youtubeLink;
  const YoutubeSlide({
    super.key,
    required this.isActivate,
    required this.youtubeLink,
  });

  @override
  State<YoutubeSlide> createState() => _YoutubeSlideState();
}

class _YoutubeSlideState extends State<YoutubeSlide> {
  YoutubePlayerController? _controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      onEnd: () {
        if (_controller == null && widget.isActivate) initController();
      },
      duration: const Duration(milliseconds: 500),
      width: MediaQuery.of(context).size.width,
      height: widget.isActivate
          ? (MediaQuery.of(context).size.width - 32) * youtubeRatio
          : 0,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: Colors.black,
      ),
      curve: Curves.fastOutSlowIn,
      child: _controller != null
          ? YoutubePlayer(
              controller: _controller!,
            )
          : const SizedBox(),
    );
  }

  @override
  dispose() {
    super.dispose();
  }

  initController() {
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.youtubeLink,
    );
  }
}
