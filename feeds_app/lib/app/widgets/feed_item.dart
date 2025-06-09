import 'package:flutter/material.dart';

class FeedItem extends StatelessWidget {
  final String imgUrl;
  final String firstName;
  final String lastName;

  const FeedItem({
    super.key,
    required this.imgUrl,
    required this.firstName,
    required this.lastName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.hardEdge,
      elevation: 8,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10),

                child: Row(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(width: 10),
                    Text(
                      '$firstName $lastName',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
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
