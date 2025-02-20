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
    
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: TextField(
                spellCheckConfiguration: SpellCheckConfiguration(),
                controller: nameController,
                decoration: InputDecoration(labelText: "Ingredient Name"),
              ),
            ),
            SizedBox(width: 10),
            SizedBox(
              width: 65,
              child: TextField(
                spellCheckConfiguration: SpellCheckConfiguration(),
                controller: amountController,
                decoration: InputDecoration(labelText: "Amount"),
              ),
            ),
            IconButton(
              icon: Icon(Icons.remove_circle, color: Colors.red),
              onPressed: onRemove,
            )
          ],
        ),
      ),
    );
  }
}