import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manager/common/components/custom_text_form_field.dart';
import 'package:manager/common/layout/default_layout.dart';
import 'package:manager/diary/model/diary_detail_model.dart';
import 'package:manager/diary/provider/diary_provider.dart';

class DiaryAddScreen extends ConsumerStatefulWidget {
  static String get routeName => 'diaryAdd';

  const DiaryAddScreen({
    super.key,
  });

  @override
  ConsumerState<DiaryAddScreen> createState() => _DiaryAddScreenState();
}

class _DiaryAddScreenState extends ConsumerState<DiaryAddScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String? title;

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300.0,
                color: Colors.grey[300],
                child: const Center(
                  child: Text('썸네일 들어갈 자리'),
                ),
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 16.0),
                      _Title(
                        initialValue: title ?? '',
                        onSaved: onTitleSaved,
                      ),
                      const SizedBox(height: 16.0),
                      // ListView.separated(
                      //   // 이렇게 하는 것은 굉장히 비효율적인 방법임
                      //   // build할때 너무 비쌈....
                      //   shrinkWrap: true,
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   separatorBuilder: (_, index) {
                      //     return const SizedBox(
                      //       height: 8.0,
                      //     );
                      //   },
                      //   itemCount: state.contentOrder.length,
                      //   itemBuilder: (_, index) {
                      //     return Container(
                      //       height: 300.0,
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(8.0),
                      //         border: Border.all(
                      //           color: Colors.black,
                      //         ),
                      //       ),
                      //       child: const Center(
                      //         child: Text('컨텐츠 들어갈 자리'),
                      //       ),
                      //     );
                      //   },
                      // ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          // state.contentOrder.add('txt');
                          // ref
                          //     .read(selectedDiaryProvider.notifier)
                          //     .updateDiary(state);
                        },
                        child: const Text('컨텐츠 추가하기'),
                      ),
                      const SizedBox(height: 32.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onTitleSaved(String? val) {
    title = val ?? '';
  }

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
      final DiaryDetailModel savingDiaryDetailModel = DiaryDetailModel.empty();
      savingDiaryDetailModel.copyWith(
        title: title,
      );

      ref.read(diaryProvider.notifier).addDiary(savingDiaryDetailModel);
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
