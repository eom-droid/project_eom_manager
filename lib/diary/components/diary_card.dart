import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:manager/common/const/colors.dart';
import 'package:manager/diary/model/diary_model.dart';

class DiaryCard extends StatelessWidget {
  final DateTime postDT;
  final String? thumbnail;
  final List<String> hashtags;
  final String title;
  final void Function(int)? onThreeDotSelected;

  const DiaryCard({
    Key? key,
    required this.postDT,
    this.thumbnail,
    required this.hashtags,
    required this.title,
    required this.onThreeDotSelected,
  }) : super(key: key);

  factory DiaryCard.fromModel({
    required DiaryModel model,
    required void Function(int)? onThreeDotSelected,
  }) {
    return DiaryCard(
      postDT: model.postDT,
      thumbnail: model.thumbnail,
      hashtags: model.hashtags,
      title: model.title,
      onThreeDotSelected: onThreeDotSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String postDate = '${postDT.year}년 ${postDT.month}월 ${postDT.day}일';
    if (thumbnail == null) {
      return const SizedBox();
    }
    return Stack(
      children: [
        if (thumbnail != null)
          ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 2.0,
                sigmaY: 2.0,
              ),
              child: Image.network(
                thumbnail!,
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.width - 32.0,
                width: double.infinity,
                // frame jank가 너무 심함
                // color: const Color(0xFFEDEDED).withOpacity(0.5),
                // colorBlendMode: BlendMode.modulate,
              ),
            ),
          ),
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(10.0),
        //   child: Image.network(
        //     thumbnail!,
        //     fit: BoxFit.cover,
        //     height: MediaQuery.of(context).size.width - 32.0,
        //     color: Colors.white.withOpacity(0.5),
        //     colorBlendMode: BlendMode.modulate,
        //   ),
        // ),
        if (thumbnail == null)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.blueGrey,
            ),
            width: double.infinity,
            height: MediaQuery.of(context).size.width - 32.0,
          ),

        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.width - 32.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.width - 32.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  BACKGROUND_BLACK.withOpacity(0.7),
                  Colors.transparent,
                  BACKGROUND_BLACK.withOpacity(0.7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.width - 32.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                child: Text(
                  postDate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        // hashtag prefix for #
                        hashtags.map((String e) => '#$e').join(' '),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    // return Column(
    //   children: [
    //     Container(
    //       width: double.infinity,
    //       color: Colors.blueGrey,
    //       height: 50.0,
    //       child: Stack(
    //         alignment: Alignment.centerRight,
    //         children: [
    //           Center(
    //             child: Text(
    //               postDate,
    //             ),
    //           ),
    //           PopupMenuButton<int>(
    //             icon: const Icon(Icons.more_vert_outlined),
    //             itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
    //               const PopupMenuItem<int>(value: 1, child: Text('수정')),
    //               const PopupMenuItem<int>(value: 2, child: Text('삭제')),
    //             ],
    //             onSelected: onThreeDotSelected,
    //           )
    //         ],
    //       ),
    //     ),
    //     if (thumbnail != null)
    //       SizedBox(
    //         height: 300.0,
    //         child: Stack(
    //           children: [
    //             if (DataUtils.isImgFile(thumbnail!))
    //               Image.network(
    //                 thumbnail!,
    //                 fit: BoxFit.cover,
    //                 width: double.infinity,
    //               ),
    //             if (DataUtils.isVidFile(thumbnail!))
    //               ThumbnailVideoPalyer(
    //                 thumbnail: thumbnail!,
    //               ),
    //             Positioned(
    //               bottom: 20,
    //               right: 0,
    //               child: Container(
    //                 color: Colors.cyan,
    //                 child: Row(
    //                   children: hashtags
    //                       .map<Padding>(
    //                         (String e) => Padding(
    //                           padding: const EdgeInsets.only(right: 8.0),
    //                           child: Text(e),
    //                         ),
    //                       )
    //                       .toList(),
    //                 ),
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //     Container(
    //       height: 50.0,
    //       color: Colors.greenAccent,
    //       child: Center(
    //         child: Text(title),
    //       ),
    //     )
    //   ],
    // );
  }
}
