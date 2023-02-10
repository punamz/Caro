import 'package:caro_game/src/presentation/view/game/game_ctrl.dart';
import 'package:caro_game/src/presentation/view/game/game_view.dart';
import 'package:caro_game/src/presentation/view/home/home_ctrl.dart';
import 'package:caro_game/src/presentation/view/home/home_view.dart';
import 'package:caro_game/src/presentation/view/login/login_ctrl.dart';
import 'package:caro_game/src/presentation/view/login/login_view.dart';
import 'package:get/get.dart';

List<GetPage> routers = [
  GetPage(
    name: HomeView.routeName,
    page: () => const HomeView(),
    binding: BindingsBuilder(() => Get.lazyPut<HomeController>(() => HomeController())),
  ),
  GetPage(
    name: LoginView.routeName,
    page: () => const LoginView(),
    binding: BindingsBuilder(() => Get.lazyPut<LoginController>(() => LoginController())),
  ),
  GetPage(
    name: GameView.routeName,
    page: () => const GameView(),
    binding: BindingsBuilder(
      () => Get.lazyPut<GameController>(() => GameController(), tag: '${++gameCtrlTag}'),
    ),
  ),
];

int gameCtrlTag = 0;
