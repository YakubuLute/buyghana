import 'package:ecomly/core/common/app/riverpod/current_user_provider.dart';
import 'package:ecomly/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly/core/extensions/string_extensions.dart';
import 'package:ecomly/core/extensions/text_style_extensions.dart';
import 'package:ecomly/core/res/styles/colours.dart';
import 'package:ecomly/core/res/styles/text.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/src/user/features/profile/presentation/widgets/profile_form.dart';
import 'package:ecomly/src/user/features/profile/presentation/widgets/update_user_button.dart';
import 'package:ecomly/src/user/presentation/app/auth_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  static const path = '/profile';

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  final nameFocusNode = FocusNode();
  final nameNotifier = ValueNotifier('');
  final changeNotifier = ValueNotifier(false);
  final updateContainer = <String, dynamic>{};
  final authUserAdapterFamilyKey = GlobalKey();

  /// If this page is locked for editing
  final lockNotifier = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    ref.listen(
      authUserProvider(authUserAdapterFamilyKey),
      (previous, next) {
        if (next is AuthUserError) {
          CoreUtils.showSnackBar(context, message: next.message);
        } else if (next is UserUpdated) {
          CoreUtils.showSnackBar(context, message: 'Update Successful');
        }
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        bottom: const AppBarBottom(),
        actions: [
          ValueListenableBuilder(
            valueListenable: lockNotifier,
            builder: (_, isLocked, __) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  onPressed: () {
                    lockNotifier.value = !lockNotifier.value;
                    if (!lockNotifier.value) {
                      nameFocusNode.requestFocus();
                    } else {
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                    final message = lockNotifier.value
                        ? 'Profile Locked'
                        : 'Profile Unlocked';
                    CoreUtils.showSnackBar(context, message: message);
                  },
                  icon: Icon(isLocked ? IconlyBroken.edit : IconlyBroken.lock),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder(
                  valueListenable: nameNotifier,
                  builder: (_, nameFromController, __) {
                    final name =
                        lockNotifier.value && nameFromController.isEmpty
                            ? currentUser!.name
                            : nameFromController;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colours.lightThemePrimaryColour,
                          child: Center(
                            child: Text(
                              name.initials,
                              textAlign: TextAlign.center,
                              style: TextStyles.headingMedium.white,
                            ),
                          ),
                        ),
                        const Gap(15),
                        Center(
                          child: Text(
                            name,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.headingMedium
                                .adaptiveColour(context),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const Gap(20),
                Expanded(
                  flex: 2,
                  child: ValueListenableBuilder(
                    valueListenable: lockNotifier,
                    builder: (_, isLocked, __) {
                      return AbsorbPointer(
                        absorbing: isLocked,
                        child: ProfileForm(
                          nameNotifier: nameNotifier,
                          nameFocusNode: nameFocusNode,
                          changeNotifier: changeNotifier,
                          updateContainer: updateContainer,
                        ),
                      );
                    },
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: changeNotifier,
                  builder: (_, versionConflict, __) {
                    if (versionConflict) {
                      return UpdateUserButton(
                        changeNotifier: changeNotifier,
                        authUserAdapterFamilyKey: authUserAdapterFamilyKey,
                        onPressed: () => lockNotifier.value = true,
                        updateData: updateContainer,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
