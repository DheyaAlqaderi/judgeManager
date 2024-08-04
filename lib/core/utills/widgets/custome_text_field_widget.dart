import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
  CustomTextFieldWidget({super.key,required this.isPassword, this.name, this.controller, this.hintText, this.textInputType});
  var name;
  var controller;
  var hintText;
  var textInputType;
  bool isPassword;
  @override
  Widget build(BuildContext context) {

    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: name,
        hintText: hintText,
        labelStyle: const TextStyle(color: Colors.grey), // Default label text color
        hintStyle: const TextStyle(color: Colors.grey), // Default hint text color
        filled: true,
        fillColor: Colors.grey.withOpacity(0.1), // Set the background color here

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none, // No border when focused
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none, // No border by default
        ),
      ),
      // validator: (){
      // },
    );
  }
}