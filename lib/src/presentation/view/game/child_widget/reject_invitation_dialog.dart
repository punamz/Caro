import 'package:caro_game/src/presentation/view/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OpponentRejectInvitationDialog extends StatelessWidget {
  final String opponentName;
  const OpponentRejectInvitationDialog({Key? key, required this.opponentName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reject Invitation'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('$opponentName declined your invitation to play the game'),
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
