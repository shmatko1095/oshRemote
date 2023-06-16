import 'dart:async';

import 'package:flutter/material.dart';
import 'package:osh_remote/pages/home/widget/stream_widget.dart';

class SmallHomeWidget extends StatefulWidget with StreamWidget {
  final String label;
  final String initial;
  final String postfix;
  final IconData iconData;

  SmallHomeWidget({
    required this.label,
    required this.iconData,
    this.initial = "--",
    this.postfix = "",
    super.key,
  });

  @override
  State createState() => _SmallHomeWidgetState();
}

class _SmallHomeWidgetState extends State<SmallHomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(10),
        elevation: 10.0,
        child: Container(
          padding: const EdgeInsets.all(5),
          child: _getValue(widget.stream),
        ));
  }

  Widget _getValue(Stream<String> stream) {
    return StreamBuilder<String>(
        stream: stream,
        initialData: widget.initial,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
            _getDataContent(snapshot));
  }

  Widget _getDataContent(AsyncSnapshot<String> snapshot) {
    if (snapshot.hasError) {
      return const Text('Error');
    } else if (snapshot.hasData) {
      return Column(
        children: [
          Text(
            widget.label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w300),
          ),
          const Divider(thickness: 1),
          Row(
            children: [
              Icon(widget.iconData, color: _getColor(), size: 40),
              const Spacer(),
              Text(snapshot.data.toString() + widget.postfix,
                  style: TextStyle(color: _getColor(), fontSize: 34)),
            ],
          )
        ],
      );
    } else {
      return const Text('Empty data');
    }
  }

  Color _getColor() {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }
}
