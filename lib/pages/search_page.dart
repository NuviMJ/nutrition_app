import 'package:flutter/material.dart';

class Post {
  final String title;
  final String description;

  Post({required this.title, required this.description});
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Post> allPosts = [];
  List<Post> filteredPosts = [];

  @override
  void initState() {
    super.initState();
    allPosts = [
      Post(
          title: 'Salad Recipes',
          description: 'Fresh and healthy salad ideas.'),
      Post(
          title: 'Smoothies',
          description: 'Delicious fruit and veggie blends.'),
      Post(
          title: 'Healthy Snacks',
          description: 'Quick and nutritious snack options.'),
      Post(
          title: 'Workout Tips',
          description: 'Best exercises to stay in shape.'),
      Post(
          title: 'Mental Health',
          description: 'Simple mindfulness and relaxation techniques.'),
    ];
    filteredPosts = allPosts;
  }

  void _search(String query) {
    final results = allPosts.where((post) {
      final titleLower = post.title.toLowerCase();
      final descriptionLower = post.description.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower) ||
          descriptionLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredPosts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Search posts...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _search,
            ),
          ),
          Expanded(
            child: filteredPosts.isEmpty
                ? const Center(child: Text('No matching posts found.'))
                : ListView.builder(
                    itemCount: filteredPosts.length,
                    itemBuilder: (context, index) {
                      final post = filteredPosts[index];
                      return ListTile(
                        leading: const Icon(Icons.article),
                        title: Text(post.title),
                        subtitle: Text(post.description),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
