import 'package:da_order/common/const/data.dart';
import 'package:da_order/common/model/model_with_id.dart';
import 'package:da_order/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_model.g.dart';

enum RestaurantPriceRange { expensive, medium, cheap }

@JsonSerializable()
class RestaurantModel implements IModelWithId{
  @override
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount, deliveryTime, deliveryFee;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.ratings,
    required this.priceRange,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

// factory RestaurantModel.fromJson({
//   required Map<String, dynamic> json,
// }) {
//   return RestaurantModel(
//     id: json['id'],
//     name: json['name'],
//     thumbUrl: 'http://$ip${json['thumbUrl']}',
//     tags: List<String>.from(json['tags']),
//     ratingsCount: json['ratingsCount'],
//     deliveryTime: json['deliveryTime'],
//     deliveryFee: json['deliveryFee'],
//     ratings: json['ratings'],
//     priceRange: RestaurantPriceRange.values.firstWhere(
//       (element) => element.name == json['priceRange'],
//     ),
//   );
// }
}
