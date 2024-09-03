// lib/views/meal_plan_view.dart
// views/meal_plan_view.dart
import 'package:flutter/material.dart';
import '../controller/meal_plan_controller.dart';
import '../models/meal_plan.dart';
import '../models/food.dart';
import '../utils/user_session.dart';


class MealPlanView extends StatefulWidget {
  final MealPlanController controller;

  MealPlanView({required this.controller});

  @override
  _MealPlanViewState createState() => _MealPlanViewState();
}
//Widget zum Anzeigen der Essenspläne
class _MealPlanViewState extends State<MealPlanView> {
  @override
  Widget build(BuildContext context) {
    print("Building MealPlanView");
    print("Is Admin: ${UserSession.isAdmin()}");

    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Plans'),
        actions: [
          if (UserSession.isAdmin())
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                print("Admin Add Button Pressed");
                _showManageMealPlanDialog(context);
              },
            ),
        ],
      ),
      body: widget.controller.mealPlans.isEmpty
          ? Center(child: Text("Keine Essenspläne vorhanden"))
          : ListView.builder(
        itemCount: widget.controller.mealPlans.length,
        itemBuilder: (context, index) {
          final mealPlan = widget.controller.getMealPlan(index);
          print("Displaying Meal Plan for Week: ${mealPlan.weekNumber}");

          return ExpansionTile(
            title: Text('Week ${mealPlan.weekNumber}'),
            subtitle: Text('Meals: ${mealPlan.mealsPerWeek.length}'),
            children: mealPlan.mealsPerWeek.map((meal) {
              print("Displaying Meal: ${meal.name}");  // Debug-Ausgabe
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
    );
  }
//Dialog/Popup zum Bearbeiten eines Essensplans
  void _showManageMealPlanDialog(BuildContext context, {MealPlan? mealPlan, int? index}) {
    final bool isNew = mealPlan == null;
    final TextEditingController weekNumberController =
    TextEditingController(text: mealPlan?.weekNumber.toString() ?? '');
    final List<Food> selectedMeals = mealPlan?.mealsPerWeek ?? [];

    print("Showing Manage MealPlan Dialog");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isNew ? 'Neuen Essensplan hinzufügen' : 'Essensplan bearbeiten'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: weekNumberController,
                  decoration: InputDecoration(labelText: 'Wochennummer'),
                  keyboardType: TextInputType.number,
                ),
                ...selectedMeals.map((meal) {
                  return ListTile(
                    title: Text(meal.name),
                    subtitle: Text('${meal.price} EUR - ${meal.type.toString().split('.').last}'),
                    trailing: UserSession.isAdmin()
                        ? IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showManageMealDialog(context, meal, mealPlan!, index!);
                      },
                    )
                        : null,
                  );
                }).toList(),
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
                if (weekNumberController.text.isNotEmpty && selectedMeals.isNotEmpty) {
                  final int weekNumber = int.parse(weekNumberController.text);

                  if (isNew) {
                    print("Adding new MealPlan");
                    widget.controller.addMealPlan(MealPlan(
                      weekNumber: weekNumber,
                      mealsPerWeek: selectedMeals,
                    ));
                  } else {
                    print("Updating MealPlan");
                    widget.controller.updateMealPlan(index!, MealPlan(
                      weekNumber: weekNumber,
                      mealsPerWeek: selectedMeals,
                    ));
                  }
                  Navigator.of(context).pop();
                  setState(() {}); // Aktualisiere die Ansicht
                }
              },
              child: Text(isNew ? 'Hinzufügen' : 'Speichern'),
            ),
          ],
        );
      },
    );
  }
//Dialog/Popup zum Bearbeiten eines Essens
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
                if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                  meal.name = nameController.text;
                  meal.price = double.parse(priceController.text);
                  meal.type = selectedType!;

                  widget.controller.updateMealPlan(index, mealPlan); // Aktualisiere den MealPlan
                  Navigator.of(context).pop();
                  setState(() {}); // Aktualisiere die Ansicht
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
