import 'package:ecomly/core/common/app/riverpod/current_user_provider.dart';
import 'package:ecomly/core/common/widgets/vertical_label_field.dart';
import 'package:ecomly/core/utils/typedefs.dart';
import 'package:ecomly/src/user/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ProfileForm extends ConsumerStatefulWidget {
  const ProfileForm({
    required this.nameFocusNode,
    required this.nameNotifier,
    required this.changeNotifier,
    required this.updateContainer,
    super.key,
  });

  final ValueNotifier<String> nameNotifier;
  final FocusNode nameFocusNode;
  final ValueNotifier<bool> changeNotifier;
  final DataMap updateContainer;

  @override
  ConsumerState createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<ProfileForm> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  bool noChanges() {
    final currentUser = ref.watch(currentUserProvider)!;
    return nameController.text.toLowerCase().trim() ==
            currentUser.name.toLowerCase().trim() &&
        emailController.text.toLowerCase().trim() ==
            currentUser.email.toLowerCase().trim() &&
        phoneController.text.toLowerCase().trim() ==
            currentUser.phone?.toLowerCase().trim();
  }

  User currentUser() {
    return ref.watch(currentUserProvider)!;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    nameController = TextEditingController(text: currentUser().name.trim())
      ..addListener(() {
        widget.nameNotifier.value = nameController.text.trim();

        debugPrint('Controller Says: ${currentUser().name}');
        if (nameController.text.toLowerCase().trim() !=
            currentUser().name.toLowerCase().trim()) {
          widget.changeNotifier.value = true;
          widget.updateContainer['name'] = nameController.text.trim();
        } else if (noChanges()) {
          widget.changeNotifier.value = false;
          widget.updateContainer.clear();
        } else {
          widget.updateContainer.remove('name');
        }
      });
    emailController = TextEditingController(text: currentUser().email.trim())
      ..addListener(() {
        if (emailController.text.toLowerCase().trim() !=
            currentUser().email.toLowerCase().trim()) {
          widget.changeNotifier.value = true;
          widget.updateContainer['email'] = emailController.text.trim();
        } else if (noChanges()) {
          widget.changeNotifier.value = false;
          widget.updateContainer.clear();
        } else {
          widget.updateContainer.remove('email');
        }
      });
    phoneController = TextEditingController(text: currentUser().phone?.trim())
      ..addListener(() {
        if (phoneController.text.toLowerCase().trim() !=
            currentUser().phone?.toLowerCase().trim()) {
          widget.changeNotifier.value = true;
          widget.updateContainer['phone'] = phoneController.text.trim();
        } else if (noChanges()) {
          widget.changeNotifier.value = false;
          widget.updateContainer.clear();
        } else {
          widget.updateContainer.remove('phone');
        }
      });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(currentUserProvider, (previous, next) {
      debugPrint('user updated');
      if (noChanges()) {
        widget.changeNotifier.value = false;
        widget.updateContainer.clear();
      }
    });
    return ListView(
      children: [
        VerticalLabelField(
          label: 'Full Name',
          focusNode: widget.nameFocusNode,
          controller: nameController,
          hintText: 'Enter your full name',
        ),
        const Gap(15),
        VerticalLabelField(
          label: 'Email',
          controller: emailController,
          hintText: 'Enter your email',
        ),
        const Gap(15),
        VerticalLabelField(
          label: 'Phone',
          controller: phoneController,
          hintText: 'Enter your phone number',
        ),
      ],
    );
  }
}
