import 'package:flutter/material.dart';
import 'package:my_counter_app/Model/employee.dart';

class GridEmployee extends StatelessWidget {
  final List<Employee> employees;

  const GridEmployee({super.key, required this.employees});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final employee = employees[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(employee.image, size: 40),
                const SizedBox(height: 5),
                Text(
                  employee.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("Dept: ${employee.department.name}"),
                Text("Phone: ${employee.phoneNumber}"),
                Text("Email: ${employee.email}"),
                Text("Age: ${employee.age} | \$${employee.salary}"),
              ],
            ),
          ),
        );
      },
    );
  }
}