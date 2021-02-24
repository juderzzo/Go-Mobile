import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/home/tabs/profile/edit_profile/edit_profile_view_model.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/common/text_field/multi_line_text_field.dart';
import 'package:go/ui/widgets/common/text_field/single_line_text_field.dart';
import 'package:go/ui/widgets/navigation/app_bar/custom_app_bar.dart';
import 'package:go/ui/widgets/user/user_profile_pic.dart';
import 'package:stacked/stacked.dart';

class EditProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditProfileViewModel>.reactive(
      onModelReady: (model) => model.initialize(context),
      viewModelBuilder: () => EditProfileViewModel(),
      builder: (context, model, child) => GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          appBar: CustomAppBar().basicActionAppBar(
            title: "Edit Profile",
            showBackButton: true,
            actionWidget: model.isBusy
                ? Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: CustomCircleProgressIndicator(
                      size: 20,
                      color: appInActiveColorAlt(),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(top: 20, right: 16),
                    child: GestureDetector(
                      onTap: () => model.updateProfile(),
                      child: CustomText(
                        text: "Done",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: appFontColor(),
                      ),
                    ),
                  ),
          ),
          body: Container(
            height: screenHeight(context),
            color: appBackgroundColor(),
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: ListView(
              children: [
                verticalSpaceMedium,
                model.updatedProfilePic == null
                    ? GestureDetector(
                        onTap: () => model.selectImage(),
                        child: Align(
                          child: UserProfilePic(
                            isBusy: model.isBusy,
                            size: 80,
                            userPicUrl: model.initialProfilePicURL,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () => model.selectImage(),
                        child: Align(
                          child: UserProfilePicFromFile(
                            file: model.updatedProfilePic,
                            size: 80,
                          ),
                        ),
                      ),
                verticalSpaceSmall,
                Align(
                  child: GestureDetector(
                    onTap: () => model.selectImage(),
                    child: CustomText(
                      text: "Change Profile Pic",
                      textAlign: TextAlign.center,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: appTextButtonColor(),
                    ),
                  ),
                ),
                verticalSpaceMedium,
                CustomText(
                  text: "Username", fontSize: 16, 
                fontWeight: FontWeight.bold, 
                color: appFontColor(),),

                verticalSpaceSmall,
                SingleLineTextField(
                  controller: model.usernameTextController,
                  hintText: "Username",
                  textLimit: 30,
                  isPassword: false,
                  
                ),
                verticalSpaceMedium,

                CustomText(
                  text: "Bio",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: appFontColor(),
                ),
                verticalSpaceSmall,

                MultiLineTextField(
                  controller: model.bioTextController,
                  hintText: "Tell Us About Yourself",
                  maxLines: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
