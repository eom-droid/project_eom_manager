import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manager/common/components/custom_animated_switch.dart';
import 'package:manager/common/components/custom_text_form_field.dart';
import 'package:manager/common/components/custom_video_player.dart';
import 'package:manager/common/components/full_loading_screen.dart';
import 'package:manager/common/model/pop_data_model.dart';
import 'package:manager/common/style/button/custom_outlined_button_style.dart';
import 'package:manager/common/utils/data_utils.dart';
import 'package:manager/common/utils/flutter_utils.dart';
import 'package:manager/diary/components/diary_edit_detail_card.dart';
import 'package:manager/common/const/colors.dart';
import 'package:manager/common/const/data.dart';
import 'package:manager/common/layout/default_layout.dart';
import 'package:manager/common/components/custom_img_input.dart';
import 'package:manager/diary/components/diary_txt_input.dart';
import 'package:manager/diary/components/diary_vid_input.dart';
import 'package:manager/diary/model/diary_detail_model.dart';
import 'package:manager/diary/provider/diary_provider.dart';
import 'package:video_player/video_player.dart';

class _ContentInput<T extends ValueNotifier> {
  DiaryContentType? contentType;
  T? controller;

  _ContentInput({
    required this.contentType,
    required this.controller,
  });
}

class DiaryEditScreen extends ConsumerStatefulWidget {
  static String get routeName => 'diaryEdit';
  final String id;

  const DiaryEditScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<DiaryEditScreen> createState() => _DiaryEditScreenState();
}

class _DiaryEditScreenState extends ConsumerState<DiaryEditScreen> {
  final ScrollController scrollController = ScrollController();

  bool isSaving = false;
  bool isInitialized = false;

  TextEditingController title = TextEditingController();

  TextEditingController weather = TextEditingController();
  List<String> hashtags = [];
  List<_ContentInput> contents = [];
  DiaryCategory category = DiaryCategory.daily;
  int thumbnailIndex = -1;

  @override
  void initState() {
    super.initState();

    // 추가인 경우는 getDetail이 필요없음
    if (widget.id != NEW_ID) {
      ref.read(diaryProvider.notifier).getDetail(id: widget.id);
    }
  }

  Future<void> init() async {
    // 1. 초기화가 되었는지 확인
    if (isInitialized) return;

    // 2-1. 추가
    if (widget.id == NEW_ID) {
      isInitialized = true;
      return;
    }

    // 2-2. 수정
    final state = ref.watch(diaryDetailProvider(widget.id));
    // state가 null이거나 DiaryModel이 아닌경우는 리턴
    if (state is! DiaryDetailModel) {
      return;
    }

    title.text = state.title;
    weather.text = state.weather;
    hashtags = state.hashtags;
    category = state.category;

    contents = state.contentOrder
        .map<_ContentInput>(
          (e) => _ContentInput(
            contentType: e,
            controller: null,
          ),
        )
        .toList();
    int txtIndex = 0;
    int imgIndex = 0;
    int vidIndex = 0;
    for (int i = 0; i < contents.length; i++) {
      switch (contents[i].contentType) {
        case DiaryContentType.txt:
          contents[i].controller = TextEditingController();
          var controller = contents[i].controller as TextEditingController;
          controller.text = state.txts[txtIndex];
          txtIndex++;
          break;
        case DiaryContentType.img:
          contents[i].controller = TextEditingController();
          var controller = contents[i].controller as TextEditingController;
          controller.text = state.imgs[imgIndex];
          imgIndex++;
          break;
        case DiaryContentType.vid:
          contents[i].controller =
              VideoPlayerController.network(state.vids[vidIndex]);
          var controller = contents[i].controller as VideoPlayerController;

          await controller.initialize();

          vidIndex++;
          break;
        default:
          break;
      }
    }
    thumbnailIndex = contents.indexWhere((element) {
      if (element.controller is TextEditingController) {
        var controller = element.controller as TextEditingController;
        return controller.text == state.thumbnail;
      } else {
        // 이부분은 조금있다가 확인해봐야됨
        // 업로드까지 진행해보고 썸네일에서 잘 나오는지
        var controller = element.controller as VideoPlayerController;
        return controller.dataSource == state.thumbnail;
      }
    });
    setState(() {
      isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // init을 initState가 아닌 build에 둔이유
    // initState안에서 ref.read를 사용하여 Detail정보를 가지고오는거는 비동기
    // 비동기라서 getDetail이 완료되었는지 확인하는 방법은 build가 다시 불려졌을때임
    // 따라서 여기에 두어서 build가 다시 불려졌을때 getDetail이 완료되었는지 확인 및 초기화를 진행함
    init();

    if (!isInitialized) {
      return const DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultLayout(
      backgroundColor: BACKGROUND_BLACK,
      title: widget.id == NEW_ID ? 'Diary Add' : 'Diary Edit',
      isFullScreen: true,
      appBarActions: [
        IconButton(
          onPressed: () async {
            if (!isSaving) {
              if (await onSavePressed()) {
                context.pop<PopDataModel>(const PopDataModel(refetch: true));
              }
            }
          },
          icon: const Icon(Icons.save_as_outlined),
        ),
      ],
      child: SafeArea(
        top: false,
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(),
          controller: scrollController,
          slivers: [
            _renderDiaryBasicInfo(),
            const SliverToBoxAdapter(
              child: SizedBox(height: 16.0),
            ),
            _renderContents(contents: contents),
            const SliverToBoxAdapter(
              child: SizedBox(height: 16.0),
            ),
            _renderContentAddButton(
              onPressed: () {
                setState(() {
                  contents.add(
                    _ContentInput(
                      contentType: null,
                      controller: null,
                    ),
                  );
                });

                SchedulerBinding.instance.addPostFrameCallback(
                  (_) {
                    scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.fastOutSlowIn,
                    );
                  },
                );
              },
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 16.0),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _renderDiaryBasicInfo() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          _renderThumbnail(),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _Category(
                  initValue: category,
                  onChanged: (value) {
                    category = value;
                  },
                ),
                const SizedBox(height: 16.0),
                _Title(
                  controller: title,
                ),
                const SizedBox(height: 16.0),
                _Weather(
                  controller: weather,
                ),
                const SizedBox(height: 16.0),
                _Hashtags(
                  initialValue: hashtags,
                  onChanged: (value) => hashtags = value,
                  hintText: '# 제외, 공백으로 나눠져요.(최대 20자)',
                  maxLength: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderThumbnail() {
    // 썸네일이 없다면
    if (thumbnailIndex != -1) {
      // 썸네일이 컨트롤러가 null이 아니라면
      if (contents[thumbnailIndex].controller != null) {
        var controller = contents[thumbnailIndex].controller;
        // 썸네일이 사진이라면
        if (controller is TextEditingController) {
          ImageProvider imageProvider;
          if (controller.text.startsWith("http")) {
            imageProvider = NetworkImage(controller.text);
          } else {
            imageProvider = FileImage(File(controller.text));
          }

          return Image(
            image: imageProvider,
            height: MediaQuery.of(context).size.width,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        } else if (controller is VideoPlayerController) {
          return SizedBox(
            height: MediaQuery.of(context).size.width,
            child: Center(
              child: CustomVideoPlayer(
                videoController: controller,
              ),
            ),
          );
        }
      }
    }
    return Container(
      height: MediaQuery.of(context).size.width,
      color: Colors.grey[300],
      child: const Center(
        child: Text('썸네일을 선택해 주세요'),
      ),
    );
  }

  SliverPadding _renderContents({
    required List<_ContentInput> contents,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList.separated(
        separatorBuilder: (context, index) {
          return const SizedBox(height: 16.0);
        },
        itemCount: contents.length,
        itemBuilder: (context, index) {
          return Dismissible(
            direction: DismissDirection.endToStart,
            key: Key(contents[index].hashCode.toString()),
            onDismissed: (direction) {
              setState(() {
                if (thumbnailIndex == index) {
                  thumbnailIndex = -1;
                } else {
                  if (thumbnailIndex > index) {
                    thumbnailIndex--;
                  }
                }
                contents.removeAt(index);
              });
            },
            child: _ContentInputWidget(
              index: index,
              isThumbnail: thumbnailIndex == index,
              contentInput: contents[index],
              onThumbnailChanged: (int index, bool value) {
                setState(() {
                  thumbnailIndex = value ? index : -1;
                });
              },
            ),
          );
        },
      ),
    );
  }

  SliverToBoxAdapter _renderContentAddButton({
    required VoidCallback onPressed,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(PRIMARY_COLOR),
          ),
          onPressed: onPressed,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text('컨텐츠 세부항목 추가하기'),
          ),
        ),
      ),
    );
  }

  Future<bool> onSavePressed() async {
    isSaving = true;

    FocusScope.of(context).requestFocus(FocusNode());
    FullLoadingScreen(context).startLoading();
    bool validateResult = await validate();
    if (validateResult) {
      final List<String> txts = [];
      final List<String> imgs = [];
      final List<String> vids = [];
      final List<DiaryContentType> contentOrder = [];

      List<MultipartFile> uploadFiles = [];

      // 비동기 가능할거같은데.....
      for (int i = 0; contents.length > i; i++) {
        if (contents[i].contentType == DiaryContentType.txt) {
          var controller = contents[i].controller as TextEditingController;
          txts.add(controller.text);
          contentOrder.add(DiaryContentType.txt);
        } else if (contents[i].contentType == DiaryContentType.img) {
          var controller = contents[i].controller as TextEditingController;
          // 기존 이미지를 사용하는 경우
          if (controller.text.startsWith("http")) {
            imgs.add(DataUtils.urlToPath(controller.text));
          }
          // 새로운 이미지를 사용하는 경우
          else {
            final String fileName = controller.text.split('/').last;
            uploadFiles.add(
              await MultipartFile.fromFile(
                controller.text,
                filename: fileName,
              ),
            );

            imgs.add(fileName);
          }

          contentOrder.add(contents[i].contentType!);
        } else if (contents[i].contentType == DiaryContentType.vid) {
          var controller = contents[i].controller as VideoPlayerController;

          // 기존 비디오를 사용하는 경우
          if (controller.dataSource.startsWith("http")) {
            vids.add(DataUtils.urlToPath(controller.dataSource));
          }
          // // 새로운 비디오를 사용하는 경우
          else {
            final String filePath =
                controller.dataSource.replaceAll('file://', '');
            final String fileName = controller.dataSource.split('/').last;
            uploadFiles.add(
              await MultipartFile.fromFile(
                filePath,
                filename: fileName,
              ),
            );

            vids.add(fileName);
          }

          contentOrder.add(contents[i].contentType!);
        }
      }

      // 썸네일
      String thumbnail = '';
      if (thumbnailIndex != -1) {
        if (contents[thumbnailIndex].controller is TextEditingController) {
          var controller =
              contents[thumbnailIndex].controller as TextEditingController;
          if (controller.text.startsWith("http")) {
            thumbnail = DataUtils.urlToPath(controller.text);
          } else {
            thumbnail = controller.text.split('/').last;
          }
        } else if (contents[thumbnailIndex].controller
            is VideoPlayerController) {
          var controller =
              contents[thumbnailIndex].controller as VideoPlayerController;
          if (controller.dataSource.startsWith("http")) {
            thumbnail = DataUtils.urlToPath(controller.dataSource);
          } else {
            thumbnail = controller.dataSource.split('/').last;
          }
        }
      }

      DiaryDetailModel diaryDetail = DiaryDetailModel(
        id: widget.id,
        title: title.text,
        writer: "엄태호",
        weather: weather.text,
        hashtags: hashtags,
        thumbnail: thumbnail,
        category: category,
        isShown: true,
        txts: txts,
        imgs: imgs,
        vids: vids,
        contentOrder: contentOrder,
        createdAt: DateTime.now(),
      );
      try {
        if (widget.id == NEW_ID) {
          await ref.read(diaryProvider.notifier).addDiary(
                diary: diaryDetail,
                uploadFiles: uploadFiles,
              );
        } else {
          await ref.read(diaryProvider.notifier).updateDiary(
                diary: diaryDetail,
                uploadFiles: uploadFiles,
              );
        }
      } catch (e) {
        print(e);
      }
    }
    FullLoadingScreen(context).stopLoading();
    isSaving = false;
    return validateResult;
  }

  Future<bool> validate() async {
    if (contents.isEmpty) {
      FlutterUtils.showSnackBar(
        context: context,
        content: '컨텐츠를 하나이상 넣어주세요',
      );
      return false;
    }
    if (thumbnailIndex == -1) {
      FlutterUtils.showSnackBar(
        context: context,
        content: '썸네일을 선택해주세요',
      );
      return false;
    }
    for (int i = 0; i < contents.length; i++) {
      if (contents[i].contentType == null) {
        FlutterUtils.showSnackBar(
          context: context,
          content: '${i + 1}번쨰 번쨰 컨텐츠 형태를 선택해주세요',
        );
        return false;
      }
      var controller = contents[i].controller;
      // 컨텐츠로서 비디오를 선택하고 비디오를 넣지 않은 경우
      if (controller == null) {
        FlutterUtils.showSnackBar(
          context: context,
          content: '${i + 1}번쨰 번쨰 컨텐츠 내용을 입력해주세요',
        );

        return false;
      }
      // 컨텐츠로서 이미지를 선택하고 이미지를 넣지 않은 경우
      if (controller is TextEditingController && controller.text == '') {
        FlutterUtils.showSnackBar(
          context: context,
          content: '${i + 1}번쨰 번쨰 컨텐츠 내용을 입력해주세요',
        );

        return false;
      }
    }

    return true;
  }
}

class _ContentInputWidget extends StatefulWidget {
  final Function(int, bool) onThumbnailChanged;
  final _ContentInput contentInput;
  final int index;
  final bool isThumbnail;
  const _ContentInputWidget({
    required this.contentInput,
    required this.index,
    required this.isThumbnail,
    required this.onThumbnailChanged,
  });

  @override
  State<_ContentInputWidget> createState() => _ContentInputWidgetState();
}

class _ContentInputWidgetState extends State<_ContentInputWidget> {
  @override
  Widget build(BuildContext context) {
    return DiaryEditDetailCard(
      borderColor: widget.isThumbnail ? PRIMARY_COLOR : null,
      childWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('#${widget.index + 1}'),
                if (widget.contentInput.contentType == DiaryContentType.img)
                  Row(
                    children: [
                      const Text('썸네일 : '),
                      const SizedBox(width: 8.0),
                      CustomAnimatedSwitch(
                        value: widget.isThumbnail,
                        onChanged: (bool value) {
                          widget.onThumbnailChanged(widget.index, value);
                        },
                      )
                    ],
                  )
              ],
            ),
          ),
          contentInputWidget(),
        ],
      ),
    );
  }

  Widget contentInputWidget() {
    switch (widget.contentInput.contentType) {
      case DiaryContentType.txt:
        widget.contentInput.controller ??= TextEditingController();
        return DiaryTxtInput(
          controller: widget.contentInput.controller as TextEditingController,
        );
      case DiaryContentType.img:
        widget.contentInput.controller ??= TextEditingController();
        var controller =
            widget.contentInput.controller as TextEditingController;
        return CustomImgInput(
          imgPath: controller.text,
          onChanged: (String value) {
            controller.text = value;
          },
        );
      case DiaryContentType.vid:
        return DiaryVidInput(
          initVideoController:
              widget.contentInput.controller as VideoPlayerController?,
          onVideoControllerChanged: (VideoPlayerController value) {
            widget.contentInput.controller = value;
          },
        );
      default:
        return renderDefaultContentInput(
          contentTypeSelected: (DiaryContentType value) {
            setState(
              () {
                widget.contentInput.contentType = value;
              },
            );
          },
        );
    }
  }

  Widget renderDefaultContentInput({
    required Function(DiaryContentType) contentTypeSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          const Text('컨텐츠 형태를 정해주세요'),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: DiaryContentType.values
                .map<OutlinedButton>(
                  (DiaryContentType e) => OutlinedButton(
                    style: customOutlinedButtonStyle,
                    onPressed: () => contentTypeSelected(e),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: Text(e.koreanValue),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _Category extends StatefulWidget {
  final DiaryCategory initValue;
  final ValueChanged<DiaryCategory> onChanged;
  const _Category({
    required this.initValue,
    required this.onChanged,
  });

  @override
  State<_Category> createState() => _CategoryState();
}

class _CategoryState extends State<_Category> {
  late DiaryCategory category;

  @override
  void initState() {
    super.initState();
    category = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '카테고리',
          style: TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2.0),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: PRIMARY_COLOR,
            ),
          ),
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                iconSize: 20.0,
                value: category,
                isExpanded: true,
                items: DiaryCategory.values
                    .map<DropdownMenuItem<DiaryCategory>>(
                      (DiaryCategory e) => DropdownMenuItem<DiaryCategory>(
                        value: e,
                        child: Center(
                          child: Text(
                            e.koreanValue,
                            style: const TextStyle(
                              color: PRIMARY_COLOR,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (DiaryCategory? value) {
                  if (value != null) {
                    setState(() {
                      category = value;
                    });
                    widget.onChanged(value);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  final TextEditingController controller;

  const _Title({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      label: '제목',
      controller: controller,
    );
  }
}

class _Weather extends StatelessWidget {
  final TextEditingController controller;

  const _Weather({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      label: '날씨',
      controller: controller,
    );
  }
}

class _Hashtags extends StatefulWidget {
  final List<String> initialValue;
  final ValueChanged<List<String>> onChanged;

  final String hintText;
  final int maxLength;

  const _Hashtags({
    required this.initialValue,
    required this.onChanged,
    required this.hintText,
    required this.maxLength,
  });

  @override
  State<_Hashtags> createState() => _HashtagsState();
}

class _HashtagsState extends State<_Hashtags> {
  String label = '';
  List<String> hashtags = [];

  @override
  void initState() {
    super.initState();
    hashtags = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    label = '해시태그(${_hashtagsLabel(hashtags)})';

    return CustomTextFormField(
      initialValue: hashtags.join(' '),
      label: label,
      onSaved: (_) {},
      onChanged: (String value) {
        setState(() {
          hashtags = _stringToHashTag(value);
        });
        widget.onChanged(_stringToHashTag(value));
      },
      hintText: widget.hintText,
      maxLength: widget.maxLength,
    );
  }

  String _hashtagsLabel(List<String> hashtags) {
    String result = '';
    for (int i = 0; i < hashtags.length; i++) {
      if (hashtags[i] == '') continue;
      result = "$result#${hashtags[i]}";
      if (i != hashtags.length - 1) {
        result += ' ';
      }
    }
    return result;
  }

  List<String> _stringToHashTag(String value) {
    return value.trim().split(' ');
  }
}
