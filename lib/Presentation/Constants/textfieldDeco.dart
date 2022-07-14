import 'package:flutter/material.dart';

InputDecoration  textFieldDeco = InputDecoration(
  suffixIcon: const Icon(Icons.search),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      color: Color(0xff0015CE),
    ),
    borderRadius: BorderRadius.circular(30.0),
  ),
  disabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      color: Color(0xff0015CE),
    ),
    borderRadius: BorderRadius.circular(30.0),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      color: Color(0xff0015CE),
    ),
    borderRadius: BorderRadius.circular(30.0),
  ),
  hintText: "Search here",
);
