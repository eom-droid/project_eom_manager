import 'package:flutter/material.dart';
import 'package:manager/music/model/music_model.dart';

class MusicCard extends StatelessWidget {
  final String title;
  final String artiste;
  final String review;
  final String albumCover;
  final String youtubeLink;

  const MusicCard({
    Key? key,
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
      title: model.title,
      artiste: model.artiste,
      review: model.review,
      albumCover: model.albumCover,
      youtubeLink: model.youtubeLink,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
