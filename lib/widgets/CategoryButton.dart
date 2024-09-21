import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CategoryButton({
    super.key,
    Key? customKey,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(7),
          shape: RoundedRectangleBorder(
              side: const BorderSide(
                  width: 2.0, color: Color.fromARGB(200, 30, 129, 176)),
              borderRadius: BorderRadius.circular(25.0)),
          backgroundColor: Colors.white,
          minimumSize: const Size(10, 40),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
              fontSize: 11, color: const Color.fromARGB(200, 30, 129, 176)),
        ),
      ),
    );
  }
}
