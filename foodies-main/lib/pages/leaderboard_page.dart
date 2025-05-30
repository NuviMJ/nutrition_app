import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  Future<List<Map<String, dynamic>>> _fetchLeaderboardData() async {
    // 1a. Fetch all user documents
    QuerySnapshot userDocsSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    // 1b. Fetch all posts and aggregate post counts
    QuerySnapshot postsSnapshot =
        await FirebaseFirestore.instance.collection('posts').get();
    Map<String, int> userPostCounts = {};
    for (var postDoc in postsSnapshot.docs) {
      final postData = postDoc.data() as Map<String, dynamic>?;
      if (postData != null && postData.containsKey('userId')) {
        final String userId = postData['userId'];
        userPostCounts[userId] = (userPostCounts[userId] ?? 0) + 1;
      }
    }

    // 1c. Create a new list for leaderboard entries
    List<Map<String, dynamic>> leaderboardEntries = [];
    
    // Create a map of user data for easy lookup
    Map<String, Map<String, dynamic>> usersMap = {};
    for (var userDoc in userDocsSnapshot.docs) {
      usersMap[userDoc.id] = userDoc.data() as Map<String, dynamic>;
    }

    // 1d. Iterate through userDocs (or rather usersMap for efficient lookup)
    // This prioritizes users in the 'users' collection
    usersMap.forEach((userId, userData) {
      // 1d.i. Get userId and displayName
      final String displayName = userData['displayName'] as String? ??
                               userData['email'] as String? ??
                               userId; // Fallback to userId
      // 1d.ii. Get postCount
      final int postCount = userPostCounts[userId] ?? 0;
      
      // 1d.iii. Add to leaderboardEntries
      leaderboardEntries.add({
        'displayName': displayName,
        'postCount': postCount,
        'userId': userId, // Keep userId for reference if needed
      });
    });

    // 1e. (Optional) Add users who have posts but no entry in 'users' collection
    userPostCounts.forEach((userId, count) {
      if (!usersMap.containsKey(userId)) { // If user not already added from usersMap
        leaderboardEntries.add({
          'displayName': userId, // Use userId as displayName
          'postCount': count,
          'userId': userId,
        });
      }
    });

    // 1f. Sort leaderboardEntries by postCount descending
    leaderboardEntries.sort((a, b) => (b['postCount'] as int).compareTo(a['postCount'] as int));

    // 1g. Return this list
    return leaderboardEntries;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchLeaderboardData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print('Leaderboard Error: ${snapshot.error}'); // Log error for debugging
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No leaderboard data available.'));
          }

          final leaderboardData = snapshot.data!;

          return ListView.builder(
            itemCount: leaderboardData.length,
            itemBuilder: (context, index) {
              final entry = leaderboardData[index];
              // 2. Update ListTile to display displayName and postCount
              final String displayName = entry['displayName'] as String;
              final int postCount = entry['postCount'] as int;

              return ListTile(
                leading: CircleAvatar(child: Text('#${index + 1}')),
                title: Text(displayName), // Use displayName
                trailing: Text('Posts: $postCount'),
              );
            },
          );
        },
      ),
    );
  }
}
