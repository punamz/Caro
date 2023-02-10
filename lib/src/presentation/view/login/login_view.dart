import 'package:caro_game/core/assets.dart';
import 'package:caro_game/src/presentation/view/home/home_view.dart';
import 'package:caro_game/src/presentation/view/login/login_ctrl.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoginView extends GetView<LoginController> {
  static const String routeName = '/LoginView';
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.4, 0.7],
            colors: [
              Color(0xFF4b4293),
              Color(0xFF4b4293),
              Color(0xFF08418e),
            ],
          ),
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Color(0x32FFFFFF), BlendMode.dstATop),
            image: ExtendedAssetImageProvider(ImageAssets.background),
          ),
        ),
        child: Center(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            elevation: 5,
            color: const Color.fromARGB(255, 171, 211, 250).withOpacity(0.4),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(child: ExtendedImage.asset(ImageAssets.loginPic, height: 100)),
                    const SizedBox(height: 10),
                    Text(
                      'Enter your name:',
                      style: context.theme.textTheme
                          .apply(bodyColor: context.theme.colorScheme.primaryContainer)
                          .labelMedium,
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: controller.nameController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(color: context.theme.colorScheme.primaryContainer),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(color: context.theme.colorScheme.primary),
                        ),
                      ),
                      style: context.theme.textTheme
                          .apply(bodyColor: context.theme.colorScheme.secondaryContainer)
                          .bodyLarge,
                      cursorColor: context.theme.colorScheme.secondaryContainer,
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.theme.colorScheme.primaryContainer,
                        foregroundColor: context.theme.colorScheme.onPrimaryContainer,
                      ),
                      child: const Text('GOGO'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
