import 'package:flutter/material.dart';
import 'package:go/constants/custom_colors.dart';
import 'package:go/ui/views/onboarding/onboarding_view_model.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:stacked/stacked.dart';

class OnboardingView extends StatelessWidget {
  final introKey = GlobalKey<IntroductionScreenState>();

  Widget _pageImg(String assetName) {
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

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 16.0);

    PageDecoration pageDecoration = PageDecoration(
      contentPadding: EdgeInsets.all(0),
      titleTextStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
      bodyTextStyle: TextStyle(fontSize: 16.0),
      titlePadding: EdgeInsets.only(top: 16.0, bottom: 8.0, left: 16, right: 16),
      imageFlex: 3,
      bodyFlex: 3,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
    );

    final List<PageViewModel> pages = [
      PageViewModel(
        title: "Fractional shares",
        body: "Instead of having to buy an entire share, invest any amount you want.",
        image: _pageImg('coding'),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: "Learn as you go",
        body: "Download the Stockpile app and master the market with our mini-lesson.",
        image: _pageImg('coding'),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: "Kids and teens",
        body: "Kids and teens can track their stocks 24/7 and place trades that you approve.",
        image: _pageImg('coding'),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: "Another title page",
        body: "Another beautiful body text for this example onboarding",
        image: _pageImg('coding'),
        footer: RaisedButton(
          onPressed: () {
            introKey.currentState?.animateScroll(0);
          },
          child: const Text(
            'FooButton',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: "Title of last page",
        bodyWidget: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Click on ", style: bodyStyle),
            Icon(Icons.edit),
            Text(" to edit a post", style: bodyStyle),
          ],
        ),
        image: _pageImg('coding'),
        decoration: pageDecoration,
      ),
    ];

    return ViewModelBuilder<OnboardingViewModel>.reactive(
      viewModelBuilder: () => OnboardingViewModel(),
      builder: (context, model, child) => Scaffold(
        body: IntroductionScreen(
          key: introKey,
          pages: pages,
          onDone: () => print('done'),
          //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
          showSkipButton: true,
          skipFlex: 0,
          nextFlex: 0,
          skip: const Text('Skip'),
          next: const Icon(Icons.arrow_forward),
          done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
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
