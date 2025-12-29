import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/signup_request.dart';
import '../providers/auth_notifier.dart';

class SignUpForm extends ConsumerStatefulWidget {
  final bool isLoading;

  const SignUpForm({super.key, required this.isLoading});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _gamertagController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _gamertagController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      final request = SignUpRequest(
        gamertag: _gamertagController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      ref.read(authNotifierProvider.notifier).signUp(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Gamertag Field
          _buildInputField(
            controller: _gamertagController,
            label: 'Gamertag',
            hintText: 'Enter your username',
            prefixIcon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Gamertag é obrigatório';
              }
              if (value.length < 3) {
                return 'Gamertag deve ter pelo menos 3 caracteres';
              }
              if (value.length > 20) {
                return 'Gamertag deve ter no máximo 20 caracteres';
              }
              if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                return 'Use apenas letras, números e underscore';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Email Field
          _buildInputField(
            controller: _emailController,
            label: 'Email Address',
            hintText: 'user@example.com',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.mail_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email é obrigatório';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Email inválido';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Password Field
          _buildInputField(
            controller: _passwordController,
            label: 'Password',
            hintText: '••••••••',
            obscureText: !_isPasswordVisible,
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Senha é obrigatória';
              }
              if (value.length < 6) {
                return 'Senha deve ter pelo menos 6 caracteres';
              }
              if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                return 'Senha deve conter maiúscula, minúscula e número';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Confirm Password Field
          _buildInputField(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            hintText: '••••••••',
            obscureText: !_isConfirmPasswordVisible,
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Confirmação de senha é obrigatória';
              }
              if (value != _passwordController.text) {
                return 'Senhas não coincidem';
              }
              return null;
            },
          ),

          const SizedBox(height: 32),

          // Sign Up Button
          ElevatedButton(
            onPressed: widget.isLoading ? null : _handleSignUp,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: AppTheme.primaryColor.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(double.infinity, 56),
            ),
            child: widget.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'START GAME',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              suffixIcon: Container(
                margin: const EdgeInsets.only(left: 16, right: 12),
                child: Icon(
                  prefixIcon,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight,
                ),
              ),
              prefixIcon: suffixIcon != null
                  ? Container(
                      margin: const EdgeInsets.only(right: 16),
                      child: suffixIcon,
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF2d1b2e) // surface-dark from design
                  : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF523b54) // border-dark
                      : Colors.grey.shade300,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF523b54)
                      : Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.primaryColor.withOpacity(0.5),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              hintStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.textSecondaryDark
                    : Colors.grey.shade400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
