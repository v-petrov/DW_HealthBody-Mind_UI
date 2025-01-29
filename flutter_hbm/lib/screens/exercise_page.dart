import 'package:flutter/material.dart';
import '../widgets/main_layout.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: Center(child: Text("Exercise Page")),
    );
  }
}