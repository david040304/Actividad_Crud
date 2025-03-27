import 'package:cruds/app.dart';
import 'package:cruds/controllers/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskController()),
      ],
      child: const MyApp(),
    ),
  );
}
