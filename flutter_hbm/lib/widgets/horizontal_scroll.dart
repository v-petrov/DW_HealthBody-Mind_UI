import 'package:flutter/material.dart';

class HorizontalScrollable extends StatefulWidget {
  final Widget child;
  final double? width;

  const HorizontalScrollable({super.key, required this.child, this.width});

  @override
  HorizontalScrollableState createState() => HorizontalScrollableState();
}

class HorizontalScrollableState extends State<HorizontalScrollable> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width,
      child: Scrollbar(
        controller: scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          child: widget.child,
        ),
      ),
    );
  }
}