import 'package:flutter/material.dart';

enum Department { IT, HR, Finance, Marketing }

class Employee {
  final int id;
  final String name;
  final int age;
  final double salary;
  final String phoneNumber;
  final String email;
  final Department department;
  final IconData image;

  Employee({
    required this.id,
    required this.name,
    required this.age,
    required this.salary,
    required this.phoneNumber,
    required this.email,
    required this.department,
    required this.image,
  });
}
