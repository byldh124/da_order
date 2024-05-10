import 'package:da_order/common/provider/pagination_provider.dart';
import 'package:flutter/cupertino.dart';

class PaginationUtils {
  static void paginate({
    required ScrollController scrollController,
    required PaginationProvider provider,
  }) {
    // 현재 위치가 최대 길이보다 조금 덜 되는 위치까지 왔다면 데이터를 추가 요청
    if (scrollController.offset > scrollController.position.maxScrollExtent - 300) {
      provider.paginate(fetchMore: true);
    }
  }
}
