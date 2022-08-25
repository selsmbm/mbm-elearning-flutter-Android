import 'package:flutter/material.dart';
import 'package:mbm_elearning/flavors.dart';
import 'package:mbm_elearning/run_app.dart';

void main() async {
  Flavors.appFlavor = Flavor.MPROD;
  runApp(await runMainApp());
}
