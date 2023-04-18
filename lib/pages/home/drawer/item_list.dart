import 'package:flutter/material.dart';
import 'package:osh_remote/block/mqtt_client/mqtt_client_bloc.dart';

class ItemList extends StatefulWidget {
  final List<ThingDescriptor> deviceList;
  final Function(String) onTap;
  final Function(String) onRemove;
  final Function(String) onRename;

  const ItemList(
      {required this.deviceList,
      required this.onTap,
      required this.onRemove,
      required this.onRename,
      super.key});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  late List<ThingDescriptor> _list;

  @override
  Widget build(BuildContext context) {
    _list = widget.deviceList;
    return ListView.builder(
      itemCount: _list.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(_list[index].sn),
          onDismissed: (dir) {
            widget.onRemove(_list[index].sn);
            setState(() {
              _list.removeAt(index);
            });
          },
          direction: DismissDirection.startToEnd,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            child: const Icon(Icons.delete),
          ),
          child: ListTile(
            leading: const Icon(Icons.home),
            title: Text(_list[index].name ?? _list[index].sn),
            onTap: () => widget.onTap(_list[index].sn),
            onLongPress: () => widget.onRename(_list[index].sn),
          ),
        );
      },
    );
  }
}
