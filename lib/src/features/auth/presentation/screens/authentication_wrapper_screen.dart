import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_process_button_widget/on_process_button_widget.dart';
import 'package:on_text_input_widget/on_text_input_widget.dart';

import '../../../../../components.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/utils/dev_functions/dev_scaffold.dart';
import '../../../../core/utils/functions/form_validation.dart';
import '../../../../core/utils/values/app_assets.dart';
import '../../../../widgets/animated_size.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/divided_bar.dart';
import '../../../../widgets/size.dart';
import '../../../../widgets/svg.dart';
import '../../../../widgets/text.dart';
import '../../../../widgets/toc_and_pp.dart';
import '../providers/authentication_provider.dart';

class AuthenticationWrapperScreen extends ConsumerWidget {
  const AuthenticationWrapperScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(authenticationScreenProvider.notifier);
    final state = ref.watch(authenticationScreenProvider);

    return DevScaffold(
      floatingActionButton:
          DevAutoFillButton(onPressed: controller.devFunctions),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(defaultPadding),
                  constraints: const BoxConstraints(
                    maxWidth: defaultMaxBoxWidth,
                  ),
                  child: CustomAnimatedSize(
                    alignment: Alignment.topCenter,
                    child: Form(
                      key: controller.loginFormKey,
                      child: Material(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            CustomAnimatedSize(
                              alignment: state.isLogin ?? true
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: CustomTextDisplay.S(
                                  isBold: true,
                                  text: state.isLogin == null
                                      ? 'Reset Password'
                                      : state.isLogin!
                                          ? 'Login'
                                          : 'Sign Up',
                                ),
                              ),
                            ),
                            const CustomSize(fraction: 4),

                            CustomAnimatedSize(
                              widthFactor: 1,
                              alignment: Alignment.topCenter,
                              child: CustomTextTitle.S(
                                text: state.isLogin == null
                                    ? 'Please provide your email to reset your password.'
                                    : state.isLogin!
                                        ? 'Welcome back! Please login to your account.'
                                        : 'Create your account to get started.',
                              ),
                            ),
                            const CustomSize(),

                            CustomAnimatedSize(
                              widthFactor: 1,
                              alignment: Alignment.topCenter,
                              child: state.isLogin == null
                                  ? null
                                  : const _RoleSelector(),
                            ),
                            const CustomSize(),

                            state.isLogin == false
                                ? const _Heading('Name')
                                : const SizedBox.shrink(),
                            state.isLogin == false
                                ? OnTextInputWidgetUserField(
                                    key: GlobalKey(),
                                    textEditingController: controller.nameC,
                                    showDetailError: true,
                                    keyboardType: TextInputType.name,
                                    hintText: 'Enter your full name',
                                    svg: AppAssets.message,
                                    autofillHints: const <String>[
                                      AutofillHints.name,
                                    ],
                                    validator: (String? value) =>
                                        nameValidation(
                                      value,
                                      showDetails: state.isLogin == false,
                                    ),
                                  )
                                : const SizedBox.shrink(),

                            // ─── Email Field ───
                            const _Heading('Email'),
                            OnTextInputWidgetUserField(
                              key: GlobalKey(),
                              textEditingController: controller.emailC,
                              showDetailError: true,
                              keyboardType: TextInputType.emailAddress,
                              hintText: 'Enter your email',
                              svg: AppAssets.message,
                              autofillHints: const <String>[
                                AutofillHints.email,
                              ],
                              validator: (String? value) => emailValidation(
                                value,
                                showDetails: state.isLogin == false,
                              ),
                            ),

                            // ─── Phone Field (Sign Up only) ───
                            state.isLogin == false
                                ? const _Heading('Phone')
                                : const SizedBox.shrink(),
                            state.isLogin == false
                                ? OnTextInputWidgetUserField(
                                    key: GlobalKey(),
                                    textEditingController: controller.phoneC,
                                    showDetailError: true,
                                    keyboardType: TextInputType.phone,
                                    hintText: 'Enter your phone number',
                                    svg: AppAssets.message,
                                    autofillHints: const <String>[
                                      AutofillHints.telephoneNumber,
                                    ],
                                    validator: (String? value) =>
                                        phoneNumberValidation(
                                      value,
                                      showDetails: state.isLogin == false,
                                    ),
                                  )
                                : const SizedBox.shrink(),

                            const _DoctorFields(),

                            CustomAnimatedSize(
                              alignment: Alignment.topCenter,
                              widthFactor: 1,
                              child: state.isLogin == null
                                  ? null
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        const _Heading('Password'),
                                        OnTextInputWidgetUserField(
                                          key: GlobalKey(),
                                          textEditingController:
                                              controller.passwordC,
                                          obscureText: true,
                                          showDetailError: true,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          hintText: 'Enter your password',
                                          svg: AppAssets.lock,
                                          validator: (String? value) =>
                                              !kDebugMode
                                                  ? passwordValidation(
                                                      value,
                                                      showDetails:
                                                          state.isLogin ==
                                                              false,
                                                    )
                                                  : null,
                                        ),
                                      ],
                                    ),
                            ),

                            const CustomSize(),

                            // ─── Terms & Conditions ───
                            Align(
                              child: CustomAnimatedSize(
                                widthFactor: 1,
                                alignment: Alignment.bottomCenter,
                                child: state.isLogin == null
                                    ? null
                                    : CustomTOCAndPP(
                                        value: state.isExcepted,
                                        onChanged: (bool value) =>
                                            controller.setIsExcepted(value),
                                      ),
                              ),
                            ),

                            const CustomSize(),

                            // ─── Dummy Credentials ───
                            CustomAnimatedSize(
                              widthFactor: 1,
                              alignment: Alignment.topCenter,
                              child: state.isLogin == true
                                  ? const _CredentialsHint()
                                  : null,
                            ),

                            // ─── Submit Button ───
                            const _LoginButton(),
                            const CustomSize(fraction: 4),
                            const _GroupButton(),
                            const _OtherLoginWay(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleSelector extends ConsumerWidget {
  const _RoleSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authenticationScreenProvider);
    final controller = ref.watch(authenticationScreenProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: UserRole.values.map((role) {
          final isSelected = state.selectedRole == role;
          final isDoctor = role == UserRole.doctor;

          return Expanded(
            child: GestureDetector(
              onTap: () => controller.setUserRole(role),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOut,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                decoration: BoxDecoration(
                  color:
                      isSelected ? colorScheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isDoctor
                          ? Icons.medical_services_rounded
                          : Icons.person_rounded,
                      size: 20,
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isDoctor ? 'Doctor' : 'Patient',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DoctorFields extends ConsumerWidget {
  const _DoctorFields();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authenticationScreenProvider);
    final controller = ref.watch(authenticationScreenProvider.notifier);

    final showDoctorFields =
        state.isLogin == false && state.selectedRole == UserRole.doctor;

    return CustomAnimatedSize(
      widthFactor: 1,
      alignment: Alignment.topCenter,
      child: showDoctorFields
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Heading('Speciality'),
                OnTextInputWidgetUserField(
                  key: GlobalKey(),
                  textEditingController: controller.specialityC,
                  showDetailError: true,
                  keyboardType: TextInputType.text,
                  hintText: 'e.g. Cardiology, Dermatology',
                  svg: AppAssets.message,
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Speciality is required';
                    }
                    return null;
                  },
                ),
                const _Heading('License Number'),
                OnTextInputWidgetUserField(
                  key: GlobalKey(),
                  textEditingController: controller.licenseC,
                  showDetailError: true,
                  keyboardType: TextInputType.text,
                  hintText: 'Enter your medical license number',
                  svg: AppAssets.message,
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'License number is required';
                    }
                    return null;
                  },
                ),
              ],
            )
          : null,
    );
  }
}


class _CredentialsHint extends StatelessWidget {
  const _CredentialsHint();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.tertiaryContainer,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 16, color: colorScheme.tertiary),
              const SizedBox(width: 6),
              Text(
                'Demo Credentials',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.tertiary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _credRow(context, '🩺 Doctor', 'doctor@test.com', '12345678'),
          const SizedBox(height: 4),
          _credRow(context, '👤 Patient', 'patient@test.com', '12345678'),
        ],
      ),
    );
  }

  Widget _credRow(
      BuildContext context, String role, String email, String pass) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme.onSurface.withOpacity(0.7);

    return Text(
      '$role → $email / $pass',
      style: textTheme.bodySmall?.copyWith(
        color: color,
        fontFamily: 'monospace',
        fontSize: 11,
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
      child: CustomTextTitle.L(text: text),
    );
  }
}


class _LoginButton extends ConsumerWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(authenticationScreenProvider.notifier);
    final state = ref.watch(authenticationScreenProvider);

    final roleLabel =
        state.selectedRole == UserRole.doctor ? 'Doctor' : 'Patient';

    return OnProcessButtonWidget(
      expandedIcon: true,
      roundBorderWhenRunning: false,
      onDone: (success) => controller.requestSuccess(
        success,
        onNavigate: () {
          context.goToHome();
        },
      ),
      onTap: () async {
        FormState? formCurrentState = controller.loginFormKey.currentState;
        if (formCurrentState == null) return false;
        if (!formCurrentState.validate()) return false;

        return await controller.requestLoginSignup();
      },
      child: Text(
        state.isLogin == null
            ? 'Reset Password'
            : state.isLogin!
                ? 'Login as $roleLabel'
                : 'Sign Up as $roleLabel',
      ),
    );
  }
}


class _GroupButton extends ConsumerWidget {
  const _GroupButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(authenticationScreenProvider.notifier);
    final state = ref.watch(authenticationScreenProvider);

    return Padding(
      padding: EdgeInsets.only(top: defaultPadding / 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CustomAnimatedSize(
            alignment: Alignment.centerRight,
            child: state.isLogin == null
                ? CustomTextButton(
                    onDone: (_) => controller.setIsLogin(true),
                    child: const Text('Login'),
                  )
                : !state.isLogin!
                    ? null
                    : CustomTextButton(
                        onDone: (_) => controller.setIsLogin(null),
                        child: const Text('Forgot Password'),
                      ),
          ),
          Text(
            '/',
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          if (state.isLogin != null)
            CustomTextButton(
              onDone: (_) {
                controller.setIsLogin(!state.isLogin!);
                controller.resetLogin();
              },
              child: Text(
                state.isLogin! ? 'Sign Up' : 'Already have an account?',
              ),
            ),
        ],
      ),
    );
  }
}


class _OtherLoginWay extends StatelessWidget {
  const _OtherLoginWay();

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || !Platform.isAndroid) return const SizedBox();

    return const Column(
      children: <Widget>[
        CustomSize(fraction: 3 / 4),
        CustomDividedBar.or(),
        CustomSize(),
        _GoogleSignIn(),
      ],
    );
  }
}

class _GoogleSignIn extends ConsumerWidget {
  const _GoogleSignIn();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(authenticationScreenProvider.notifier);

    return Align(
      child: CustomAnimatedSize(
        child: OnProcessButtonWidget(
          onTap: () async => controller.googleSignIn(),
          onDone: (success) => controller.requestSuccess(
            success,
            onNavigate: () {
              context.goToHome();
            },
          ),
          borderRadius: BorderRadius.circular(10000),
          backgroundColor: Colors.transparent,
          expanded: false,
          iconColor: Theme.of(context).colorScheme.onSurface,
          child: CustomSVG(
            'assets/svg/icons/google_icon.svg',
            height: defaultPadding,
          ),
        ),
      ),
    );
  }
}