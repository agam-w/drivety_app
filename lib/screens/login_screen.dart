import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../utils/validators.dart';
import '../utils/constants.dart';
import '../services/auth_service.dart'; // Import the auth service
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Check if user is already logged in
    _checkLoginStatus();
  }

  // Check if user is already logged in and redirect to home screen
  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    if (isLoggedIn && mounted) {
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<void> _login() async {
    setState(() {
      _errorMessage = null;
    });

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Hardcoded credentials for demo
      try {
        // Get user input
        final email = _emailController.text.trim();
        final password = _passwordController.text;

        // Validate against hardcoded credentials for demo
        if (email == Constants.demoEmail &&
            password == Constants.demoPassword) {
          // Mock user data - in a real app this would come from your backend
          final mockToken =
              'mock_auth_token_${DateTime.now().millisecondsSinceEpoch}';
          final mockUserId = 'user_123';
          final mockUserName = 'Demo User';
          final mockUserRole = 'Safety Officer';

          // Save authentication data
          final success = await AuthService.login(
              mockToken, mockUserId, mockUserName, mockUserRole);

          if (success && mounted) {
            // Navigate to home screen on successful login
            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
          } else {
            throw Exception('Failed to save authentication data');
          }
        } else {
          // Show error message for invalid credentials
          setState(() {
            _errorMessage =
                'Invalid email or password. Try using ${Constants.demoEmail} / ${Constants.demoPassword}';
          });
        }
      } catch (e) {
        // Handle any errors during login
        setState(() {
          _errorMessage = 'Login failed: ${e.toString()}';
        });
      } finally {
        // Reset loading state if still mounted
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo and title
                        Icon(
                          Icons.shield,
                          size: 60,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Welcome Back',
                          style: Theme.of(context).textTheme.displayLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Log in to your account to continue',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Error message (if any)
                        if (_errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline,
                                    color: Colors.red),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Email field
                        CustomTextField(
                          controller: _emailController,
                          hintText: 'Email Address',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.validateEmail,
                        ),
                        const SizedBox(height: 16),

                        // Password field
                        CustomTextField(
                          controller: _passwordController,
                          hintText: 'Password',
                          prefixIcon: Icons.lock_outline,
                          obscureText: !_isPasswordVisible,
                          validator: Validators.validatePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                        ),

                        // Forgot password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Implement forgot password functionality
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Forgot password feature coming soon!')),
                              );
                            },
                            child: const Text('Forgot Password?'),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Login button
                        CustomButton(
                          text: 'LOG IN',
                          onPressed: _login,
                          isLoading: _isLoading,
                        ),

                        const Spacer(),

                        // Register link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(RegisterScreen.routeName);
                              },
                              child: const Text('Register'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
