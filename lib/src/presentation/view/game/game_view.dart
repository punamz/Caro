import 'package:caro_game/core/constrant.dart';
import 'package:caro_game/core/router_config.dart';
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

  @override
  String? get tag => '$gameCtrlTag';

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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(() => Text(
                    'You: ${controller.yourScore.value}',
                    style: context.textTheme.apply(bodyColor: context.theme.colorScheme.primary).titleMedium,
                  )),
              const SizedBox(width: 50),
              Obx(() => Text(
                    'Opponent : ${controller.partnerScore.value}',
                    style: context.textTheme.apply(bodyColor: context.theme.colorScheme.error).titleMedium,
                  )),
            ],
          ),
          // Obx(() => controller.showResult.isTrue
          //     ? Text(controller.winner?.title ?? '')
          //     : Obx(() => Text(
          //           controller.isWaitingOpponentStep.isTrue ? 'Waiting ${controller.device.name} ...' : 'Your Turn',
          //         ))),
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
                            onChangeEnd: (value) => Storage.instance.writeDouble(Constant.stoMusicVolume, value),
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
                            onChangeEnd: (value) => Storage.instance.writeDouble(Constant.stoSoundEffect, value),
                            onChanged: (value) => controller.soundEffect.call(value),
                          ))
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        body: Column(
          children: [
            Obx(() => controller.showResult.isTrue || controller.isWaitingInvitation.isTrue
                ? const SizedBox.shrink()
                : Obx(() => AnimatedCrossFade(
                      firstChild: SizedBox(
                        width: context.width,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: context.theme.colorScheme.primary),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              child: Text(
                                'Your turn',
                                style:
                                    context.textTheme.apply(bodyColor: context.theme.colorScheme.onPrimary).bodyLarge,
                              ),
                            ),
                          ),
                        ),
                      ),
                      secondChild: SizedBox(
                        width: context.width,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: context.theme.colorScheme.error),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              child: Text(
                                'Opponent turn',
                                style: context.textTheme.apply(bodyColor: context.theme.colorScheme.onError).bodyLarge,
                              ),
                            ),
                          ),
                        ),
                      ),
                      crossFadeState: controller.isWaitingOpponentStep.isFalse
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 410),
                      firstCurve: Curves.decelerate,
                      secondCurve: Curves.decelerate,
                    ))),
            Expanded(
              child: Obx(() => controller.isWaitingInvitation.isTrue
                  ? WaitingWidget(opponentName: controller.device.name)
                  : const Center(child: GameBoardWidget())),
            ),
            SizedBox(
              width: context.width,
              child: Obx(
                () => AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: ResultBottomSheet(
                    winner: controller.winner,
                    onExit: () {
                      controller.sendData(Constant.exitRoom);
                      Get.back();
                    },
                    onRematch: controller.rematch,
                  ),
                  crossFadeState: controller.showResult.isFalse ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 410),
                  sizeCurve: Curves.decelerate,
                  firstCurve: Curves.decelerate,
                  secondCurve: Curves.decelerate,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
