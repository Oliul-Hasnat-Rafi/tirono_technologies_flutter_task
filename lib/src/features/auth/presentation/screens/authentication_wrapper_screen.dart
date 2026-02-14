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

/// AuthenticationWrapperScreen
class AuthenticationWrapperScreen extends ConsumerWidget {
  /// AuthenticationWrapperScreen Constructor
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
                                        : 'Please provide your email and password to sign up.',
                              ),
                            ),
                            const CustomSize(),
                            //! Name
                            state.isLogin == false
                                ? _Heading('Name')
                                : const SizedBox.shrink(),
                            state.isLogin == false
                                ? OnTextInputWidgetUserField(
                                    key: GlobalKey(),
                                    textEditingController: controller.nameC,
                                    showDetailError: true,
                                    keyboardType: TextInputType.name,
                                    hintText: 'Enter your name',
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

                            //! Email
                            _Heading('Email'),
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
//! Phone
                            state.isLogin == false
                                ? _Heading('Phone')
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
                            //! Password
                            CustomAnimatedSize(
                              alignment: Alignment.topCenter,
                              widthFactor: 1,
                              child: state.isLogin == null
                                  ? null
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        _Heading('Password'),
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

                            //! Login Button
                            const _Login(),
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

class _Login extends ConsumerWidget {
  const _Login();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(authenticationScreenProvider.notifier);
    final state = ref.watch(authenticationScreenProvider);

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
            ? 'Reset'
            : state.isLogin!
                ? 'Login'
                : 'Sign Up',
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
                    child: Text('Login'),
                  )
                : !state.isLogin!
                    ? null
                    : CustomTextButton(
                        onDone: (_) => controller.setIsLogin(null),
                        child: Text('Forgot Password'),
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
          // enable: false,
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
