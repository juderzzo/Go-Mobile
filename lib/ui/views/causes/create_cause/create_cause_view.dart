import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go/constants/custom_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/causes/create_cause/create_cause_view_model.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:go/ui/widgets/causes/add_image_button.dart';
import 'package:go/ui/widgets/causes/cause_img_preview.dart';
import 'package:go/ui/widgets/common/text_field_container.dart';
import 'package:go/ui/widgets/navigation/app_bar/go_app_bar.dart';
import 'package:stacked/stacked.dart';

class CreateCauseView extends StatelessWidget {
  final nameController = TextEditingController();
  final goalsController = TextEditingController();
  final whyController = TextEditingController();
  final whoController = TextEditingController();
  final resourcesController = TextEditingController();
  final charityWebsiteController = TextEditingController();
  final action1Controller = TextEditingController();
  final action2Controller = TextEditingController();
  final action3Controller = TextEditingController();

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
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4),
          Text(
            subHeader,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget singleLineTextField({TextEditingController controller, String hintText, int textLimit}) {
    return TextFieldContainer(
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.black,
        //validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
        inputFormatters: [
          LengthLimitingTextInputFormatter(textLimit),
        ],
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget multiLineTextField({TextEditingController controller, String hintText}) {
    return TextFieldContainer(
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.black,
        //validator: (value) => value.isEmpty ? 'Field Cannot be Empty' : null,
        maxLines: null,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget imgBtn(BuildContext context, CreateCauseViewModel model, int imgNum) {
    double iconSize = 20;
    double height = 75;
    double width = 110;
    return model.isEditing
        ? CauseImgPreview(
            onTap: () => model.selectImg(context: context, imgNum: imgNum, ratioX: width, ratioY: height),
            height: height,
            width: width,
            imgURL: null,
          )
        : (imgNum == 1 && model.img1 == null) || (imgNum == 2 && model.img2 == null) || (imgNum == 3 && model.img3 == null)
            ? AddImageButton(
                onTap: () => model.selectImg(context: context, imgNum: imgNum, ratioX: width, ratioY: height),
                iconSize: iconSize,
                height: height,
                width: width,
              )
            : CauseImgPreview(
                onTap: () => model.selectImg(context: context, imgNum: imgNum, ratioX: width, ratioY: height),
                height: height,
                width: width,
                file: imgNum == 1
                    ? model.img1
                    : imgNum == 2
                        ? model.img2
                        : model.img3,
              );
  }

  Widget addImagesRow(BuildContext context, CreateCauseViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        imgBtn(context, model, 1),
        imgBtn(context, model, 2),
        imgBtn(context, model, 3),
      ],
    );
  }

  Widget form(BuildContext context, CreateCauseViewModel model) {
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: [
          verticalSpaceSmall,

          ///NAME OF CAUSE
          textFieldHeader(
            "Name",
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
            "Images",
            "Select up to three images for your cause",
          ),
          verticalSpaceSmall,
          addImagesRow(context, model),
          verticalSpaceMedium,

          ///GOALS FOR CAUSE
          textFieldHeader(
            "Goals",
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
            "Why?",
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
            "Who Are You?",
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
            "Action!",
            "List three things you'd like your cause's followers to do each day to further the cause - besides donating."
                "\n\n(e.g., email/call government officials, attend protest, spread awareness via social media)",
          ),
          verticalSpaceSmall,
          singleLineTextField(
            controller: action1Controller,
            hintText: "Task 01",
          ),
          verticalSpaceSmall,
          singleLineTextField(
            controller: action2Controller,
            hintText: "Task 02",
          ),
          verticalSpaceSmall,
          singleLineTextField(
            controller: action3Controller,
            hintText: "Task 03",
          ),
          verticalSpaceLarge,
          CustomButton(
            height: 48,
            backgroundColor: CustomColors.goGreen,
            text: "Publish",
            textColor: Colors.white,
            isBusy: model.isBusy,
            onPressed: () async {
              bool formSuccess = await model.validateAndSubmitForm(
                name: nameController.text.trim(),
                goal: goalsController.text.trim(),
                why: whyController.text.trim(),
                who: whoController.text.trim(),
                resources: resourcesController.text.trim(),
                charityURL: charityWebsiteController.text.trim(),
                action1: action1Controller.text.trim(),
                action2: action2Controller.text.trim(),
                action3: action3Controller.text.trim(),
              );
              if (formSuccess) {
                displayBottomActionSheet(context, model);
              }
            },
          ),
        ],
      ),
    );
  }

  displayBottomActionSheet(BuildContext context, CreateCauseViewModel model) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              height: 280,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cause Published!',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        onPressed: () => model.pushAndReplaceUntilHomeNavView(),
                        icon: Icon(
                          FontAwesomeIcons.times,
                          color: Colors.black,
                          size: 16,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Share Your Cause!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 24),
                  GestureDetector(
                    child: Text(
                      'Copy Link (disabled)',
                      style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w700),
                    ),
                    onTap: null,
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    child: Text(
                      'Share (disabled)',
                      style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w700),
                    ),
                    onTap: null,
                  ),
                  SizedBox(height: 24),
                  GestureDetector(
                    child: Text(
                      'Done',
                      style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                    onTap: () => model.pushAndReplaceUntilHomeNavView(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateCauseViewModel>.reactive(
      viewModelBuilder: () => CreateCauseViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: GoAppBar().basicAppBar(title: "Create Cause", showBackButton: true),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: screenHeight(context),
            width: screenWidth(context),
            color: Colors.white,
            child: form(context, model),
          ),
        ),
      ),
    );
  }
}
