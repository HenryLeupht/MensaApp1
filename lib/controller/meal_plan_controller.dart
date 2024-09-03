// lib/controller/meal_plan_controller.dart
import '../models/meal_plan.dart';
import '../models/food.dart';

class MealPlanController {
  List<MealPlan> mealPlans = [];

  MealPlanController() {
    // Beispiel-Daten
    mealPlans.add(MealPlan(
      weekNumber: 1,
      mealsPerWeek: [
        Food(name: "Pasta", price: 7.5, type: FoodType.vegan),
        Food(name: "Salad", price: 5.0, type: FoodType.vegetarian),
      ],
    ));
  }
// Methode zum Abrufen der Liste von Essensplänen
  List<MealPlan> getMealPlans() {
    return mealPlans;
  }
// Methode zum Abrufen eines bestimmten Essensplans
  MealPlan getMealPlan(int index) {
    return mealPlans[index];
  }
// Methode zum Hinzufügen eines Essensplans
  void addMealPlan(MealPlan mealPlan) {
    mealPlans.add(mealPlan);
  }
// Methode zum Aktualisieren eines Essensplans
  void updateMealPlan(int index, MealPlan mealPlan) {
    if (index >= 0 && index < mealPlans.length) {
      mealPlans[index] = mealPlan;
    }
  }
}
