import 'package:da_order/common/model/cursor_pagination_model.dart';
import 'package:da_order/common/model/pagination_params.dart';

abstract class IBasePaginationRepository<T> {
  Future<CursorPagination<T>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
  });
}
