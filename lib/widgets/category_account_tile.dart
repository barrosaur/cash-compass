import 'package:flutter/material.dart';
import 'package:cash_compass/constants/colors.dart' as clr;

class CategoryAccountTile extends StatelessWidget {
  final String emoji;
  final String name;
  final VoidCallback onDelete;

  const CategoryAccountTile({
    super.key,
    required this.emoji,
    required this.name,
    required this.onDelete,
  });

  @override 
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide (color: clr.matteblack),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: TextStyle(fontSize: 25)),
          const SizedBox(width: 20),
          Text(
            name,
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 23,
              color: clr.matteblack,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.delete, color: clr.matteblack),
          ),
        ],
      ),
    );
  }
}