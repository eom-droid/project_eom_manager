// import 'package:flutter/material.dart';
// import 'package:manager/common/const/colors.dart';
// import 'package:manager/common/const/data.dart';
// import 'package:manager/music/model/music_model.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class MusicCard extends StatefulWidget {
//   final String title;
//   final String artiste;
//   final String review;
//   final String albumCover;
//   final String youtubeLink;

//   const MusicCard({
//     Key? key,
//     required this.title,
//     required this.artiste,
//     required this.review,
//     required this.albumCover,
//     required this.youtubeLink,
//   }) : super(key: key);

//   factory MusicCard.fromModel({
//     required MusicModel model,
//   }) {
//     return MusicCard(
//       title: model.title,
//       artiste: model.artiste,
//       review: model.review,
//       albumCover: model.albumCover,
//       youtubeLink: model.youtubeLink,
//     );
//   }

//   @override
//   State<MusicCard> createState() => _MusicCardState();
// }

// class _MusicCardState extends State<MusicCard> {
//   bool youtubeActivate = false;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(10),
//                     topRight: Radius.circular(10),
//                   ),
//                   color: Colors.black,
//                   image: DecorationImage(
//                     colorFilter: ColorFilter.mode(
//                       Colors.black.withOpacity(0.5),
//                       BlendMode.dstATop,
//                     ),
//                     image: NetworkImage(widget.albumCover),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 child: InkWell(
//                   onTap: () {
//                     setState(() {
//                       youtubeActivate = !youtubeActivate;
//                     });
//                   },
//                   child: Container(
//                     width: MediaQuery.of(context).size.width - 16,
//                     color: Colors.black.withOpacity(0.7),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16.0,
//                       vertical: 16.0,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               widget.title,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 22,
//                               ),
//                             ),
//                             Text(
//                               widget.artiste,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ],
//                         ),
//                         IconButton(
//                           onPressed: () {},
//                           icon: const Icon(
//                             Icons.play_arrow_rounded,
//                             color: Colors.white,
//                             size: 30,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               YoutubeSlide(
//                 isActivate: youtubeActivate,
//                 youtubeLink: widget.youtubeLink,
//               ),
//             ],
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width,
//             padding: const EdgeInsets.symmetric(
//               horizontal: 16.0,
//               vertical: 16.0,
//             ),
//             decoration: BoxDecoration(
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(10),
//                 bottomRight: Radius.circular(10),
//               ),
//               color: Colors.black.withOpacity(0.3),
//             ),
//             child: Text(
//               widget.review,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 15,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class YoutubeSlide extends StatefulWidget {
//   final bool isActivate;
//   final String youtubeLink;
//   const YoutubeSlide({
//     super.key,
//     required this.isActivate,
//     required this.youtubeLink,
//   });

//   @override
//   State<YoutubeSlide> createState() => _YoutubeSlideState();
// }

// class _YoutubeSlideState extends State<YoutubeSlide> {
//   YoutubePlayerController? _controller;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       onEnd: () {
//         if (_controller == null && widget.isActivate) initController();
//       },
//       duration: const Duration(milliseconds: 500),
//       width: MediaQuery.of(context).size.width,
//       height: widget.isActivate
//           ? (MediaQuery.of(context).size.width - 32) * youtubeRatio
//           : 0,
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(10),
//           topRight: Radius.circular(10),
//         ),
//         color: Colors.black,
//       ),
//       curve: Curves.fastOutSlowIn,
//       child: _controller != null
//           ? YoutubePlayer(
//               onReady: () {
//                 print('ready');
//               },
//               controller: _controller!,
//               showVideoProgressIndicator: true,
//               progressIndicatorColor: PRIMARY_COLOR,
//               progressColors: const ProgressBarColors(
//                 playedColor: PRIMARY_COLOR,
//                 handleColor: PRIMARY_COLOR,
//               ),
//             )
//           : const SizedBox(),
//     );
//   }

//   @override
//   dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   initController() {
//     _controller = YoutubePlayerController(
//       initialVideoId: widget.youtubeLink,
//       flags: const YoutubePlayerFlags(
//         autoPlay: true,
//       ),
//     );
//     setState(() {});
//   }
// }
