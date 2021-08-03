import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/constants/custom_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/causes/create_cause/create_cause_view_model.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:go/ui/widgets/causes/add_image_button.dart';
import 'package:go/ui/widgets/causes/cause_img_preview.dart';
import 'package:go/ui/widgets/common/text_field/multi_line_text_field.dart';
import 'package:go/ui/widgets/common/text_field/single_line_text_field.dart';
import 'package:go/ui/widgets/navigation/app_bar/custom_app_bar.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class CreateCauseView extends StatelessWidget {
  final String? id;
  CreateCauseView(@PathParam() this.id);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateCauseViewModel>.reactive(
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.initialize(id!),
      viewModelBuilder: () => CreateCauseViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar().basicAppBar(
            title: model.isBusy
                ? ""
                : model.isEditing
                    ? "Edit Cause"
                    : "Create Cause",
            showBackButton: true),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: screenHeight(context),
            width: screenWidth(context),
            color: appBackgroundColor(),
            child: model.isBusy ? Container() : _CauseForm(),
          ),
        ),
      ),
    );
  }
}

class _CauseForm extends HookViewModelWidget<CreateCauseViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, CreateCauseViewModel model) {
    
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: [
          verticalSpaceSmall,

          ///NAME OF CAUSE
          _TextFieldHeader(
            header: "*Name",
            subHeader: "What is the name of your cause?",
          ),
          verticalSpaceSmall,
          _CauseNameField(),
          verticalSpaceMedium,

          ///CAUSE IMAGES
          _TextFieldHeader(
            header: "*Images",
            subHeader: "Select up to three images for your cause. The leftmost image is required, and will be your title image",
          ),
          verticalSpaceSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CauseImage(imgNum: 1),
              _CauseImage(imgNum: 2),
              _CauseImage(imgNum: 3),
            ],
          ),
          verticalSpaceMedium,

          ///GOALS FOR CAUSE
          _TextFieldHeader(
            header: "*Goals",
            subHeader: "What are the goals of your cause? What are you fighting for?",
          ),
          verticalSpaceSmall,
          _CauseGoalsField(),
          verticalSpaceMedium,

          ///REASONS FOR CAUSE
          _TextFieldHeader(
            header: "*Why?",
            subHeader: "Why is your cause important? Why is it worth it?",
          ),
          verticalSpaceSmall,
          _CauseWhyField(),
          verticalSpaceMedium,

          ///WHO CREATED THIS CAUSE
          _TextFieldHeader(
            header: "*Who Are You?",
            subHeader: "Who are you as a changemaker? What is your experience in the fight for this cause?",
          ),
          verticalSpaceSmall,
          _CauseWhoField(),
          verticalSpaceMedium,

          ///CAUSE RESOURCES
          _TextFieldHeader(
            header: "Resources",
            subHeader: "Are there additional resources for anyone looking to learn more about your cause?\n"
                "(e.g., websites, books, articles, videos, etc.)",
          ),
          verticalSpaceSmall,
          _CauseResourcesField(),
          verticalSpaceMedium,

          ///CHARITY LINK
          _TextFieldHeader(
            header: "Charity",
            subHeader: "Would you like to raise funds for this cause using Go!'s platform? If so, please provide a link to the charity of your choice.",
          ),
          verticalSpaceSmall,
          _CauseWebsiteField(),
          verticalSpaceMedium,

          ///CAUSE TASKS
          _TextFieldHeader(
            header: "Youtube Link",
            subHeader: "If you feel your cause would be supported by a short video on youtube, please link it here for display",
          ),

          verticalSpaceSmall,
          _CauseVideoLinkField(),
          verticalSpaceMedium,

          ///CAUSE MONETIZATION
          _TextFieldHeader(
            header: "Monetization",
            subHeader: "If you would like to monetize your cause by allowing users to watch advertisements, turn the switch to on",
          ),
          verticalSpaceSmall,

          _CauseMonetizationField(),

          verticalSpaceMedium,

          model.cause.monetized!
              ? Center(child: Text("On", style: TextStyle(color: CustomColors.goGreen, fontSize: 20, fontWeight: FontWeight.bold)))
              : Center(
                  child: Text(
                    "Off",
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                ),

          verticalSpaceLarge,

          _TextFieldHeader(
            header: "Actions!",
            subHeader:
                "To add actions, go to 'Update Checklist' after you've created your cause on the checklist page. List things you'd like your cause's followers to do each day to further the cause - besides donating."
                "\n\n(e.g., email/call government officials, attend protest, spread awareness via social media). The checklist page can be accessed by clicking on your cause in your home page, and then swiping to the second tab, titled 'Action List;",
          ),
          verticalSpaceMedium,

          verticalSpaceLarge,
          CustomButton(
            height: 48,
            backgroundColor: CustomColors.goGreen,
            text: "Publish",
            textColor: Colors.white,
            isBusy: model.isBusy || model.isUploading ? true : false,
            onPressed: () => model.validateAndSubmitForm(),
          ),
        ],
      ),
    );
  }
}

class _TextFieldHeader extends StatelessWidget {
  final String header;
  final String subHeader;
  _TextFieldHeader({required this.header, required this.subHeader});

  @override
  Widget build(BuildContext context) {
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
}



class _CauseImage extends HookViewModelWidget<CreateCauseViewModel> {
  final int imgNum;
  _CauseImage({required this.imgNum});

  final double iconSize = 20;
  final double height = 75;
  final double width = 110;

  @override
  Widget buildViewModelWidget(BuildContext context, CreateCauseViewModel model) {
    return model.isEditing
        ? (imgNum == 1 && model.img1 != null) || (imgNum == 2 && model.img2 != null) || (imgNum == 3 && model.img3 != null)
            ? CauseImgPreview(
                onTap: () => model.selectImage(context: context, imgNum: imgNum, ratioX: width, ratioY: height),
                height: height,
                width: width,
                file: imgNum == 1
                    ? model.img1
                    : imgNum == 2
                        ? model.img2
                        : model.img3,
              )
            : model.cause.imageURLs!.length < imgNum
                ? AddImageButton(
                    onTap: () => model.selectImage(context: context, imgNum: imgNum, ratioX: width, ratioY: height),
                    iconSize: iconSize,
                    height: height,
                    width: width,
                  )
                : CauseImgPreview(
                    onTap: () => model.selectImage(context: context, imgNum: imgNum, ratioX: width, ratioY: height),
                    height: height,
                    width: width,
                    imgURL: model.cause.imageURLs![imgNum - 1],
                  )
        : (imgNum == 1 && model.img1 == null) || (imgNum == 2 && model.img2 == null) || (imgNum == 3 && model.img3 == null)
            ? AddImageButton(
                onTap: () => model.selectImage(context: context, imgNum: imgNum, ratioX: width, ratioY: height),
                iconSize: iconSize,
                height: height,
                width: width,
              )
            : CauseImgPreview(
                onTap: () => model.selectImage(context: context, imgNum: imgNum, ratioX: width, ratioY: height),
                height: height,
                width: width,
                file: imgNum == 1
                    ? model.img1
                    : imgNum == 2
                        ? model.img2
                        : model.img3,
              );
  }
}

class _CauseNameField extends HookViewModelWidget<CreateCauseViewModel> {
  final nameController = useTextEditingController();

  @override
  Widget buildViewModelWidget(BuildContext context, CreateCauseViewModel model) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (!model.loadedPreviousCauseName) {
        nameController.text = model.loadPreviousCauseName();
      } 
    });

    return SingleLineTextField(
      controller: nameController,
      hintText: "Cause Name",
      textLimit: 75,
      isPassword: false,
      onChanged: (val) => model.updateCauseName(val),
    );
  }
}



class _CauseGoalsField extends HookViewModelWidget<CreateCauseViewModel> {
  final goalsController = useTextEditingController();
  
  @override
  Widget buildViewModelWidget(BuildContext context, CreateCauseViewModel model) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (!model.loadedPreviousCauseGoal) {
        goalsController.text = model.loadPreviousCauseGoal();
      }
    
    });

    return MultiLineTextField(
      enabled: true,
      controller: goalsController,
      hintText: "Goals",
      initialValue: null,
      maxLines: null,
      onChanged: (val) => model.updateCauseGoal(val),
    );
  }
}


class _CauseWhyField extends HookViewModelWidget<CreateCauseViewModel> {
  final whyController = useTextEditingController();

  @override
  Widget buildViewModelWidget(BuildContext context, CreateCauseViewModel model) {
    

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (!model.loadedPreviousCauseWhy) {
        whyController.text = model.loadPreviousCauseWhy();
      }
    });

    return MultiLineTextField(
      enabled: true,
      controller: whyController,
      hintText: "The reason for your cause",
      initialValue: null,
      maxLines: null,
      onChanged: (val) => model.updateCauseWhy(val),
    );
  }
}

class _CauseWhoField extends HookViewModelWidget<CreateCauseViewModel> {
  final whoController = useTextEditingController();

  @override
  Widget buildViewModelWidget(BuildContext context, CreateCauseViewModel model) {
    

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (!model.loadedPreviousCauseWho) {
        whoController.text = model.loadPreviousCauseWho();
      }
    });

    return MultiLineTextField(
      enabled: true,
      controller: whoController,
      hintText: "Who are you?",
      initialValue: null,
      maxLines: null,
      onChanged: (val) => model.updateCauseWho(val),
    );
  }
}

class _CauseResourcesField extends HookViewModelWidget<CreateCauseViewModel> {
  final resourcesController = useTextEditingController();

  @override
  Widget buildViewModelWidget(BuildContext context, CreateCauseViewModel model) {
    

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (!model.loadedPreviousCauseResources) {
        resourcesController.text = model.loadPreviousCauseResources();
      }
    });

    return MultiLineTextField(
      enabled: true,
      controller: resourcesController,
      hintText: "Additional Resources",
      initialValue: null,
      maxLines: null,
      onChanged: (val) => model.updateCauseResources(val),
    );
  }
}

class _CauseWebsiteField extends HookViewModelWidget<CreateCauseViewModel> {
  final websiteController = useTextEditingController();

  @override
  Widget buildViewModelWidget(BuildContext context, CreateCauseViewModel model) {
    

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (!model.loadedPreviousCauseWebsite) {
        websiteController.text = model.loadPreviousCauseWebsite();
      }
    });

    return SingleLineTextField(
      controller: websiteController,
      hintText: "Website",
      textLimit: 75,
      isPassword: false,
      onChanged: (val) => model.updateCauseWebsite(val),
    );
  }
}

class _CauseVideoLinkField extends HookViewModelWidget<CreateCauseViewModel> {
  final videoLinkController = useTextEditingController();
  
  @override
  Widget buildViewModelWidget(BuildContext context, CreateCauseViewModel model) {
    

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (!model.loadedPreviousCauseVideoLink) {
        videoLinkController.text = model.loadPreviousCauseVideoLink();
      }
    });

    return SingleLineTextField(
      controller: videoLinkController,
      hintText: "https://youtube.com/...",
      textLimit: 75,
      isPassword: false,
      onChanged: (val) => model.updateCauseVideoLink(val),
    );
  }
}

class _CauseMonetizationField extends HookViewModelWidget<CreateCauseViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, CreateCauseViewModel model) {
    return Container(
      width: 200.0,
      child: Switch(
        value: model.cause.monetized!,
        onChanged: (val) => model.updateCauseMonetization(val),
      ),
    );
  }
}
