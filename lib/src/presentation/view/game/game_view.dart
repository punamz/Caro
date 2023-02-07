import 'package:caro_game/core/constrant.dart';
import 'package:caro_game/src/infrastructure/get_storage/local_database.dart';
import 'package:caro_game/src/presentation/view/game/child_widget/exit_dialog.dart';
import 'package:caro_game/src/presentation/view/game/child_widget/game_board_widget.dart';
import 'package:caro_game/src/presentation/view/game/child_widget/result_bottom_sheet.dart';
import 'package:caro_game/src/presentation/view/game/child_widget/waiting_widget.dart';
import 'package:caro_game/src/presentation/view/game/game_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameView extends GetView<GameController> {
  static const String routeName = '/GameView';
  const GameView({Key? key}) : super(key: key);

  Future<void> _onWillPop() async {
    bool? value = await Get.dialog<bool>(const ExitDialog());
    if (value == true) {
      controller.sendData(Constant.exitRoom);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _onWillPop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() => controller.showResult.isTrue
              ? Text(controller.winner?.title ?? '')
              : Obx(() => Text(
                    controller.isWaitingOpponentStep.isTrue
                        ? 'Waiting ${controller.device.name} ...'
                        : 'Your Turn',
                  ))),
          actions: [
            PopupMenuButton(
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Row(
                    children: [
                      const Expanded(child: Text("Scroll to partner's move")),
                      Obx(() => Switch(
                            value: controller.enableScroller.value,
                            onChanged: (value) {
                              controller.enableScroller.call(value);
                              Storage.instance.writeBool(Constant.stoScrollMap, value);
                            },
                          ))
                    ],
                  ),
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      const Expanded(child: Text('Music volume')),
                      Obx(() => Slider(
                            value: controller.musicVolume.value,
                            onChangeEnd: (value) =>
                                Storage.instance.writeDouble(Constant.stoMusicVolume, value),
                            onChanged: (value) {
                              controller.musicVolume.call(value);
                              controller.assetsAudioPlayer.setVolume(value);
                            },
                          ))
                    ],
                  ),
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      const Expanded(child: Text('Sound effects')),
                      Obx(() => Slider(
                            value: controller.soundEffect.value,
                            onChangeEnd: (value) =>
                                Storage.instance.writeDouble(Constant.stoSoundEffect, value),
                            onChanged: (value) => controller.soundEffect.call(value),
                          ))
                    ],
                  ),
                ),
              ],
            )
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(() => Text(
                        'You: ${controller.yourScore.value}',
                        style: context.textTheme
                            .apply(bodyColor: context.theme.colorScheme.error)
                            .titleMedium,
                      )),
                  const SizedBox(width: 50),
                  Obx(() => Text(
                        'Opponent : ${controller.partnerScore.value}',
                        style: context.textTheme
                            .apply(bodyColor: context.theme.colorScheme.primary)
                            .titleMedium,
                      )),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Obx(() => controller.isWaitingInvitation.isTrue
                  ? WaitingWidget(opponentName: controller.device.name)
                  : const Center(child: GameBoardWidget())),
            ),
            Obx(() => controller.showResult.isTrue
                ? ResultBottomSheet(
                    winner: controller.winner,
                    onExit: () {
                      controller.sendData(Constant.exitRoom);
                      Get.back();
                    },
                    onRematch: controller.rematch,
                  )
                : const SizedBox.shrink())
          ],
        ),
      ),
    );
  }
}
