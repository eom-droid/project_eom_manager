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
import 'package:manager/common/utils/data_utils.dart';
import 'package:manager/common/utils/flutter_utils.dart';
import 'package:manager/music/model/music_model.dart';
import 'package:manager/music/provider/music_provider.dart';

//
class MusicEditScreen extends ConsumerWidget {
  static String get routeName => "musicEdit";
  final String id;
  MusicEditScreen({
    super.key,
    required this.id,
  });

  final ScrollController scrollController = ScrollController();

  bool isFullScreen = false;

  TextEditingController titleTextCon = TextEditingController();
  TextEditingController artisteTextCon = TextEditingController();
  TextEditingController albumCoverTextCon = TextEditingController();
  TextEditingController reviewTextCon = TextEditingController();
  TextEditingController youtubeMusicIdTextCon = TextEditingController();
  TextEditingController spotifyIdTextCon = TextEditingController();

  bool isSaving = false;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   if(widget.id !=NEW_ID){

  //   }

  //   // if (widget.id != NEW_ID) {
  //   //   final model = ref.read(musicProvider.notifier).getMusicById(widget.id);
  //   //   titleTextCon.text = model.title;
  //   //   artisteTextCon.text = model.artiste;
  //   //   albumCoverTextCon.text = model.albumCover;
  //   //   reviewTextCon.text = model.review;
  //   //   youtubeMusicIdTextCon.text = model.youtubeMusicId;
  //   //   spotifyIdTextCon.text = model.spotifyId;
  //   // } else {
  //   //   titleTextCon.text = '홍대충';
  //   //   artisteTextCon.text = 'lobonabeat';
  //   //   reviewTextCon.text = "홍대충이라는 노래는 홍대에서";
  //   //   youtubeMusicIdTextCon.text =
  //   //       "https://music.youtube.com/watch?v=N-YypFxDC_0&feature=share";
  //   //   spotifyIdTextCon.text =
  //   //       "https://open.spotify.com/track/1HL8Jveuh7tZnCqHzGyyzB?si=678dd1c98b50405b";
  //   // }
  // }

  init(WidgetRef ref) {
    final state = ref.watch(musicDetailProvider(id));
    if (state != null) {
      titleTextCon.text = state.title;
      artisteTextCon.text = state.artiste;
      albumCoverTextCon.text = state.albumCover;
      reviewTextCon.text = state.review;
      youtubeMusicIdTextCon.text = state.youtubeMusicId;
      spotifyIdTextCon.text = state.spotifyId;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    init(ref);
    return DefaultLayout(
      title: id == NEW_ID ? '플리 추가' : '플리 수정',
      appBarActions: [
        IconButton(
          onPressed: () async {
            if (!isSaving) {
              if (await onSavePressed(
                context: context,
                ref: ref,
              )) {
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
                    imgPath: albumCoverTextCon.text,
                    onChanged: (value) {
                      albumCoverTextCon.text = value;
                    },
                    maxheightWidth: 500,
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              CustomTextFormField(
                label: '제목',
                controller: titleTextCon,
              ),
              const SizedBox(height: 12.0),
              CustomTextFormField(
                label: '아티스트',
                controller: artisteTextCon,
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
                      controller: reviewTextCon,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12.0),
              CustomTextFormField(
                label: 'Youtube Music Id',
                controller: youtubeMusicIdTextCon,
              ),
              CustomTextFormField(
                label: 'Spotify Id',
                controller: spotifyIdTextCon,
              ),
              const SizedBox(
                height: 16.0,
              ),
              const SizedBox(height: 200.0),
            ],
          ),
        ),
      ),
    );
  }

  bool validate(
    BuildContext context,
  ) {
    if (titleTextCon.text == '') {
      FlutterUtils.showSnackBar(
        context: context,
        content: '제목을 입력해주세요.',
      );
      return false;
    }

    if (artisteTextCon.text == '') {
      FlutterUtils.showSnackBar(
        context: context,
        content: '아티스트를 입력해주세요.',
      );
      return false;
    }

    if (albumCoverTextCon.text == '') {
      FlutterUtils.showSnackBar(
        context: context,
        content: '앨범 커버를 입력해주세요.',
      );
      return false;
    }

    if (reviewTextCon.text == '') {
      FlutterUtils.showSnackBar(
        context: context,
        content: '한줄평을 입력해주세요.',
      );
      return false;
    }

    if (youtubeMusicIdTextCon.text == '') {
      FlutterUtils.showSnackBar(
        context: context,
        content: 'Youtube Music URL을 입력해주세요.',
      );
      return false;
    }

    if (spotifyIdTextCon.text == '') {
      FlutterUtils.showSnackBar(
        context: context,
        content: 'Spotify URL을 입력해주세요.',
      );
      return false;
    }

    return true;
  }

  Future<bool> onSavePressed({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    isSaving = true;
    FocusScope.of(context).requestFocus(FocusNode());
    FullLoadingScreen(context).startLoading();
    bool validateResult = validate(context);
    if (validateResult) {
      // youtube music id 만 자르기
      youtubeMusicIdTextCon.text = youtubeMusicIdTextCon.text.startsWith("http")
          ? youtubeMusicIdTextCon.text.split("v=")[1]
          : youtubeMusicIdTextCon.text;

      youtubeMusicIdTextCon.text = youtubeMusicIdTextCon.text.split("&")[0];

      // spotify track id 만 자르기
      spotifyIdTextCon.text = spotifyIdTextCon.text.startsWith("http")
          ? spotifyIdTextCon.text.split("track/")[1]
          : spotifyIdTextCon.text;
      spotifyIdTextCon.text = spotifyIdTextCon.text.split("?")[0];

      MultipartFile? thumbnail;
      String thumbnailFileName = albumCoverTextCon.text.split('/').last;
      if (!albumCoverTextCon.text.startsWith("http")) {
        thumbnailFileName = thumbnailFileName.split('/').last;
        thumbnail = await MultipartFile.fromFile(
          albumCoverTextCon.text,
          filename: thumbnailFileName,
        );
      } else {
        albumCoverTextCon.text = DataUtils.urlToPath(albumCoverTextCon.text);
      }
      MusicModel music = MusicModel(
        id: id,
        title: titleTextCon.text,
        artiste: artisteTextCon.text,
        albumCover: albumCoverTextCon.text,
        review: reviewTextCon.text,
        youtubeMusicId: youtubeMusicIdTextCon.text,
        spotifyId: spotifyIdTextCon.text,
      );

      if (id == NEW_ID) {
        // 상단 validation에서 thumbnial의 유무를 확인함
        await ref
            .read(musicProvider.notifier)
            .addMusic(music: music, thumbnail: thumbnail!);
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
