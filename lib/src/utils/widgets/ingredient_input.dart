import 'package:flutter/material.dart';

class IngredientInput extends StatelessWidget{
  final TextEditingController nameController;
  final TextEditingController amountController;
  final VoidCallback onRemove;

  const IngredientInput({
    super.key,
    required this.nameController,
    required this.amountController,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: amountController,
            decoration: InputDecoration(labelText: "Ingredient Name"),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: amountController,
            decoration: InputDecoration(labelText: "Amount"),
          ),
        ),
        IconButton(
          icon: Icon(Icons.remove_circle, color: Colors.red),
          onPressed:(){},
        )
      ],
    );
  }
}