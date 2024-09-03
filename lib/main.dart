// lib/main.dart
import 'package:flutter/material.dart';
import 'views/login_view.dart';
import 'views/food_view.dart';
import 'views/meal_plan_view.dart';
import 'controller/food_controller.dart';
import 'controller/meal_plan_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Essensplan App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/food',  // Diese Route muss existieren
      routes: {
        '/food': (context) => FoodView(controller: FoodController()),
        '/login': (context) => LoginView(),
        '/meal_plan': (context) => MealPlanView(controller: MealPlanController()),
      },
    );
  }
}
