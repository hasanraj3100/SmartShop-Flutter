import 'package:flutter/material.dart';

import '../../screens/splash/splash_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/product/product_page.dart';
import '../../screens/product/category_page.dart';
import '../../screens/cart/cart_screen.dart';
import '../../screens/favourites/favourites_screen.dart';
import '../../screens/profile/profile_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const product = '/product';
  static const category = '/category';
  static const cart = '/cart';
  static const favourites = '/favourites';
  static const profile = '/profile';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (_) => const SplashScreen(),
      login: (_) => const LoginScreen(),
      // register: (_) => const RegisterScreen(),
      home: (_) => const HomeScreen(),
      // product: (_) => const ProductPage(),
      // category: (_) => const CategoryPage(),
      // cart: (_) => const CartScreen(),
      // favourites: (_) => const FavouritesScreen(),
      // profile: (_) => const ProfileScreen(),
    };
  }
}
