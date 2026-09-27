import 'package:flutter/material.dart';
import 'package:my_counter_app/Service/api_calling.dart';
import 'package:my_counter_app/Model/user.dart';
import 'package:my_counter_app/View/Screens/posts_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
  
    if (_usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter any name!')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      List<User> users = await ApiCalling().getUsers();

      setState(() => _isLoading = false);

      if (users.isNotEmpty) {
        
        User defaultUser = users.first;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostsScreen(user: defaultUser),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                hintText: 'e.g. Bret',
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}