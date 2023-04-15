import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:osh_remote/block/mqtt_client/mqtt_client_bloc.dart';
import 'package:osh_remote/block/sign_in/sign_in_bloc.dart';
import 'package:osh_remote/pages/add_device/add_device.dart';

class DrawerPresenter extends StatelessWidget {
  final Function() onSignOut;
  final Function(String) onDeviceTap;

  const DrawerPresenter(
      {required this.onSignOut, required this.onDeviceTap, super.key});

  // void _onAddDevice1(BuildContext context) {
  //   showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(S.of(context)!.user_not_confirmed_title),
  //         content:
  //         SizedBox(
  //             height: 200,
  //             width: 100,
  //             child:
  //         MobileScanner(
  //               // fit: BoxFit.contain,
  //               controller: MobileScannerController(
  //                 detectionSpeed: DetectionSpeed.normal,
  //                 facing: CameraFacing.back,
  //                 torchEnabled: true,
  //               ),
  //               onDetect: (capture) {
  //                 final List<Barcode> barcodes = capture.barcodes;
  //                 final Uint8List? image = capture.image;
  //                 for (final barcode in barcodes) {
  //                   debugPrint('Barcode found! ${barcode.rawValue}');
  //                 }
  //               },
  //             )
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             style: TextButton.styleFrom(
  //               textStyle: Theme.of(context).textTheme.labelLarge,
  //             ),
  //             child: Text(S.of(context)!.cancel),
  //             onPressed: () => Navigator.of(context).pop(),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
              accountEmail: Text(state.user.email));
        });
  }

  Widget _getDeviceList() {
    return BlocBuilder<MqttClientBloc, MqttClientState>(
        builder: (context, state) {
      List<Widget> list = [];

      for (int count = 0; count < state.userThingsList.length; count++) {
        list.add(ListTile(
            leading: const Icon(Icons.home),
            title: Text(state.userThingsList[count]),
            onTap: onDeviceTap(state.userThingsList[count])));
      }

      list.add(ListTile(
          leading: const Icon(Icons.add, color: Colors.blue),
          title: Text(S.of(context)!.addDevice),
          onTap: () => Navigator.of(context).push(AddDeviceForm.route())));

      return ListView(
        children: list,
      );
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
          onTap: onSignOut,
        ),
      ],
    ));
  }
}
