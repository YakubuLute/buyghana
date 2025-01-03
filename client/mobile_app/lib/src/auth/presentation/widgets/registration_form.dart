import 'package:country_picker/country_picker.dart';
import 'package:ecomly/core/common/widgets/input_field.dart';
import 'package:ecomly/core/common/widgets/rounded_button.dart';
import 'package:ecomly/core/common/widgets/vertical_label_field.dart';
import 'package:ecomly/core/extensions/widget_extensions.dart';
import 'package:ecomly/core/utils/core_utils.dart';
import 'package:ecomly/src/auth/presentation/app/riverpod/auth_provider.dart';
import 'package:ecomly/src/auth/presentation/utils/auth_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class RegistrationForm extends ConsumerStatefulWidget {
  const RegistrationForm({super.key});

  @override
  ConsumerState<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends ConsumerState<RegistrationForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final countryController = TextEditingController();
  final obscurePasswordNotifier = ValueNotifier(true);
  final obscureConfirmPasswordNotifier = ValueNotifier(true);

  final countryNotifier = ValueNotifier<Country?>(null);

  void pickCountry() {
    AuthUtils.pickCountry(context, onSelect: (country) {
      if (country == countryNotifier.value) return;
      countryNotifier.value = country;
    });
  }

  @override
  void initState() {
    super.initState();
    countryNotifier.addListener(() {
      if (countryNotifier.value == null) {
        phoneController.clear();
        countryController.clear();
      } else {
        countryController.text = countryNotifier.value!.phoneCode;
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    obscurePasswordNotifier.dispose();
    obscureConfirmPasswordNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider());

    ref.listen(authProvider(), (previous, next) {
      if (next is AuthError) {
        CoreUtils.showSnackBar(context, message: next.message);
      } else if (next is Registered) {
        CoreUtils.postFrameCall(() => context.go('/'));
      }
    });

    return Form(
      key: formKey,
      child: Column(
        children: [
          VerticalLabelField(
            label: 'Full Name',
            hintText: 'Enter your name',
            controller: fullNameController,
            keyboardType: TextInputType.name,
          ),
          const Gap(20),
          VerticalLabelField(
            label: 'Email',
            hintText: 'Enter your email',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const Gap(20),
          ValueListenableBuilder(
              valueListenable: countryNotifier,
              builder: (_, country, __) {
                return VerticalLabelField(
                  label: 'Phone',
                  enabled: country != null,
                  hintText: 'Enter your phone number',
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  validator: (value) {
                    if (!isPhoneValid(
                      value!,
                      defaultCountryCode: country?.countryCode,
                    )) {
                      return 'Invalid Phone number';
                    }
                    return null;
                  },
                  inputFormatters: [
                    PhoneInputFormatter(
                        defaultCountryCode: country?.countryCode),
                  ],
                  mainFieldFlex: 3,
                  prefix: InputField(
                      controller: countryController,
                      readOnly: true,
                      contentPadding: const EdgeInsets.only(left: 10),
                      suffixIcon: GestureDetector(
                        onTap: pickCountry,
                        child: const Icon(Icons.arrow_drop_down),
                      ),
                      validator: (value) {
                        if (!isPhoneValid(
                          phoneController.text,
                          defaultCountryCode: country?.countryCode,
                        )) {
                          return '';
                        }
                        return null;
                      }),
                );
              }),
          const Gap(20),
          ValueListenableBuilder(
            valueListenable: obscurePasswordNotifier,
            builder: (_, value, __) {
              return VerticalLabelField(
                label: 'Password',
                hintText: 'Enter your password',
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                suffixIcon: GestureDetector(
                  onTap: () {
                    obscurePasswordNotifier.value =
                        !obscurePasswordNotifier.value;
                  },
                  child: Icon(
                    value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
                obscureText: value,
              );
            },
          ),
          const Gap(20),
          ValueListenableBuilder(
            valueListenable: obscureConfirmPasswordNotifier,
            builder: (_, value, __) {
              return VerticalLabelField(
                label: 'Confirm Password',
                hintText: 'Re-enter your password',
                controller: confirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
                suffixIcon: GestureDetector(
                  onTap: () {
                    obscureConfirmPasswordNotifier.value =
                        !obscureConfirmPasswordNotifier.value;
                  },
                  child: Icon(
                    value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
                obscureText: value,
                validator: (value) {
                  if (value! != passwordController.text.trim()) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              );
            },
          ),
          const Gap(40),
          RoundedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                FocusManager.instance.primaryFocus?.unfocus();
                final phoneNumber = phoneController.text.trim();
                final country = countryNotifier.value!;
                final formattedNumber =
                    '+${country.phoneCode}${toNumericString(phoneNumber)}';
                final email = emailController.text.trim();
                final password = passwordController.text.trim();
                final fullName = fullNameController.text.trim();
                await ref.read(authProvider().notifier).register(
                      name: fullName,
                      email: email,
                      password: password,
                      phone: formattedNumber,
                    );
              }
            },
            text: 'Sign Up',
          ).loading(auth is AuthLoading),
        ],
      ),
    );
  }
}
