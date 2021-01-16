import 'package:flutter/material.dart';
import 'package:go/constants/custom_colors.dart';
import 'package:go/ui/views/onboarding/onboarding_view_model.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:stacked/stacked.dart';
import 'package:image_picker/image_picker.dart';

class OnboardingView extends StatelessWidget {
  final introKey = GlobalKey<IntroductionScreenState>();
  TextEditingController bioController = new TextEditingController();
  TextEditingController interestController = new TextEditingController();
  TextEditingController inspirationsController = new TextEditingController();
  TextEditingController websiteController = new TextEditingController();

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
      titlePadding:
          EdgeInsets.only(top: 16.0, bottom: 8.0, left: 16, right: 16),
      imageFlex: 3,
      bodyFlex: 3,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
    );

    List<PageViewModel> pages(model) {
    return [

      PageViewModel(
        title: "Choose a profile picture",
        body: "Click on the Icon above to choose an image",
        image: 
        Column(
          children: [
            SizedBox(height: 200,),
           
            
              GestureDetector(
                                onTap: () {
                                  model.getImage();
                                },
                                child: model.selectedImage() != null
                                    ? Container(
                                        //Container if there is an image
                                       decoration: BoxDecoration(
                                         shape: BoxShape.circle,
                                        
                                       ),

                                       height: MediaQuery.of(context).size.height * 1 / 5,
                                       width: MediaQuery.of(context).size.height * 1 / 5 ,


                                          
                                      child: 
                                      ClipOval(
                                        

                                             child: Image.file(model.selectedImage(),
                                              fit: BoxFit.fill),
                                      ),
                                            
                                      
                                        
                                      )
                                    : Container(
                                        //Container if theres not an image

                                        height: MediaQuery.of(context).size.height * 1 / 5,
                                        
                                        child: Icon(Icons.add_a_photo),
                                        decoration: BoxDecoration(
                                            //border: Border.all(color: Colors.black),
                                            shape: BoxShape.circle,
                                            )),
                            ),
            
          ],
        ),
        
        decoration: pageDecoration,
      ),


      PageViewModel(
        title: "Enter your bio",
        bodyWidget: Container(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 24.0, 24.0),
              child: Text(
                "Tell us something about yourself that we can display on your profile",
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 5 / 6,
                child: TextField(
                  controller: bioController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 400,
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 1 / 7),
          ],
        )),
        image: _pageImg('bio'),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: "Tell us about your interests",
        bodyWidget: Container(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 24.0, 24.0),
              child: Text(
                "We'll display your interests to other changemakers",
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 5 / 6,
                child: TextField(
                  controller: interestController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 200,
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 1 / 7),
          ],
        )),
        image: _pageImg('interests'),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: "Inspirations",
        bodyWidget: Container(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 24.0, 24.0),
              child: Text(
                "We'll display your interests to other changemakers",
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 5 / 6,
                child: TextField(
                  controller: inspirationsController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 200,
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 1 / 7),
          ],
        )),
        image: _pageImg('inspirations'),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: "Personal Site",
        body: "Enter your personal website (if applicable)",
        image: _pageImg('website'),
        footer: Container(
            width: MediaQuery.of(context).size.width * 5 / 6,
            child: TextField(
              controller: websiteController,
              keyboardType: TextInputType.multiline,
              maxLines: 1,
              maxLength: 50,
            )),
        decoration: pageDecoration,
      ),
      
    ];
    }

    return ViewModelBuilder<OnboardingViewModel>.reactive(
      viewModelBuilder: () => OnboardingViewModel(),
      builder: (context, model, child) => Scaffold(
        body: IntroductionScreen(
          key: introKey,
          pages: pages(model),
          onDone: () => model.completeOnboarding(model.selectedImage(), bioController.text,
           interestController.text, inspirationsController.text, websiteController.text),
          //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
          showSkipButton: true,
          skipFlex: 0,
          nextFlex: 0,
          skip: const Text('Skip'),
          next: const Icon(Icons.arrow_forward),
          done:
              const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
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
