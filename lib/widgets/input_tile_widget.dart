import 'package:flutter/material.dart';

class InputTileWidget extends StatelessWidget {
  const InputTileWidget({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: child),
    );
  }
}
