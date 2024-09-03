// lib/controller/food_controller.dart
import '../models/food.dart';

class FoodController {
  List<Food> foods = [];

  FoodController() {
    // Beispielessen hinzufügen
    addFood(Food(name: "Pizza", price: 8.5, type: FoodType.meat));
    addFood(Food(name: "Salat", price: 5.0, type: FoodType.vegetarian));
    addFood(Food(name: "Pasta", price: 7.5, type: FoodType.vegan));
  }
// Methode zum Abrufen der Liste von Essen
  List<Food> getFoods() {
    return foods;
  }
// Methode zum Hinzufügen von Essen
  void addFood(Food food) {
    foods.add(food);
  }
// Methode zum Aktualisieren von Essen
  void updateFood(int index, Food updatedFood) {
    if (index >= 0 && index < foods.length) {
      foods[index] = updatedFood;
    }
  }
// Methode zum Abrufen eines bestimmten Essens
  Food getFood(int index) {
    return foods[index];
  }
}