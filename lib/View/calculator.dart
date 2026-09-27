import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _number = '';
  int num1 = 0;
  int num2 = 0;
  String operator = '';
  String result = '';

  void _onNumberClick(String value) {
    setState(() {
      _number += value;
    });
  }

  void _onOperatorClick(String op) {
    setState(() {
      if (_number.isNotEmpty) {
        num1 = int.tryParse(_number) ?? 0;
        operator = op;
        _number = '';
      }
    });
  }

  void _calculateResult() {
    setState(() {
      if (_number.isNotEmpty && operator.isNotEmpty) {
        num2 = int.tryParse(_number) ?? 0;
        int res = 0;

        switch (operator) {
          case '+':
            res = num1 + num2;
            break;
          case '-':
            res = num1 - num2;
            break;
          case 'x':
            res = num1 * num2;
            break;
          case '/':
            if (num2 != 0) {
              result = (num1 / num2).toStringAsFixed(2);
              _number = result;
              operator = '';
              return;
            } else {
              result = 'Error';
              _number = '';
              return;
            }
        }
        result = res.toString();
        _number = result;
        operator = '';
      }
    });
  }

  void _clear() {
    setState(() {
      _number = '';
      num1 = 0;
      num2 = 0;
      operator = '';
      result = '';
    });
  }

  Widget _buildBtn(String text, Function() onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(18),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ITI Calculator"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
          
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Text(
                _number.isEmpty ? "0" : _number,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                _buildBtn("7", () => _onNumberClick("7")),
                _buildBtn("8", () => _onNumberClick("8")),
                _buildBtn("9", () => _onNumberClick("9")),
                _buildBtn("+", () => _onOperatorClick("+")),
              ],
            ),

            Row(
              children: [
                _buildBtn("4", () => _onNumberClick("4")),
                _buildBtn("5", () => _onNumberClick("5")),
                _buildBtn("6", () => _onNumberClick("6")),
                _buildBtn("-", () => _onOperatorClick("-")),
              ],
            ),

            Row(
              children: [
                _buildBtn("1", () => _onNumberClick("1")),
                _buildBtn("2", () => _onNumberClick("2")),
                _buildBtn("3", () => _onNumberClick("3")),
                _buildBtn("x", () => _onOperatorClick("x")),
              ],
            ),

            Row(
              children: [
                _buildBtn("0", () => _onNumberClick("0")),
                _buildBtn("=", _calculateResult),
                _buildBtn("/", () => _onOperatorClick("/")),
                _buildBtn("C", _clear),
              ],
            ),
          ],
        ),
      ),
    );
  }
}