import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manager/common/components/custom_text_field.dart';
import 'package:manager/common/layout/default_layout.dart';
import 'package:manager/diary/model/diary_model.dart';
import 'package:manager/home/provider/diary_selected_provider.dart';

class DiaryAddScreen extends ConsumerWidget {
  static String get routeName => 'diaryAdd';

  const DiaryAddScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DiaryDetailModel state = ref.watch(selectedDiaryProvider);
    print('rebeuild');
    return DefaultLayout(
      title: 'Diary Add',
      isFullScreen: true,
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
            const SizedBox(height: 16.0),
            _renderBasicInfo(),
            const SizedBox(height: 16.0),
            ListView.separated(
              // 이렇게 하는 것은 굉장히 비효율적인 방법임
              // build할때 너무 비쌈....
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, index) {
                return const SizedBox(
                  height: 8.0,
                );
              },
              itemCount: state.contentOrder.length,
              itemBuilder: (_, index) {
                return Container(
                  height: 300.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: const Center(
                    child: Text('컨텐츠 들어갈 자리'),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                state.contentOrder.add('txt');
                ref.read(selectedDiaryProvider.notifier).updateDiary(state);
              },
              child: const Text('추가하기'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderBasicInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            initialValue: '',
            label: '제목',
            onSaved: (String? val) {
              print(val);
            },
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  initialValue: '',
                  label: '날씨',
                  onSaved: (String? val) {
                    print(val);
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: CustomTextField(
                  initialValue: '',
                  label: '게시일자',
                  onSaved: (String? val) {
                    print(val);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          CustomTextField(
            initialValue: '',
            label: '해시태그',
            onSaved: (String? val) {
              print(val);
            },
          ),
        ],
      ),
    );
  }
}
