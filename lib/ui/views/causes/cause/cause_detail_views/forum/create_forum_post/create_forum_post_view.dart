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
    //print("imgfile");
    ///print(model.imgFile.runtimeType);
    //print("img");
    //print(model.img);
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ListView(
        shrinkWrap: true,
        children: [
          verticalSpaceSmall,
          Container(
            color: appBackgroundColor(),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                TextFormField(
                  controller: model.postTextController,
                  decoration: InputDecoration(
                      hintText: "What's on your mind?",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(5),
                      fillColor: appBackgroundColor()),
                  maxLines: null,
                ),
                model.imgFile == null && model.img == null
                    ? Container(
                        //color: appTextFieldContainerColor(),
                        child: Column(
                          children: [
                            verticalSpaceTiny,
                            Row(
                              children: [
                                IconButton(
                                    icon: Icon(
                                      Icons.filter_rounded,
                                      size: 25,
                                    ),
                                    onPressed: () {
                                      model.selectImage();
                                    }),
                              ],
                            ),
                          ],
                        ),
                      )
                    :
                    //this one is for the file image
                    model.imgFile != null
                        ? Stack(
                            children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  child: Image.file(model.imgFile)),
                              SizedBox(
                                height: 22,
                                width: 22,
                                child: IconButton(
                                      icon: Icon(
                                        Icons.cancel,
                                      ),
                                    
                                    onPressed: () {
                                      model.imgFile = null;
                                      model.notifyListeners();
                                    }),
                              )
                            ],
                          )
                        //this is for the network image
                        : Stack(
                            children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  child: Image.network(model.img)),
                              SizedBox(
                                height: 22,
                                width: 22,
                                child: IconButton(
                                    icon: Icon(
                                      Icons.cancel,
                                    ),
                                    onPressed: () {
                                      model.img = null;
                                      model.imgFile = null;
                                      model.imgChanged = true;
                                      model.notifyListeners();
                                    }),
                              )
                            ],
                          ),
              ],
            ),
          ),
          verticalSpaceTiny,
          CustomButton(
            height: 48,
            backgroundColor: CustomColors.goGreen,
            text: model.isEditing ? "Update" : "Publish",
            textColor: Colors.white,
            isBusy: model.isBusy,
            onPressed: () => model.validateAndSubmitForm(),
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
        appBar: CustomAppBar()
            .basicAppBar(title: "Create Post", showBackButton: true),
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
