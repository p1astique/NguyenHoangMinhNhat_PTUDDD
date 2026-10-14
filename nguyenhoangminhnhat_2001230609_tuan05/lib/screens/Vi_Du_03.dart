import 'package:flutter/material.dart';

class ViDu03 extends StatelessWidget {
  const ViDu03({super.key});

  static const List<String> dsTieuDe = [
    'Login',
    'Search',
    'Profile',
    'Setting',
    'Cart',
    'Payment',
    'Task',
    'Alert',
    'Bank',
    'Wallet',
    'Email',
    'More',
  ];

  static const List<IconData> dsIcon = [
    Icons.login,
    Icons.search,
    Icons.person,
    Icons.settings,
    Icons.shopping_cart,
    Icons.payment,
    Icons.task,
    Icons.notifications,
    Icons.account_balance,
    Icons.wallet,
    Icons.email,
    Icons.more_horiz,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GridView Demo'),
        backgroundColor: const Color.fromARGB(
          255,
          239,
          168,
          4,
        ),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {},
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: dsTieuDe.length,

          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),

          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
                borderRadius: BorderRadius.circular(10),
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    dsIcon[index],
                    size: 40,
                    color: Colors.blue,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    dsTieuDe[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}