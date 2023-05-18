import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/route_manager.dart';
import 'package:social_login_payment/home/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  Stripe.publishableKey =
      "pk_test_51N6qLRSIOHzIzKEcOEuNIpnKBke6SBUBLXUpjvSN1dzSapaIPmzaFqJ7RZuvN7Li6vD9xeXilIzuyvtztLYcqEk1008dMAsczY";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Social & Payment  implement',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
