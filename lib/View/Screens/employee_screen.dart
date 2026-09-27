import 'package:flutter/material.dart';
import 'package:my_counter_app/Model/employee.dart';
import 'package:my_counter_app/View/Widgets/empty_employee_list.dart';
import 'package:my_counter_app/View/Widgets/grid_employee.dart';
import 'package:my_counter_app/View/Widgets/list_employee.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final List<Employee> employees = [];
  bool isGrid = false;

  final List<Department> departments = Department.values;
  final Map<String, IconData> imageIcons = {
    'Person': Icons.person,
    'Work': Icons.work,
    'Account': Icons.account_circle,
    'Badge': Icons.badge,
  };

  void _showEmployeeDialog(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final salaryController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();

    Department selectedDepartment = Department.IT;
    IconData selectedIcon = Icons.person;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Add Employee"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "Name"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Age"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: salaryController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Salary"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: "Phone Number"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: "Email"),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<Department>(
                      value: selectedDepartment,
                      decoration: const InputDecoration(labelText: "Department"),
                      items: departments.map((Department dept) {
                        return DropdownMenuItem<Department>(
                          value: dept,
                          child: Text(dept.name),
                        );
                      }).toList(),
                      onChanged: (Department? newValue) {
                        if (newValue != null) {
                          setDialogState(() {
                            selectedDepartment = newValue;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<IconData>(
                      value: selectedIcon,
                      decoration: const InputDecoration(labelText: "Select Image / Icon"),
                      items: imageIcons.entries.map((entry) {
                        return DropdownMenuItem<IconData>(
                          value: entry.value,
                          child: Row(
                            children: [
                              Icon(entry.value),
                              const SizedBox(width: 8),
                              Text(entry.key),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (IconData? newValue) {
                        if (newValue != null) {
                          setDialogState(() {
                            selectedIcon = newValue;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      setState(() {
                        employees.add(
                          Employee(
                            id: employees.length + 1,
                            name: nameController.text,
                            age: int.tryParse(ageController.text) ?? 0,
                            salary: double.tryParse(salaryController.text) ?? 0.0,
                            phoneNumber: phoneController.text,
                            email: emailController.text,
                            department: selectedDepartment,
                            image: selectedIcon,
                          ),
                        );
                      });
                      Navigator.pop(dialogContext);
                    }
                  },
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Management"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("List"),
                Switch(
                  value: isGrid,
                  onChanged: (value) {
                    setState(() {
                      isGrid = value;
                    });
                  },
                ),
                const Text("Grid"),
              ],
            ),
            const Divider(),
            Expanded(
              child: employees.isEmpty
                  ? const EmptyEmployeeList()
                  : (isGrid
                      ? GridEmployee(employees: employees)
                      : ListEmployee(employees: employees)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEmployeeDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}