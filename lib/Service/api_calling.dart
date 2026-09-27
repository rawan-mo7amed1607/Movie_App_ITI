import 'package:http/http.dart' as http;
import 'package:my_counter_app/Model/user.dart';
import 'package:my_counter_app/Model/post.dart';
import 'package:my_counter_app/Model/comment.dart';

class ApiCalling {
  final String baseUrl = "https://jsonplaceholder.typicode.com";

  Future<List<User>> getUsers() async {
    final url = Uri.parse("$baseUrl/users");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return userFromJson(response.body);
    } else {
      throw Exception("Failed to load users");
    }
  }

  Future<List<Post>> getPostsByUser(int userId) async {
    final url = Uri.parse("$baseUrl/posts?userId=$userId");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return postFromJson(response.body);
    } else {
      throw Exception("Failed to load posts");
    }
  }

  Future<List<Comment>> getCommentsByPost(int postId) async {
    final url = Uri.parse("$baseUrl/comments?postId=$postId");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return commentFromJson(response.body);
    } else {
      throw Exception("Failed to load comments");
    }
  }
}