import 'package:caro_game/core/assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class WaitingWidget extends StatelessWidget {
  final String opponentName;
  const WaitingWidget({Key? key, required this.opponentName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Waiting for $opponentName to accept game invitation',
              style: context.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          Lottie.asset(AnimationAssets.waiting, height: 100),
        ],
      ),
    );
  }
}
