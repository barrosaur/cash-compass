import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cash_compass/constants/colors.dart' as clr;

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: clr.matteblack,
      title: Row(
        children: [
          SvgPicture.asset(
            'assets/images/logo.svg',
            height: 75.0,
            width: 75.0,
          ),
          const SizedBox(width: 10.0),
          Text(
            "CashCompass",
            style: TextStyle(
              fontFamily: "InriaSans",
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);
}
