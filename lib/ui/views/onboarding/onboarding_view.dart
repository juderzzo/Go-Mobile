import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/onboarding/onboarding_view_model.dart';
import 'package:go/ui/views/settings/settings_view_model.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:go/ui/widgets/buttons/custom_text_button.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/common/text_field/multi_line_text_field.dart';
import 'package:go/ui/widgets/common/text_field/single_line_text_field.dart';
import 'package:go/ui/widgets/common/text_field/text_field_container.dart';
import 'package:go/ui/widgets/user/user_profile_pic.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:stacked/stacked.dart';

class OnboardingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OnboardingViewModel>.reactive(
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => OnboardingViewModel(),
      builder: (context, model, child) => Scaffold(
        body: model.isBusy
            ? Center(
                child: CustomCircleProgressIndicator(size: 10, color: appActiveColor()),
              )
            : GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: IntroductionScreen(
                  globalBackgroundColor: appBackgroundColor(),
                  key: model.introKey,
                  freeze: false,
                  onChange: (val) {
                    model.updatePageNum(val);
                    if (model.pageNum == 5) {
                      model.updateShowNextButton(true);
                    } else {
                      model.updateShowNextButton(false);
                    }
                  },
                  onDone: model.isLoading ? () {} : () => model.validateAndSubmit(),
                  onSkip: () => model.navigateToNextPage(),
                  showSkipButton: false,
                  showNextButton: model.showNextButton,
                  skipFlex: 0,
                  nextFlex: 0,
                  skip: Text('Skip', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                  next: Icon(
                    FontAwesomeIcons.arrowRight,
                    size: 24.0,
                    color: Colors.black,
                  ),
                  done: model.isLoading
                      ? CustomCircleProgressIndicator(size: 10, color: appActiveColor())
                      : Text('Done', style: TextStyle(color: appFontColor(), fontWeight: FontWeight.bold)),
                  dotsDecorator: DotsDecorator(
                    size: Size(0.0, 0.0),
                    color: Colors.white,
                    activeColor: Colors.white,
                    activeSize: Size(0.0, 0.0),
                  ),
                  pages: [
                    OnboardingPages().initialPage(),
                    OnboardingPages().associatedEmailPage(model),
                    OnboardingPages().notificationPermissionPage(model),
                    OnboardingPages().locationPermissionPage(model),
                    OnboardingPages().userInfoPage(model),
                  ],
                ),
              ),
      ),
    );
  }
}

class _OnboardingImage extends StatelessWidget {
  final String assetName;
  _OnboardingImage({required this.assetName});

  @override
  Widget build(BuildContext context) {
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
}

class OnboardingPages {
  PageDecoration pageDecoration = PageDecoration(
    contentMargin: EdgeInsets.all(0),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
    bodyTextStyle: TextStyle(fontSize: 14.0),
    titlePadding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16, right: 16),
    imageFlex: 1,
    descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    pageColor: Colors.white,
    //imagePadding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
  );

  PageViewModel initialPage() {
    return PageViewModel(
      titleWidget: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Welcome",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
      bodyWidget: Column(
        children: [
          Text(
            "Let's answer a few questions to help get you going.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0, height: 1.5),
          ),

          SizedBox(height: 50,),

          TextButton(
            child: Text("Log Out", 
            style: TextStyle(color: Colors.red)
            ),
            onPressed: (){OnboardingViewModel.signOut();},
            )
        ],
      ),
      image: _OnboardingImage(assetName: 'go_logo_slogan'),
      decoration: pageDecoration,
    );
  }

  PageViewModel associatedEmailPage(OnboardingViewModel model) {
    return PageViewModel(
      titleWidget: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "What's Your Email Address?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
      bodyWidget: Text(
        "Just In Case You Lose Access to Your Account",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18.0, height: 1.5),
      ),
      footer: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextFieldContainer(
              height: 50,
              child: TextFormField(
                controller: null,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.black,
                validator: (val) => val!.isEmpty ? 'Field Cannot be Empty' : null,
                maxLines: null,
                onChanged: (val) => model.updateEmail(val),
                decoration: InputDecoration(
                  hintText: "Email Address",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          CustomButton(
            text: "Set Email Address",
            textColor: Colors.black,
            backgroundColor: Colors.white,
            width: 300.0,
            height: 45.0,
            onPressed: () => model.validateAndSubmitEmailAddress(),
            isBusy: false,
          ),
        ],
      ),
      image: _OnboardingImage(assetName: 'email'),
      decoration: pageDecoration,
    );
  }

  PageViewModel notificationPermissionPage(OnboardingViewModel model) {
    return PageViewModel(
      titleWidget: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Are you in the loop?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
      bodyWidget: Text(
        "Enable notifications to know what causes are active in your area",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18.0, height: 1.5),
      ),
      image: _OnboardingImage(assetName: 'notifBell'),
      decoration: pageDecoration,
      footer: Container(
        child: Column(
          children: [
            model.isLoading
                ? CustomCircleProgressIndicator(size: 40, color: appActiveColor())
                : CustomButton(
                    text: model.notificationError ? "Try Again" : "Enable Notifications",
                    textColor: Colors.black,
                    backgroundColor: Colors.white,
                    width: 300.0,
                    height: 45.0,
                    onPressed: () => model.checkNotificationPermissions(),
                    isBusy: false,
                  ),
            model.notificationError
                ? Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: GestureDetector(
                      onTap: () => model.openAppSettings(),
                      child: Text(
                        "Open App Settings",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blue, fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                : Container(),
            verticalSpaceMedium,
            CustomTextButton(
              onTap: () => model.navigateToNextPage(),
              text: "Skip",
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: appFontColorAlt(),
            ),
          ],
        ),
      ),
    );
  }

  PageViewModel locationPermissionPage(OnboardingViewModel model) {
    return PageViewModel(
      titleWidget: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Where Are You?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
      bodyWidget: Text(
        "Please share your location to located causes in your area",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18.0, height: 1.5),
      ),
      image: _OnboardingImage(assetName: 'pinpoint'),
      decoration: pageDecoration,
      footer: Container(
        child: Column(
          children: [
            model.isLoading
                ? CustomCircleProgressIndicator(size: 40, color: appActiveColor())
                : CustomButton(
                    text: model.locationError ? "Try Again" : "Enable Location",
                    textColor: Colors.black,
                    backgroundColor: Colors.white,
                    width: 300.0,
                    height: 45.0,
                    onPressed: () => model.checkLocationPermissions(),
                    isBusy: model.updatingLocation,
                  ),
            model.locationError
                ? Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: GestureDetector(
                      onTap: () => model.openAppSettings(),
                      child: Text(
                        "Open App Settings",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blue, fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  PageViewModel userInfoPage(OnboardingViewModel model) {
    PageDecoration finalPageDecor = PageDecoration(
      contentMargin: EdgeInsets.all(0),
      titlePadding: EdgeInsets.only(top: 16.0, bottom: 8.0, left: 16, right: 16),
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imageFlex: 1,
      bodyFlex: 3,
      pageColor: appBackgroundColor(),
    );
    return PageViewModel(
      decoration: finalPageDecor,
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
          SingleLineTextField(
            controller: null,
            hintText: "Username",
            textLimit: 50,
            isPassword: false,
            onChanged: (String val) => model.updateUsername(val),
          ),
          verticalSpaceMedium,
          MultiLineTextField(
            controller: null,
            hintText: "Short Bio",
            maxLines: 7,
            onChanged: (String val) => model.updateBio(val),
            enabled: true,
            initialValue: null,
          ),
          verticalSpaceMedium,
        ],
      ),
    );
  }
}
