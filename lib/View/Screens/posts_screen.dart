import 'package:flutter/material.dart';
import 'package:my_counter_app/Model/user.dart';
import 'package:my_counter_app/Model/post.dart';
import 'package:my_counter_app/Service/api_calling.dart';
import 'package:my_counter_app/View/Screens/comments_screen.dart';

class PostsScreen extends StatelessWidget {
  final User user;

  const PostsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts by ${user.name}')),
      body: FutureBuilder<List<Post>>(
        future: ApiCalling().getPostsByUser(user.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts found'));
          }

          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(post.body),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(post: post),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}