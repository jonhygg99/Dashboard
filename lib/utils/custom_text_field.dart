import 'package:flutter/material.dart';

TextField customTextField(
    {inputType, controller, onChange, hintText, errorText, widgetMaxSize}) {
  return TextField(
    keyboardType: inputType,
    textInputAction: TextInputAction.next,
    controller: controller,
    autofocus: false,
    onChanged: onChange,
    style: TextStyle(color: Colors.black),
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.blueGrey[800],
          width: 3,
        ),
      ),
      filled: true,
      hintStyle: new TextStyle(
        color: Colors.blueGrey[300],
      ),
      hintText: hintText,
      fillColor: Colors.white,
      errorText: errorText,
      errorStyle: TextStyle(
        fontSize: 12,
        color: Colors.redAccent,
      ),
    ),
  );
}
