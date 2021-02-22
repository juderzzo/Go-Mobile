import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/auth/sign_up/sign_up_view_model.dart';
import 'package:go/ui/widgets/auth_buttons/apple_auth_button.dart';
import 'package:go/ui/widgets/auth_buttons/fb_auth_button.dart';
import 'package:go/ui/widgets/auth_buttons/google_auth_button.dart';
import 'package:go/ui/widgets/busy_button.dart';
import 'package:go/ui/widgets/input_field.dart';
import 'package:go/utils/url_handler.dart';
import 'package:stacked/stacked.dart';

class SignUpView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Widget orTextLabel() {
    return Text(
      'or sign up with',
      style: TextStyle(
        color: Colors.black54,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget signInWithAccountText(BuildContext context, SignUpViewModel model) {
    return Container(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: "Already Have an Account? ",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: 'Sign In Here',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
              recognizer: TapGestureRecognizer()..onTap = () => model.replaceWithSignInPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceAgreement(BuildContext context) {
    return Container(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'By Registering, You agree to the ',
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(
              text: 'Terms and Conditions ',
              style: TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () =>
                    UrlHandler().launchInWebViewOrVC(context, "https://app.termly.io/document/terms-of-use-for-ios-app/78fa496a-010a-4d4f-b33c-c835e23059bb"),
            ),
            TextSpan(
              text: 'and ',
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(
              text: 'Privacy Policy. ',
              style: TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () =>
                    UrlHandler().launchInWebViewOrVC(context, "https://app.termly.io/document/terms-of-use-for-ios-app/78fa496a-010a-4d4f-b33c-c835e23059bb"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
      viewModelBuilder: () => SignUpViewModel(),
      builder: (context, model, child) => Scaffold(
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 120,
                          child: Image.asset(
                            'assets/images/go_logo.png',
                            filterQuality: FilterQuality.medium,
                          ),
                        ),
                        verticalSpaceLarge,
                        InputField(
                          placeholder: 'Email',
                          controller: emailController,
                        ),
                        verticalSpaceSmall,
                        InputField(
                          placeholder: 'Password',
                          password: true,
                          controller: passwordController,
                        ),
                        verticalSpaceSmall,
                        InputField(
                          placeholder: 'Confirm Password',
                          password: true,
                          controller: confirmPasswordController,
                        ),
                        verticalSpaceMedium,
                        BusyButton(
                          title: 'Register',
                          busy: model.isBusy,
                          onPressed: () {
                            model.signUpWithEmail(
                              email: emailController.text,
                              password: passwordController.text,
                              confirmPassword: confirmPasswordController.text,
                            );
                          },
                        ),
                        verticalSpaceMedium,
                        orTextLabel(),
                        verticalSpaceSmall,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FacebookAuthButton(
                              action: () => model.loginWithFacebook(),
                            ),
                            Platform.isIOS
                                ? AppleAuthButton(
                                    action: () => model.loginWithApple(),
                                  )
                                : Container(),
                            GoogleAuthButton(
                              action: () => model.loginWithGoogle(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  verticalSpaceMedium,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: signInWithAccountText(context, model),
                  ),
                  verticalSpaceLarge,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: serviceAgreement(context),
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
