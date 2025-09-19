import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/image_utilies.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 3)); // fake delay
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.checkAuthentication(); // 🔹 load token before checking
    log("isAuthenticated=========${authProvider.isAuthenticated}");

    if (authProvider.isAuthenticated) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    log("message==width==${MediaQuery.of(context).size.width * 0.015}");
    log("message==width==${MediaQuery.of(context).size.height * 0.01}");
    return Scaffold(body: Center(child: Image.asset(AssetsImage.app_logo)));
  }
}
