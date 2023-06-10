import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:manager/common/components/custom_animated_switch.dart';
import 'package:manager/common/components/custom_text_form_field.dart';
import 'package:manager/common/layout/loading_layout.dart';
import 'package:manager/common/model/pop_data_model.dart';
import 'package:manager/common/style/button/custom_outlined_button_style.dart';
import 'package:manager/common/utils/data_utils.dart';
import 'package:manager/diary/components/diary_edit_detail_card.dart';
import 'package:manager/common/const/colors.dart';
import 'package:manager/common/const/data.dart';
import 'package:manager/common/layout/default_layout.dart';
import 'package:manager/diary/components/diary_img_input.dart';
import 'package:manager/diary/components/diary_txt_input.dart';
import 'package:manager/diary/components/diary_vid_input.dart';
import 'package:manager/diary/model/diary_detail_model.dart';
import 'package:manager/diary/provider/diary_provider.dart';

class _ContentInput {
  DiaryContentType? contentType;
  TextEditingController controller;
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
  final GlobalKey<FormState> formKey = GlobalKey();
  final ScrollController scrollController = ScrollController();

  bool isLoading = false;
  bool isInitialized = false;

  String title = '';
  DateTime postDT = DataUtils.dateOnly(DateTime.now());
  String weather = '';
  List<String> hashtags = [];
  List<_ContentInput> contents = [];
  DiaryCategory category = DiaryCategory.daily;
  int thumbnailIndex = -1;
  int postDateInd = -1;

  @override
  void initState() {
    super.initState();

    // 추가인 경우는 getDetail이 필요없음
    if (widget.id != NEW_ID) {
      ref.read(diaryProvider.notifier).getDetail(id: widget.id);
    }

    // weather = '맑음';
    // hashtags.addAll(['안녕', '이거는', '테스트']);
    // contents.add(
    //   _ContentInput(
    //     contentType: DiaryContentType.txt,
    //     controller: TextEditingController(text: '테스트 메시지\n테스트 메시지'),
    //   ),
    // );
  }

  void init() {
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

    title = state.title;
    postDT = state.postDT;
    weather = state.weather;
    hashtags = state.hashtags;
    category = state.category;
    postDateInd = state.postDateInd;

    contents = state.contentOrder
        .map<_ContentInput>(
          (e) => _ContentInput(
            contentType: e,
            controller: TextEditingController(),
          ),
        )
        .toList();
    int txtIndex = 0;
    int imgIndex = 0;
    int vidIndex = 0;
    for (int i = 0; i < contents.length; i++) {
      switch (contents[i].contentType) {
        case DiaryContentType.txt:
          contents[i].controller.text = state.txts[txtIndex];
          txtIndex++;
          break;
        case DiaryContentType.img:
          contents[i].controller.text = state.imgs[imgIndex];
          imgIndex++;
          break;
        case DiaryContentType.vid:
          contents[i].controller.text = state.vids[vidIndex];
          vidIndex++;
          break;
        default:
          break;
      }
    }
    thumbnailIndex = state.thumbnail == null
        ? -1
        : contents.indexWhere(
            (element) => element.controller.text == state.thumbnail);
    isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    init();

    if (!isInitialized) {
      return const DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return LoadingLayout(
      isLoading: isLoading,
      childWidget: DefaultLayout(
        title: widget.id == NEW_ID ? 'Diary Add' : 'Diary Edit',
        isFullScreen: true,
        appBarActions: [
          IconButton(
            onPressed: () async {
              if (!isLoading) {
                await onSavePressed();
                context.pop<PopDataModel>(const PopDataModel(refetch: true));
              }
            },
            icon: const Icon(Icons.save_as_outlined),
          ),
        ],
        child: SafeArea(
          top: false,
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                  setState(
                    () {
                      contents.add(
                        _ContentInput(
                            contentType: null,
                            controller: TextEditingController()),
                      );
                    },
                  );

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
      ),
    );
  }

  SliverToBoxAdapter _renderDiaryBasicInfo() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          _renderThumbnail(),
          const SizedBox(height: 16.0),
          Form(
            key: formKey,
            child: Padding(
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
                    initialValue: title,
                    onSaved: onTitleSaved,
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _PostDate(
                          initValue: postDT,
                          onChanged: (DateTime value) {
                            postDT = value;
                          },
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: _Weather(
                          initialValue: weather,
                          onSaved: onWeatherSaved,
                        ),
                      )
                    ],
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
          ),
        ],
      ),
    );
  }

  Widget _renderThumbnail() {
    if (thumbnailIndex != -1 &&
        contents[thumbnailIndex].controller.text != '') {
      ImageProvider imageProvider;
      if (contents[thumbnailIndex].controller.text.startsWith("http")) {
        imageProvider = NetworkImage(contents[thumbnailIndex].controller.text);
      } else {
        imageProvider =
            FileImage(File(contents[thumbnailIndex].controller.text));
      }

      return Image(
        image: imageProvider,
        height: 300.0,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return Container(
        height: 300.0,
        color: Colors.grey[300],
        child: const Center(
          child: Text('썸네일을 선택해 주세요'),
        ),
      );
    }
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
          final key = DateTime.now().toString();
          return Dismissible(
            direction: DismissDirection.endToStart,
            key: Key(key),
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
              onLoading: (error, value) {
                if (error != null) {
                  _showSnackBar(content: error);
                } else {
                  setState(() {
                    isLoading = value;
                  });
                }
              },
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

  Future<void> onSavePressed() async {
    isLoading = true;

    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {});

    if (validate()) {
      formKey.currentState!.save();
      final List<String> txts = [];
      final List<String> imgs = [];
      final List<String> vids = [];
      final List<DiaryContentType> contentOrder = [];

      List<MultipartFile> uploadFiles = [];

      // 비동기 가능할거같은데.....
      for (int i = 0; contents.length > i; i++) {
        if (contents[i].contentType == DiaryContentType.txt) {
          txts.add(contents[i].controller.text);
          contentOrder.add(DiaryContentType.txt);
        } else {
          // 기존 이미지를 사용하는 경우
          if (contents[i].controller.text.startsWith("http")) {
            imgs.add(DataUtils.urlToPath(contents[i].controller.text));
          }
          // 새로운 이미지를 사용하는 경우
          else {
            final String fileName = contents[i].controller.text.split('/').last;
            uploadFiles.add(
              await MultipartFile.fromFile(
                contents[i].controller.text,
                filename: fileName,
              ),
            );

            imgs.add(fileName);
          }

          contentOrder.add(contents[i].contentType!);
        }
      }

      // 썸네일
      String? thumbnail;
      if (thumbnailIndex != -1) {
        if (contents[thumbnailIndex].controller.text.startsWith("http")) {
          thumbnail =
              DataUtils.urlToPath(contents[thumbnailIndex].controller.text);
        } else {
          thumbnail = contents[thumbnailIndex].controller.text.split('/').last;
        }
      }

      DiaryDetailModel diaryDetail = DiaryDetailModel(
        id: widget.id,
        title: title,
        writer: "엄태호",
        weather: weather,
        hashtags: hashtags,
        postDT: postDT,
        postDateInd: postDateInd,
        thumbnail: thumbnail,
        category: category,
        isShown: true,
        txts: txts,
        imgs: imgs,
        vids: vids,
        contentOrder: contentOrder,
      );

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
    }

    // setState(() {
    //   isLoading = false;
    // });
  }

  bool validate() {
    if (formKey.currentContext == null) {
      _showSnackBar(content: 'formKey가 없습니다');
      return false;
    }

    // form 내 모든 필드의 validate를 실행
    if (!formKey.currentState!.validate()) {
      _showSnackBar(content: '기본 정보를 입력해주세요');

      return false;
    }

    if (contents.isEmpty) {
      _showSnackBar(content: '컨텐츠를 한개이상 넣어주세요');
      return false;
    }
    for (int i = 0; i < contents.length; i++) {
      if (contents[i].contentType == null) {
        _showSnackBar(content: '${i + 1}번쨰 컨텐츠 형태를 선택해주세요');
        return false;
      }
      if (contents[i].controller.text == '') {
        _showSnackBar(content: '${i + 1}번쨰 번쨰 컨텐츠 내용을 입력해주세요');
        return false;
      }
    }
    return true;
  }

  void _showSnackBar({
    required String content,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  onTitleSaved(String? val) {
    title = val ?? '';
  }

  onWeatherSaved(String? val) {
    weather = val ?? '';
  }
}

class _ContentInputWidget extends StatefulWidget {
  final Function(String?, bool) onLoading;
  final Function(int, bool) onThumbnailChanged;
  final _ContentInput contentInput;
  final int index;
  final bool isThumbnail;
  const _ContentInputWidget({
    required this.onLoading,
    required this.contentInput,
    required this.index,
    required this.isThumbnail,
    required this.onThumbnailChanged,
  });

  @override
  State<_ContentInputWidget> createState() => __ContentInputWidgetState();
}

class __ContentInputWidgetState extends State<_ContentInputWidget> {
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
                if (widget.contentInput.contentType == DiaryContentType.img ||
                    widget.contentInput.contentType == DiaryContentType.vid)
                  Row(
                    children: [
                      const Text('썸네일 : '),
                      const SizedBox(width: 8.0),
                      CustomAnimatedSwitch(
                        value: widget.isThumbnail,
                        onChanged: (bool value) {
                          // setState(() {
                          //   thumbnailIndex = value ? index : -1;
                          // });
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
        return DiaryTxtInput(
          controller: widget.contentInput.controller,
        );
      case DiaryContentType.img:
        return DiaryImgInput(
          loadingTrigger: (error, value) {
            if (error != null) {
              // 에러상태일때는 로딩 여부 false 고정
              widget.onLoading(error, false);
            } else {
              widget.onLoading(null, value);
            }
          },
          controller: widget.contentInput.controller,
        );
      case DiaryContentType.vid:
        return const DiaryVidInput();
      default:
        return renderDefaultContentInput(callback: (DiaryContentType value) {
          setState(() {
            widget.contentInput.contentType = value;
          });
        });
    }
  }

  Widget renderDefaultContentInput({
    required Function(DiaryContentType) callback,
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
                    style: e != DiaryContentType.vid
                        ? customOutlinedButtonStyle
                        : customOutlinedButtonStyle.copyWith(
                            foregroundColor:
                                MaterialStateProperty.all(BODY_TEXT_COLOR),
                            side: MaterialStateProperty.all(
                              const BorderSide(
                                color: BODY_TEXT_COLOR,
                              ),
                            ),
                          ),
                    onPressed:
                        e != DiaryContentType.vid ? () => callback(e) : null,
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
    // TODO: implement initState
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
  final FormFieldSetter<String> onSaved;
  final String initialValue;

  const _Title({
    required this.onSaved,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      initialValue: initialValue,
      label: '제목',
      onSaved: onSaved,
    );
  }
}

class _PostDate extends StatefulWidget {
  final DateTime initValue;
  final ValueChanged<DateTime> onChanged;

  const _PostDate({
    required this.initValue,
    required this.onChanged,
  });

  @override
  State<_PostDate> createState() => _PostDateState();
}

class _PostDateState extends State<_PostDate> {
  late DateTime postDate;
  TextEditingController postDateTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postDate = widget.initValue;
    postDateTextController.text = DateFormat('yyyy-MM-dd').format(postDate);
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      label: '게시일자',
      onSaved: (_) {},
      onTap: () => onTapDatePicker(),
      controller: postDateTextController,
    );
  }

  onTapDatePicker() async {
    FocusScope.of(context).requestFocus(FocusNode());

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: postDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        postDateTextController.text =
            DateFormat('yyyy-MM-dd').format(selectedDate);
        postDate = selectedDate;
      });
      widget.onChanged(selectedDate);
    }
  }
}

class _Weather extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final String initialValue;

  const _Weather({
    required this.onSaved,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      initialValue: initialValue,
      label: '날씨',
      onSaved: onSaved,
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
    // TODO: implement initState
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
