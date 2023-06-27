import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manager/common/components/custom_img_input.dart';
import 'package:manager/common/components/custom_text_form_field.dart';
import 'package:manager/common/components/full_loading_screen.dart';
import 'package:manager/common/components/multi_line_text_field.dart';
import 'package:manager/common/const/colors.dart';
import 'package:manager/common/const/data.dart';
import 'package:manager/common/layout/default_layout.dart';
import 'package:manager/common/model/pop_data_model.dart';
import 'package:manager/common/utils/flutter_utils.dart';
import 'package:manager/music/model/music_model.dart';
import 'package:manager/music/provider/music_provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MusicEditScreen extends ConsumerStatefulWidget {
  static String get routeName => 'musicEdit';

  final String id;

  const MusicEditScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<MusicEditScreen> createState() => _MusicEditScreenState();
}

class _MusicEditScreenState extends ConsumerState<MusicEditScreen> {
  YoutubePlayerController? _controller;
  final ScrollController scrollController = ScrollController();

  bool isFullScreen = false;

  TextEditingController title = TextEditingController();
  TextEditingController artiste = TextEditingController();
  TextEditingController albumCover = TextEditingController();
  TextEditingController review = TextEditingController();
  TextEditingController youtubeLink = TextEditingController();

  bool isSaving = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.id != NEW_ID) {
      final model = ref.read(musicProvider.notifier).getMusicById(widget.id);
      title.text = model.title;
      artiste.text = model.artiste;
      albumCover.text = model.albumCover;
      review.text = model.review;
      youtubeLink.text = model.youtubeLink;
      if (youtubeLink.text != '') {
        _controller = YoutubePlayerController.fromVideoId(
          videoId: youtubeLink.text,
          autoPlay: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: widget.id == NEW_ID ? '플리 추가' : '플리 수정',
      appBarActions: [
        IconButton(
          onPressed: () async {
            if (!isSaving) {
              if (await onSavePressed()) {
                context.pop<PopDataModel>(
                  const PopDataModel(refetch: true),
                );
              }
            }
          },
          icon: const Icon(Icons.save_as_outlined),
        ),
      ],
      child: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    '앨범 커버',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: PRIMARY_COLOR,
                    ),
                  ),
                  CustomImgInput(
                    imgPath: albumCover.text,
                    onChanged: (value) {
                      albumCover.text = value;
                    },
                    maxheightWidth: 500,
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              CustomTextFormField(
                label: '제목',
                controller: title,
              ),
              const SizedBox(height: 12.0),
              CustomTextFormField(
                label: '아티스트',
                controller: artiste,
              ),
              const SizedBox(height: 12.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: PRIMARY_COLOR,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 4.0, top: 8.0),
                      child: Text(
                        '한줄평',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: PRIMARY_COLOR,
                        ),
                      ),
                    ),
                    // 아래에 dash line 추가
                    const Divider(
                      color: PRIMARY_COLOR,
                      thickness: 1.5,
                    ),
                    MultiLineTextField(
                      controller: review,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      label: 'Youtube',
                      onSaved: (String? value) {
                        if (value != null) {
                          //여기 완성해야됨
                        }
                      },
                      controller: youtubeLink,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());

                        String initialVideoId;
                        if (youtubeLink.text.startsWith("http")) {
                          initialVideoId = youtubeLink.text.split("v=")[1];
                        } else {
                          initialVideoId = youtubeLink.text;
                        }
                        setState(() {
                          _controller = YoutubePlayerController.fromVideoId(
                            videoId: initialVideoId,
                            autoPlay: true,
                          );
                        });
                      },
                      child: const Text('불러오기'),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              if (_controller != null)
                YoutubePlayer(
                  controller: _controller!,
                ),
              if (_controller == null)
                Container(
                  color: Colors.grey[300],
                  height:
                      (MediaQuery.of(context).size.width - 32) * youtubeRatio,
                  child: const Center(
                    child: Text(
                      'Youtube URL을 입력해주세요.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: PRIMARY_COLOR,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 200.0),
            ],
          ),
        ),
      ),
    );
  }

  bool validate() {
    if (title.text == '') {
      FlutterUtils.showSnackBar(
        context: context,
        content: '제목을 입력해주세요.',
      );
      return false;
    }

    if (artiste.text == '') {
      FlutterUtils.showSnackBar(
        context: context,
        content: '아티스트를 입력해주세요.',
      );
      return false;
    }

    if (albumCover.text == '') {
      FlutterUtils.showSnackBar(
        context: context,
        content: '앨범 커버를 입력해주세요.',
      );
      return false;
    }

    if (review.text == '') {
      FlutterUtils.showSnackBar(
        context: context,
        content: '한줄평을 입력해주세요.',
      );
      return false;
    }

    if (youtubeLink.text == '') {
      FlutterUtils.showSnackBar(
        context: context,
        content: 'Youtube URL을 입력해주세요.',
      );
      return false;
    }
    return true;
  }

  Future<bool> onSavePressed() async {
    isSaving = true;
    FocusScope.of(context).requestFocus(FocusNode());
    FullLoadingScreen(context).startLoading();
    bool validateResult = validate();
    if (validateResult) {
      MusicModel music = MusicModel(
        id: widget.id,
        title: title.text,
        artiste: artiste.text,
        albumCover: albumCover.text,
        review: review.text,
        youtubeLink: youtubeLink.text.startsWith("http")
            ? youtubeLink.text.split("v=")[1]
            : youtubeLink.text,
      );
      final String thumbNailFileName = albumCover.text.split('/').last;

      MultipartFile thumbnail = await MultipartFile.fromFile(
        albumCover.text,
        filename: thumbNailFileName,
      );

      if (widget.id == NEW_ID) {
        await ref
            .read(musicProvider.notifier)
            .addMusic(music: music, thumbnail: thumbnail);
      } else {
        await ref
            .read(musicProvider.notifier)
            .updateMusic(music: music, thumbnail: thumbnail);
      }
    }

    FullLoadingScreen(context).stopLoading();
    isSaving = false;
    return validateResult;
  }
}
