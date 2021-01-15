import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/constants/custom_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/forum/create_forum_post/create_forum_post_view_model.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:go/ui/widgets/common/text_field/multi_line_text_field.dart';
import 'package:go/ui/widgets/navigation/app_bar/custom_app_bar.dart';
import 'package:stacked/stacked.dart';

class CreateForumPostView extends StatelessWidget {
  final postTextController = TextEditingController();

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

  Widget form(BuildContext context, CreateForumPostViewModel model) {
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: [
          verticalSpaceSmall,
          MultiLineTextField(
            controller: postTextController,
            hintText: "What's on your mind?",
            maxLines: 10,
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
                post: postTextController.text.trim(),
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
    return ViewModelBuilder<CreateForumPostViewModel>.reactive(
      onModelReady: (model) => model.initialize(context),
      viewModelBuilder: () => CreateForumPostViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar().basicAppBar(title: "Create Post", showBackButton: true),
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
