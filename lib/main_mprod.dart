import 'package:flutter/material.dart';
import 'package:mbm_elearning/run_app.dart';
import 'flavors.dart';

void main() async {
  Flavors.appFlavor = Flavor.MPROD;
  runApp(await runMainApp());
}
