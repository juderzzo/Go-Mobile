import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:go/ui/widgets/causes/check_list_item_formdart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/utils/custom_string_methods.dart';
import 'package:stacked/stacked.dart';

import 'edit_checklist_view_model.dart';

class EditChecklistView extends StatefulWidget {
  final List arguments;

  EditChecklistView({this.arguments});

  @override
  _EditChecklistViewState createState() => _EditChecklistViewState(arguments: arguments);
}

class _EditChecklistViewState extends State<EditChecklistView> {
  final List arguments;
  List actions;
  String creatorId;
  String currentUID;
  String name;
  String causeID;
  List<String> headers;
  List<String> subHeaders;
  bool initialized = false;

  _EditChecklistViewState({this.arguments});

  List<CheckField> dynamicList = [];

  addAction() {
    int currentLength = dynamicList.length;
    setState(() {
      dynamicList.add(CheckField(
        id: getRandomString(35),
        header: "",
        subheader: "",
        index: currentLength,
        view: this,
      ));
    });

    //build(context);
  }

  Widget wrapper(model) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addAction,
      ),
      backgroundColor: appBackgroundColor(),
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 70,
        backgroundColor: appBackgroundColor(),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: appIconColor(),
          ),
          onPressed: () {
            model.navigateBack();
          },
        ),
        title: Container(
          height: 39,
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 3 / 4,
            child: ListView.builder(
              itemCount: dynamicList.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) => dynamicList[index],
            ),
          ),
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
              print(causeID);
              model.updateChecklist(dynamicList, causeID);
            },
          )
        ],
      ),
    );
  }

  initialize(EditChecklistViewModel model) {
    if (!initialized) {
      actions = arguments[0];
      creatorId = arguments[1];
      currentUID = arguments[2];
      name = arguments[3];
      causeID = arguments[4];
      headers = arguments[5];
      subHeaders = arguments[6];
      for (int i = 0; i < actions.length; i++) {
        print(i);
        dynamicList.add(
          CheckField(id: actions[i], header: headers[i], subheader: subHeaders[i], index: i, onChangedHeader: null, onChangedSubHeader: null, onDelete: null),
        );
      }
      initialized = true;
    }
  }

  void remove(int index) {
    for (int i = 0; i < dynamicList.length; i++) {
      //first go through all the previous ones and change their indecies
      if (i > index) {
        dynamicList[i].index = dynamicList[i].index - 1;
      }
    }

    dynamicList.removeAt(index);
    setState(() {});
  }

  Widget build(BuildContext context) {
    return ViewModelBuilder<EditChecklistViewModel>.reactive(
        viewModelBuilder: () => EditChecklistViewModel(),
        onModelReady: initialize(EditChecklistViewModel()),
        createNewModelOnInsert: true,
        builder: (context, model, child) => Scaffold(
              //resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    //minHeight: MediaQuery.of(context).size.height,
                    //minWidth: MediaQuery.of(context).size.width,
                    maxHeight: MediaQuery.of(context).size.height,
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: wrapper(model),
                ),
              ),
            ));
  }
}
