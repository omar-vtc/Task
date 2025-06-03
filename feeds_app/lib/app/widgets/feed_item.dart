import 'package:feeds_app/domain/entities/media.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class FeedItem extends StatelessWidget {
  const FeedItem({super.key, required this.imgUrl});
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.hardEdge,
      elevation: 8,
      child: Image(
        image: NetworkImage(imgUrl),
        fit: BoxFit.cover,
        height: 300,
        width: double.infinity,
      ),
    );
  }
}
