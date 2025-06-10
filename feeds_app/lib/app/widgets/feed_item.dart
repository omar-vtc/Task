import 'package:flutter/material.dart';

class FeedItem extends StatelessWidget {
  final String imgUrl;
  final String firstName;
  final String lastName;
  final bool isLiked; // 🆕
  final VoidCallback onLikeToggle; // 🆕

  const FeedItem({
    super.key,
    required this.imgUrl,
    required this.firstName,
    required this.lastName,
    required this.isLiked,
    required this.onLikeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.hardEdge,
      elevation: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.person),
                const SizedBox(width: 10),
                Text(
                  '$firstName $lastName',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Image with Like Button Overlay
          Stack(
            children: [
              Image.network(
                imgUrl,
                fit: BoxFit.cover,
                height: 600,
                width: double.infinity,
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: IconButton(
                  onPressed: onLikeToggle,
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
