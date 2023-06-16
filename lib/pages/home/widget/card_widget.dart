import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String label;
  final String value;
  final IconData iconData;

  const CardWidget({
    required this.label,
    required this.value,
    required this.iconData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(10),
        elevation: 10.0,
        child: Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w300),
                ),
                const Divider(thickness: 1),
                Row(
                  children: [
                    Icon(iconData, color: _getColor(context), size: 40),
                    const Spacer(),
                    Text(value,
                        style:
                            TextStyle(color: _getColor(context), fontSize: 34)),
                  ],
                )
              ],
            )));
  }

  Color _getColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }
}
