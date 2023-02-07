import 'package:caro_game/core/assets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DiscoveringWidget extends StatelessWidget {
  const DiscoveringWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Discovering'),
        const SizedBox(height: 10),
        Lottie.asset(AnimationAssets.finding, height: 100),
      ],
    );
  }
}
