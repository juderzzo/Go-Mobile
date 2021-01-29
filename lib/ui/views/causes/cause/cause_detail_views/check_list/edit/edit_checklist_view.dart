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
import 'package:go/utils/random_string_generator.dart';
import 'package:stacked/stacked.dart';
import 'edit_checklist_viewmodel.dart';

class EditChecklistView extends StatefulWidget {
  final List arguments;

  EditChecklistView({this.arguments});

  @override
  _EditChecklistViewState createState() =>
      _EditChecklistViewState(arguments: arguments);
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
        header: null,
        subheader: null,
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
      backgroundColor: Colors.white,
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
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 5 / 6,
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
        dynamicList.add(CheckField(
          id: actions[i],
          header: headers[i],
          subheader: subHeaders[i],
          index: i,
          view: this,
        ));
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
    return ViewModelBuilder<EditChecklistViewModel>.nonReactive(
        viewModelBuilder: () => EditChecklistViewModel(),
        onModelReady: initialize(EditChecklistViewModel()),
        createNewModelOnInsert: true,
        builder: (context, model, child) => Container(child: wrapper(model)));
  }
}

class CheckField extends StatelessWidget {
  String id;
  String header;
  String subheader;
  int index;
  _EditChecklistViewState view;

  CheckField({this.id, this.header, this.subheader, this.index, this.view});
  TextEditingController headerController = new TextEditingController();
  TextEditingController subHeaderController = new TextEditingController();

  //we need an index and and id to have the cause
  //CheckField({this.id, this.header, this.subheader, this.index});
  Widget build(BuildContext context) {
    headerController.text = header;
    subHeaderController.text = subheader;
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 10.0, 0.0, 0.0),
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Column(children: [
            Container(
              width: MediaQuery.of(context).size.width * 3 / 4,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                  controller: headerController,
                  onChanged: (leon) {
                    header = headerController.text;
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8.0),
                      hintText: "Action",
                      border: InputBorder.none)),
            ),
            verticalSpaceMedium,
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              width: MediaQuery.of(context).size.width * 3 / 4,
              child: TextFormField(
                onChanged: (leon) {
                    subheader = subHeaderController.text;
                  },
                  controller: subHeaderController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8.0),
                      hintText: "Description",
                      border: InputBorder.none)),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 60.0),
            child: Container(
              height: 40,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.red),
              child: IconButton(
                icon: Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
                onPressed: () {
                  print(this.index);
                  view.remove(this.index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
