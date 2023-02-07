import 'package:caro_game/core/constrant.dart';
import 'package:caro_game/src/domain/model/game_argument.dart';
import 'package:caro_game/src/presentation/view/game/game_view.dart';
import 'package:caro_game/src/presentation/view/home/child_widget/device_item_widget.dart';
import 'package:caro_game/src/presentation/view/home/child_widget/discovering_widget.dart';
import 'package:caro_game/src/presentation/view/home/home_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  static const String routeName = '/HomeView';
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.disConnectAll();
        controller.stopAdvertising();
        controller.stopDiscovery();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Find another player')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('Select nearby player', style: context.textTheme.titleMedium),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Obx(() => controller.deviceFound.isEmpty
                    ? const DiscoveringWidget()
                    : ListView.builder(
                        itemCount: controller.deviceFound.length,
                        itemBuilder: (context, index) => DeviceItemWidget(
                          device: controller.deviceFound[index],
                          onConnect: controller.requestConnection,
                          onDisconnect: controller.stopEndpoint,
                          onStartGame: (device, size) {
                            controller.sendMessage(device, '${Constant.startGameCode}$size');
                            Get.toNamed(GameView.routeName,
                                arguments: GameArgument(device, false, size));
                          },
                        ),
                      )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
