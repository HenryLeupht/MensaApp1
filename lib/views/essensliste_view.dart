import 'package:flutter/material.dart';
import '../controller/meal_plan_controller.dart';
import '../models/food.dart';

class EssensListeView extends StatefulWidget {
  final MealPlanController controller;

  EssensListeView({required this.controller});

  @override
  _EssensListeViewState createState() => _EssensListeViewState();
}

class _EssensListeViewState extends State<EssensListeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Essenliste', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: widget.controller.getAvailableFoods().length,
          itemBuilder: (context, index) {
            final food = widget.controller.getAvailableFoods()[index];
            return Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                title: Text(food.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text('${food.price} EUR - ${food.type.toString().split('.').last}', style: TextStyle(fontSize: 16)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.deepPurple),
                      onPressed: () {
                        _showManageFoodDialog(context, food, index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Löschen bestätigen'),
                              content: Text('Möchten Sie dieses Essen wirklich löschen?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    widget.controller.deleteFood(index);
                                    Navigator.of(context).pop();
                                    setState(() {});
                                  },
                                  child: Text('Löschen'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Abbrechen'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showManageFoodDialog(context, null, null); // Null für neues Essen
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan,
      ),
    );
  }

  void _showManageFoodDialog(BuildContext context, Food? food, int? index) {
    final bool isNew = food == null;
    final TextEditingController nameController = TextEditingController(text: food?.name ?? '');
    final TextEditingController priceController = TextEditingController(text: food?.price.toString() ?? '');
    FoodType? selectedType = food?.type ?? FoodType.vegan;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isNew ? 'Neues Essen hinzufügen' : 'Essen bearbeiten'),
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
                  final newFood = Food(
                    name: nameController.text,
                    price: double.parse(priceController.text),
                    type: selectedType!,
                  );

                  if (isNew) {
                    widget.controller.addFood(newFood);
                  } else {
                    widget.controller.updateFood(index!, newFood);
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
}
