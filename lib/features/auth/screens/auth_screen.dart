import 'package:flutter/material.dart';

import 'signup-screen.dart';
import 'login-screen.dart';
import 'otp-screen.dart';

class AuthScreen extends StatefulWidget {
  final String initialRoute;

  const AuthScreen({super.key, this.initialRoute = 'signup'});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late String _currentRoute;

  @override
  void initState() {
    super.initState();
    _currentRoute = widget.initialRoute;
  }

  void _navigateTo(String route) {
    setState(() {
      _currentRoute = route;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentRoute) {
      case 'login':
        return LoginScreen();
      case 'otp':
        return OTPScreen(identifier: '');
        // return OTPScreen(identifier: "");
        
      case 'signup':
      default:
        return SignupScreen();
    }
  }
}
