
import 'package:flutter/material.dart';

Widget inputfield({
  required String hintText,
  required TextEditingController controller,
  String? errorMessage,
  bool? obscureText,
  void Function()? onPressed,
  TextInputType? keyboardType,
}) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            suffixIcon: onPressed != null && obscureText != null
                ? GestureDetector(
                    onTap: onPressed,
                    child: obscureText
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                  )
                : SizedBox.shrink(),
            suffixIconConstraints: BoxConstraints(maxHeight: 30),
          ),
          obscureText: obscureText ?? false,
        ),
      ),
      (errorMessage != null)
          ? Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),
            )
          : SizedBox.shrink(),
    ],
  );
}
