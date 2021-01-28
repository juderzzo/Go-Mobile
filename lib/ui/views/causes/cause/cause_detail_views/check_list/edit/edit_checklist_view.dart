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

class EditChecklistView extends StatefulWidget {
  List actions;
  String creatorId;
  String currentUID;
  String name;
  String causeID;

  EditChecklistView({this.actions, this.creatorId, this.name, this.causeID});

  @override
  _EditChecklistViewState createState() => _EditChecklistViewState();
}

class _EditChecklistViewState extends State<EditChecklistView> {
  List actions;
  String creatorId;
  String currentUID;
  String name;
  String causeID;

  List<DynamicField> dynamicList = [];
  List<String> headers = [];
  List<String> subHeaders = [];
  

  initDynamic() {
    int initLen = actions.length;
    for (int i = 0; i < initLen; i++) {
      dynamicList.add(DynamicField());
    }
  }

  addDynamic(model) {
    if (dynamicList.length < 1) {
      dynamicList = [];
    } else {
      //print(headers.toString());
    }
    setState(() {});
    dynamicList.add(DynamicField());
    

    //print(dynamicList);
    
  }

  _EditChecklistViewState(
      {this.actions, this.creatorId, this.name, this.causeID});

  initialize(BuildContext context) {
    Map<String, dynamic> args = RouteData.of(context).arguments;
    actions = args['actions'];
    creatorId = args['creatorID'];
    currentUID = args['currentUID'];
    name = args['name'];
    causeID = args['causeID'];
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
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            addDynamic(model);
            setState(() {});
          },
          child: new Icon(Icons.add),
        ),
        body: Column(children: [
          Flexible(
            flex: 2,
            child: new ListView(
              
              children: dynamicList,
            ),
          ),
          
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditChecklistViewModel>.reactive(
      viewModelBuilder: () => EditChecklistViewModel(),
      onModelReady: (_) {
        initialize(context);
        initDynamic();
      },
      builder: (context, model, child) => Container(
        child: checkListItems(model),
      ),
    );
  }
}

class DynamicField extends StatelessWidget {
  TextEditingController header = new TextEditingController();
  TextEditingController subHeader = new TextEditingController();

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 48.0, 0.0),
          child: singleLineTextField(
              controller: header,
              hintText: "Header",
              textLimit: 20,
              onChanged: null),
        ),
        Container(
          height: 10,
          child: Row(
            children: [
              Spacer(),
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: null,
                color: Colors.red,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 48.0, 0.0),
          child: singleLineTextField(
              controller: subHeader, hintText: "Subheader", textLimit: 20),
        ),
      ]),
    );
  }
}

Widget singleLineTextField(
    {TextEditingController controller,
    String hintText,
    int textLimit,
    Function onChanged}) {
  return TextFieldContainer(
    child: TextFormField(
      onChanged: onChanged,
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

// Widget textFieldHeader(String header, String subHeader) {
//   return Container(
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Text(
//           header,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: appFontColor(),
//           ),
//         ),
//         SizedBox(height: 4),
//         Text(
//           subHeader,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w300,
//             color: appFontColorAlt(),
//           ),
//         ),
//       ],
//     ),
//   );
// }
