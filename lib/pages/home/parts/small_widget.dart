import 'dart:async';

import 'package:flutter/material.dart';
import 'package:osh_remote/pages/home/widget/stream_widget.dart';

class SmallHomeWidget extends StatefulWidget with StreamWidget {
  final String label;
  final IconData iconData;

  SmallHomeWidget({
    required this.label,
    required this.iconData,
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
                // _getValue(widget.counterStream),
              ],
            )
          ],
        ));
  }

  Widget _getValue(Stream<String> stream) {
    return StreamBuilder<String>(
        stream: stream,
        initialData: "--",
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                Visibility(
                  visible: snapshot.hasData,
                  child: Text(
                    snapshot.data.toString(),
                    style: const TextStyle(color: Colors.black, fontSize: 24),
                  ),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              return Text(snapshot.data.toString(),
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 34,
                  ));
            } else {
              return const Text('Empty data');
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        });
  }
}
