import 'package:flutter/material.dart';
import '../models/budget_tracker.dart';

class BudgetTrackerScreen extends StatefulWidget {
  const BudgetTrackerScreen({super.key});

  @override
  State<BudgetTrackerScreen> createState() => _BudgetTrackerScreenState();
}

class _BudgetTrackerScreenState extends State<BudgetTrackerScreen> {
  final List<BudgetTracker> moneyList = [
    BudgetTracker(
      name: "Spent",
      amount: 250,
      type: Type.spent,
      isSpent: true,
    ),
    BudgetTracker(
      name: "Salary",
      amount: 10000,
      type: Type.salary,
      isSpent: false,
    ),
  ];

  double get totalBalance {
    double total = 0;
    for (var item in moneyList) {
      if (item.isSpent) {
        total -= item.amount;
      } else {
        total += item.amount;
      }
    }
    return total;
  }

  void _showAddTransactionDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    final customTypeController = TextEditingController();

    Type selectedType = Type.salary;
    bool isSpent = false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Add Transaction",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "Transaction Name",
                          prefixIcon: Icon(Icons.edit),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter a name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: "Amount",
                          prefixIcon: Icon(Icons.attach_money),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter an amount";
                          }
                          if (double.tryParse(value) == null || double.parse(value) <= 0) {
                            return "Please enter a valid positive number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSpent ? Colors.red[50] : Colors.green[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSpent ? Colors.red.shade200 : Colors.green.shade200,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isSpent ? "Spent (Expense -)" : "Income (+)",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: isSpent ? Colors.red : Colors.green,
                              ),
                            ),
                            Switch(
                              value: isSpent,
                              activeColor: Colors.red,
                              inactiveThumbColor: Colors.green,
                              onChanged: (val) {
                                setDialogState(() {
                                  isSpent = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      DropdownButtonFormField<Type>(
                        value: selectedType,
                        decoration: const InputDecoration(
                          labelText: "Category Type",
                          prefixIcon: Icon(Icons.category),
                          border: OutlineInputBorder(),
                        ),
                        items: Type.values.map((type) {
                          return DropdownMenuItem<Type>(
                            value: type,
                            child: Text(type.name),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() {
                              selectedType = val;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),

                      if (selectedType == Type.other)
                        TextFormField(
                          controller: customTypeController,
                          decoration: const InputDecoration(
                            labelText: "Specify Other Type",
                            hintText: "e.g., Shopping, Gym...",
                            prefixIcon: Icon(Icons.more_horiz),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (selectedType == Type.other &&
                                (value == null || value.trim().isEmpty)) {
                              return "Please specify the type";
                            }
                            return null;
                          },
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        moneyList.add(
                          BudgetTracker(
                            name: nameController.text.trim(),
                            amount: double.parse(amountController.text.trim()),
                            type: selectedType,
                            isSpent: isSpent,
                            customType: selectedType == Type.other
                                ? customTypeController.text.trim()
                                : null,
                          ),
                        );
                      });
                      Navigator.of(ctx).pop();
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Budget Tracker",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTransactionDialog,
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.indigo, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Your Current Money",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "\$${totalBalance.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: totalBalance < 0 ? Colors.redAccent : Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Recent Transactions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: moneyList.isEmpty
                  ? const Center(
                      child: Text(
                        "No transactions available yet.",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: moneyList.length,
                      itemBuilder: (context, index) {
                        final item = moneyList[index];
                        final displayType = item.type == Type.other && item.customType != null
                            ? item.customType!
                            : item.type.name;

                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: item.isSpent
                                  ? Colors.red[50]
                                  : Colors.green[50],
                              child: Icon(
                                item.isSpent
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: item.isSpent ? Colors.red : Colors.green,
                              ),
                            ),
                            title: Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Type: $displayType",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            trailing: Text(
                              "${item.isSpent ? '-' : '+'} \$${item.amount.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: item.isSpent ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}