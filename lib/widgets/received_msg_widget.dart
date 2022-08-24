import 'package:flutter/material.dart';

class ReceivedMsgWidget extends StatelessWidget {
  const ReceivedMsgWidget({
    Key? key,
    required this.text,
    required this.date,
    required this.name,
  }) : super(key: key);
  final String text;
  final String date;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(4.0),
          //   child: CircleAvatar(
          //     radius: 16,
          //     child: Image.network(
          //         'https://flyclipart.com/thumb2/default-avatar-png-icon-free-download-518373.png'),
          //   ),
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(20),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .75),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          color: Colors.deepPurple.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(text),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  style: Theme.of(context).textTheme.bodySmall,
                  date,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
