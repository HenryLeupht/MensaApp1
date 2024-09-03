// lib/models/meal_plan.dart
import 'food.dart';
//Modell für einen Essensplan
class MealPlan {
  List<Food> mealsPerWeek;
  int weekNumber;

  MealPlan({required this.mealsPerWeek, required this.weekNumber});
}
