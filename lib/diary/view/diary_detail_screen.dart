import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:manager/common/components/custom_text_form_field.dart';
import 'package:manager/common/layout/loading_layout.dart';
import 'package:manager/common/style/button/custom_outlined_button_style.dart';
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
  String? contentType;
  TextEditingController controller;
  _ContentInput({
    required this.contentType,
    required this.controller,
  });
}

class DiaryDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'diaryDetail';
  final String id;

  const DiaryDetailScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends ConsumerState<DiaryDetailScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final ScrollController scrollController = ScrollController();

  bool isLoading = false;

  String title = '';
  DateTime postDate = DateTime.now();
  TextEditingController postDateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  String weather = '';
  List<String> hashtags = [];
  List<_ContentInput> contents = [];
  String category = CATEGORY_DAILY;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    title = '테스트 메시지';
    weather = '맑음';
    hashtags.addAll(['안녕', '이거는', '테스트']);
    contents.add(
      _ContentInput(
        contentType: CONTENT_TYPE_TXT,
        controller: TextEditingController(text: '테스트 메시지\n테스트 메시지'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingLayout(
      isLoading: isLoading,
      childWidget: DefaultLayout(
        title: 'Diary Add',
        isFullScreen: true,
        AppBarActions: [
          IconButton(
            onPressed: () {
              onSavePressed();
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
              _renderTop(),
              const SliverToBoxAdapter(
                child: SizedBox(height: 16.0),
              ),
              renderDetailContents(contents: contents),
              const SliverToBoxAdapter(
                child: SizedBox(height: 16.0),
              ),
              renderAddContentButton(onPressed: () {
                setState(() {
                  contents.add(_ContentInput(
                      contentType: null, controller: TextEditingController()));
                });

                SchedulerBinding.instance.addPostFrameCallback((_) {
                  scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.fastOutSlowIn);
                });
              }),
              const SliverToBoxAdapter(
                child: SizedBox(height: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter renderAddContentButton({
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

  SliverPadding renderDetailContents({
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
                contents.removeAt(index);
              });
            },
            child: DiaryEditDetailCard(
              index: index,
              childWidget: renderContent(
                contentInput: contents[index],
                callback: (String contentType) {
                  setState(() {
                    contents[index].contentType = contentType;
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget renderContent({
    required _ContentInput contentInput,
    required void Function(String) callback,
  }) {
    switch (contentInput.contentType) {
      case CONTENT_TYPE_TXT:
        return DiaryTxtInput(
          controller: contentInput.controller,
        );
      case CONTENT_TYPE_IMG:
        return DiaryImgInput(
          controller: contentInput.controller,
        );
      case CONTENT_TYPE_VID:
        return const DiaryVidInput();
      default:
        return renderDefault(callback: callback);
    }
  }

  Widget renderDefault({
    required void Function(String) callback,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          const Text('컨텐츠 형태를 정해주세요'),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                style: customOutlinedButtonStyle,
                onPressed: () => callback(CONTENT_TYPE_TXT),
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Text('텍스트'),
                ),
              ),
              OutlinedButton(
                style: customOutlinedButtonStyle,
                onPressed: () => callback(CONTENT_TYPE_IMG),
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Text('이미지'),
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: BODY_TEXT_COLOR,
                  side: const BorderSide(
                    color: BODY_TEXT_COLOR,
                  ),
                ),
                // onPressed: () => callback(CONTENT_TYPE_VID),
                onPressed: () => {},
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Text('동영상'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _renderTop() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Container(
            height: 300.0,
            color: Colors.grey[300],
            child: const Center(
              child: Text('썸네일 들어갈 자리'),
            ),
          ),
          const SizedBox(height: 16.0),
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _Category(
                    category: category,
                    onChanged: (value) {
                      if (value != null) {
                        category = value;
                      }
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
                          onTap: onTapDatePicker,
                          onSaved: onPostDateSaved,
                          controller: postDateController,
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
                    onSaved: onHashTagsSaved,
                    initialValue: hashtags.join(' '),
                    onChanged: onHashTagsChanged,
                    hashtags: hashtags,
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
        postDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        postDate = selectedDate;
      });
    }
  }

  onHashTagsChanged(String? val) {
    if (val == null) return;
    final splitedList = val.split(' ');
    setState(() {
      hashtags = splitedList;
    });
  }

  // upload(File imageFile) async {
  //   // dio.options.headers['Content-Type'] = 'multipart/form-data';
  //   final repository = ref.read(uploadRepositoryProvider);
  //   final a = await MultipartFile.fromFile(imageFile.path);
  //   print(a.contentType);
  //   print(a.filename);
  //   final b = MultipartFile.fromBytes(_image2!.readAsBytesSync(),
  //       filename: imageFile.path.split('/').last);
  //   repository.uploadImage(folderName: 'diary', files: [a, b]);
  //   // print(imageFile.path);

  //   // Response response = await dio.post(
  //   //   '/diary/upload',
  //   //   data: FormData.fromMap({
  //   //     'file': MultipartFile.fromBytes(int8List, filename: 'upload.jpg'),
  //   //   }),
  //   // );
  // }

  onTitleSaved(String? val) {
    title = val ?? '';
  }

  onPostDateSaved(String? val) {
    // postDate = DateTime.parse(val);
  }
  onWeatherSaved(String? val) {
    weather = val ?? '';
  }

  onHashTagsSaved(String? val) {}

  void onSavePressed() async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      isLoading = true;
    });

    if (validate()) {
      final List<String> txts = [];
      final List<String> imgs = [];
      final List<String> vids = [];
      final List<String> contentOrder = [];

      List<MultipartFile> uploadFiles = [];

      for (int i = 0; contents.length > i; i++) {
        if (contents[i].contentType == CONTENT_TYPE_TXT) {
          txts.add(contents[i].controller.text);
          contentOrder.add(CONTENT_TYPE_TXT);
        } else {
          final String fileName = contents[i].controller.text.split('/').last;
          uploadFiles.add(
            await MultipartFile.fromFile(
              contents[i].controller.text,
              filename: fileName,
            ),
          );

          if (contents[i].contentType == CONTENT_TYPE_IMG) {
            imgs.add(fileName);
            contentOrder.add(CONTENT_TYPE_IMG);
          } else {
            vids.add(fileName);
            contentOrder.add(CONTENT_TYPE_VID);
          }
        }
      }

      ref.read(diaryProvider.notifier).addDiary(
            diary: DiaryDetailModel(
              id: NEW_ID,
              title: title,
              writer: '엄태호',
              weather: weather,
              hashtags: hashtags,
              postDate: postDate,
              thumnail: '',
              category: category,
              isShown: true,
              regDTime: DateTime.now(),
              modDTime: DateTime.now(),
              diaryId: NEW_ID,
              txts: txts,
              imgs: imgs,
              vids: vids,
              contentOrder: contentOrder,
            ),
            uploadFiles: uploadFiles,
          );
    }

    setState(() {
      isLoading = false;
    });
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
}

class _Category extends StatelessWidget {
  final String category;
  final ValueChanged<String?> onChanged;
  const _Category({
    required this.category,
    required this.onChanged,
  });

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
                value: category,
                isExpanded: true,
                items: [
                  CATEGORY_DAILY,
                  CATEGORY_TRAVEL,
                  CATEGORY_STUDY,
                ]
                    .map<DropdownMenuItem<String>>(
                      (e) => DropdownMenuItem<String>(
                        value: e,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Center(
                            child: Text(
                                {
                                  CATEGORY_DAILY: '일상',
                                  CATEGORY_TRAVEL: '여행',
                                  CATEGORY_STUDY: '공부',
                                }[e]!,
                                style: const TextStyle(
                                  color: PRIMARY_COLOR,
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
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

class _PostDate extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final VoidCallback onTap;
  final TextEditingController controller;

  const _PostDate({
    required this.onSaved,
    required this.onTap,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      label: '게시일자',
      onSaved: onSaved,
      onTap: onTap,
      controller: controller,
    );
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

class _Hashtags extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final String initialValue;
  final ValueChanged<String>? onChanged;
  final List<String> hashtags;

  final String hintText;
  final int maxLength;

  const _Hashtags({
    required this.onSaved,
    required this.initialValue,
    required this.onChanged,
    required this.hashtags,
    required this.hintText,
    required this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    final label = '해시태그(${_hashtagsToString(hashtags)})';
    return CustomTextFormField(
      initialValue: initialValue,
      label: label,
      onSaved: onSaved,
      onChanged: onChanged,
      hintText: hintText,
      maxLength: maxLength,
    );
  }

  String _hashtagsToString(List<String> hashtags) {
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
}
