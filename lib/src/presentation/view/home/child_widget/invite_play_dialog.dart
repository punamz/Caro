import 'package:caro_game/generated/l10n.dart';
import 'package:caro_game/src/domain/model/device_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvitePlayDialog extends StatelessWidget {
  final DeviceModel device;
  final int mapSize;
  final void Function(DeviceModel) onPlay;
  final void Function(DeviceModel) onDenice;

  const InvitePlayDialog(
      {Key? key, required this.device, required this.onPlay, required this.onDenice, required this.mapSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).game_invitation_title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('${device.name} ${S.of(context).game_invitation_message}'),
          Text('${S.of(context).map_size}: $mapSize×$mapSize'),
        ],
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            Get.back();
            onDenice(device);
          },
          child: Text(S.of(context).denice),
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
          child: Text(S.of(context).play),
        ),
      ],
    );
  }
}
