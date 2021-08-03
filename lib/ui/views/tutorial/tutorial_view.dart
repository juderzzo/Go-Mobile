import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/constants/custom_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/onboarding/onboarding_view_model.dart';
import 'package:go/ui/views/tutorial/tutorial_viewmodel.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:go/ui/widgets/buttons/custom_text_button.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/common/text_field/multi_line_text_field.dart';
import 'package:go/ui/widgets/common/text_field/single_line_text_field.dart';
import 'package:go/ui/widgets/user/user_profile_pic.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class TutorialView extends StatelessWidget {
  final introKey = GlobalKey<IntroductionScreenState>();

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
        ],
      ),
    );
  }

  PageViewModel newPage(TutorialViewModel model, BuildContext context) {
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
            text:
                """Each cause also has an forum, where you can interact with friends and colleagues with like minded goals."
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
            text:
                """Lastly, your feed is a place where you can interact with posts from all the cause forums you follow. Be sure to check it daily!
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

  PageViewModel finalPage(OnboardingViewModel model) {
    PageDecoration pageDecoration = PageDecoration(
      contentMargin: EdgeInsets.all(0),
      titlePadding:
          EdgeInsets.only(top: 16.0, bottom: 8.0, left: 16, right: 16),
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
                          pages: [
                            initialPage(),
                            //profilePicUsernamePage(model, context),
                           // newPage(model, context),
                            newPage2(model, context),
                            newPage3(model, context),
                            newPage4(model, context),
                            newPage5(model, context),
                            newPage6(model, context),
                            newPage7(model, context),
                            finalPage(model),
                          ],
                          onDone: () {
                            if (!model.isBusy) {
                              model.navigateToPreviousPage();
                            }
                          },
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                            ),
                          ))))));
    }
  }

