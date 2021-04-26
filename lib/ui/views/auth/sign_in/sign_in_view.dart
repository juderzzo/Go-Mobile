import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/constants/custom_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/auth/sign_in/sign_in_view_model.dart';
import 'package:go/ui/widgets/auth_buttons/apple_auth_button.dart';
import 'package:go/ui/widgets/auth_buttons/fb_auth_button.dart';
import 'package:go/ui/widgets/auth_buttons/google_auth_button.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:go/ui/widgets/buttons/custom_text_button.dart';
import 'package:go/ui/widgets/input_field.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class SignInView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignInViewModel>.reactive(
      viewModelBuilder: () => SignInViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 120,
                            child: Image.asset(
                              'assets/images/go_logo_slogan.png',
                              filterQuality: FilterQuality.medium,
                            ),
                          ),
                          verticalSpaceLarge,
                          _EmailField(),
                          verticalSpaceSmall,
                          _PasswordField(),
                          verticalSpaceMedium,
                          CustomButton(
                            text: "Login",
                            isBusy: model.isBusy,
                            height: 40,
                            onPressed: () => model.signInWithEmail(),
                            backgroundColor: CustomColors.balticSea,
                            textColor: Colors.white,
                            elevation: 0,
                          ),
                          verticalSpaceMedium,
                          Text(
                            'or sign in with',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          verticalSpaceSmall,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FacebookAuthButton(
                                action: () => model.signInWithFacebook(),
                              ),
                              Platform.isIOS
                                  ? AppleAuthButton(
                                      action: () => model.signInWithApple(),
                                    )
                                  : Container(),
                              GoogleAuthButton(
                                action: () => model.signInWithGoogle(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  verticalSpaceLarge,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: _OrSignUp(),
                  ),
                  verticalSpaceMedium,
                  CustomTextButton(
                    onTap: () => model.navigateToForgot(),
                    text: "Forgot Password?",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: appTextButtonColor(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailField extends HookViewModelWidget<SignInViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, SignInViewModel model) {
    TextEditingController _emailController = useTextEditingController();

    return InputField(
      controller: _emailController,
      placeholder: "Email",
      onChanged: (val) => model.updateEmail(val),
    );
  }
}

class _PasswordField extends HookViewModelWidget<SignInViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, SignInViewModel model) {
    TextEditingController _passwordController = useTextEditingController();

    return InputField(
      controller: _passwordController,
      placeholder: "Password",
      onChanged: (val) => model.updatePassword(val),
      password: true,
    );
  }
}

class _OrSignUp extends HookViewModelWidget<SignInViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, SignInViewModel model) {
    return Container(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: "Don't Have an Account? ",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: 'Register Here',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
              recognizer: TapGestureRecognizer()..onTap = () => model.replaceWithSignUpPage(),
            ),
          ],
        ),
      ),
    );
  }
}
