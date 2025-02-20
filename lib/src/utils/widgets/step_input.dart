import 'package:flutter/material.dart';

class StepInput extends StatelessWidget {
  final TextEditingController stepController;
  final VoidCallback onRemove;

  const StepInput({
    super.key,
    required this.stepController,
    required this.onRemove
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
                controller: stepController,
                decoration: InputDecoration(labelText: "Step"),
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