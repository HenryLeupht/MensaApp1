// lib/controller/meal_plan_controller.dart
import '../models/meal_plan.dart';
import '../models/food.dart';

class MealPlanController {
  List<MealPlan> mealPlans = [];
  List<Food> availableFoods = [
    Food(name: "Pasta", price: 8.0, type: FoodType.vegan),
    Food(name: "Salad", price: 6.0, type: FoodType.vegetarian),
    Food(name: "Pommes", price: 4.5, type: FoodType.vegan),
    Food(name: "Chicken Teriyaki mit Reis", price: 9.0, type: FoodType.meat),
    Food(name: "Tofu Süß Sauer", price: 7.0, type: FoodType.vegetarian),
    Food(name: "Pad Thai mit Tofu", price: 8.0, type: FoodType.vegan),
    Food(name: "Pizza Margherita", price: 7.5, type: FoodType.vegetarian),
    Food(name: "Lachsnudeln", price: 9.0, type: FoodType.meat),
    Food(name: "Asiatische Gemüsepfanne mit Erdnusssoße", price: 7.0, type: FoodType.vegan),
    Food(name: "Kumpir mit Halloumi und Gemüse", price: 7.5, type: FoodType.vegetarian),
  ];

  MealPlanController() {
    mealPlans.add(MealPlan(
      weekNumber: 1,  //anpassen
      mealsPerWeek: [
        Food(name: "hier schauen dass wir die individuelle Woche + Essen einfügen/ speichern", price: 100, type: FoodType.vegan),

      ],
    ));
  }

  List<MealPlan> getMealPlans() {
    return mealPlans;
  }

  MealPlan getMealPlan(int index) {
    return mealPlans[index];
  }

  void addMealPlan(MealPlan mealPlan) {
    mealPlans.add(mealPlan);
  }

  void updateMealPlan(int index, MealPlan mealPlan) {
    if (index >= 0 && index < mealPlans.length) {
      mealPlans[index] = mealPlan;
    }
  }

  List<Food> getAvailableFoods() {
    return availableFoods;
  }

  void addFood(Food food) {
    availableFoods.add(food);
  }

  void updateFood(int index, Food updatedFood) {
    if (index >= 0 && index < availableFoods.length) {
      availableFoods[index] = updatedFood;
    }
  }

  void deleteFood(int index) {
    if (index >= 0 && index < availableFoods.length) {
      availableFoods.removeAt(index);
    }
  }

  int getFoodIndex(Food food) {
    return availableFoods.indexOf(food);
  }
}
