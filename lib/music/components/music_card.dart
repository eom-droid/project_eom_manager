import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:manager/common/const/colors.dart';
import 'package:manager/music/model/music_model.dart';

class MusicCard extends StatefulWidget {
  final String id;
  final String title;
  final String artiste;
  final String review;
  final String albumCover;
  final String youtubeMusicId;
  final String spotifyId;

  const MusicCard({
    Key? key,
    required this.id,
    required this.title,
    required this.artiste,
    required this.review,
    required this.albumCover,
    required this.youtubeMusicId,
    required this.spotifyId,
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
      youtubeMusicId: model.youtubeMusicId,
      spotifyId: model.spotifyId,
    );
  }

  @override
  State<MusicCard> createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
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
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 10.0,
                    sigmaY: 10.0,
                  ),
                  child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    color:
                        const Color.fromARGB(255, 25, 25, 25).withOpacity(0.6),
                  ),
                  width: MediaQuery.of(context).size.width - 32,
                  child: Dismissible(
                    confirmDismiss: (DismissDirection direction) async {
                      return false;
                    },
                    background: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      child: Container(
                        color: SPOTIFY_LOGO_COLOR.withAlpha(100),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Spotify',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    secondaryBackground: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      child: Container(
                        color: YOUTUBE_MUSIC_LOGO_COLOR.withAlpha(100),
                        child: const Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'YT Music',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    key: Key(widget.id),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: SPOTIFY_LOGO_COLOR.withAlpha(100),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(50),
                              topRight: Radius.circular(50),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: SvgPicture.asset(
                              'asset/imgs/spotify-logo.svg',
                              height: 20,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: YOUTUBE_MUSIC_LOGO_COLOR.withAlpha(100),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              topLeft: Radius.circular(50),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: SvgPicture.asset(
                              'asset/imgs/youtube-music-logo.svg',
                              height: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: 16.0,
          //     vertical: 16.0,
          //   ),
          //   decoration: BoxDecoration(
          //     borderRadius: const BorderRadius.only(
          //       bottomLeft: Radius.circular(10),
          //       bottomRight: Radius.circular(10),
          //     ),
          //     color: Colors.black.withOpacity(0.3),
          //   ),
          //   child: Text(
          //     widget.review,
          //     textAlign: TextAlign.center,
          //     style: const TextStyle(
          //       fontSize: 15,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
