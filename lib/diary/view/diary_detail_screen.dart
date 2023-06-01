import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:manager/common/const/colors.dart';
import 'package:manager/common/const/data.dart';
import 'package:manager/common/layout/loading_layout.dart';
import 'package:manager/common/layout/default_layout.dart';
import 'package:manager/diary/model/diary_detail_model.dart';
import 'package:manager/diary/model/diary_model.dart';
import 'package:manager/diary/provider/diary_provider.dart';

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

  @override
  void initState() {
    super.initState();
    ref.read(diaryProvider.notifier).getDetail(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(diaryDetailProvider(widget.id));

    if (state == null) {
      return const DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return LoadingLayout(
      isLoading: isLoading,
      childWidget: Scaffold(
        backgroundColor: Colors.white,
        appBar: _renderTransparentAppBar(),
        extendBodyBehindAppBar: true,
        body: CustomScrollView(
          slivers: [
            _renderTop(model: state),
            if (state is DiaryDetailModel) _renderContent(model: state),
          ],
        ),
      ),
    );
  }

  AppBar _renderTransparentAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Colors.black54,
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _renderTop({
    required DiaryModel model,
  }) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              const SizedBox(
                height: 300,
                child: Placeholder(),
              ),
              Positioned(
                bottom: 16.0,
                right: 0.0,
                child: Container(
                  color: BODY_TEXT_COLOR,
                  child: Row(
                    children: model.hashtags
                        .map<Padding>(
                          (e) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: SizedBox(
                              child: Text(
                                '#$e',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16.0,
                ),
                Text(
                  DateFormat("yy년 M월 d일 HH:mm").format(model.postDT),
                  // textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    '날씨 : ${model.weather}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Center(
                  child: Text(
                    model.title,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // null 처리 어떻게 할지 고민좀
  SliverPadding _renderContent({
    required DiaryDetailModel model,
  }) {
    int txtIndex = 0;
    int imgIndex = 0;
    int vidIndex = 0;

    final content = model.contentOrder.map((e) {
      if (e == DiaryContentType.txt) {
        return model.txts[txtIndex++];
      } else if (e == DiaryContentType.img) {
        return model.imgs[imgIndex++];
      } else if (e == DiaryContentType.vid) {
        return model.vids[vidIndex++];
      }
      return null;
    }).toList();
    if (model.contentOrder.isEmpty) {
      return const SliverPadding(padding: EdgeInsets.all(0.0));
    }

    return SliverPadding(
      padding: const EdgeInsets.only(top: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: content.length,
          (context, index) {
            final contentType = model.contentOrder[index];

            if (contentType == DiaryContentType.txt) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  content[index],
                  style: const TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              );
            } else if (contentType == DiaryContentType.img) {
              imgIndex++;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  height: 300,
                  child: Text('$imgIndex'),
                ),
              );
            } else if (contentType == DiaryContentType.vid) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  height: 300,
                  child: Text('$vidIndex'),
                ),
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}
