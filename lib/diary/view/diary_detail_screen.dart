import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:manager/common/components/thumbnail_video_player.dart';
import 'package:manager/common/const/colors.dart';
import 'package:manager/common/const/data.dart';
import 'package:manager/common/layout/default_layout.dart';
import 'package:manager/common/utils/data_utils.dart';
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

    return Scaffold(
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            _renderThumbnail(model: state),
            _renderBasicInfo(model: state),
            // skeleton screen add here
            if (state is DiaryDetailModel) _renderContent(model: state),
          ],
        ),
      ),
    );
  }

  SliverAppBar _renderThumbnail({
    required DiaryModel model,
  }) {
    final height = MediaQuery.of(context).size.width * 1.3;
    final imageHeight = height + MediaQuery.of(context).viewPadding.top;
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      // elevation: 0,
      expandedHeight: height,

      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            if (model.thumbnail != null)
              if (DataUtils.isImgFile(model.thumbnail!))
                Center(
                  child: Image.network(
                    model.thumbnail!,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: imageHeight,
                  ),
                ),
            if (DataUtils.isVidFile(model.thumbnail!))
              Center(
                child: ThumbnailVideoPalyer(
                  thumbnail: model.thumbnail!,
                ),
              ),
            if (model.thumbnail == null)
              Container(
                color: Colors.grey,
                width: MediaQuery.of(context).size.width,
                height: imageHeight,
              ),
            Positioned(
              bottom: 32.0,
              right: 0.0,
              child: Container(
                color: BODY_TEXT_COLOR,
                child: Row(
                  children: model.hashtags
                      .map<Padding>(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            ),
            Container(
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.black87,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _renderBasicInfo({
    required DiaryModel model,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
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
    );
  }

  SliverPadding _renderContent({
    required DiaryDetailModel model,
  }) {
    int txtIndex = 0;
    int imgIndex = 0;
    int vidIndex = 0;

    List<String?> content = <String>[];
    try {
      content = model.contentOrder.map((e) {
        if (e == DiaryContentType.txt) {
          return model.txts[txtIndex++];
        } else if (e == DiaryContentType.img) {
          return model.imgs[imgIndex++];
        } else if (e == DiaryContentType.vid) {
          return model.vids[vidIndex++];
        }
        return null;
      }).toList();
    } catch (e) {
      return const SliverPadding(padding: EdgeInsets.all(0.0));
    }

    if (model.contentOrder.isEmpty) {
      return const SliverPadding(padding: EdgeInsets.all(0.0));
    }

    return SliverPadding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      sliver: SliverList.separated(
        itemCount: content.length,
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 16.0,
          );
        },
        itemBuilder: (context, index) {
          final contentType = model.contentOrder[index];

          if (contentType == DiaryContentType.txt) {
            return Text(
              content[index]!,
              style: const TextStyle(
                fontSize: 14.0,
              ),
            );
          } else if (contentType == DiaryContentType.img) {
            return Image.network(
              content[index]!,
              fit: BoxFit.cover,
            );
          } else if (contentType == DiaryContentType.vid) {
            return SizedBox(
              height: 300,
              child: Text('$vidIndex'),
            );
          }
          return null;
        },
      ),
    );
  }
}
