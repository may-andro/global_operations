import 'package:design_system/design_system.dart';
import 'package:global_ops/src/app/run_app_initialization.dart';
import 'package:module_injector/module_injector.dart';

Future<void> restartApp() async {
  final serviceLocator = ModuleInjectorController().serviceLocator;
  await serviceLocator.reset();
  await runAppWithInitialization();
}

void restartAppWithoutInitialization() {
  runMainApp(DesignSystem.primary);
}
