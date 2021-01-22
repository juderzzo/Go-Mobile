import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/constants/custom_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/onboarding/onboarding_view_model.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:go/ui/widgets/buttons/custom_text_button.dart';
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
          height: 150,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.low,
        ),
      ),
    );
  }

  PageViewModel initialPage() {
    PageDecoration pageDecoration = PageDecoration(
      contentPadding: EdgeInsets.all(0),
      titleTextStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
      bodyTextStyle: TextStyle(fontSize: 16.0),
      titlePadding: EdgeInsets.only(top: 0.0, bottom: 8.0, left: 16, right: 16),
      imageFlex: 3,
      bodyFlex: 3,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: appBackgroundColor(),
    );

    return PageViewModel(
      decoration: pageDecoration,
      image: onboardingImage('go_logo_transparent'),
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
    );
  }

  PageViewModel profilePicUsernamePage(OnboardingViewModel model) {
    PageDecoration pageDecoration = PageDecoration(
      contentPadding: EdgeInsets.all(0),
      titlePadding: EdgeInsets.only(top: 16.0, bottom: 8.0, left: 16, right: 16),
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imageFlex: 1,
      bodyFlex: 3,
      pageColor: appBackgroundColor(),
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
          verticalSpaceMedium,
          SingleLineTextField(controller: model.usernameTextController, hintText: "username", textLimit: 50, isPassword: false),
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
      titlePadding: EdgeInsets.only(top: 16.0, bottom: 8.0, left: 16, right: 16),
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imageFlex: 2,
      bodyFlex: 3,
      pageColor: appBackgroundColor(),
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
          MultiLineTextField(controller: model.bioTextController, hintText: "What Inspires You?", maxLines: 10),
          verticalSpaceMedium,
          CustomButton(
            onPressed: () async {
              bool complete = await model.completeBio();
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

  PageViewModel interestsPage(OnboardingViewModel model) {
    PageDecoration pageDecoration = PageDecoration(
      contentPadding: EdgeInsets.all(0),
      titlePadding: EdgeInsets.only(top: 16.0, bottom: 8.0, left: 16, right: 16),
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imageFlex: 1,
      bodyFlex: 3,
      pageColor: appBackgroundColor(),
    );
    return PageViewModel(
      decoration: pageDecoration,
      image: Container(),
      titleWidget: Column(
        children: [
          CustomText(
            text: "What Are You Interested In?",
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
          verticalSpaceMedium,
          SingleLineTextField(controller: model.usernameTextController, hintText: "username", textLimit: 50, isPassword: false),
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

  PageViewModel notificationPermissionPage(OnboardingViewModel model) {
    PageDecoration pageDecoration = PageDecoration(
      contentPadding: EdgeInsets.all(0),
      titlePadding: EdgeInsets.only(top: 16.0, bottom: 8.0, left: 16, right: 16),
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imageFlex: 2,
      bodyFlex: 3,
      pageColor: appBackgroundColor(),
    );
    return PageViewModel(
      decoration: pageDecoration,
      image: onboardingImage('coding'),
      titleWidget: Column(
        children: [
          CustomText(
            text: "The Power to Change is in Your Hands!",
            textAlign: TextAlign.center,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: appFontColor(),
          ),
        ],
      ),
      bodyWidget: Column(
        children: [
          CustomText(
            text: "Enable Notifications to be Alerted About the Latest News & Causes",
            textAlign: TextAlign.center,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: appFontColor(),
          ),
          verticalSpaceMedium,
          CustomButton(
            onPressed: model.notificationsEnabled ? () => introKey.currentState.next() : () => model.enableNotifications(),
            text: model.notificationsEnabled ? "Continue" : "Enable Notifications",
            textSize: 16,
            textColor: appFontColor(),
            height: 40,
            width: 300,
            backgroundColor: appButtonColor(),
            elevation: 2,
            isBusy: model.isBusy,
          ),
          verticalSpaceMedium,
          model.notificationsEnabled
              ? Container()
              : CustomTextButton(
                  onTap: () => introKey.currentState.next(),
                  text: "Skip",
                  textAlign: TextAlign.center,
                  color: appFontColorAlt(),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
        ],
      ),
    );
  }

  PageViewModel finalPage(OnboardingViewModel model) {
    PageDecoration pageDecoration = PageDecoration(
      contentPadding: EdgeInsets.all(0),
      titlePadding: EdgeInsets.only(top: 16.0, bottom: 8.0, left: 16, right: 16),
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imageFlex: 3,
      bodyFlex: 3,
      pageColor: appBackgroundColor(),
    );
    return PageViewModel(
      decoration: pageDecoration,
      image: onboardingImage('coding'),
      titleWidget: Column(
        children: [
          CustomText(
            text: "You're All Set to Go",
            textAlign: TextAlign.center,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: appFontColor(),
          ),
        ],
      ),
      bodyWidget: Column(
        children: [
          CustomText(
            text: "(Your slogan here..?)",
            textAlign: TextAlign.center,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: appFontColor(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OnboardingViewModel>.reactive(
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => OnboardingViewModel(),
      builder: (context, model, child) => Scaffold(
          body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: IntroductionScreen(
          freeze: true,
          key: introKey,
          pages: [
            initialPage(),
            profilePicUsernamePage(model),
            bioPage(model),
            // interestsPage(model),
            notificationPermissionPage(model),
            finalPage(model),
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
      )),
    );
  }
}
