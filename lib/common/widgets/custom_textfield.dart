import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final GlobalKey formKey;
  final TextEditingController textController;
  const CustomTextField(
      {super.key, required this.textController, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'K!ID cannot be empty';
          } else if (value.length != 8) {
            return 'K!ID is 8 character long';
          }
          if (!value.startsWith("K24")) {
            return "Invalid K!ID";
          }

          return null;
        },
        style: const TextStyle(color: Colors.white, fontSize: 17.0),
        controller: textController,
        decoration: InputDecoration(
          prefixIcon: Container(
            height: 40.0,
            width: 40.0,
            margin: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 5),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(40, 34, 8, 100), // Dark blue
                      Color.fromARGB(40, 67, 39, 107), // Dark purple
                    ]),
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withOpacity(0.25), width: 1.5)),
            child: Center(
              child: Text(
                "K!ID",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: 14,
                ),
              ),
            ),
          ),
          labelText: 'Enter K!ID',
          labelStyle: const TextStyle(
              color: Color.fromARGB(101, 255, 255, 255), fontSize: 17.0),
          filled: true,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                width: 1.5, color: Color.fromARGB(100, 255, 255, 255)),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          fillColor: const Color.fromARGB(20, 255, 255, 255),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Colors.white),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Colors.white),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }
}
