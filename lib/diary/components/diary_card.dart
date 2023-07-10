import 'package:flutter/material.dart';
import 'package:manager/common/components/thumbnail_video_player.dart';
import 'package:manager/common/utils/data_utils.dart';
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

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Colors.blueGrey,
          height: 50.0,
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Center(
                child: Text(
                  postDate,
                ),
              ),
              PopupMenuButton<int>(
                icon: const Icon(Icons.more_vert_outlined),
                itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                  const PopupMenuItem<int>(value: 1, child: Text('수정')),
                  const PopupMenuItem<int>(value: 2, child: Text('삭제')),
                ],
                onSelected: onThreeDotSelected,
              )
            ],
          ),
        ),
        if (thumbnail != null)
          SizedBox(
            height: 300.0,
            child: Stack(
              children: [
                if (DataUtils.isImgFile(thumbnail!))
                  Image.network(
                    thumbnail!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                if (DataUtils.isVidFile(thumbnail!))
                  ThumbnailVideoPalyer(
                    thumbnail: thumbnail!,
                  ),
                Positioned(
                  bottom: 20,
                  right: 0,
                  child: Container(
                    color: Colors.cyan,
                    child: Row(
                      children: hashtags
                          .map<Padding>(
                            (String e) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(e),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                )
              ],
            ),
          ),
        Container(
          height: 50.0,
          color: Colors.greenAccent,
          child: Center(
            child: Text(title),
          ),
        )
      ],
    );
  }
}
