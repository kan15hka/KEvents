import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  GlobalKey formKey;
  TextEditingController textController;
  CustomTextField(
      {super.key, required this.textController, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'The MKID cannot be empty';
          } else if (value.length != 8) {
            return 'MKID is 8 character long';
          }
          return null;
        },
        style: const TextStyle(color: Colors.white, fontSize: 17.0),
        controller: textController,
        decoration: const InputDecoration(
          hintText: 'eg: xxxxxxxx',
          hintStyle: TextStyle(
              color: Color.fromARGB(101, 255, 255, 255), fontSize: 17.0),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 1.5, color: Color.fromARGB(100, 255, 255, 255)),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          fillColor: Color.fromARGB(20, 255, 255, 255),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Colors.white),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          border: OutlineInputBorder(
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
