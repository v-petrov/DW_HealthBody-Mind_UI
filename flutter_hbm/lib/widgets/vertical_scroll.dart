import 'package:flutter/material.dart';

class VerticalScrollable extends StatefulWidget {
  final Widget child;
  final double? height;

  const VerticalScrollable({super.key, required this.child, this.height});

  @override
  VerticalScrollableState createState() => VerticalScrollableState();
}

class VerticalScrollableState extends State<VerticalScrollable> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.height ?? MediaQuery.of(context).size.height,
      child: Scrollbar(
        controller: scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.vertical,
          child: widget.child,
        ),
      ),
    );
  }
}
