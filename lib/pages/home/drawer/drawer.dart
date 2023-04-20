import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/mqtt_client/mqtt_client_bloc.dart';
import 'package:osh_remote/block/sign_in/sign_in_bloc.dart';
import 'package:osh_remote/pages/home/add_device/add_device.dart';
import 'package:osh_remote/pages/home/drawer/item_list.dart';

class DrawerPresenter extends StatelessWidget {
  const DrawerPresenter({super.key});

  void _onSignOut(BuildContext context) {
    context.read<SignInBloc>().add(const SignInLogoutRequested());
    context.read<MqttClientBloc>().add(const MqttStopEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
        buildWhen: (previous, current) => previous.user != current.user,
        builder: (context, state) {
          return Drawer(
              child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                  accountName: Text(state.user.name),
                  accountEmail: Text(state.user.email)),
              const Expanded(child: ItemList()),
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
                onTap: () => _onSignOut(context),
              ),
            ],
          ));
        });
  }
}
