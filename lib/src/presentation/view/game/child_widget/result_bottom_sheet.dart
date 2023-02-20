import 'package:caro_game/core/assets.dart';
import 'package:caro_game/core/enum_value.dart';
import 'package:caro_game/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:lottie/lottie.dart';

class ResultBottomSheet extends StatelessWidget {
  final Winner? winner;
  final void Function() onExit;
  final void Function() onRematch;
  const ResultBottomSheet({Key? key, required this.winner, required this.onExit, required this.onRematch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 100,
            child: Lottie.asset(
              winner == Winner.draw
                  ? AnimationAssets.draw
                  : winner == Winner.me
                      ? AnimationAssets.winner
                      : AnimationAssets.loser,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: context.theme.colorScheme.onPrimaryContainer,
              backgroundColor: context.theme.colorScheme.primaryContainer,
            ),
            onPressed: onRematch,
            child: Text(S.of(context).play_again),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: context.theme.colorScheme.onError,
              backgroundColor: context.theme.colorScheme.error,
            ),
            onPressed: onExit,
            child: Text(S.of(context).exit_room_title),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
