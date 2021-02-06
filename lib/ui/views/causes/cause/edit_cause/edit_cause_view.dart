import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/constants/custom_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/causes/create_cause/create_cause_view_model.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:go/ui/widgets/causes/add_image_button.dart';
import 'package:go/ui/widgets/causes/cause_img_preview.dart';
import 'package:go/ui/widgets/common/text_field/text_field_container.dart';
import 'package:go/ui/widgets/navigation/app_bar/custom_app_bar.dart';
import 'package:stacked/stacked.dart';

import 'edit_cause_viewmodel.dart';

class EditCauseView extends StatelessWidget {
  final String causeID;
  String name;
  String goals;
  String why;
  String who;
  String resources;
  String charity;
  dynamic img1;
  dynamic img2;
  dynamic img3;

  final nameController = TextEditingController();
  final goalsController = TextEditingController();
  final whyController = TextEditingController();
  final whoController = TextEditingController();
  final resourcesController = TextEditingController();
  final charityWebsiteController = TextEditingController();

  EditCauseView(
      {this.causeID,
      this.name,
      this.goals,
      this.why,
      this.who,
      this.resources,
      this.charity,
      this.img1,
      this.img2,
      this.img3});

  Void initialize() {
    //print(this.causeID);
    nameController.text = name;
    goalsController.text = goals;
    whoController.text = why;
    whyController.text = who;
    resourcesController.text = resources;
    charityWebsiteController.text = charity;
  }

  Widget textFieldHeader(String header, String subHeader) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            header,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: appFontColor(),
            ),
          ),
          SizedBox(height: 4),
          Text(
            subHeader,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: appFontColorAlt(),
            ),
          ),
        ],
      ),
    );
  }

  Widget singleLineTextField(
      {TextEditingController controller, String hintText, int textLimit}) {
    return TextFieldContainer(
      child: TextFormField(
        controller: controller,
        cursorColor: appFontColorAlt(),
        //validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
        inputFormatters: [
          LengthLimitingTextInputFormatter(textLimit),
        ],
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget multiLineTextField(
      {TextEditingController controller, String hintText}) {
    return TextFieldContainer(
      child: TextFormField(
        controller: controller,
        cursorColor: appFontColorAlt(),
        //validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
        maxLines: null,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget imgBtn(BuildContext context, EditCauseViewModel model, int imgNum) {
    double iconSize = 20;
    double height = 75;
    double width = 110;
    

    return model.isEditing
        ? CauseImgPreview(
            onTap: () => model.selectImage(
                context: context,
                imgNum: imgNum,
                ratioX: width,
                ratioY: height),
            height: height,
            width: width,
            imgURL: null,
          )
        : (imgNum == 1 && model.img1 == null) ||
                (imgNum == 2 && model.img2 == null) ||
                (imgNum == 3 && model.img3 == null)
            ? AddImageButton(
                onTap: () async {
                  await model.selectImage(
                      context: context,
                      imgNum: imgNum,
                      ratioX: width,
                      ratioY: height);
                  
                },
                iconSize: iconSize,
                height: height,
                width: width,
              )
            : CauseImgPreview(
                onTap: () {
                  print(1);
                  model.selectImage(
                      context: context,
                      imgNum: imgNum,
                      ratioX: width,
                      ratioY: height);
                  print(model.img2.runtimeType);
                },
                height: height,
                width: width,
                file: imgNum == 1 && model.img1Changed && model.img1 != null
                    ? model.img1
                    : imgNum == 2 && model.img2Changed && model.img2 != null
                        ? model.img2
                        : imgNum == 3 && model.img3Changed && model.img3 != null
                            ? model.img3
                            : null,
                imgURL: imgNum == 1 && img1 != null
                    ? img1.url
                    : imgNum == 2 && img2 != null
                        ? img2.url
                        : imgNum == 3 && img3 != null
                            ? img3.url
                            : null,
              );
  }

  Widget addImagesRow(BuildContext context, EditCauseViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        imgBtn(context, model, 1),
        imgBtn(context, model, 2),
        imgBtn(context, model, 3),
      ],
    );
  }

  Widget form(BuildContext context, EditCauseViewModel model) {
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: [
          verticalSpaceSmall,

          ///NAME OF CAUSE
          textFieldHeader(
            "*Name",
            "What is the name of your cause?",
          ),
          verticalSpaceSmall,
          singleLineTextField(
            controller: nameController,
            hintText: "Name of Cause",
            textLimit: 75,
          ),
          verticalSpaceMedium,

          ///CAUSE IMAGES
          textFieldHeader(
            "*Images",
            "Select up to three images for your cause. The leftmost image is required, and will be your title image",
          ),
          verticalSpaceSmall,
          addImagesRow(context, model),
          verticalSpaceMedium,

          ///GOALS FOR CAUSE
          textFieldHeader(
            "*Goals",
            "What are the goals of your cause? What are you fighting for?",
          ),
          verticalSpaceSmall,
          multiLineTextField(
            controller: goalsController,
            hintText: "Goals",
          ),
          verticalSpaceMedium,

          ///REASONS FOR CAUSE
          textFieldHeader(
            "*Why?",
            "Why is your cause important? Why is it worth it?",
          ),
          verticalSpaceSmall,
          multiLineTextField(
            controller: whyController,
            hintText: "The reason for your cause",
          ),
          verticalSpaceMedium,

          ///WHO CREATED THIS CAUSE
          textFieldHeader(
            "*Who Are You?",
            "Who are you as a changemaker? What is your experience in the fight for this cause?",
          ),
          verticalSpaceSmall,
          multiLineTextField(
            controller: whoController,
            hintText: "Who are you?",
          ),
          verticalSpaceMedium,

          ///CAUSE RESOURCES
          textFieldHeader(
            "Resources",
            "Are there additional resources for anyone looking to learn more about your cause?\n"
                "(e.g., websites, books, articles, videos, etc.)",
          ),
          verticalSpaceSmall,
          multiLineTextField(
            controller: resourcesController,
            hintText: "Additional Resources",
          ),
          verticalSpaceMedium,

          ///CHARITY LINK
          textFieldHeader(
            "Charity",
            "Would you like to raise funds for this cause using Go!'s platform? If so, please provide a link to the charity of your choice.",
          ),
          verticalSpaceSmall,
          singleLineTextField(
            controller: charityWebsiteController,
            hintText: "https://example.com",
          ),
          verticalSpaceMedium,

          ///CAUSE TASKS
          textFieldHeader(
            "Actions!",
            "To add actions, go to 'Edit Checklist' after you've created your cause on the checklist page. List things you'd like your cause's followers to do each day to further the cause - besides donating."
                "\n\n(e.g., email/call government officials, attend protest, spread awareness via social media)",
          ),
          verticalSpaceSmall,

          verticalSpaceLarge,
          CustomButton(
            height: 48,
            backgroundColor: CustomColors.goGreen,
            text: "Publish",
            textColor: Colors.white,
            isBusy: model.isBusy,
            onPressed: () async {
              bool formSuccess = await model.validateAndSubmitForm(
                causeID: causeID,
                name: nameController.text.trim(),
                goal: goalsController.text.trim(),
                why: whyController.text.trim(),
                who: whoController.text.trim(),
                resources: resourcesController.text.trim(),
                charityURL: charityWebsiteController.text.trim(),
              );
              if (formSuccess) {
                model.displayCauseUploadSuccessBottomSheet();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditCauseViewModel>.reactive(
      viewModelBuilder: () =>
          EditCauseViewModel(img1: img1, img2: img2, img3: img3),
      onModelReady: (f) => initialize(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar()
            .basicAppBar(title: "Edit Cause", showBackButton: true),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: screenHeight(context),
            width: screenWidth(context),
            color: appBackgroundColor(),
            child: form(context, model),
          ),
        ),
      ),
    );
  }
}
