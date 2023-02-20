import 'package:caro_game/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExitDialog extends StatelessWidget {
  const ExitDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).exit_room_title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(S.of(context).exit_room_message),
        ],
      ),
      actions: <Widget>[
        OutlinedButton(
          onPressed: Get.back,
          child: Text(S.of(context).cancel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: context.theme.colorScheme.onPrimaryContainer,
            backgroundColor: context.theme.colorScheme.primaryContainer, // foreground
          ),
          onPressed: () => Get.back(result: true),
          child: Text(S.of(context).exit),
        ),
      ],
    );
  }
}
