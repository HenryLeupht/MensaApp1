// lib/views/meal_plan_view.dart

import 'package:flutter/material.dart';
import '../controller/meal_plan_controller.dart';
import '../models/meal_plan.dart';
import '../models/food.dart';
import '../utils/user_session.dart';
import 'create_meal_plan_view.dart';
import 'essensliste_view.dart'; // Importiere den neuen View

class MealPlanView extends StatefulWidget {
  final MealPlanController controller;

  MealPlanView({required this.controller});

  @override
  _MealPlanViewState createState() => _MealPlanViewState();
}

class _MealPlanViewState extends State<MealPlanView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Plans'),
      ),
      body: widget.controller.mealPlans.isEmpty
          ? Center(child: Text("Keine Essenspläne vorhanden"))
          : ListView.builder(
        itemCount: widget.controller.mealPlans.length,
        itemBuilder: (context, index) {
          final mealPlan = widget.controller.getMealPlan(index);

          return ExpansionTile(
            title: Text('Woche ${mealPlan.weekNumber}'),
            subtitle: Text('Anzahl der Mahlzeiten: ${mealPlan.mealsPerWeek.length}'),
            children: mealPlan.mealsPerWeek.map((meal) {
              return ListTile(
                title: Text(meal.name),
                subtitle: Text('${meal.price} EUR - ${meal.type.toString().split('.').last}'),
                trailing: UserSession.isAdmin()
                    ? IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showManageMealDialog(context, meal, mealPlan, index);
                  },
                )
                    : null,
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: UserSession.isAdmin()
          ? Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CreateMealPlanView(controller: widget.controller),
                ),
              );
            },
            label: Text('Essensplan erstellen'),
            icon: Icon(Icons.add),
            backgroundColor: Colors.green,
          ),
          SizedBox(height: 16),
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EssensListeView(controller: widget.controller),
                ),
              );
            },
            label: Text('Essen verwalten'),
            icon: Icon(Icons.food_bank),
            backgroundColor: Colors.blue,
          ),
        ],
      )
          : null,
    );
  }

  void _showManageMealDialog(BuildContext context, Food meal, MealPlan mealPlan, int index) {
    final TextEditingController nameController = TextEditingController(text: meal.name);
    final TextEditingController priceController = TextEditingController(text: meal.price.toString());
    FoodType? selectedType = meal.type;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Essen bearbeiten'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Preis'),
                  keyboardType: TextInputType.number,
                ),
                DropdownButton<FoodType>(
                  value: selectedType,
                  items: FoodType.values.map((FoodType type) {
                    return DropdownMenuItem<FoodType>(
                      value: type,
                      child: Text(type.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (FoodType? value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                  hint: Text('Art wählen'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && priceController.text.isNotEmpty && selectedType != null) {
                  meal.name = nameController.text;
                  meal.price = double.parse(priceController.text);
                  meal.type = selectedType!;

                  widget.controller.updateMealPlan(index, mealPlan);
                  Navigator.of(context).pop();
                  setState(() {}); // Refresh the view
                }
              },
              child: Text('Speichern'),
            ),
          ],
        );
      },
    );
  }
}
