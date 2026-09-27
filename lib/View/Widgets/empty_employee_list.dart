import 'package:flutter/material.dart';

class EmptyEmployeeList extends StatelessWidget {
  const EmptyEmployeeList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "No employees added yet!",
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}