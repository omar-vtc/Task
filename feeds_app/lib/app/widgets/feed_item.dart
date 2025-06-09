import 'package:flutter/material.dart';

class FeedItem extends StatelessWidget {
  const FeedItem({super.key, required this.imgUrl});
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.hardEdge,
      elevation: 8,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  "User Name",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Image(
            image: NetworkImage(imgUrl),
            fit: BoxFit.cover,
            height: 600,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
