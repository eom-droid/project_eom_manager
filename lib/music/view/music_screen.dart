import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manager/common/components/pagination_list_view.dart';
import 'package:manager/common/const/data.dart';
import 'package:manager/music/components/music_card.dart';
import 'package:manager/music/provider/music_provider.dart';
import 'package:manager/music/view/music_edit_screen.dart';

class MusicScreen extends ConsumerWidget {
  const MusicScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('???????????');
    return Stack(
      children: [
        PaginationListView(
          provider: musicProvider,
          itemBuilder: <MusicModel>(_, int index, model) {
            // return MusicCard.fromModel(
            //   model: model,
            // );
            return MusicCard.fromModel(
              model: model,
            );
          },
        ),
        Positioned(
          bottom: 20,
          right: 0,
          child: FloatingActionButton(
            onPressed: () async {
              context.pushNamed(
                MusicEditScreen.routeName,
                pathParameters: {'rid': NEW_ID},
              );
            },
            child: const Icon(Icons.add),
          ),
        )
      ],
    );
  }

  // pushNamed({
  //   required WidgetRef ref,
  //   required BuildContext context,
  //   required String routeName,
  //   required String snackBarText,
  //   String? id,
  // }) async {
  //   final popData = await context.pushNamed<PopDataModel>(
  //     DiaryEditScreen.routeName,
  //     pathParameters: {'rid': id ?? NEW_ID},
  //   );
  //   if (popData != null && popData.refetch == true) {
  //     ref.read(diaryProvider.notifier).paginate(forceRefetch: true);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(snackBarText),
  //       ),
  //     );
  //   }
  // }
}
