import 'package:da_order/common/const/data.dart';
import 'package:da_order/common/secure_storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureStorageProvider);

  final dio = Dio();
  dio.interceptors.add(
    CustomInterceptor(storage: storage),
  );
  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({required this.storage});

  // 1) 요청을 보낼 때
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');

    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');
      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      options.headers['authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  // 2) 응답을 받을 때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES ${response.statusCode}] [${response.requestOptions.method}] ${response.requestOptions.uri}');
    print('[RES] ${response.data}');

    super.onResponse(response, handler);
  }

  // 3) 에러가 났을 때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401에러가 났을때 (status code)
    // 토큰을 재발급 받는 시도를 하고 토큰이 재발급 되면
    // 다시 새로운 토큰으로 요청을 한다.

    print('[ERROR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // refreshToken 아예 없으면
    // 에러를 던진다
    if (refreshToken == null) {
      //에러를 던질때는 handler.reject를 사용한다.
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        final response = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );

        final accessToken = response.data['accessToken'];
        final options = err.requestOptions;
        options.headers['authorization'] = 'Bearer $accessToken';

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        await dio.fetch(err.requestOptions);
      } on DioException catch (e) {
        return handler.reject(err);
      }
    }

    super.onError(err, handler);
  }
}
