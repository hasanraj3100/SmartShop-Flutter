// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart'; // For theme adaptation

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controllers for personal details (dummy for now)
  final TextEditingController _nameController = TextEditingController(text: 'Oasimul Raj');
  final TextEditingController _emailController = TextEditingController(text: 'raj@example.com');
  final TextEditingController _phoneController = TextEditingController(text: '+01 2345 67890');

  // Controllers for password change
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Form keys for validation
  final _personalDetailsFormKey = GlobalKey<FormState>();
  final _changePasswordFormKey = GlobalKey<FormState>();

  // Password visibility states
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _savePersonalDetails() {
    if (_personalDetailsFormKey.currentState!.validate()) {
      // TODO: Implement logic to save personal details
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Personal details saved!')),
      );
      print('Saving personal details...');
    }
  }

  void _changePassword() {
    if (_changePasswordFormKey.currentState!.validate()) {
      // TODO: Implement logic to change password
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully!')),
      );
      print('Changing password...');
      // Clear password fields after successful change
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // No need for isDarkMode check here as we directly use Theme.of(context)
    // final themeProvider = Provider.of<ThemeProvider>(context);
    // final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    // Define colors directly from Theme.of(context)
    final textColor = Theme.of(context).colorScheme.onSurface;
    // For secondary text/hint text, use onSurface with opacity
    final secondaryTextColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.7);
    final dividerColor = Theme.of(context).dividerColor;


    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Use theme's scaffold background
      appBar: AppBar(
        title: const Text('About me'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personal Details Section
            Text(
              'Personal Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor, // Uses theme's onSurface color
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _personalDetailsFormKey,
              child: Column(
                children: [
                  _buildProfileInputField(
                    controller: _nameController,
                    icon: Icons.person_outline,
                    hintText: 'Full Name',
                    readOnly: false, // Can be edited
                    // Removed explicit color parameters, now uses theme
                  ),
                  const SizedBox(height: 12),
                  _buildProfileInputField(
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    hintText: 'Email Address',
                    readOnly: false, // Can be edited
                    keyboardType: TextInputType.emailAddress,
                    // Removed explicit color parameters, now uses theme
                  ),
                  const SizedBox(height: 12),
                  _buildProfileInputField(
                    controller: _phoneController,
                    icon: Icons.phone_outlined,
                    hintText: 'Phone Number',
                    readOnly: false, // Can be edited
                    keyboardType: TextInputType.phone,
                    // Removed explicit color parameters, now uses theme
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Divider(color: dividerColor), // Uses theme's divider color
            const SizedBox(height: 30),

            // Change Password Section
            Text(
              'Change Password',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor, // Uses theme's onSurface color
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _changePasswordFormKey,
              child: Column(
                children: [
                  _buildPasswordInputField(
                    controller: _currentPasswordController,
                    hintText: 'Current password',
                    icon: Icons.lock_outline,
                    isVisible: _isCurrentPasswordVisible,
                    toggleVisibility: () {
                      setState(() {
                        _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your current password';
                      }
                      return null;
                    },
                    // Removed explicit color parameters, now uses theme
                  ),
                  const SizedBox(height: 12),
                  _buildPasswordInputField(
                    controller: _newPasswordController,
                    hintText: 'New password',
                    icon: Icons.lock_outline,
                    isVisible: _isNewPasswordVisible,
                    toggleVisibility: () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    // Removed explicit color parameters, now uses theme
                  ),
                  const SizedBox(height: 12),
                  _buildPasswordInputField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm password',
                    icon: Icons.lock_outline,
                    isVisible: _isConfirmPasswordVisible,
                    toggleVisibility: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your new password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    // Removed explicit color parameters, now uses theme
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Save Settings Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _savePersonalDetails(); // Save personal details
                  _changePassword(); // Attempt to change password
                }, child: Text("Save Setting"),
                // ElevatedButton style is now picked up from AppTheme.elevatedButtonTheme
                // No need to define it here explicitly
              ),
            ),
            const SizedBox(height: 20), // Spacing at the bottom
          ],
        ),
      ),
    );
  }

  // Helper method to build a standard profile input field
  Widget _buildProfileInputField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    bool readOnly = true,
    TextInputType? keyboardType,
    // Removed explicit color parameters
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface), // Uses theme's onSurface color
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)), // Uses onSurface with opacity
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)), // Uses onSurface with opacity
        // Border and fill color are now handled by InputDecorationTheme in app_theme.dart
      ),
    );
  }

  // Helper method to build a password input field with visibility toggle
  Widget _buildPasswordInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool isVisible,
    required VoidCallback toggleVisibility,
    String? Function(String?)? validator,
    // Removed explicit color parameters
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface), // Uses theme's onSurface color
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)), // Uses onSurface with opacity
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)), // Uses onSurface with opacity
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), // Uses onSurface with opacity
          ),
          onPressed: toggleVisibility,
        ),
        // Border and fill color are now handled by InputDecorationTheme in app_theme.dart
      ),
      validator: validator,
    );
  }
}
