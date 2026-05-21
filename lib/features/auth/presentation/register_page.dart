import 'package:fitness_tracker/app/theme/app_colors.dart';
import 'package:fitness_tracker/app/theme/app_text_styles.dart';
import 'package:fitness_tracker/core/ui/primary_button.dart';
import 'package:fitness_tracker/core/ui/primary_text_field.dart';
import 'package:fitness_tracker/features/auth/presentation/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider) == AuthStatus.loading;

    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: "Let's get started!\nSign "),
                          TextSpan(
                            text: 'up',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.screenTitle,
                    ),
                    const SizedBox(height: 20),
                    PrimaryTextField(
                      hintText: 'Name',
                      obscureText: false,
                      controller: _nameController,
                    ),
                    const SizedBox(height: 10),
                    PrimaryTextField(
                      hintText: 'Email',
                      obscureText: false,
                      controller: _emailController,
                    ),
                    const SizedBox(height: 10),
                    PrimaryTextField(
                      hintText: 'Password',
                      obscureText: true,
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 10),
                    PrimaryButton(
                      text: 'Sign up',
                      width: double.infinity,
                      height: 46,
                      onPressed: () async {
                        try {
                          await ref
                              .read(authControllerProvider.notifier)
                              .register(
                                name: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                          if (context.mounted) {
                            context.go('/login');
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        }
                      },
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already registered?',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => context.go('/login'),
                          child: const Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
      ),
    );
  }
}
