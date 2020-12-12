import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go/constants/custom_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/causes/create_cause/create_cause_view_model.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
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
  final task1Controller = TextEditingController();
  final task2Controller = TextEditingController();
  final task3Controller = TextEditingController();

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

  Widget addImagesButton() {
    return GestureDetector(
      onTap: null,
      child: Text(
        "Add Images",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget form() {
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
          addImagesButton(),
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
            controller: task1Controller,
            hintText: "Task 01",
          ),
          verticalSpaceSmall,
          singleLineTextField(
            controller: task2Controller,
            hintText: "Task 02",
          ),
          verticalSpaceSmall,
          singleLineTextField(
            controller: task3Controller,
            hintText: "Task 03",
          ),
          verticalSpaceLarge,
          CustomButton(
            onPressed: null,
            height: 48,
            backgroundColor: CustomColors.goGreen,
            text: "Publish",
            textColor: Colors.white,
          ),
        ],
      ),
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
            child: form(),
          ),
        ),
      ),
    );
  }
}
