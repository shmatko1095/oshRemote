import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanner extends StatelessWidget {
  QrCodeScanner({super.key});

  final MobileScannerController _cameraController = MobileScannerController();

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => QrCodeScanner());
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
              color: Colors.white,
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
        body: MobileScanner(
          fit: BoxFit.fitHeight,
          controller: _cameraController,
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              debugPrint('Barcode found! ${barcode.rawValue}');
            }
          },
        ),
      ),
    );
  }
}
