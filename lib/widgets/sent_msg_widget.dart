import 'package:flutter/material.dart';

class SentMsgWidget extends StatelessWidget {
  const SentMsgWidget({
    Key? key,
    required this.text,
    required this.date,
  }) : super(key: key);
  final String text;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(20),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .75),
            decoration: const BoxDecoration(
              color: Colors.cyan,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                topLeft: Radius.circular(12),
              ),
            ),
            child: Text(text),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              style: Theme.of(context).textTheme.bodySmall,
              date,
            ),
          ),
        ],
      ),
    );
  }
}
