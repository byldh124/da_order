import 'package:da_order/common/const/colors.dart';
import 'package:da_order/restaurant/model/restaurant_detail_model.dart';
import 'package:da_order/restaurant/model/restaurant_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  // 이미지
  final Widget image;

  // 레스토랑 이름
  final String name;

  // 레스토랑 태그
  final List<String> tags;

  // 평점 갯수
  final int ratingsCount;

  // 배송 걸리는 시간
  final int deliveryTime;

  // 배송 비용
  final int deliveryFee;

  // 평균 평점
  final double ratings;

  //상세카드여부
  final bool isDetail;

  //Hero Widget tag
  final String? heroKey;

  final String? detail;

  const RestaurantCard({
    super.key,
    required this.image,
    required this.name,
    required this.tags,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.ratings,
    this.isDetail = false,
    this.heroKey,
    this.detail,
  });

  factory RestaurantCard.fromModel(
      {required RestaurantModel model, bool isDetail = false, String? detail}) {
    return RestaurantCard(
      image: Image.network(
        model.thumbUrl,
        fit: BoxFit.cover,
      ),
      name: model.name,
      tags: model.tags,
      ratingsCount: model.ratingsCount,
      deliveryTime: model.deliveryTime,
      deliveryFee: model.deliveryFee,
      ratings: model.ratings,
      isDetail: isDetail,
      heroKey: model.id,
      detail: model is RestaurantDetailModel && isDetail ? model.detail : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (heroKey != null)
          Hero(
            tag: ObjectKey(heroKey),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDetail ? 0 : 12),
              child: image,
            ),
          ),
        if (heroKey == null)
          ClipRRect(
            borderRadius: BorderRadius.circular(isDetail ? 0 : 12),
            child: image,
          ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isDetail ? 16 : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                tags.join(' · '),
                style: TextStyle(color: BODY_TEXT_COLOR, fontSize: 14),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  _IconText(
                    icon: Icons.star,
                    label: ratings.toString(),
                  ),
                  _renderDot(),
                  _IconText(
                    icon: Icons.receipt,
                    label: ratingsCount.toString(),
                  ),
                  _renderDot(),
                  _IconText(
                    icon: Icons.timelapse_outlined,
                    label: '$deliveryTime 분',
                  ),
                  _renderDot(),
                  _IconText(
                    icon: Icons.monetization_on,
                    label: '${deliveryFee == 0 ? '무료' : deliveryFee}',
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              if (detail != null) Text('$detail'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _renderDot() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          '·',
          style: TextStyle(fontWeight: FontWeight.w500),
        ));
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconText({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: PRIMARY_COLOR,
          size: 14,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
