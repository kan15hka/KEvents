import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SearchTextFormField extends StatelessWidget {
  const SearchTextFormField(
      {super.key,
      required this.controller,
      this.onChanged,
      required this.labelText});
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String labelText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white, fontSize: 17.0),
      controller: controller,
      decoration: InputDecoration(
        prefixIconColor: const Color.fromARGB(179, 255, 255, 255),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Iconsax.search_normal,
            size: 25.0,
          ),
        ),
        labelText: labelText,
        labelStyle: const TextStyle(
            color: Color.fromARGB(101, 255, 255, 255), fontSize: 17.0),
        filled: true,
        enabledBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(width: 1, color: Color.fromARGB(100, 255, 255, 255)),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        fillColor: Colors.transparent,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1.5, color: Colors.white),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.white),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
