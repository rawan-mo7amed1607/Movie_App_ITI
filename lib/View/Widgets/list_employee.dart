import 'package:flutter/material.dart';
import 'package:my_counter_app/Model/employee.dart';

class ListEmployee extends StatelessWidget {
  final List<Employee> employees;

  const ListEmployee({super.key, required this.employees});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final employee = employees[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Icon(employee.image),
            ),
            title: Text(employee.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Department: ${employee.department.name}"),
                Text("Phone: ${employee.phoneNumber}"),
                Text("Email: ${employee.email}"),
                Text("Age: ${employee.age} | Salary: \$${employee.salary}"),
              ],
            ),
          ),
        );
      },
    );
  }
}