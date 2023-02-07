import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExitDialog extends StatelessWidget {
  const ExitDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Exit room'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Text('Do you want to exit this room and end the match'),
        ],
      ),
      actions: <Widget>[
        OutlinedButton(
          onPressed: Get.back,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: context.theme.colorScheme.onPrimaryContainer,
            backgroundColor: context.theme.colorScheme.primaryContainer, // foreground
          ),
          onPressed: () => Get.back(result: true),
          child: const Text('Exit'),
        ),
      ],
    );
  }
}
