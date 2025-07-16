import 'package:flutter/material.dart';

class HomeStack extends StatelessWidget {
  const HomeStack({super.key, required this.tittle, required this.img});
  final String tittle;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1, color: Color(0xFF999999)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(img, fit: BoxFit.cover),
                ),

                Text(
                  tittle,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Color(0xFF050505),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
