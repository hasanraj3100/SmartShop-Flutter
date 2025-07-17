import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartshop/providers/auth_provider.dart';
import 'package:smartshop/providers/cart_provider.dart';
import 'package:smartshop/providers/product_provider.dart';

import 'app.dart';
import 'core/utils/shared_prefs.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  await SharedPrefs.init(prefs);

  // Load saved theme mode
  final isDarkMode = SharedPrefs.getBool('isDarkMode') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(isDarkMode)),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()), 
        ChangeNotifierProvider(create: (_) => CartProvider())
        // Add more providers here later (e.g., AuthProvider)
      ],
      child: const MyApp(),
    ),
  );
}
