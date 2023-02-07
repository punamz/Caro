import 'package:caro_game/src/presentation/view/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OpponentExitDialog extends StatelessWidget {
  final String opponentName;
  const OpponentExitDialog({Key? key, required this.opponentName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Opponent exit'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('$opponentName has left the room'),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: context.theme.colorScheme.onPrimaryContainer,
            backgroundColor: context.theme.colorScheme.primaryContainer,
          ),
          onPressed: () => Get.until((route) => Get.currentRoute == HomeView.routeName),
          child: const Text('Ok'),
        ),
      ],
    );
  }
}