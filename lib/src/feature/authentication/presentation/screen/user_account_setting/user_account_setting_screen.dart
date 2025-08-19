import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/delete_account/delete_account_screen.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/logout/logout_screen.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/update_password/update_password_screen.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/user_account_setting/bloc/bloc.dart';
import 'package:global_ops/src/module_injector/app_module_configurator.dart';

class UserAccountSettingScreen extends StatelessWidget {
  const UserAccountSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          appServiceLocator.get<UserAccountSettingBloc>()
            ..add(LoadUserAccountEvent()),
      child: BlocBuilder<UserAccountSettingBloc, UserAccountSettingState>(
        builder: (context, state) {
          switch (state) {
            case final UserAccountLoadedState _:
              return DsCardWidget(
                backgroundColor:
                    context.colorPalette.invertedBackground.primary,
                radius: context.dimen.radiusLevel2,
                elevation: context.dimen.elevationLevel1,
                margin: EdgeInsets.only(bottom: context.space(factor: 2)),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: context.space(factor: 2),
                      ),
                      leading: DSCircularIconCardWidget(
                        icon: Icons.person,
                        backgroundColor: context.colorPalette.neutral.grey1,
                        color: context.colorPalette.neutral.grey7,
                      ),
                      title: DSTextWidget(
                        context.localizations.settingCurrentUser,
                        color: context.colorPalette.neutral.grey1,
                        style: context.typography.titleMedium,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                      subtitle: DSTextWidget(
                        state.userName.capitalize,
                        color: context.colorPalette.neutral.grey3,
                        style: context.typography.bodyMedium,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                    DSHorizontalDividerWidget(
                      thickness: 1,
                      color: context.colorPalette.neutral.grey5,
                    ),
                    _ItemWidget(
                      title: context.localizations.settingChangePassword,
                      icon: Icons.lock,
                      onTap: () => UpdatePasswordScreen.navigate(context),
                    ),
                    _ItemWidget(
                      icon: Icons.logout,
                      title: context.localizations.settingLogout,
                      onTap: () {
                        LogoutScreen.showAsDialogOrBottomSheet(context);
                      },
                    ),
                    _ItemWidget(
                      icon: Icons.delete_forever,
                      title: context.localizations.settingDeleteAccount,
                      onTap: () => DeleteAccountScreen.navigate(context),
                    ),
                  ],
                ),
              );
            case final UserAccountErrorState state:
              return Center(
                child: DSTextWidget(
                  state.message,
                  color: context.colorPalette.semantic.error,
                  style: context.typography.bodyLarge,
                ),
              );
            case final UserAccountSettingInitialState _:
            case final UserAccountLoadingState _:
            default:
              return Center(
                child: DSLoadingWidget(size: context.space(factor: 5)),
              );
          }
        },
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.space(factor: 2),
      ),
      leading: Icon(
        icon,
        size: context.iconSize,
        color: context.colorPalette.neutral.grey1.color,
      ),
      title: DSTextWidget(
        title,
        color: context.colorPalette.neutral.grey1,
        style: context.typography.titleSmall,
        maxLines: 1,
        textOverflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
    );
  }
}
