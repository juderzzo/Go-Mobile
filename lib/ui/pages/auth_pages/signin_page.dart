import 'package:flutter/material.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/widgets/busy_button.dart';
import 'package:go/ui/widgets/input_field.dart';
import 'package:go/ui/widgets/text_link.dart';
import 'package:go/viewmodels/signup_page_model.dart';
import 'package:provider_architecture/provider_architecture.dart';

class SignInPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SignUpPageModel>.withConsumer(
      viewModel: SignUpPageModel(),
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
                    padding: EdgeInsets.symmetric(horizontal: 50),
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
                          onPressed: () {
                            // TODO: Perform firebase login here
                          },
                        ),
                        verticalSpaceMedium,
                        TextLink(
                          'Create an Account if you\'re new.',
                          onPressed: () {
                            // TODO: Handle navigation
                          },
                        ),
                      ],
                    ),
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
