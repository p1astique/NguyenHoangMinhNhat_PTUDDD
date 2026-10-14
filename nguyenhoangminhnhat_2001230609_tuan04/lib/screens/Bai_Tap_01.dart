import 'package:flutter/material.dart';
import 'dart:math';

class BaiTap01 extends StatefulWidget {
  const BaiTap01({super.key});

  @override
  State<BaiTap01> createState() => _BaiTap01State();
}

class _BaiTap01State extends State<BaiTap01> {
  String display = '0';

  double? firstNumber;
  String? operator;
  bool shouldClearDisplay = false;

  void buttonPressed(String value) {
    setState(() {
      // Số
      if ('0123456789'.contains(value)) {
        if (display == '0' || shouldClearDisplay) {
          display = value;
          shouldClearDisplay = false;
        } else {
          display += value;
        }
      }

      // Dấu thập phân
      else if (value == '.') {
        if (shouldClearDisplay) {
          display = '0.';
          shouldClearDisplay = false;
        } else if (!display.contains('.')) {
          display += '.';
        }
      }

      // Xóa toàn bộ
      else if (value == 'C' || value == 'CE') {
        display = '0';
        firstNumber = null;
        operator = null;
        shouldClearDisplay = false;
      }

      // Xóa một ký tự
      else if (value == '⌫') {
        if (display.length > 1) {
          display = display.substring(0, display.length - 1);
        } else {
          display = '0';
        }
      }

      // Đổi dấu
      else if (value == '+/-') {
        double number = double.parse(display);
        display = formatNumber(-number);
      }

      // Phần trăm
      else if (value == '%') {
        double number = double.parse(display);
        display = formatNumber(number / 100);
      }

      // 1/x
      else if (value == '1/x') {
        double number = double.parse(display);

        if (number == 0) {
          display = 'Error';
        } else {
          display = formatNumber(1 / number);
        }
      }

      // Bình phương
      else if (value == 'x²') {
        double number = double.parse(display);
        display = formatNumber(number * number);
      }

      // Căn bậc hai
      else if (value == '√x') {
        double number = double.parse(display);

        if (number < 0) {
          display = 'Error';
        } else {
          display = formatNumber(sqrt(number));
        }
      }

      // Phép toán
      else if (value == '+' ||
          value == '−' ||
          value == '×' ||
          value == '÷') {
        firstNumber = double.parse(display);
        operator = value;
        shouldClearDisplay = true;
      }

      // Dấu bằng
      else if (value == '=') {
        if (firstNumber != null && operator != null) {
          double secondNumber = double.parse(display);
          double result = 0;

          switch (operator) {
            case '+':
              result = firstNumber! + secondNumber;
              break;

            case '−':
              result = firstNumber! - secondNumber;
              break;

            case '×':
              result = firstNumber! * secondNumber;
              break;

            case '÷':
              if (secondNumber == 0) {
                display = 'Error';
                firstNumber = null;
                operator = null;
                return;
              }

              result = firstNumber! / secondNumber;
              break;
          }

          display = formatNumber(result);

          firstNumber = null;
          operator = null;
          shouldClearDisplay = true;
        }
      }
    });
  }

  String formatNumber(double number) {
    if (number == number.toInt()) {
      return number.toInt().toString();
    }

    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Standard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {},
          ),
        ],
      ),

      body: Column(
        children: [
          // Màn hình máy tính
          Container(
            width: double.infinity,
            height: 130,
            padding: const EdgeInsets.all(20),
            alignment: Alignment.bottomRight,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                display,
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Các nút bộ nhớ
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('MC'),
              Text('MR'),
              Text('M+'),
              Text('M-'),
              Text('MS'),
            ],
          ),

          const SizedBox(height: 10),

          // Bàn phím
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                children: [
                  buildRow(['%', 'CE', 'C', '⌫']),
                  buildRow(['1/x', 'x²', '√x', '÷']),
                  buildRow(['7', '8', '9', '×']),
                  buildRow(['4', '5', '6', '−']),
                  buildRow(['1', '2', '3', '+']),
                  buildRow(['+/-', '0', '.', '=']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRow(List<String> buttons) {
    return Expanded(
      child: Row(
        children: buttons.map((text) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.all(2),
              child: ElevatedButton(
                onPressed: () {
                  buttonPressed(text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      text == '=' ? Colors.blue : Colors.grey[200],
                  foregroundColor:
                      text == '=' ? Colors.white : Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}