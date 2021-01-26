import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/check_list/check_list_view_model.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:go/ui/widgets/causes/cause_check_list_item.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/common/text_field/text_field_container.dart';
import 'package:stacked/stacked.dart';
import 'edit_checklist_viewmodel.dart';

class EditChecklistView extends StatelessWidget {
  List actions;
  List descriptors;
  String creatorId;
  String currentUID;
  String name;
  String causeID;
  TextEditingController action0 = TextEditingController();
  TextEditingController action1 = TextEditingController();
  TextEditingController action2 = TextEditingController();
  TextEditingController descriptor0 = TextEditingController();
  TextEditingController descriptor1 = TextEditingController();
  TextEditingController descriptor2 = TextEditingController();

  initialize(BuildContext context) {
    Map<String, dynamic> args = RouteData.of(context).arguments;
    actions = args['actions'];
    descriptors = args['descriptors'];
    creatorId = args['creatorID'];
    currentUID = args['currentUID'];
    name = args['name'];
    causeID = args['causeID'];

    print(causeID);

    //print(actions);
    //print(descriptors);
    action0.text = actions[0];
    action1.text = actions[1];
    action2.text = actions[2];

    descriptor0.text = descriptors[0];
    descriptor1.text = descriptors[1];
    descriptor2.text = descriptors[2];

    //print('actions' + actions.toString());
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
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget checkListItems(model) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 40,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            model.navigateBack();
          },
        ),
        title: Container(
          height: 40,
          width: 300,
          child: ListView(scrollDirection: Axis.horizontal, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: CustomFittedText(
                text: name,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: appFontColor(),
                textAlign: TextAlign.left,
              ),
            ),
          ]),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28.0, 0.0, 28.0, 0.0),
          child: ListView(children: [
            verticalSpaceLarge,
            textFieldHeader(
              "Edit Your Action List!",
              "List three things (titles and descriptions) you'd like your cause's followers to do each day to further the cause - besides donating."
                  "\n\n(e.g., email/call government officials, attend protest, spread awareness via social media)",
            ),
            verticalSpaceSmall,
            singleLineTextField(
              controller: action0,
              hintText: "Task 01",
            ),
            verticalSpaceSmall,
            singleLineTextField(
              controller: descriptor0,
              hintText: "Description",
            ),
            verticalSpaceMedium,
            singleLineTextField(
              controller: action1,
              hintText: "Task 02",
            ),
            verticalSpaceSmall,
            singleLineTextField(
              controller: descriptor1,
              hintText: "Description",
            ),
            verticalSpaceMedium,
            singleLineTextField(
              controller: action2,
              hintText: "Task 03",
            ),
            verticalSpaceSmall,
            singleLineTextField(
              controller: descriptor2,
              hintText: "Description",
            ),
            verticalSpaceLarge,
            CustomButton(
              text: "Submit",
              textSize: 16,
              textColor: appFontColor(),
              height: 40,
              width: 300,
              backgroundColor: appButtonColor(),
              elevation: 2,
              isBusy: false,
              onPressed: () {
                model.updateChecklist(causeID, [action0.text, action1.text, action2.text], [descriptor0.text, descriptor1.text, descriptor2.text]);
              },
            )
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditChecklistViewModel>.reactive(
      viewModelBuilder: () => EditChecklistViewModel(),
      onModelReady: initialize(context),
      builder: (context, model, child) => Container(
        child: checkListItems(model),
      ),
    );
  }
}
