import 'package:flutter/material.dart';
import '../widgets/main_layout.dart';

class FoodPage extends StatelessWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: Center(child: Text("Food Page")),
    );
  }
}