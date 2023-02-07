import 'package:caro_game/src/domain/model/device_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvitePlayDialog extends StatelessWidget {
  final DeviceModel device;
  final int mapSize;
  final void Function(DeviceModel) onPlay;
  final void Function(DeviceModel) onDenice;

  const InvitePlayDialog(
      {Key? key,
      required this.device,
      required this.onPlay,
      required this.onDenice,
      required this.mapSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Game invitation'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('${device.name} send you a game invite'),
          Text('map size: $mapSize×$mapSize'),
        ],
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            Get.back();
            onDenice(device);
          },
          child: const Text('Denice'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: context.theme.colorScheme.onPrimaryContainer,
            backgroundColor: context.theme.colorScheme.primaryContainer, // foreground
          ),
          onPressed: () {
            Get.back();
            onPlay(device);
          },
          child: const Text('Play'),
        ),
      ],
    );
  }
}
