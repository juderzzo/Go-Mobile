import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/search/admins_search/admins_search_view.dart';
import 'package:go/ui/views/search/search_view.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';
import 'package:go/ui/widgets/common/custom_text.dart';
import 'package:go/ui/widgets/common/text_field/text_field_header.dart';
import 'package:go/ui/widgets/common/zero_state_view.dart';
import 'package:go/ui/widgets/list_builders/list_check_list_items.dart';
import 'package:go/ui/widgets/list_builders/list_user_search_results.dart';
import 'package:go/ui/widgets/navigation/app_bar/custom_app_bar.dart';
import 'package:go/ui/widgets/search/search_result_view.dart';
import 'package:stacked/stacked.dart';

import 'adminviewmodel.dart';

class AdminView extends StatelessWidget {
  
  final GoCause cause; 
  bool admin;
  ScrollController scrollController;
  
  AdminView({this.cause, this.admin});

  


  Widget Stats({int index, String title, AdminViewModel model}){
    bool show = (index == 0 && model.showMoney) || (index == 1 && model.showAdmins) || (index == 2 && model.showFollowers);
    return Container(
      color: appBackgroundColor(),
      child: 
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
          Text(title, style: TextStyle(
            fontSize: 24 ),),
          Spacer(),
          IconButton(icon:  !show ? Icon(Icons.arrow_left) : Icon(Icons.arrow_drop_down), onPressed: (){model.showTake(index, model);})
        ],
        ),
      ),);
  }

  

//the add admin will dirctly alter the firebase first, then it will pull in the current admins
  Widget Admins(){
    return AdminSearchView(cause: cause, );
  }

  Widget listAdminResults(AdminViewModel model){
    //print(model.userResults[0].type);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        
        ListUsersSearchResults(
          results: model.currentAdmins,
          scrollController: null,
          isScrollable: false,
          onSearchTermSelected: (val){
            model.navigateToUserView(val);},
          removeAdmin: (){},
          cause: cause,
        ),
      ],
    );
  }

  
        
  
bool initialized = false;
  @override
  Widget build(BuildContext context) {
    
    return ViewModelBuilder<AdminViewModel>.reactive(
      onModelReady: (model) => model.initialize(cause, admin),
      viewModelBuilder: () => AdminViewModel(),
      builder: (context, model, child) {
        //model.initialize(cause);
        //  new Timer.periodic(Duration(seconds: 10), (Timer t){
        //    model.initialize(cause);
        //    model.updateAdmins(cause);
        //    print("chi");
        //  });
        return Scaffold(
        backgroundColor: appBackgroundColor(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: 
            Column(
              children: [
                ListView(
                  shrinkWrap: true,
                  children: 
                  [

                  Stats(index: 0, title: "Monetization", model: model),
                    //Monetization Columns

                  model.showMoney ? Column(
                    children: [
                    SizedBox(height: 30,),
                    
                    Row(
                      children: [
                        Spacer(),
                        Container(
                          child: Text("Total Ad Views: ", style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: appFontColor(),
                          ),)
                        ),
                        Container(
                          child: Text("${cause.revenue}" , style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode() ? Colors.green[600] : Colors.green,
                          ),)
                        ),
                        Spacer()
                      ],
                    ),

                    verticalSpaceMedium,

                    Row(
                      children: [
                        Spacer(),
                        Container(
                          child: Text("Estimated CPM: ", style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: appFontColor(),
                          ),)
                        ),
                        Container(
                          child: Text("${0.564}" , style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode() ? Colors.green[600] : Colors.green,
                          ),)
                        ),
                        Spacer()
                      ],
                    ),

                    verticalSpaceMedium,


                    Row(
                      children: [
                        Spacer(),
                        Container(
                          child: Text("Total Ad Revenue: ", style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: appFontColor(),
                          ),)
                        ),
                        Container(
                          child: Text("\$${(cause.revenue * 0.564/1000).toStringAsFixed(2)}" , style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode() ? Colors.green[600] : Colors.green,
                          ),)
                        ),
                        Spacer()
                      ],
                    ),

                    SizedBox(height: 10,)


                    ],) : Container(height: 10,),


                    //Now lets deal with the admins

                    Stats(model: model, index: 1, title: "Cause Admins"),
                    model.showAdmins ? Column(
                      children: [

                        Container(
                          height: MediaQuery.of(context).size.height * 1.5/5,
                          width: MediaQuery.of(context).size.width * 5/6,
                          child: Admins()),

                    SizedBox(height: 10,),


                        Row(
                          children: [
                            Spacer(),
                            CustomText(
                                text: "Current Admins",
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.left,
                                fontSize: 24,
                                color: appFontColorAlt(),
                              ),
                            Spacer(flex: 3)
                          ],
                        ),

                        //List all the current Causes Admins
                        listAdminResults(model),
                      ],
                    ) : Container(),
                  ],
                ),
              ],
            ),
          ),)
        );
      }
      
    );
  }
}