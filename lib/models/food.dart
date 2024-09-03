// lib/models/food.dart

//Modell für ein Essen
class Food {
  String name;
  double price;
  FoodType type;

  Food({required this.name, required this.price, required this.type});
}

enum FoodType { vegetarian, vegan, meat }
