import 'package:caro_game/generated/l10n.dart';
import 'package:caro_game/src/domain/model/device_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nearby_connections/nearby_connections.dart';

class DeviceItemWidget extends StatelessWidget {
  final DeviceModel device;
  final void Function(DeviceModel) onConnect;
  final void Function(DeviceModel) onDisconnect;
  final void Function(DeviceModel, int) onStartGame;
  const DeviceItemWidget(
      {Key? key, required this.device, required this.onConnect, required this.onDisconnect, required this.onStartGame})
      : super(key: key);

  Future<void> _onStart() async {
    int? size = await Get.dialog<int>(_SelectMapSizeDialog());
    if (size != null) onStartGame(device, size);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      device.name,
                      style: context.textTheme.titleMedium,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 5),
                    Text(device.id),
                  ],
                ),
              ),
              if (device.connectionInfo == null || device.status != Status.CONNECTED)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: context.theme.colorScheme.onSecondaryContainer,
                    backgroundColor: context.theme.colorScheme.secondaryContainer, // foreground
                  ),
                  onPressed: device.connecting == true ? null : () => onConnect(device),
                  child: Text(device.connecting == true ? S.of(context).connecting : S.of(context).connect),
                )
              else ...[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: context.theme.colorScheme.onError,
                    backgroundColor: context.theme.colorScheme.error, // foreground
                  ),
                  onPressed: () => onDisconnect(device),
                  child: Text(S.of(context).disconnect),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: context.theme.colorScheme.onPrimaryContainer,
                    backgroundColor: context.theme.colorScheme.primaryContainer,
                  ),
                  onPressed: _onStart,
                  child: Text(S.of(context).start_game),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectMapSizeDialog extends StatelessWidget {
  _SelectMapSizeDialog({Key? key}) : super(key: key);

  final RxInt _sized = 20.obs;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).map_size),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(() => Text('${S.of(context).set_map_size_to} ${_sized.value}×${_sized.value}')),
          Obx(() => Slider(
                min: 5,
                max: 50,
                value: _sized.value.toDouble(),
                onChanged: (value) => _sized.call(value.toInt()),
              ))
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: context.theme.colorScheme.onPrimaryContainer,
            backgroundColor: context.theme.colorScheme.primaryContainer, // foreground
          ),
          onPressed: () {
            Get.back(result: _sized.value);
          },
          child: Text(S.of(context).confirm),
        ),
      ],
    );
  }
}
