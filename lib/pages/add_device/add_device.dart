import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:osh_remote/utils/constants.dart';

class AddDeviceForm extends StatefulWidget {
  const AddDeviceForm({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const AddDeviceForm());
  }

  @override
  State<StatefulWidget> createState() => _AddDeviceFormState();
}

class _AddDeviceFormState extends State<AddDeviceForm> {
  final _cameraController = MobileScannerController();
  final _snFieldController = TextEditingController();
  final _scFieldController = TextEditingController();
  String? _snValue;
  String? _scValue;

  @override
  void initState() {
    super.initState();
    _snFieldController
        .addListener(() => setState(() => _snValue = _snFieldController.text));
    _scFieldController
        .addListener(() => setState(() => _scValue = _scFieldController.text));
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _snFieldController.dispose();
    _scFieldController.dispose();
    super.dispose();
  }

  bool _isValid(String? value, int len) {
    if (value == null) return true;
    if (value.isEmpty) return true;
    return value.length >= len;
  }

  bool _isConfirmAvailable() {
    return (_snValue != null &&
            _snValue!.length >= Constants.minSerialNumberLength) &&
        (_scValue != null && _scValue!.length >= Constants.minSecureCodeLength);
  }

  Widget _getQrCodeScanner(BuildContext context) {
    return SizedBox(
        height: 300,
        child: MobileScanner(
          fit: BoxFit.fitWidth,
          controller: _cameraController,
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            if (barcodes.isNotEmpty && barcodes.last.rawValue != null) {
              //jsonString example: {"SN":"848445","SC":"00005lplplplp81"}
              final data = jsonDecode(barcodes.last.rawValue!);
              _snFieldController.text = data[Constants.serialNumberJsonKey]!;
              _scFieldController.text = data[Constants.secureCodeJsonKey]!;
            }
          },
        ));
  }

  Widget _getSNField(BuildContext context) {
    return TextFormField(
      controller: _snFieldController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: S.of(context)!.serialNumberLabel,
        hintText: S.of(context)!.serialNumberHint,
        errorText: _isValid(_snValue, Constants.minSerialNumberLength)
            ? null
            : S.of(context)!.serialNumberError,
      ),
    );
  }

  Widget _getSCField(BuildContext context) {
    return TextFormField(
      controller: _scFieldController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: S.of(context)!.secureCodeLabel,
        hintText: S.of(context)!.secureCodeHint,
        errorText: _isValid(_scValue, Constants.minSecureCodeLength)
            ? null
            : S.of(context)!.secureCodeError,
      ),
    );
  }

  Widget _getConfirmButton(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: _isConfirmAvailable() ? () {} : null,
            child: Text(S.of(context)!.addDevice)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context)!.addDevice),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: ValueListenableBuilder(
                valueListenable: _cameraController.torchState,
                builder: (context, state, child) => state == TorchState.on
                    ? const Icon(Icons.flash_on)
                    : const Icon(Icons.flash_off),
              ),
              onPressed: () => _cameraController.toggleTorch(),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: Constants.formPadding,
          child: Column(
            children: [
              ...[
                _getQrCodeScanner(context),
                _getSNField(context),
                _getSCField(context),
                _getConfirmButton(context),
              ].expand((element) => [element, const SizedBox(height: 24)])
            ],
          ),
        ),
      ),
    );
  }
}
