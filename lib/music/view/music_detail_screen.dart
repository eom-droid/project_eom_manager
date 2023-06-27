import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manager/music/model/music_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MusciDetailScreen extends StatefulWidget {
  static String get routeName => 'musicDetail';
  final String id;
  final MusicModel music;

  const MusciDetailScreen({
    super.key,
    required this.id,
    required this.music,
  });

  @override
  State<MusciDetailScreen> createState() => _MusciDetailScreenState();
}

class _MusciDetailScreenState extends State<MusciDetailScreen> {
  WebViewController WVcontroller = WebViewController();
  final bool _isLoadingPage = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WVcontroller.setJavaScriptMode(JavaScriptMode.unrestricted);
    WVcontroller.setBackgroundColor(const Color(0x00000000));
    // WVcontroller.setNavigationDelegate(
    //   NavigationDelegate(
    //     onProgress: (int progress) {
    //       // Update loading bar.
    //     },
    //     onPageStarted: (String url) {},
    //     onPageFinished: (String url) {
    //       setState(() {
    //         _isLoadingPage = false;
    //       });
    //     },
    //     onWebResourceError: (WebResourceError error) {},

    //     // onNavigationRequest: (NavigationRequest request) {
    //     //   // if (request.url.startsWith('https://www.youtube.com/')) {
    //     //   //   return NavigationDecision.prevent;
    //     //   // }
    //     //   // return NavigationDecision.navigate;
    //     // },
    //   ),
    // );
    WVcontroller.loadRequest(
        Uri.parse('https://www.youtube.com/watch?v=IwQb89Gf4Ko'));
  }

  // YoutubePlayerController controller = YoutubePlayerController(
  //   params: const YoutubePlayerParams(
  //     showFullscreenButton: true,
  //   ),
  // );

  bool pop = false;

  waitForSecond() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final albumCoverSizeDobule = (MediaQuery.of(context).size.width / 2);
    // controller.cueVideoById(videoId: widget.music.youtubeLink);
    print('build');
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2),
                  BlendMode.dstATop,
                ),
                image: NetworkImage(widget.music.albumCover),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              top: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 4),
                    child: Hero(
                      tag: "albumCover${widget.music.id}",
                      child: Container(
                        height: albumCoverSizeDobule,
                        width: albumCoverSizeDobule,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.white,
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(widget.music.albumCover),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    child:
                        !pop ? WebViewWidget(controller: WVcontroller) : null,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 8.0,
            child: IconButton(
              onPressed: () {
                context.pop();
                // WVcontroller.clearCache();
                pop = true;
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    // 11111111111
    // return YoutubePlayerScaffold(
    //   controller: controller,
    //   builder: (childContext, player) {
    //     return Scaffold(
    //       body: Stack(
    //         children: [
    //           Container(
    //             decoration: BoxDecoration(
    //               color: Colors.black,
    //               image: DecorationImage(
    //                 colorFilter: ColorFilter.mode(
    //                   Colors.black.withOpacity(0.2),
    //                   BlendMode.dstATop,
    //                 ),
    //                 image: NetworkImage(widget.music.albumCover),
    //                 fit: BoxFit.cover,
    //               ),
    //             ),
    //             child: SafeArea(
    //               top: true,
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.stretch,
    //                 children: [
    //                   const SizedBox(
    //                     height: 60,
    //                   ),
    //                   Padding(
    //                     padding: EdgeInsets.symmetric(
    //                         horizontal:
    //                             MediaQuery.of(childContext).size.width / 4),
    //                     child: Hero(
    //                       tag: "albumCover${widget.music.id}",
    //                       child: Container(
    //                         height: albumCoverSizeDobule,
    //                         width: albumCoverSizeDobule,
    //                         decoration: BoxDecoration(
    //                           boxShadow: const [
    //                             BoxShadow(
    //                               color: Colors.white,
    //                               spreadRadius: 5,
    //                               blurRadius: 10,
    //                               offset: Offset(0, 3),
    //                             ),
    //                           ],
    //                           borderRadius: BorderRadius.circular(10),
    //                           image: DecorationImage(
    //                             image: NetworkImage(widget.music.albumCover),
    //                             fit: BoxFit.cover,
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                   const SizedBox(
    //                     height: 50,
    //                   ),
    //                   SizedBox(
    //                     height: MediaQuery.of(childContext).size.width,
    //                     width: MediaQuery.of(childContext).size.width,
    //                     child: WebViewWidget(controller: WVcontroller),
    //                   )

    //                   // Stack(
    //                   //   children: [
    //                   //     // player,
    //                   //     // FutureBuilder(
    //                   //     //   future: waitForSecond(),
    //                   //     //   builder: (_, snapshot) {
    //                   //     //     if (snapshot.connectionState ==
    //                   //     //         ConnectionState.done) {
    //                   //     //       return player;
    //                   //     //     } else {
    //                   //     //       return const SizedBox(
    //                   //     //         height: 200,
    //                   //     //         width: 200,
    //                   //     //         child: Center(
    //                   //     //           child: CircularProgressIndicator(),
    //                   //     //         ),
    //                   //     //       );
    //                   //     //     }
    //                   //     //   },
    //                   //     // ),
    //                   //     Container(
    //                   //       color: Colors.black,
    //                   //       width: MediaQuery.of(childContext).size.width,
    //                   //       height: MediaQuery.of(childContext).size.width,
    //                   //     ),
    //                   //     Positioned(child: player),
    //                   //   ],
    //                   // )
    //                   // player,
    //                   // if (pop == false)
    //                   // FutureBuilder(
    //                   //   future: waitForSecond(),
    //                   //   builder: (_, snapshot) {
    //                   //     Widget child;
    //                   //     if (snapshot.connectionState ==
    //                   //         ConnectionState.done) {
    //                   //       child = player;
    //                   //     } else {
    //                   //       child = const SizedBox(
    //                   //         height: 200,
    //                   //         width: 200,
    //                   //         child: Center(
    //                   //           child: CircularProgressIndicator(),
    //                   //         ),
    //                   //       );
    //                   //     }
    //                   //     return AnimatedSwitcher(
    //                   //       duration: const Duration(milliseconds: 500),
    //                   //       child: child,
    //                   //     );
    //                   //   },
    //                   // )
    //                 ],
    //               ),
    //             ),
    //           ),
    //           Positioned(
    //             top: MediaQuery.of(childContext).padding.top,
    //             left: 8.0,
    //             child: IconButton(
    //               onPressed: () {
    //                 // context.pop();

    //                 childContext.pop();
    //                 pop = true;
    //               },
    //               icon: const Icon(
    //                 Icons.arrow_back_ios,
    //                 color: Colors.white,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );
    // print('build');

    // 222222222222
    // return Scaffold(
    //   body: YoutubePlayerScaffold(
    //       controller: controller,
    //       builder: (childContext, player) {
    //         return Stack(
    //           children: [
    //             Container(
    //               decoration: BoxDecoration(
    //                 color: Colors.black,
    //                 image: DecorationImage(
    //                   colorFilter: ColorFilter.mode(
    //                     Colors.black.withOpacity(0.2),
    //                     BlendMode.dstATop,
    //                   ),
    //                   image: NetworkImage(widget.music.albumCover),
    //                   fit: BoxFit.cover,
    //                 ),
    //               ),
    //               child: SafeArea(
    //                 top: true,
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.stretch,
    //                   children: [
    //                     const SizedBox(
    //                       height: 60,
    //                     ),
    //                     Padding(
    //                       padding: EdgeInsets.symmetric(
    //                           horizontal:
    //                               MediaQuery.of(context).size.width / 4),
    //                       child: Hero(
    //                         tag: "albumCover${widget.music.id}",
    //                         child: Container(
    //                           height: albumCoverSizeDobule,
    //                           width: albumCoverSizeDobule,
    //                           decoration: BoxDecoration(
    //                             boxShadow: const [
    //                               BoxShadow(
    //                                 color: Colors.white,
    //                                 spreadRadius: 5,
    //                                 blurRadius: 10,
    //                                 offset: Offset(0, 3),
    //                               ),
    //                             ],
    //                             borderRadius: BorderRadius.circular(10),
    //                             image: DecorationImage(
    //                               image: NetworkImage(widget.music.albumCover),
    //                               fit: BoxFit.cover,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     const SizedBox(
    //                       height: 50,
    //                     ),
    //                     // player,
    //                     // if (pop == false)
    //                     FutureBuilder(
    //                       future: waitForSecond(),
    //                       builder: (_, snapshot) {
    //                         if (snapshot.data != null) {
    //                           return YoutubePlayer(
    //                             controller: controller,
    //                           );
    //                         }
    //                         return const SizedBox(
    //                           height: 200,
    //                           width: 200,
    //                           child: Center(
    //                             child: CircularProgressIndicator(),
    //                           ),
    //                         );
    //                       },
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             ),
    //             Positioned(
    //               top: MediaQuery.of(context).padding.top,
    //               left: 8.0,
    //               child: IconButton(
    //                 onPressed: () {
    //                   childContext.pop();

    //                   pop = true;
    //                 },
    //                 icon: const Icon(
    //                   Icons.arrow_back_ios,
    //                   color: Colors.white,
    //                 ),
    //               ),
    //             ),
    //           ],
    //         );
    //       }),
    // );
  }
}
