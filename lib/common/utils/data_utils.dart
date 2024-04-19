import 'package:da_order/common/const/data.dart';

class DataUtils {
  static String pathToUrl(String value) {
    return 'http://$ip$value';
  }

  static List<String> listPathsToUrl(List<String> urls) {
    return urls.map((e) => pathToUrl(e)).toList();
  }
}
