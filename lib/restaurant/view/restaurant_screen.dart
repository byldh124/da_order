import 'package:da_order/common/model/cursor_pagination_model.dart';
import 'package:da_order/common/utils/pagination_utils.dart';
import 'package:da_order/restaurant/component/restaurant_card.dart';
import 'package:da_order/restaurant/model/restaurant_model.dart';
import 'package:da_order/restaurant/provider/restaurant_provider.dart';
import 'package:da_order/restaurant/repository/restaurant_repository.dart';
import 'package:da_order/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  // Future<List<RestaurantModel>> paginateRestaurant({required WidgetRef ref}) async {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    PaginationUtils.paginate(
      scrollController: scrollController,
      provider: ref.read(restaurantProvider.notifier),
    );

    /*// 현재 위치가 최대 길이보다 조금 덜 되는 위치까지 왔다면 데이터를 추가 요청
    if (scrollController.offset >
        scrollController.position.maxScrollExtent - 300) {
      ref.read(restaurantProvider.notifier).paginate(fetchMore: true);
    }*/
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantProvider);

    if (data is CursorPaginationLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }

    // CursorPagination
    // CursorPaginationFetchingMore
    // CursorPaginationRefetching
    final cp = data as CursorPagination;

    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        controller: scrollController,
        itemBuilder: (_, index) {
          if (index == cp.data.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Center(
                child: data is CursorPaginationFetchingMore
                    ? CircularProgressIndicator()
                    : Text('마지막 데이터'),
              ),
            );
          }
          final item = cp.data[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => RestaurantDetailScreen(
                        id: item.id,
                      )));
            },
            child: RestaurantCard.fromModel(
              model: item,
              isDetail: false,
            ),
          );
        },
        separatorBuilder: (_, index) {
          return const SizedBox(
            height: 8,
          );
        },
        itemCount: cp.data.length + 1,
      ),
    ));
  }
}
