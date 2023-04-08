import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/mqtt_client/mqtt_client_bloc.dart';
import 'package:osh_remote/block/sign_in/sign_in_bloc.dart';

class DrawerPresenter extends StatelessWidget {
  final void Function() onSignOut;
  final void Function(String) onDeviceTap;

  const DrawerPresenter(
      {required this.onSignOut, required this.onDeviceTap, super.key});

  void _requestUserThingList(BuildContext context, String userId) {
    BlocProvider.of<MqttClientBloc>(context)
        .add(MqttGetUserThingsRequested(userId: userId));
  }

  Widget _getDrawerHeader() {
    return BlocBuilder<SignInBloc, SignInState>(
        buildWhen: (previous, current) => previous.user != current.user,
        builder: (context, state) {
          _requestUserThingList(context, state.user.userId);
          return UserAccountsDrawerHeader(
              accountName: Text(state.user.name),
              accountEmail: Text(state.user.username));
        });
  }

  Widget _getDeviceList() {
    return BlocBuilder<MqttClientBloc, MqttClientState>(
        builder: (context, state) {
      return ListView.builder(
          itemCount: state.userThingsList.length,
          itemBuilder: (context, int index) {
            return ListTile(
                leading: const Icon(Icons.home),
                title: Text(state.userThingsList[index]),
                onTap: () => onDeviceTap(state.userThingsList[index]));
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        _getDrawerHeader(),
        Expanded(
          child: _getDeviceList(),
        ),
        const Spacer(),
        const Divider(thickness: 1.5),
        ListTile(
          leading: const Icon(Icons.power_settings_new, color: Colors.red),
          title: Text(S.of(context)!.signOut),
          onTap: () => onSignOut,
        ),
      ],
    ));
  }
}
