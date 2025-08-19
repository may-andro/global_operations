import 'package:core/core.dart' as core;
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/splash/presentation/bloc/bloc.dart';
import 'package:global_ops/src/feature/splash/presentation/widget/widget.dart';
import 'package:module_injector/module_injector.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    required this.buildConfig,
    required this.moduleConfigurators,
    required this.onInitializationSuccessful,
    super.key,
  });

  final core.BuildConfig buildConfig;
  final List<ModuleConfigurator> moduleConfigurators;
  final void Function(DesignSystem) onInitializationSuccessful;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return SplashBloc(ModuleInjectorController(), moduleConfigurators)
          ..add(InitEvent());
      },
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return BlocBuilder<SplashBloc, SplashState>(
                builder: (context, state) {
                  return Stack(
                    children: [
                      Positioned(
                        top: constraints.maxHeight * 0.25,
                        height: constraints.maxHeight * 0.05,
                        left: 0,
                        right: 0,
                        child: DSLogoImageWidget.rectangle(fit: BoxFit.contain)
                            .animate()
                            .shimmer(
                              duration: const Duration(milliseconds: 600),
                              color: context.shimmerColor,
                            ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: _InfoWidget(state, buildConfig),
                      ),
                      if (state is SetUpCompetedState) ...[
                        Positioned.fill(
                          child: Animate(
                            effects: const [
                              ScaleEffect(
                                begin: Offset(0.1, 0.1),
                                end: Offset(3, 3),
                                duration: Duration(milliseconds: 500),
                                curve: Curves.linear,
                              ),
                            ],
                            onComplete: (_) {
                              onInitializationSuccessful(state.designSystem);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF0B78BE),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _InfoWidget extends StatelessWidget {
  const _InfoWidget(this.state, this.buildConfig);

  final SplashState state;
  final core.BuildConfig buildConfig;

  @override
  Widget build(BuildContext context) {
    final isDescriptive = buildConfig.buildEnvironment.isSplashDescriptive;

    switch (state) {
      case final SetUpCompetedState _:
        return const SizedBox.shrink();
      case final SetUpErrorState state:
        return SetupFailureWidget(state.cause);
      case final SetUpProgressState state:
        return isDescriptive
            ? SetupStatusInfoWidget(state.setUpStatus)
            : SetupProgressWidget(state.progress);
    }
  }
}

extension on BuildContext {
  Color get shimmerColor {
    return MediaQuery.of(this).platformBrightness == Brightness.dark
        ? const Color(0xFF121212)
        : const Color(0xFFFFFFFF);
  }
}
