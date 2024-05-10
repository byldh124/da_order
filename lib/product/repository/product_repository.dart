import 'package:da_order/common/const/data.dart';
import 'package:da_order/common/dio/dio.dart';
import 'package:da_order/common/model/cursor_pagination_model.dart';
import 'package:da_order/common/model/pagination_params.dart';
import 'package:da_order/common/repository/base_pagination_repository.dart';
import 'package:da_order/product/model/product_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';

part 'product_repository.g.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final repository = ProductRepository(dio, baseUrl: 'http://$ip/product');
  return repository;
});

@RestApi()
abstract class ProductRepository implements IBasePaginationRepository<ProductModel> {
  factory ProductRepository(Dio dio, {String baseUrl}) = _ProductRepository;

  @override
  @GET('/')
  @Headers({'accessToken' : 'true'})
  Future<CursorPagination<ProductModel>> paginate({PaginationParams? paginationParams = const PaginationParams()});
}