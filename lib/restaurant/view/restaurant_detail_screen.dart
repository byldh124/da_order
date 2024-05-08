import 'package:da_order/common/layout/default_layout.dart';
import 'package:da_order/common/model/cursor_pagination_model.dart';
import 'package:da_order/product/component/product_card.dart';
import 'package:da_order/rating/component/rating_card.dart';
import 'package:da_order/rating/model/rating_model.dart';
import 'package:da_order/restaurant/component/restaurant_card.dart';
import 'package:da_order/restaurant/model/restaurant_detail_model.dart';
import 'package:da_order/restaurant/model/restaurant_model.dart';
import 'package:da_order/restaurant/provider/restaurant_provider.dart';
import 'package:da_order/restaurant/provider/restaurant_rating_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletons/skeletons.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String id;

  RestaurantDetailScreen({super.key, required this.id});

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  String title = '상세 페이지';

  @override
  void initState() {
    super.initState();
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
  }

  // Future<RestaurantDetailModel> _getRestaurantDetail({required WidgetRef ref}) async {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingState = ref.watch(restaurantRatingProvider(widget.id));

    print("ratingState : $ratingState");

    if (state == null) {
      return DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultLayout(
      title: state.name,
      child: CustomScrollView(
        slivers: [
          _renderTop(model: state),
          if (state is! RestaurantDetailModel) _renderLoading(),
          if (state is RestaurantDetailModel) _renderLabel(),
          if (state is RestaurantDetailModel)
            _renderProducts(products: state.products),
          if (ratingState is CursorPagination<RatingModel>)
            _renderRatings(
              models: ratingState.data,
            )
        ],
      ),
    );
  }

  SliverToBoxAdapter _renderTop({required RestaurantModel model}) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
        detail: '맛있는 떡볶이',
      ),
    );
  }

  SliverPadding _renderProducts({
    required List<RestaurantProductModel> products,
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard(product: products[index]),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  SliverPadding _renderRatings({
    required List<RatingModel> models,
  }) {
    return SliverPadding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
              (_, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: RatingCard.fromModel(model: models[index]),
                  ),
              childCount: models.length),
        ));
  }

  SliverPadding _renderLoading() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(List.generate(
            3,
            (index) => Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: SkeletonParagraph(
                    style: SkeletonParagraphStyle(
                        lines: 5, padding: EdgeInsets.zero),
                  ),
                ))),
      ),
    );
  }

  SliverPadding _renderLabel() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
