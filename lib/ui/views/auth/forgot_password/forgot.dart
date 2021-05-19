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
  TextEditingController emailController = TextEditingController();
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForgotViewModel>.reactive(
        viewModelBuilder: () => ForgotViewModel(),
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          ),
            backgroundColor: Colors.white,
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
                                verticalSpaceLarge,
                                Text("Please enter the email for your account"),
                                verticalSpaceSmall,
                                InputField(
                                  placeholder: 'Email',
                                  controller: emailController,
                                ),
                                verticalSpaceSmall,
                                BusyButton(
                                  title: 'Send',
                                  busy: model.isBusy,
                                  onPressed: () {
                                    model.sendResetEmail(
                                      emailController.text,
                                    );
                                   
                                  },
                                ),

                                SizedBox(
                                  height: 50,
                                )
                              ]))
                    ]))))));
  }
}
