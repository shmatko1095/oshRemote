import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/mqtt_client/mqtt_client_bloc.dart';
import 'package:osh_remote/block/sign_in/sign_in_bloc.dart';
import 'package:osh_remote/pages/home/add_device/add_device.dart';
import 'package:osh_remote/pages/home/drawer/item_list.dart';

class DrawerPresenter extends StatelessWidget {
  final Function() onSignOut;
  final Function(String) onTap;
  final Function(String) onRemove;
  final Function(String) onRename;

  const DrawerPresenter(
      {required this.onSignOut,
      required this.onTap,
      required this.onRemove,
      required this.onRename,
      super.key});

  void _requestUserThingList(BuildContext context) {
    final userId = BlocProvider.of<SignInBloc>(context).state.user.userId;
    BlocProvider.of<MqttClientBloc>(context)
        .add(MqttGetUserThingsRequested(userId: userId));
  }

  Widget _getListBuilder(String userId) {
    return BlocBuilder<MqttClientBloc, MqttClientState>(
        buildWhen: (previous, current) =>
            previous.userThingsList != current.userThingsList,
        builder: (context, state) {
          return ItemList(
              deviceList: List.from(state.userThingsList),
              onTap: onTap,
              onRename: onRename,
              onRemove: onRemove);
        });
  }

  @override
  Widget build(BuildContext context) {
    _requestUserThingList(context);

    return BlocBuilder<SignInBloc, SignInState>(
        buildWhen: (previous, current) => previous.user != current.user,
        builder: (context, state) {
          return Drawer(
              child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                  accountName: Text(state.user.name),
                  accountEmail: Text(state.user.email)),
              Expanded(
                child: _getListBuilder(state.user.userId),
              ),
              const Spacer(),
              ListTile(
                  leading: const Icon(Icons.add, color: Colors.blue),
                  title: Text(S.of(context)!.addDevice),
                  onTap: () =>
                      Navigator.of(context).push(AddDeviceForm.route())),
              const Divider(thickness: 1.5),
              ListTile(
                leading:
                    const Icon(Icons.power_settings_new, color: Colors.red),
                title: Text(S.of(context)!.signOut),
                onTap: onSignOut,
              ),
            ],
          ));
        });
  }
}
