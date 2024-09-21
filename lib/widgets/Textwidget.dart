import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String placeholder;
  final String hintText;
  final bool obsoureText;
  final TextEditingController textEditingController;

  const TextFieldWidget(
      {super.key,
      required this.placeholder,
      required this.hintText,
      required this.obsoureText,
      required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      obscureText: obsoureText,
      autofocus: true,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: const TextStyle(color: Colors.black),
        hintText: placeholder,
        hintStyle: const TextStyle(color: Colors.grey),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(200, 30, 129, 176)),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromARGB(200, 30, 129, 176), width: 2.5),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}
