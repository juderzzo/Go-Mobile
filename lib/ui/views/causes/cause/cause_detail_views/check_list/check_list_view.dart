import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/causes/cause/cause_detail_views/check_list/check_list_view_model.dart';
import 'package:go/ui/widgets/buttons/custom_button.dart';
import 'package:go/ui/widgets/causes/cause_check_list_item.dart';
import 'package:stacked/stacked.dart';
import 'dart:async';

class CheckListView extends StatefulWidget {
  final List actions;
  //final List descriptors;
  final String creatorId;
  final String currentUID;
  final String name;
  final String causeID;

  //for futurebuilders

  CheckListView({
    this.actions,
    //this.descriptors,
    this.creatorId,
    this.currentUID,
    this.name,
    this.causeID,
  });

  @override
  _CheckListViewState createState() => _CheckListViewState(
      actions: actions,
      creatorId: creatorId,
      currentUID: currentUID,
      name: name,
      causeID: causeID);
}

class _CheckListViewState extends State<CheckListView> {
  final List actions;
  //final List descriptors;
  final String creatorId;
  final String currentUID;
  final String name;
  final String causeID;
  final List actionFutures = [];
  final List checks = [];

  //for futurebuilders

  _CheckListViewState({
    this.actions,
    //this.descriptors,
    this.creatorId,
    this.currentUID,
    this.name,
    this.causeID,
  });

  bool parseBool(string) {
    return string.toLowerCase() == 'true';
  }

  List<Widget> generateChecklist(model, fut) {
    List<Widget> ans = [];
    for (var i = 0; i < fut.length; i++) {
      ans.add(
        FutureBuilder(
            future: fut[i],
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                //print(fut);
                //print(snapshot.data);
                return GestureDetector(
                  onTap: () {
                    if (parseBool(snapshot.data[3])) {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) => AlertDialog(
                          title: Text("Confrimation"),
                          content: Text(
                              "Once you check off an item, it cannot be unchecked. Are you sure you completed this item?"),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: Text(
                                  "No",
                                )),
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                  model.addCheck(snapshot.data[0], currentUID);
                                  print("tapped");
                                  setState(() {});
                                },
                                child: Text(
                                  "Yes",
                                )),
                          ],
                        ),
                      );
                    }
                  },
                  child: CauseCheckListItem(
                    id: snapshot.data[0],
                    isChecked: parseBool(snapshot.data[3]),
                    header: snapshot.data[1],
                    subHeader: snapshot.data[2],
                  ),
                );
              } else {
                return Container(
                  width: 100,
                );
              }
            }),
      );

      ans.add(verticalSpaceMedium);
    }

    ans.add(verticalSpaceMedium);
    ans.add(verticalSpaceLarge);
    ans.add(verticalSpaceLarge);
    creatorId == currentUID
        ? ans.add(CustomButton(
            text: "Edit Checklist",
            textSize: 16,
            textColor: appFontColor(),
            height: 40,
            width: 300,
            backgroundColor: appButtonColor(),
            elevation: 2,
            isBusy: false,
            onPressed: () {
              print(causeID);
              // model.navigateToEdit(actions, descriptors, creatorId,
              //     currentUID, name, causeID);
            },
          ))
        : ans.add(SizedBox(

            ///child: Text(model.userID()),
            ));

    return ans;
  }

  Widget checkListItems(model, List fut) {
    //print(fut);
    //print(creatorId);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        shrinkWrap: true,
        children: generateChecklist(model, fut),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < actions.length; i++) {
      actionFutures.add(
        CheckListViewModel.generateItem(actions[i], currentUID),
      );
    }

    //print(actionFutures);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckListViewModel>.nonReactive(
      viewModelBuilder: () => CheckListViewModel(),
      createNewModelOnInsert: true,
      builder: (context, model, child) => Container(
        child: checkListItems(model, actionFutures),
      ),
    );
  }
}
