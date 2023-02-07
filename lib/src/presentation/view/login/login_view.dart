import 'package:caro_game/core/assets.dart';
import 'package:caro_game/src/presentation/view/home/home_view.dart';
import 'package:caro_game/src/presentation/view/login/login_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoginView extends GetView<LoginController> {
  static const String routeName = '/LoginView';
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Enter your name:'),
            const SizedBox(height: 5),
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (controller.nameController.text.trim().isEmpty) {
                  Get.snackbar(
                    'Oops!',
                    'Enter your name before play game',
                    backgroundColor: context.theme.colorScheme.error,
                    colorText: context.theme.colorScheme.onError,
                  );
                  return;
                }
                Get.dialog(
                  WillPopScope(
                    onWillPop: () async => false,
                    child: Center(
                      child: SizedBox(height: 100, child: Lottie.asset(AnimationAssets.loading)),
                    ),
                  ),
                );
                bool permission = await controller.checkAndRequestPermission();
                Get.back();
                if (permission) {
                  Get.offNamed(
                    HomeView.routeName,
                    arguments: controller.nameController.text.trim(),
                  );
                }
              },
              child: const Text('GOGO'),
            )
          ],
        ),
      ),
    );
  }
}
