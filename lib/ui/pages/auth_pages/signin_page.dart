import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/auth_buttons/apple_auth_button.dart';
import 'package:go/ui/widgets/auth_buttons/fb_auth_button.dart';
import 'package:go/ui/widgets/auth_buttons/google_auth_button.dart';
import 'package:go/ui/widgets/busy_button.dart';
import 'package:go/ui/widgets/input_field.dart';
import 'package:go/viewmodels/signin_page_model.dart';
import 'package:provider_architecture/provider_architecture.dart';

class SignInPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Widget orTextLabel() {
    return Text(
      'or sign in with',
      style: TextStyle(
        color: Colors.black54,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget signUpForAccountText(BuildContext context, SignInPageModel model) {
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

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SignInPageModel>.withConsumer(
      viewModelBuilder: () => SignInPageModel(),
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 120,
                          child: Image.asset('assets/images/go_logo.png'),
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
                        verticalSpaceMedium,
                        BusyButton(
                          title: 'Login',
                          busy: model.busy,
                          onPressed: () {
                            model.signInWithEmail(
                              email: emailController.text,
                              password: passwordController.text,
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
                              action: null,
                            ),
                            Platform.isIOS
                                ? AppleAuthButton(
                                    action: null,
                                  )
                                : Container(),
                            GoogleAuthButton(
                              action: null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  verticalSpaceLarge,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: signUpForAccountText(context, model),
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
