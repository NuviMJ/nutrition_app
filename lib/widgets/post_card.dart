import 'dart:math';
import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final String postId;
  final Map<String, dynamic> postData;
  final String caption;
  final String imageUrl;
  final String username;
  final List<dynamic> likedBy;
  final int commentCount;
  final Map<String, dynamic>? nutrition;

  final void Function(bool isLiked) onLikeToggle;
  final VoidCallback onCommentTap;

  const PostCard({
    super.key,
    required this.postId,
    required this.postData,
    required this.caption,
    required this.imageUrl,
    required this.username,
    required this.likedBy,
    required this.commentCount,
    required this.onLikeToggle,
    required this.onCommentTap,
    this.nutrition,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late bool isLiked;
  late int currentLikeCount;
  Map<String, dynamic>? randomNutrition;

  final List<String> nutritionLabels = [
    'Protein',
    'Fat',
    'Carbs',
    'Vitamin C',
    'Calcium',
  ];

  @override
  void initState() {
    super.initState();
    String currentUserId = 'currentUserId'; // Replace with actual user ID
    isLiked = widget.likedBy.contains(currentUserId);
    currentLikeCount = widget.likedBy.length;

    if (widget.nutrition == null || widget.nutrition!.isEmpty) {
      randomNutrition = _generateRandomNutrition();
    }
  }

  Map<String, dynamic> _generateRandomNutrition() {
    final rand = Random();
    Map<String, dynamic> data = {};
    final count = 3 + rand.nextInt(nutritionLabels.length - 2);
    final selectedLabels = List<String>.from(nutritionLabels)..shuffle(rand);

    for (int i = 0; i < count; i++) {
      data[selectedLabels[i]] = rand.nextInt(101);
    }
    return data;
  }

  void toggleLike() {
    setState(() {
      isLiked ? currentLikeCount-- : currentLikeCount++;
      isLiked = !isLiked;
    });
    widget.onLikeToggle(isLiked);
  }

  Widget _buildNutritionInfo() {
    final nutritionData = (widget.nutrition == null || widget.nutrition!.isEmpty)
        ? randomNutrition
        : widget.nutrition;

    if (nutritionData == null || nutritionData.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: nutritionData.entries.map((entry) {
          final String label = entry.key;
          final double value = (entry.value as num).toDouble().clamp(0, 100);

          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$label: ${value.toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: value / 100,
                  backgroundColor: Colors.grey[300],
                  color: Colors.green,
                  minHeight: 6,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Icons.account_circle, size: 40),
            title: Text(widget.username, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: widget.imageUrl.isNotEmpty
                ? Image.network(widget.imageUrl, fit: BoxFit.cover)
                : Image.asset(
                    'assets/placeholder.jpg', // Make sure this file exists in your assets folder
                    fit: BoxFit.cover,
                  ),
          ),
          _buildNutritionInfo(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(widget.caption, style: const TextStyle(fontSize: 16)),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: toggleLike,
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                  label: Text(currentLikeCount.toString()),
                ),
                TextButton.icon(
                  onPressed: widget.onCommentTap,
                  icon: const Icon(Icons.comment_outlined, color: Colors.grey),
                  label: Text(widget.commentCount.toString()),
                ),
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Share feature not implemented yet.')),
                    );
                  },
                  icon: const Icon(Icons.share_outlined, color: Colors.grey),
                  label: const Text('Share'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
