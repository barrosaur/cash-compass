import 'package:flutter/material.dart';

class CstmBtn extends StatelessWidget {
  final String btnLabel;
  final String? emoji; // imgAsset from Category/Account
  final IconData? icon; // fallback if no emoji
  final VoidCallback onPressed;
  final Color bgColor;
  final Color txtColor;

  const CstmBtn({
    super.key,
    required this.btnLabel,
    required this.onPressed,
    required this.bgColor,
    required this.txtColor,
    this.emoji,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (emoji != null && emoji!.isNotEmpty)
            Text(
              emoji!,
              style: const TextStyle(fontSize: 18),
            )
          else if (icon != null)
            Icon(icon),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              btnLabel,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: "Inter",
                color: txtColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
