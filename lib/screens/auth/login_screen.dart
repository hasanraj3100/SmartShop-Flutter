// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart'; // Assuming this path
import '../../core/routes/app_routes.dart'; // Assuming this path for navigation

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  bool _rememberMe = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Function to handle login
  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, attempt to log in
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      // Show a loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logging in...'),
          duration: Duration(seconds: 2), // Short duration for loading
        ),
      );

      try {
        await authProvider.login(email, password);
        // If login is successful, navigate to home screen
        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide loading
          Navigator.of(context).pushReplacementNamed(AppRoutes.home); // Navigate to home
        }
      } catch (e) {
        // Handle login errors
        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The Scaffold body will now contain a Column, which will then scroll
        body: Column(
          children: <Widget>[
            // Top Section with Image and Welcome Text
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('Auth1-login.png'), // Your local image
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {
                        debugPrint('Error loading asset image: $exception');
                      },
                    ),
                  ),
                  child: DecoratedBox( // Added DecoratedBox for gradient overlay
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4), // Darker at top
                          Colors.transparent, // Transparent at bottom
                        ],
                        stops: const [0.0, 0.25], // Gradient covers top quarter (0.0 to 0.25 of height)
                      ),
                    ),
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      title: const Text(
                        'Welcome',
                        style: TextStyle(color: Colors.white),
                      ),
                      centerTitle: true,
                    ),
                  ),
                ),
              ],
            ),
            // Bottom Section with Login Form
            // Use Flexible and SingleChildScrollView to allow the form to scroll
            // and to take remaining space, while slightly overlapping the image.
            Flexible(
              child: Transform.translate( // Use Transform.translate for visual offset
                offset: const Offset(0.0, -30.0), // Negative Y offset to move it up
                child: SingleChildScrollView(
                  child: Container(
                    // Removed margin: const EdgeInsets.only(top: -30) to fix the assertion error
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor, // Use scaffold background color
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Welcome back!',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sign in to your account',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Email Input
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              hintText: 'Enter your email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none, // No border line
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Password Input
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none, // No border line
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),

                          // Remember Me & Forgot Password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Switch(
                                    value: _rememberMe,
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value;
                                      });
                                    },
                                    activeColor: Theme.of(context).primaryColor,
                                  ),
                                  const Text('Remember me'),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  // TODO: Implement navigation to forgot password screen
                                  print('Navigate to forgot password screen');
                                },
                                child: Text(
                                  'Forgot password?',
                                  style: TextStyle(color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),

                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _handleLogin,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Theme.of(context).primaryColor, // Use primary color
                                foregroundColor: Colors.white, // Text color
                                elevation: 5, // Add shadow
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Register Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Don\'t have an account?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(AppRoutes.register); // Navigate to register
                                },
                                child: Text(
                                  'Sign up',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}
