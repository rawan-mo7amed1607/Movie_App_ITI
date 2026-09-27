import 'package:flutter/material.dart';
import 'package:my_counter_app/Model/post.dart';
import 'package:my_counter_app/Model/comment.dart';
import 'package:my_counter_app/Service/api_calling.dart';

class CommentsScreen extends StatelessWidget {
  final Post post;

  const CommentsScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Comments (${post.title})')),
      body: FutureBuilder<List<Comment>>(
        future: ApiCalling().getCommentsByPost(post.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No comments found'));
          }

          final comments = snapshot.data!;
          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(child: Text(comment.id.toString())),
                  title: Text(comment.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(comment.email, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 5),
                      Text(comment.body),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}