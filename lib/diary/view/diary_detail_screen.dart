import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:manager/common/components/custom_text_form_field.dart';
import 'package:manager/common/const/colors.dart';
import 'package:manager/common/const/data.dart';
import 'package:manager/common/layout/default_layout.dart';

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

  String? title;
  DateTime postDate = DateTime.now();
  TextEditingController postDateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  String? weather;
  List<String> hashTags = [];
  List<String?> contentOrder = [];
  List<String> txts = [];

  // final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
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
          controller: scrollController,
          slivers: [
            renderTop(),
            const SliverToBoxAdapter(
              child: SizedBox(height: 16.0),
            ),
            renderDetailContents(contentOrder: contentOrder),
            const SliverToBoxAdapter(
              child: SizedBox(height: 16.0),
            ),
            renderAddContentButton(),
            const SliverToBoxAdapter(
              child: SizedBox(height: 16.0),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter renderAddContentButton() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(PRIMARY_COLOR),
          ),
          onPressed: () {
            setState(() {
              contentOrder.add(null);
              scrollController.animateTo(
                scrollController.position.maxScrollExtent + 150.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
              );
            });
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text('컨텐츠 세부항목 추가하기'),
          ),
        ),
      ),
    );
  }

  SliverPadding renderDetailContents({
    required List<String?> contentOrder,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            // 여기서 selectbox를 두고 txt vid img 중 택1을 진행

            if (contentOrder[index] == null) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: INPUT_BORDER_COLOR,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text('#${index + 1}'),
                          ),
                          const Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Text('컨텐츠 형태 선택')),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                contentOrder.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.cancel_outlined),
                          )
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: PRIMARY_COLOR,
                              side: const BorderSide(
                                color: PRIMARY_COLOR,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                contentOrder[index] = CONTENT_TYPE_TXT;
                              });
                            },
                            child: const Text('텍스트'),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: PRIMARY_COLOR,
                              side: const BorderSide(
                                color: PRIMARY_COLOR,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                contentOrder[index] = CONTENT_TYPE_IMG;
                              });
                            },
                            child: const Text('이미지'),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: PRIMARY_COLOR,
                              side: const BorderSide(
                                color: PRIMARY_COLOR,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                contentOrder[index] = CONTENT_TYPE_VID;
                              });
                            },
                            child: const Text('동영상'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
              );
            }

            return Container(
              height: 300.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: Center(
                child: Text(contentOrder[index]!),
              ),
            );
          },
          childCount: contentOrder.length,
        ),
      ),
    );
  }

  SliverToBoxAdapter renderTop() {
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
          // showImage(),
          // ElevatedButton(
          //   onPressed: () {
          //     getImage(ImageSource.gallery);
          //   },
          //   child: const Text('이미지 가져오기'),
          // ),
          // ElevatedButton(
          //   onPressed: () {
          //     upload(_image!);
          //   },
          //   child: const Text('이미지 업로드하기'),
          // ),

          const SizedBox(height: 16.0),
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _Title(
                    initialValue: title ?? '',
                    onSaved: onTitleSaved,
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          initialValue: weather ?? '',
                          onSaved: onWeatherSaved,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  _HashTags(
                    onSaved: onHashTagsSaved,
                    initialValue: hashTags.join(' '),
                    onChanged: onHashTagsChanged,
                    hashTags: hashTags,
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
      hashTags = splitedList;
    });
  }

  // Widget showImage() {
  //   return Container(
  //       color: const Color(0xffd0cece),
  //       width: MediaQuery.of(context).size.width,
  //       height: MediaQuery.of(context).size.width + 500,
  //       child: Center(
  //           child: _image == null
  //               ? const Text('No image selected.')
  //               : Image.file(
  //                   File(_image!.path),
  //                   fit: BoxFit.fitWidth,
  //                   width: MediaQuery.of(context).size.width,
  //                 )));
  // }

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

  // Future<File> getImage() async {
  //   final ImagePicker picker = ImagePicker();
  //   // Pick an image
  //   final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  //   //TO convert Xfile into file
  //   File file = File(image!.path);
  //   //print(‘Image picked’);
  //   return file;
  // }

  // 비동기 처리를 통해 갤러리에서 이미지를 가져온다.
  // Future getImage(ImageSource imageSource) async {
  //   try {
  //     final image = await picker.pickImage(
  //       source: imageSource,
  //       // imageQuality는 직접 찍은 사진에 대해서 보정값이 들어가며
  //       // 캡쳐한 이미지는 보정값이 적용이 안됨
  //       imageQuality: 85,
  //       // 현재로서 제일 적당한 사이즈로서 보임
  //       // 5mb를 넘지 않으며, 깨짐 정도도 적당함
  //       maxHeight: 1080,
  //       maxWidth: 1080,
  //     );

  //     setState(() {
  //       if (image == null) return;
  //       if (_image != null) {
  //         _image2 = File(image.path);
  //       } else {
  //         _image = File(image.path); // 가져온 이미지를 _image에 저장
  //       }
  //     });
  //   } catch (e) {
  //     // 1. not supported image file(ex : heic)
  //     if (e is PlatformException) {
  //       // print(e);
  //     } else {
  //       print(e);
  //     }
  //   }
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

  // Widget _renderBasicInfo({required String? title}) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       CustomTextFormField(
  //         initialValue: title,
  //         label: '제목',
  //         onSaved: (String? val) {
  //           title = val ?? '';
  //         },
  //       ),
  //       const SizedBox(height: 16.0),
  //       const Row(
  //         children: [
  //           Expanded(
  //             child: Text('???'),
  //             // child: CustomTextField(
  //             //   initialValue:state.postDate,
  //             //   label: '날씨',
  //             //   onSaved: (String? val) {
  //             //     print(val);
  //             //   },
  //             // ),
  //           ),
  //           SizedBox(width: 16.0),
  //           Expanded(
  //             child: Text('???'),

  //             // child: CustomTextField(
  //             //   initialValue: '',
  //             //   label: '게시일자',
  //             //   onSaved: (String? val) {
  //             //     print(val);
  //             //   },
  //             // ),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 16.0),
  //       // CustomTextField(
  //       //   initialValue: '',
  //       //   label: '해시태그',
  //       //   onSaved: (String? val) {
  //       //     print(val);
  //       //   },
  //       // ),
  //     ],
  //   );
  // }

  void onSavePressed() async {
    if (formKey.currentContext == null) return;

    // final DiaryDetailModel state = ref.read(selectedDiaryProvider);

    // form 내 모든 필드의 validate를 실행
    if (formKey.currentState!.validate()) {
      // form 내 모든 필드의 save를 실행
      formKey.currentState!.save();
      // final DiaryDetailModel savingDiaryDetailModel = DiaryDetailModel.empty();
      // savingDiaryDetailModel.copyWith(
      //   title: title,
      // );

      // ref.read(diaryProvider.notifier).addDiary(savingDiaryDetailModel);
    }
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

class _HashTags extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final String initialValue;
  final ValueChanged<String>? onChanged;
  final List<String> hashTags;

  final String hintText;
  final int maxLength;

  const _HashTags({
    required this.onSaved,
    required this.initialValue,
    required this.onChanged,
    required this.hashTags,
    required this.hintText,
    required this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    final label = '해시태그(${_hashTagsToString(hashTags)})';
    return CustomTextFormField(
      initialValue: initialValue,
      label: label,
      onSaved: onSaved,
      onChanged: onChanged,
      hintText: hintText,
      maxLength: maxLength,
    );
  }

  String _hashTagsToString(List<String> hashTags) {
    String result = '';
    for (int i = 0; i < hashTags.length; i++) {
      if (hashTags[i] == '') continue;
      result = "$result#${hashTags[i]}";
      if (i != hashTags.length - 1) {
        result += ' ';
      }
    }
    return result;
  }
}
