import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handle_permissions/home/home_bindings.dart';
import 'package:handle_permissions/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FilePicker x GetX',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurpleAccent
      ),
      initialBinding: HomeBindings(),
      home: const HomePage(),
    );
  }
}
