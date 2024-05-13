import 'package:da_order/common/component/pagination_list_view.dart';
import 'package:da_order/product/component/product_card.dart';
import 'package:da_order/product/model/product_model.dart';
import 'package:da_order/product/provider/product_provider.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
      provider: productProvider,
      itemBuilder: <ProductModel>(_, index, model) {
        return ProductCard.fromProductModel(model: model);
      },
    );
  }
}
