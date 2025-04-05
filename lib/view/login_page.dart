import 'package:flutter/material.dart';
import 'package:uploaddoc/view/dashboard.dart';
import 'package:uploaddoc/widgets/app_button_with_icon.dart';
import 'package:uploaddoc/widgets/apptextformfield.dart';
import 'package:uploaddoc/widgets/orseparator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff00224F),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 60),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 60),
                Text(
                  'Hello Welcome Back',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Opacity(
                  opacity: 0.4,
                  child: Text(
                    'Welcome back please\nsign in again',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AppTextFormField(
                          hintText: 'Email',
                          prefixIcon: Icons.email_outlined,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (String? email) {
                            if (email == null || !email.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30),
                        AppTextFormField(
                          hintText: 'Password',
                          prefixIcon: Icons.lock_outline,
                          controller: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (String? password) {
                            if (password == null || password.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 35),
                        ElevatedButton(
                          onPressed: onTapLoginButton,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 56),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff00224F),
                            ),
                          ),
                        ),
                        SizedBox(height: 60),
                        OrSeparator(),
                        SizedBox(height: 20),
                        AppButtonWithIcon(
                          text: 'Facebook',
                          icon: Icons.facebook,
                          onPressed: () {},
                        ),
                        SizedBox(height: 14),
                        AppButtonWithIcon(
                          text: 'Google',
                          icon: Icons.g_mobiledata,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Navigate to Dashboard
  void navigateToDashboard(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Dashboard()),
    );
  }

  void onTapLoginButton() {
    // Validate the form
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      navigateToDashboard(context);
    }
  }
}
