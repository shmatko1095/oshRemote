import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_cubit.dart';
import 'package:osh_remote/block/thing_cubit/thing_controller_state.dart';
import 'package:osh_remote/pages/home/drawer/thing_item.dart';

class ItemList extends StatelessWidget {
  const ItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThingControllerCubit, ThingControllerState>(
        buildWhen: (previous, current) =>
            previous.getThingDataList().length !=
            current.getThingDataList().length,
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.getThingDataList().length,
            itemBuilder: (context, index) =>
                ThingItem(sn: state.getThingDataList()[index].sn),
          );
        });
  }
}
