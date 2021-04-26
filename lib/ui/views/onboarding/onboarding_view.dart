import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
import 'package:go/ui/widgets/input_field.dart';
import 'package:go/ui/widgets/user/user_profile_pic.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

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
      contentMargin: EdgeInsets.all(0),
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
              "Welcome to Go",
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
            color: Colors.black,
          ),
          verticalSpaceMedium,
          CustomButton(
            onPressed: () => introKey.currentState!.next(),
            text: "Next",
            textSize: 16,
            textColor: Colors.black,
            height: 40,
            width: 300,
            backgroundColor: appButtonColor(),
            elevation: 2,
            isBusy: false,
          ),
          FlatButton(
              onPressed: OnboardingViewModel.signOut,
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ))
        ],
      ),
    );
  }

  PageViewModel profilePicUsernamePage(OnboardingViewModel model, context) {
    PageDecoration pageDecoration = PageDecoration(
      contentMargin: EdgeInsets.all(0),
      titlePadding: EdgeInsets.only(top: 0.0, bottom: 8.0, left: 16, right: 16),
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
            color: Colors.black,
          ),
          verticalSpaceMedium,
          GestureDetector(
            onTap: () => model.selectImage(context),
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
          SingleLineTextField(
            controller: model.usernameTextController,
            hintText: "Username",
            textLimit: 50,
            isPassword: false,
            onChanged: (String val) {},
            onSubmitted: (String val) {},
          ),
          verticalSpaceMedium,
          verticalSpaceMedium,
          verticalSpaceMedium,
          CustomButton(
            onPressed: () async {
              bool complete = await model.completeProfilePicUsernamePage();
              if (complete) {
                introKey.currentState!.next();
              }
            },
            text: "Next",
            textSize: 16,
            textColor: Colors.black,
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

  PageViewModel newPage(OnboardingViewModel model, BuildContext context) {
    PageDecoration pageDecoration = PageDecoration(
      contentMargin: EdgeInsets.all(8.0),
      titlePadding: EdgeInsets.only(top: 16.0, bottom: 0, left: 16, right: 16),
      descriptionPadding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 16.0),
      imageFlex: 5,
      bodyFlex: 2,
      pageColor: appBackgroundColor(),
    );
    return PageViewModel(
      decoration: pageDecoration,
      image: Center(
          child: Image.asset(
        'assets/images/flutter_01.png',
        width: MediaQuery.of(context).size.width * 29 / 40,
      )),
      titleWidget: Column(
        children: [
          CustomText(
            text: "Home page",
            textAlign: TextAlign.center,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ],
      ),
      bodyWidget: Column(
        children: [
          CustomText(
            text:
                """When you log in, youll be taken to your home page, a place for you to easily access all of the causes you follow. Causes are the backbone of Go!, and you'll learn more about them in a bit. You'll also notice four icons in your bottom bar. These will guide you through the app.""",
            textAlign: TextAlign.center,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  PageViewModel newPage2(OnboardingViewModel model, BuildContext context) {
    PageDecoration pageDecoration = PageDecoration(
      contentMargin: EdgeInsets.all(8.0),
      titlePadding: EdgeInsets.only(top: 16.0, bottom: 0, left: 16, right: 16),
      descriptionPadding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 16.0),
      imageFlex: 5,
      bodyFlex: 2,
      pageColor: appBackgroundColor(),
    );
    return PageViewModel(
      decoration: pageDecoration,
      image: Center(
          child: Image.asset(
        'assets/images/flutter_04.png',
        width: MediaQuery.of(context).size.width * 29 / 40,
      )),
      titleWidget: Column(
        children: [
          CustomText(
            text: "Explore page",
            textAlign: TextAlign.center,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ],
      ),
      bodyWidget: Column(
        children: [
          CustomText(
            text:
                """The explore page is where you can search through all the changemakers (our term for fellow users) and causes. Click on a cause block to see what that cause is about. 
                """,
            textAlign: TextAlign.center,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  PageViewModel newPage3(OnboardingViewModel model, BuildContext context) {
    PageDecoration pageDecoration = PageDecoration(
      contentMargin: EdgeInsets.all(8.0),
      titlePadding: EdgeInsets.only(top: 16.0, bottom: 0, left: 16, right: 16),
      descriptionPadding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 16.0),
      imageFlex: 5,
      bodyFlex: 2,
      pageColor: appBackgroundColor(),
    );
    return PageViewModel(
      decoration: pageDecoration,
      image: Center(
          child: Image.asset(
        'assets/images/flutter_07.png',
        width: MediaQuery.of(context).size.width * 29 / 40,
      )),
      titleWidget: Column(
        children: [
          CustomText(
            text: "Cause interface",
            textAlign: TextAlign.center,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ],
      ),
      bodyWidget: Column(
        children: [
          CustomText(
            text:
                """When you click on a cause, you will be taken to it's about page. This is where you can learn all about it, as well as see the founders. However, the causes core purpose lies within the other 2 tabs on this page.
                """,
            textAlign: TextAlign.center,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  PageViewModel newPage4(OnboardingViewModel model, BuildContext context) {
    PageDecoration pageDecoration = PageDecoration(
      contentMargin: EdgeInsets.all(8.0),
      titlePadding: EdgeInsets.only(top: 16.0, bottom: 0, left: 16, right: 16),
      descriptionPadding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 16.0),
      imageFlex: 5,
      bodyFlex: 2,
      pageColor: appBackgroundColor(),
    );
    return PageViewModel(
      decoration: pageDecoration,
      image: Center(
          child: Image.asset(
        'assets/images/flutter_08.png',
        width: MediaQuery.of(context).size.width * 29 / 40,
      )),
      titleWidget: Column(
        children: [
          CustomText(
            text: "Cause interface",
            textAlign: TextAlign.center,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ],
      ),
      bodyWidget: Column(
        children: [
          CustomText(
            text:
                """Each cause has an action list. This list is core to Go!, and is how we convert online engagement into real action. Cause admins publish a check for changemakers to complete and earn credits. Additionally, monitized causes allow users the option to watch an ad for Go! credits, raising money for the cause per view."
                """,
            textAlign: TextAlign.center,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  PageViewModel newPage5(OnboardingViewModel model, BuildContext context) {
    PageDecoration pageDecoration = PageDecoration(
      contentMargin: EdgeInsets.all(8.0),
      titlePadding: EdgeInsets.only(top: 16.0, bottom: 0, left: 16, right: 16),
      descriptionPadding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 16.0),
      imageFlex: 5,
      bodyFlex: 2,
      pageColor: appBackgroundColor(),
    );
    return PageViewModel(
      decoration: pageDecoration,
      image: Center(
          child: Image.asset(
        'assets/images/flutter_09.png',
        width: MediaQuery.of(context).size.width * 29 / 40,
      )),
      titleWidget: Column(
        children: [
          CustomText(
            text: "Cause interface",
            textAlign: TextAlign.center,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ],
      ),
      bodyWidget: Column(
        children: [
          CustomText(
            text: """Each cause also has an forum, where you can interact with friends and colleagues with like minded goals."
                """,
            textAlign: TextAlign.center,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  PageViewModel newPage6(OnboardingViewModel model, BuildContext context) {
    PageDecoration pageDecoration = PageDecoration(
      contentMargin: EdgeInsets.all(8.0),
      titlePadding: EdgeInsets.only(top: 16.0, bottom: 0, left: 16, right: 16),
      descriptionPadding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 16.0),
      imageFlex: 5,
      bodyFlex: 2,
      pageColor: appBackgroundColor(),
    );
    return PageViewModel(
      decoration: pageDecoration,
      image: Center(
          child: Image.asset(
        'assets/images/flutter_03.png',
        width: MediaQuery.of(context).size.width * 29 / 40,
      )),
      titleWidget: Column(
        children: [
          CustomText(
            text: "Profile",
            textAlign: TextAlign.center,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ],
      ),
      bodyWidget: Column(
        children: [
          CustomText(
            text:
                """Back to the original bottom bar, your profile is where you can edit your personal details, as well as see your posts and causes. Use the ... and settings icon to edit details about yourself and your apps layout.
                """,
            textAlign: TextAlign.center,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  PageViewModel newPage7(OnboardingViewModel model, BuildContext context) {
    PageDecoration pageDecoration = PageDecoration(
      contentMargin: EdgeInsets.all(8.0),
      titlePadding: EdgeInsets.only(top: 16.0, bottom: 0, left: 16, right: 16),
      descriptionPadding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 16.0),
      imageFlex: 5,
      bodyFlex: 2,
      pageColor: appBackgroundColor(),
    );
    return PageViewModel(
      decoration: pageDecoration,
      image: Center(
          child: Image.asset(
        'assets/images/flutter_11.png',
        width: MediaQuery.of(context).size.width * 29 / 40,
      )),
      titleWidget: Column(
        children: [
          CustomText(
            text: "Feed",
            textAlign: TextAlign.center,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ],
      ),
      bodyWidget: Column(
        children: [
          CustomText(
            text: """Lastly, your feed is a place where you can interact with posts from all the cause forums you follow. Be sure to check it daily!
                """,
            textAlign: TextAlign.center,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  PageViewModel bioPage(OnboardingViewModel model) {
    PageDecoration pageDecoration = PageDecoration(
      contentMargin: EdgeInsets.all(0),
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
        color: Colors.black,
      ),
      bodyWidget: Column(
        children: [
          CustomText(
            text: "Tell us a little bit more about yourself",
            textAlign: TextAlign.center,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          verticalSpaceMedium,
          MultiLineTextField(
            controller: model.bioTextController,
            hintText: "Who are you?",
            maxLines: 7,
            onSubmitted: (String val) {},
            onChanged: (String val) {},
          ),
          verticalSpaceMedium,
          CustomButton(
            onPressed: () async {
              bool complete = await model.completeBio();
              if (complete) {
                introKey.currentState!.next();
              }
            },
            text: "Next",
            textSize: 16,
            textColor: Colors.black,
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

  PageViewModel interestsPage(OnboardingViewModel model, context) {
    PageDecoration pageDecoration = PageDecoration(
      contentMargin: EdgeInsets.all(0),
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
            text: "What are you interested in?",
            textAlign: TextAlign.center,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          verticalSpaceMedium,
          GestureDetector(
            onTap: () => model.selectImage(context),
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
          SingleLineTextField(
            controller: model.usernameTextController,
            hintText: "username",
            textLimit: 50,
            isPassword: false,
            onChanged: (String val) {},
            onSubmitted: (String val) {},
          ),
          verticalSpaceMedium,
          CustomButton(
            onPressed: () async {
              bool complete = await model.completeProfilePicUsernamePage();
              if (complete) {
                introKey.currentState!.next();
              }
            },
            text: "Next",
            textSize: 16,
            textColor: Colors.black,
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
      contentMargin: EdgeInsets.all(0),
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
            text: "The Power for Change is in Your Hands!",
            textAlign: TextAlign.center,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ],
      ),
      bodyWidget: Column(
        children: [
          CustomText(
            text: "Enable notifications to be alerted about the latest news & causes",
            textAlign: TextAlign.center,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          verticalSpaceMedium,
          CustomButton(
            onPressed: model.notificationsEnabled ? () => introKey.currentState!.next() : () => model.enableNotifications(),
            text: model.notificationsEnabled ? "Continue" : "Enable Notifications",
            textSize: 16,
            textColor: Colors.black,
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
                  onTap: () => introKey.currentState!.next(),
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
      contentMargin: EdgeInsets.all(0),
      titlePadding: EdgeInsets.only(top: 16.0, bottom: 8.0, left: 16, right: 16),
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imageFlex: 3,
      bodyFlex: 3,
      pageColor: appBackgroundColor(),
    );
    return PageViewModel(
      decoration: pageDecoration,
      image: onboardingImage('logo'),
      titleWidget: Column(
        children: [
          CustomText(
            text: "You're all set to go",
            textAlign: TextAlign.center,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ],
      ),
      bodyWidget: Column(
        children: [
          CustomText(
            text: "Go! Be the change",
            textAlign: TextAlign.center,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
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
      builder: (context, model, child) => ChangeNotifierProvider.value(
        value: model,
        child: Scaffold(
            body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: IntroductionScreen(
            freeze: false,
            key: introKey,
            pages: !model.tutorial!
                ? [
                    _OnboardingPageBuilder(model: model).buildInitialPage(),
                    profilePicUsernamePage(model, context),
                    newPage(model, context),
                    newPage2(model, context),
                    newPage3(model, context),
                    newPage4(model, context),
                    newPage5(model, context),
                    newPage6(model, context),
                    newPage7(model, context),
                    //bioPage(model),
                    // interestsPage(model),
                    notificationPermissionPage(model),
                    finalPage(model),
                  ]
                : [
                    initialPage(),
                    //profilePicUsernamePage(model, context),
                    newPage(model, context),
                    newPage2(model, context),
                    newPage3(model, context),
                    newPage4(model, context),
                    newPage5(model, context),
                    newPage6(model, context),
                    newPage7(model, context),
                    //bioPage(model),
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
            showSkipButton: true,
            showNextButton: true,
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
                    color: Colors.black,
                  ),
            dotsDecorator: const DotsDecorator(
              size: Size(5.0, 5.0),
              color: Color(0xFFBDBDBD),
              activeColor: CustomColors.goGreen,
              activeSize: Size(22.0, 10.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
          ),
        )),
      ),
    );
  }
}

class _OnboardingImage extends StatelessWidget {
  final String imageName;
  _OnboardingImage({required this.imageName});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Image.asset(
          'assets/images/$imageName.png',
          height: 150,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.low,
        ),
      ),
    );
  }
}

class _OnboardingPageBuilder {
  final OnboardingViewModel model;
  _OnboardingPageBuilder({required this.model});

  PageViewModel buildInitialPage() {
    PageDecoration pageDecoration = PageDecoration(
      contentMargin: EdgeInsets.all(0),
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
      image: _OnboardingImage(imageName: "go_logo_transparent"),
      titleWidget: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Welcome to Go",
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
            color: Colors.black,
          ),
          verticalSpaceMedium,
        ],
      ),
    );
  }
}

class _EmailField extends HookViewModelWidget<OnboardingViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, OnboardingViewModel model) {
    TextEditingController _emailController = useTextEditingController();

    return InputField(
      controller: _emailController,
      placeholder: "Email",
      //onChanged: (val) => model.updateEmail(val),
    );
  }
}
