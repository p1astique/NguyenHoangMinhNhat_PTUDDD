
import 'package:flutter/material.dart';

import '../controllers/tai_khoan_controller.dart';

class Bai02BTVN extends StatefulWidget {
  const Bai02BTVN({super.key});

  @override
  State<Bai02BTVN> createState() => _Bai02BTVNState();
}

class _Bai02BTVNState extends State<Bai02BTVN> {
  final TaiKhoanController controller = TaiKhoanController();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool isRegister = false;
  bool obscurePassword = true;
  bool loading = false;

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> signIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showMessage('Vui lòng nhập email và mật khẩu');
      return;
    }

    setState(() => loading = true);

    try {
      final success = await controller.login(email, password);

      if (!mounted) return;

      if (success) {
        await showDialog<void>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Đăng nhập thành công'),
            content: Text(
              'Chào mừng $email!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showMessage('Email hoặc mật khẩu không chính xác');
      }
    } catch (e) {
      showMessage('Không thể đăng nhập: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirm = confirmController.text;

    if (password != confirm) {
      showMessage('Mật khẩu xác nhận không khớp');
      return;
    }

    setState(() => loading = true);

    try {
      final message = await controller.register(
        email,
        password,
      );

      if (!mounted) return;

      showMessage(message);

      if (message == 'Đăng ký thành công') {
        setState(() {
          isRegister = false;
          passwordController.clear();
          confirmController.clear();
        });
      }
    } catch (e) {
      showMessage('Không thể đăng ký: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 02 - BTVN'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              color: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      isRegister
                          ? Icons.person_add_alt_1
                          : Icons.lock_outline,
                      size: 48,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 12),

                    Text(
                      isRegister ? 'Register' : 'Sign In',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'example@gmail.com',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),

                    if (isRegister) ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: confirmController,
                        obscureText: obscurePassword,
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.verified_user_outlined),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    if (loading)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    else if (isRegister)
                      ElevatedButton(
                        onPressed: register,
                        child: const Text('Register'),
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: signIn,
                              child: const Text('Sign In'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isRegister = true;
                                  passwordController.clear();
                                  confirmController.clear();
                                });
                              },
                              child: const Text('Register'),
                            ),
                          ),
                        ],
                      ),

                    if (isRegister) ...[
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: loading
                            ? null
                            : () {
                                setState(() {
                                  isRegister = false;
                                  passwordController.clear();
                                  confirmController.clear();
                                });
                              },
                        child: const Text(
                          'Đã có tài khoản? Sign In',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
