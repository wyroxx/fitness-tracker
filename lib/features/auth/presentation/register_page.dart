import 'package:fitness_tracker/core/ui/primary_button.dart';
import 'package:fitness_tracker/core/ui/primary_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
                    TextSpan(text: "Let's get started!\nSign "),
                    TextSpan(
                      text: 'up',
                      style: TextStyle(
                        color: Color(0xFF3981E0),
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              const PrimaryTextField(
                hintText: 'Email',
                obscureText: false
              ),
              const SizedBox(height: 10),
              const PrimaryTextField(
                hintText: 'Password',
                obscureText: true
              ),
              const SizedBox(height: 10),
              const PrimaryTextField(
                hintText: 'Confirm password',
                obscureText: true
              ),
              const SizedBox(height: 10),
              PrimaryButton(
                text: 'Sign up',
                width: double.infinity,
                height: 46,
                onPressed: () {}
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
                        color: Color(0xFF3981E0),
                      ),
                    ),
                  )
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
