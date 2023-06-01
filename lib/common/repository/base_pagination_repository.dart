import 'package:manager/common/model/cursor_pagination_model.dart';
import 'package:manager/common/model/model_with_id.dart';
import 'package:manager/common/model/pagination_params.dart';

// T는 paginating을 진행할 Model
// P는 pagination을 위한 params model
abstract class IBasePaginationRepository<T extends IModelPagination,
    P extends PaginationParamsBase> {
  Future<CursorPagination<T>> paginate({
    P? paginationParams,
  });
}
