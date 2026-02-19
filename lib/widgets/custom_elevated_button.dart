import 'package:flutter/material.dart';

Widget customElevatedButton({required String label, required void Function()? onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(20),
      ),
      backgroundColor: const Color(0xFF10B981),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 32),
    ),
    child: Text(
      label,
      style: TextStyle(
        // color: Colors.brown[900],
        color: const Color(0xFFFFFFFF),
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}