import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:manager/common/const/colors.dart';
import 'package:manager/common/utils/data_utils.dart';
import 'package:manager/diary/model/diary_model.dart';

class DiaryCard extends StatelessWidget {
  final String id;
  final DateTime createdAt;
  final String thumbnail;
  final List<String> hashtags;
  final String title;
  final int likeCount;
  final bool isLike;
  final void Function(int)? onThreeDotSelected;
  final VoidCallback onTapLike;

  const DiaryCard({
    Key? key,
    required this.id,
    required this.createdAt,
    required this.thumbnail,
    required this.hashtags,
    required this.title,
    required this.isLike,
    required this.onThreeDotSelected,
    required this.onTapLike,
    required this.likeCount,
  }) : super(key: key);

  factory DiaryCard.fromModel({
    required DiaryModel model,
    required void Function(int)? onThreeDotSelected,
    required VoidCallback onTapLike,
  }) {
    return DiaryCard(
      id: model.id,
      createdAt: model.createdAt,
      thumbnail: model.thumbnail,
      hashtags: model.hashtags,
      title: model.title,
      isLike: model.isLike,
      likeCount: model.likeCount,
      onThreeDotSelected: onThreeDotSelected,
      onTapLike: onTapLike,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String postDate =
        '${createdAt.year}년 ${createdAt.month}월 ${createdAt.day}일';
    return Stack(
      children: [
        Hero(
          tag: 'thumbnail$id',
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 2.0,
                sigmaY: 2.0,
              ),
              child: Image.network(
                thumbnail,
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.width - 32.0,
                width: double.infinity,
                key: UniqueKey(),
              ),
            ),
          ),
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
                    fontSize: 14.0,
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
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        // hashtag prefix for #
                        hashtags.map((String e) => '#$e').join(' '),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 0,
          child: PopupMenuButton<int>(
            icon: const Icon(
              Icons.more_vert_outlined,
              color: Colors.white,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
              const PopupMenuItem<int>(value: 1, child: Text('수정')),
              const PopupMenuItem<int>(value: 2, child: Text('삭제')),
            ],
            onSelected: onThreeDotSelected,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 8,
          child: InkWell(
            onTap: onTapLike,
            child: Container(
              decoration: BoxDecoration(
                color: BACKGROUND_BLACK.withOpacity(0.7),
                // color: Colors.amber.withOpacity(0.7),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              child: Column(
                children: [
                  Icon(
                    isLike ? Icons.favorite : Icons.favorite_border_outlined,
                    color: PRIMARY_COLOR,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    DataUtils.number2Unit.format(likeCount),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
