import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RenameThingDialog {
  static Future<void> show(BuildContext context, Function(String?) onChanged) {
    String? newThingName;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context)!.renameDevice),
          content: TextFormField(
            decoration: InputDecoration(
              labelText: S.of(context)!.deviceName,
            ),
            onChanged: (value) => newThingName = value,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(S.of(context)!.cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(S.of(context)!.confirm),
              onPressed: () {
                onChanged(newThingName);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
