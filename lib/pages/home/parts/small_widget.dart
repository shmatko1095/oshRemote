import 'package:flutter/material.dart';

class SmallHomeWidget extends StatefulWidget {
  final String label;
  final String value;
  final IconData iconData;
  final ValueChanged<String>? onChanged;

  const SmallHomeWidget({
    required this.label,
    required this.value,
    required this.iconData,
    this.onChanged,
    super.key,
  });

  @override
  State createState() => _SmallHomeWidgetState();
}

class _SmallHomeWidgetState extends State<SmallHomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // width: 48.0,
        // height: 48.0,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          backgroundBlendMode: BlendMode.src,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black26
              : Colors.white,
          boxShadow: [
            BoxShadow(
              blurStyle: BlurStyle.solid,
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              offset: const Offset(3, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              widget.label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w300),
            ),
            const Divider(thickness: 1),
            Row(
              children: [
                Icon(widget.iconData,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    size: 40),
                const Spacer(),
                Text(
                  widget.value,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 34,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                )
              ],
            )
          ],
        ));
  }
}
