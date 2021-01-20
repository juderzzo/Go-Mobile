import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/constants/custom_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/onboarding/onboarding_view_model.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/common/text_field/multi_line_text_field.dart';
import 'package:go/ui/widgets/common/text_field/single_line_text_field.dart';
import 'package:go/ui/widgets/user/user_profile_pic.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:stacked/stacked.dart';

class OnboardingView extends StatelessWidget {
  final introKey = GlobalKey<IntroductionScreenState>();
  TextEditingController bioController = new TextEditingController();
  TextEditingController interestController = new TextEditingController();
  TextEditingController inspirationsController = new TextEditingController();
  TextEditingController websiteController = new TextEditingController();

  Widget onboardingImage(String assetName) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Image.asset(
          'assets/images/$assetName.png',
          height: 200,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
        ),
      ),
    );
  }

  PageViewModel initialPage() {
    PageDecoration pageDecoration = PageDecoration(
      contentPadding: EdgeInsets.all(0),
      titleTextStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
      bodyTextStyle: TextStyle(fontSize: 16.0),
      titlePadding:
          EdgeInsets.only(top: 16.0, bottom: 8.0, left: 16, right: 16),
      imageFlex: 3,
      bodyFlex: 3,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
    );

    return PageViewModel(
      titleWidget: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Welcome to Go!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
      bodyWidget: Column(
        children: [
          CustomText(
            text: "Let's answer a few questions to help get you going!",
            textAlign: TextAlign.center,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: appFontColor(),
          ),
          verticalSpaceMedium,
          CustomButton(
            onPressed: () => introKey.currentState.next(),
            text: "Next",
            textSize: 16,
            textColor: appFontColor(),
            height: 40,
            width: 300,
            backgroundColor: appButtonColor(),
            elevation: 2,
            isBusy: false,
          ),
        ],
      ),
      image: onboardingImage('go_logo'),
      decoration: pageDecoration,
    );
  }

  PageViewModel profilePicUsernamePage(OnboardingViewModel model) {
    PageDecoration pageDecoration = PageDecoration(
      contentPadding: EdgeInsets.all(0),
      titlePadding:
          EdgeInsets.only(top: 16.0, bottom: 8.0, left: 16, right: 16),
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imageFlex: 1,
      bodyFlex: 3,
      pageColor: Colors.white,
    );
    return PageViewModel(
      decoration: pageDecoration,
      image: Container(),
      titleWidget: Column(
        children: [
          CustomText(
            text: "Choose a Username and Profile Pic",
            textAlign: TextAlign.center,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: appFontColor(),
          ),
          verticalSpaceMedium,
          GestureDetector(
            onTap: () => model.selectImage(),
            child: model.imgFile == null
                ? UserProfilePic(
                    userPicUrl: model.profilePlaceholderImgURL,
                    size: 100,
                    isBusy: false,
                  )
                : UserProfilePicFromFile(file: model.imgFile, size: 100),
          ),
        ],
      ),
      bodyWidget: Column(
        children: [
          SingleLineTextField(
              controller: model.usernameTextController,
              hintText: "username",
              textLimit: 50,
              isPassword: false),
          verticalSpaceMedium,
          CustomButton(
            onPressed: () async {
              bool complete = await model.completeProfilePicUsernamePage();
              if (complete) {
                introKey.currentState.next();
              }
            },
            text: "Next",
            textSize: 16,
            textColor: appFontColor(),
            height: 40,
            width: 300,
            backgroundColor: appButtonColor(),
            elevation: 2,
            isBusy: model.isBusy,
          ),
        ],
      ),
    );
  }

  PageViewModel bioPage(OnboardingViewModel model) {
    PageDecoration pageDecoration = PageDecoration(
      contentPadding: EdgeInsets.all(0),
      titlePadding:
          EdgeInsets.only(top: 16.0, bottom: 8.0, left: 16, right: 16),
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imageFlex: 2,
      bodyFlex: 3,
      pageColor: Colors.white,
    );
    return PageViewModel(
      decoration: pageDecoration,
      image: onboardingImage('bio'),
      titleWidget: CustomText(
        text: "Add Bio",
        textAlign: TextAlign.center,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: appFontColor(),
      ),
      bodyWidget: Column(
        children: [
          CustomText(
            text: "Tell Us a Little Bit More About Yourself",
            textAlign: TextAlign.center,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: appFontColor(),
          ),
          verticalSpaceMedium,
          MultiLineTextField(
              controller: model.bioTextController,
              hintText: "What Inspires You?",
              maxLines: 10),
        ],
      ),
    );
  }

  PageViewModel interestsPage(OnboardingViewModel model) {
    PageDecoration pageDecoration = PageDecoration(
      contentPadding: EdgeInsets.all(0),
      titlePadding:
          EdgeInsets.only(top: 16.0, bottom: 8.0, left: 16, right: 16),
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imageFlex: 2,
      bodyFlex: 3,
      pageColor: Colors.white,
    );

    return PageViewModel(
      decoration: pageDecoration,
      
    );
  }

  // PageViewModel associatedEmailPage(PageDecoration pageDecoration) {
  //   return PageViewModel(
  //     titleWidget: Container(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: [
  //           Text(
  //             "What's Your Email Address?",
  //             textAlign: TextAlign.center,
  //             style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
  //           )
  //         ],
  //       ),
  //     ),
  //     bodyWidget: Text(
  //       "Just In Case You Lose Access to Your Account",
  //       textAlign: TextAlign.center,
  //       style: TextStyle(fontSize: 18.0, height: 1.5),
  //     ),
  //     footer: Column(
  //       children: [
  //         Form(
  //           key: formKey,
  //           child: Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 16),
  //             child: TextFieldContainer(
  //               height: 50,
  //               child: TextFormField(
  //                 controller: textEditingController,
  //                 keyboardType: TextInputType.emailAddress,
  //                 cursorColor: Colors.black,
  //                 validator: (val) => val.isEmpty ? 'Field Cannot be Empty' : null,
  //                 maxLines: null,
  //                 onSaved: (val) {
  //                   emailAddress = val.trim();
  //                   setState(() {});
  //                 },
  //                 decoration: InputDecoration(
  //                   hintText: "Email Address",
  //                   border: InputBorder.none,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //         SizedBox(height: 16.0),
  //         CustomColorButton(
  //           text: "Set Email Address",
  //           textColor: Colors.black,
  //           backgroundColor: Colors.white,
  //           width: 300.0,
  //           height: 45.0,
  //           onPressed: () => validateAndSubmitEmailAddress(),
  //         ),
  //       ],
  //     ),
  //     image: onboardingImage('phone_email'),
  //     decoration: pageDecoration,
  //   );
  // }

  //

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OnboardingViewModel>.reactive(
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => OnboardingViewModel(),
      builder: (context, model, child) => Scaffold(
        body: IntroductionScreen(
          freeze: true,
          key: introKey,
          pages: [
            initialPage(),
            profilePicUsernamePage(model),
            bioPage(model),
          ],
          onDone: () {
            if (!model.isBusy) {
              model.completeOnboarding();
            }
          },
          //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
          showSkipButton: false,
          showNextButton: false,
          skipFlex: 0,
          nextFlex: 0,
          skip: const Text('Skip'),
          next: const Icon(Icons.arrow_forward),
          done: model.isBusy
              ? CustomCircleProgressIndicator(
                  size: 10,
                  color: appActiveColor(),
                )
              : CustomText(
                  text: "Done",
                  textAlign: TextAlign.center,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: appFontColor(),
                ),
          dotsDecorator: const DotsDecorator(
            size: Size(10.0, 10.0),
            color: Color(0xFFBDBDBD),
            activeColor: CustomColors.goGreen,
            activeSize: Size(22.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
        ),
      ),
    );
  }
}
