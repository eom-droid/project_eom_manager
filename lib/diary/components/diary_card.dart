import 'package:flutter/material.dart';
import 'package:manager/diary/model/diary_model.dart';

class DiaryCard extends StatelessWidget {
  final DateTime postDate;
  final String thumbnail;
  final List<String> hashtags;
  final String title;

  const DiaryCard({
    Key? key,
    required this.postDate,
    required this.thumbnail,
    required this.hashtags,
    required this.title,
  }) : super(key: key);

  factory DiaryCard.fromModel({
    required DiaryModel model,
  }) {
    return DiaryCard(
      postDate: model.postDate,
      thumbnail: model.thumbnail,
      hashtags: model.hashtags,
      title: model.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String postDate =
        '${this.postDate.year}년 ${this.postDate.month}월 ${this.postDate.day}일';

    return InkWell(
      onTap: () {},
      child: Container(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.blueGrey,
              height: 50.0,
              child: Center(
                child: Text(
                  postDate,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 300.0,
              child: Stack(
                children: [
                  Container(
                    color: Colors.grey,
                    width: double.infinity,
                    height: 300.0,
                    child: const Text('사진'),
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
        ),
      ),
    );
  }
}
