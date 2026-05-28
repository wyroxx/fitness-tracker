import 'package:fitness_tracker/app/theme/app_colors.dart';
import 'package:fitness_tracker/app/theme/app_text_styles.dart';
import 'package:fitness_tracker/core/ui/primary_button.dart';
import 'package:fitness_tracker/core/ui/primary_text_field.dart';
import 'package:fitness_tracker/core/ui/snack_bar.dart';
import 'package:fitness_tracker/core/utils/validator.dart';
import 'package:fitness_tracker/features/auth/presentation/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    try {
      await ref
          .read(authControllerProvider.notifier)
          .login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
      if (mounted) {
        context.go('/trainings');
      }
    } catch (e) {
      if (mounted) {
        showAppToast(context, message: e.toString(), type: AppToastType.error);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider) == AuthStatus.loading;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Welcome back!\nSign '),
                    TextSpan(
                      text: 'in',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: AppTextStyles.screenTitle,
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryTextField(
                      hintText: 'Email',
                      obscureText: false,
                      controller: _emailController,
                      validator: ref.read(validatorProvider).validateEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    PrimaryTextField(
                      hintText: 'Password',
                      obscureText: true,
                      controller: _passwordController,
                      validator: ref.read(validatorProvider).validatePassword,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    PrimaryButton(
                      text: isLoading ? 'Signing in...' : 'Sign in',
                      width: double.infinity,
                      height: 46,
                      onPressed: _login,
                      isEnabled: !isLoading,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Not registered?',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => context.go('/register'),
                    child: const Text(
                      'Sign up',
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
