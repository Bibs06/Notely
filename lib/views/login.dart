import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notely/core/services/local_storage.dart';
import 'package:notely/core/utils/colors.dart';
import 'package:notely/core/utils/go.dart';
import 'package:notely/core/widgets/custom_btn.dart';
import 'package:notely/core/widgets/toast.dart';
import 'package:notely/view_models/auth_view_model.dart';
import 'package:notely/views/home.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final viewModel = ref.read(authProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome Back",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 40),

                /// Email
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter email";
                    }
                    if (!value.contains("@")) {
                      return "Invalid email";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                /// Password
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter password";
                    }
                    if (value.length < 6) {
                      return "Minimum 6 characters";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                /// Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomBtn(
                    btnText: "Login",
                    bgColor: AppColors.darkBlue,
                    textColor: AppColors.white,
                    textSize: 16.sp,
                    isLoading: authState == AuthState.loading,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        final success = await viewModel.login(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );

                        if (success) {
                          await LocalStorage.setBool('isLogin', true);
                          Go.toWithPopUntil(context, HomeView());
                          customToast('Welcome');

                          // Navigate to Home
                        } else {
                          customToast('Invalid Credentials');
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
