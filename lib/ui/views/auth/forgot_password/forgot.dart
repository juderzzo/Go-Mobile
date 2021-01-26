import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/auth/sign_in/sign_in_view_model.dart';
import 'package:go/ui/widgets/auth_buttons/apple_auth_button.dart';
import 'package:go/ui/widgets/auth_buttons/fb_auth_button.dart';
import 'package:go/ui/widgets/auth_buttons/google_auth_button.dart';
import 'package:go/ui/widgets/busy_button.dart';
import 'package:go/ui/widgets/input_field.dart';
import 'package:stacked/stacked.dart';

import 'forgot_viewmodel.dart';

class ForgotView extends StatelessWidget {
  TextEditingController emailController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForgotViewModel>.reactive(
        viewModelBuilder: () => ForgotViewModel(),
        builder: (context, model, child) => Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  model.navigateBack();
                },
              ),
        ),
            body: GestureDetector(
                onTap: FocusScope.of(context).unfocus,
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Center(
                        child: ListView(shrinkWrap: true, children: [
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                
                                SizedBox(
                                  height: 120,
                                  child: Image.asset(
                                      'assets/images/go_logo_transparent.png'),
                                ),
                                verticalSpaceMedium,
                                Text("Enter your email to reset your password"),
                                verticalSpaceMedium,
                                InputField(
                                  placeholder: 'Email',
                                  controller: emailController,
                                ),

                                verticalSpaceLarge,

                                BusyButton(
                                  title: 'Reset Password',
                                  busy: model.isBusy,
                                    onPressed: () {
                                      model.resetPass(
                                        emailController.text,
                                      );
                                    },
                                  ),

                                
                                SizedBox(height: 100,),

                                
                              ]))
                    ]))))));
  }
}
