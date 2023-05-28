import 'package:flutter/material.dart';
import 'package:manager/common/const/setting.dart';
import 'package:manager/common/provider/pagination_provider.dart';

class PaginationUtils {
  static void paginate({
    required ScrollController controller,
    required PaginationProvider provider,
  }) {
    if (controller.offset >
        controller.position.maxScrollExtent - GAP_WHEN_PAGINATE) {
      provider.paginate(
        fetchMore: true,
      );
    }
  }
}
