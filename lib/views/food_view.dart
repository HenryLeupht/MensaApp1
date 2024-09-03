// lib/views/food_view.dart
import 'package:flutter/material.dart';
import '../controller/food_controller.dart';
import '../utils/user_session.dart';
import '../models/food.dart';

class FoodView extends StatefulWidget {
  final FoodController controller;

  const FoodView({super.key, required this.controller});

  @override
  _FoodViewState createState() => _FoodViewState();
}

class _FoodViewState extends State<FoodView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food List'),
        leading: IconButton(  // Button nach links verschieben
          icon: const Icon(Icons.login),
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
        ),
        actions: [
          if (UserSession.isAdmin())
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _showManageFoodDialog(context);
              },
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.controller.getFoods().length,
        itemBuilder: (context, index) {
          final food = widget.controller.getFood(index);
          return ListTile(
            title: Text(food.name),
            subtitle: Text('${food.price} EUR - ${food.type.toString().split('.').last}'),
            trailing: UserSession.isAdmin()
                ? IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _showManageFoodDialog(context, food: food, index: index);
              },
            )
                : null,
          );
        },
      ),
    );
  }
// Methode zum Anzeigen des Dialogs zum Hinzufügen oder Bearbeiten von Essen
  void _showManageFoodDialog(BuildContext context, {Food? food, int? index}) {
    final bool isNew = food == null;
    final TextEditingController nameController =
    TextEditingController(text: food?.name ?? '');
    final TextEditingController priceController =
    TextEditingController(text: food?.price.toString() ?? '');
    FoodType? selectedType = food?.type;

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
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Preis'),
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
                  hint: const Text('Art wählen'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    priceController.text.isNotEmpty &&
                    selectedType != null) {
                  final String name = nameController.text;
                  final double price = double.parse(priceController.text);
                  final FoodType type = selectedType!;

                  if (isNew) {
                    widget.controller.addFood(Food(name: name, price: price, type: type));
                  } else {
                    widget.controller.updateFood(index!, Food(
                      name: name,
                      price: price,
                      type: type,
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
}
