import 'package:flutter/material.dart';
import '../models/food.dart';
import '../models/meal_plan.dart';
import '../controller/meal_plan_controller.dart';

class CreateMealPlanView extends StatefulWidget {
  final MealPlanController controller;

  CreateMealPlanView({required this.controller});

  @override
  _CreateMealPlanViewState createState() => _CreateMealPlanViewState();
}

class _CreateMealPlanViewState extends State<CreateMealPlanView> {
  int selectedWeek = 1;
  Map<String, Food?> selectedMeals = {
    'Montag': null,
    'Dienstag': null,
    'Mittwoch': null,
    'Donnerstag': null,
    'Freitag': null,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neuen Essensplan erstellen', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: DropdownButton<int>(
                  value: selectedWeek,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedWeek = newValue!;
                    });
                  },
                  items: List.generate(8, (index) => index + 1)
                      .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('Woche $value'),
                    );
                  }).toList(),
                ),
              ),
            ),

            Expanded(
              child: ListView(
                children: selectedMeals.keys.map((day) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(day, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      trailing: DropdownButton<Food>(
                        value: selectedMeals[day],
                        hint: Text('Essen auswählen'),
                        items: widget.controller.getAvailableFoods().map((Food food) {
                          return DropdownMenuItem<Food>(
                            value: food,
                            child: Text('${food.name} - ${food.type.toString().split('.').last}'),
                          );
                        }).toList(),
                        onChanged: (Food? newFood) {
                          setState(() {
                            selectedMeals[day] = newFood;
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (selectedMeals.values.any((meal) => meal == null)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Bitte wählen Sie ein Essen für jeden Tag.')),
                    );
                    return;
                  }
                  final mealPlan = MealPlan(
                    weekNumber: selectedWeek,
                    mealsPerWeek: selectedMeals.entries.map((entry) {
                      return Food(  //default
                        name: entry.value?.name ?? '',
                        price: entry.value?.price ?? 0.0,
                        type: entry.value?.type ?? FoodType.vegan,
                      );
                    }).toList(),
                  );
                  widget.controller.addMealPlan(mealPlan); //hinzufügen, muss aber noch abgerufen werden
                  Navigator.of(context).pop();
                },
                child: Text('Speichern', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black12,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
