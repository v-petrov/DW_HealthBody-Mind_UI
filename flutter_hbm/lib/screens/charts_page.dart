import 'package:flutter/material.dart';
import '../widgets/main_layout.dart';

class ChartsPage extends StatelessWidget {
  const ChartsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: Center(child: Text("Charts Page")),
    );
  }
}