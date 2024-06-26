import 'package:da_order/common/model/cursor_pagination_model.dart';
import 'package:da_order/common/model/pagination_params.dart';
import 'package:da_order/common/provider/pagination_provider.dart';
import 'package:da_order/restaurant/model/restaurant_model.dart';
import 'package:da_order/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }

  return state.data.firstWhere((element) => element.id == id);
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  return RestaurantStateNotifier(repository: repository);
});

class RestaurantStateNotifier extends PaginationProvider<RestaurantModel, RestaurantRepository> {

  RestaurantStateNotifier({
    required super.repository,
  });

  /// migrate -> @PaginationProvider
  /*Future<void> paginate(
      {int fetchCount = 20,
      //추가로 데이터 더 가져오기
      // true - 추가로 데이터 더 가져옴
      // false - 새로고침(현재 상태를 덮어씌움)
      bool fetchMore = false,
      // 강제로 다시 로딩하기
      // true - CursorPaginationLoading()
      bool forceRefecth = false}) async {
    try {
      // state의 상태는 5가지가 될수 있음.
      // 1) CursorPagination - 정상적으로 데이터가 있음
      // 2) CursorPaginationLoading - 데이터가 로딩중 (캐시 없음)
      // 3) CursorPaginationError - 에러 발생
      // 4) CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터를 가져옴
      // 5) CursorPaginationFetchMore = 추가 데이터를 paginate 해오라는 요청을 받았을 때
      // 바로 반환하는 상황
      // 1) hasMore = false (기존 상태에서 이미 다음 데이터가 없다는 값을 들고있다면)
      // 2) 로딩중 - fetchMore : true
      //    fetchMore가 아닐때

      if (state is CursorPagination && !forceRefecth) {
        final pState = state as CursorPagination;
        if (!pState.meta.hasMore) {
          return;
        }
      }

      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(count: fetchCount);

      if (fetchMore) {
        final pState = state as CursorPagination;

        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        paginationParams =
            paginationParams.copyWith(after: pState.data.last.id);
      } else {
        // 만약에 데이터가 있는 상황이라면
        // 기존 데이터를 보존한채로 fetch (api 요청)을 진행
        if (state is CursorPagination && !forceRefecth) {
          final pState = state as CursorPagination;
          state = CursorPaginationRefetching(
            meta: pState.meta,
            data: pState.data,
          );
        }
        //나머지 상황
        else {
          state = CursorPaginationLoading();
        }
      }

      final response = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore;

        //기존 데이터에 새로운 데이터 추가
        state = response.copyWith(
          data: [
            ...pState.data,
            ...response.data,
          ],
        );
      } else {
        state = response;
      }
    } catch (e) {
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }*/

  void getDetail({
    required String id,
  }) async {
    // 만약에 아직 데이터가 하나도 없는 상태라면 (CursorPagination이 아니라면)
    // 데이터를 가져오는 시도를 한다.
    if (state is! CursorPagination) {
      await paginate();
    }

    // state 가 CursorPagination이 아닐때 그냥 리턴
    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;

    final response = await repository.getRestaurantDetail(id: id);

    state = pState.copyWith(
      data: pState.data
          .map<RestaurantModel>((e) => e.id == id ? response : e)
          .toList(),
    );
  }
}
