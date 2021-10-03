import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/constants/app_colors.dart';
import 'package:go/constants/custom_colors.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:go/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:go/services/firestore/data/cause_data_service.dart';
import 'package:go/services/firestore/data/post_data_service.dart';
import 'package:go/services/navigation/custom_navigation_service.dart';
import 'package:go/ui/shared/ui_helpers.dart';
import 'package:go/ui/views/base/app_base_view_model.dart';
import 'package:go/ui/widgets/common/custom_progress_indicator.dart';
import 'package:go/ui/widgets/forum_posts/forum_post_block/forum_post_block_view.dart';
import 'package:go/utils/custom_string_methods.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ListCausePostsModel extends BaseViewModel {
  PostDataService _postDataService = locator<PostDataService>();
  CustomBottomSheetService customBottomSheetService =
      locator<CustomBottomSheetService>();
  CustomNavigationService _customNavigationService =
      locator<CustomNavigationService>();
  NavigationService _navigationService = locator<NavigationService>();
  AppBaseViewModel appBaseViewModel = locator<AppBaseViewModel>();
  CauseDataService _causeDataService = locator<CauseDataService>();

  ///HELPERS
  ScrollController scrollController = ScrollController();
  String listKey = "initial-cause-posts-key";

  ///DATA
  late String causeID;
  Future<List<DocumentSnapshot>>? dataResultsLoader;
  List<DocumentSnapshot> dataResults = [];
  GoCause? cause;
  Widget builder = Center(
    child: CircularProgressIndicator(
      color: CustomColors.goGreen,
    )
    ,);

  bool loadingAdditionalData = false;
  bool moreDataAvailable = true;

  int resultsLimit = 30;

  Future<List<DocumentSnapshot>> _initialize(String id) async {
    causeID = id;
    cause = await _causeDataService.getCauseByID(causeID);
    //print("heres1");
    notifyListeners();
    return await loadData();
  }

  Future<void> refreshData() async {
    scrollController.jumpTo(scrollController.position.minScrollExtent);

    //clear previous data
    //dataResults = [];
    loadingAdditionalData = false;
    moreDataAvailable = true;

    notifyListeners();
    //load all data
    await loadData();
  }

  Future<List<DocumentSnapshot>> loadData() async {
    setBusy(true);

    //load data with params
    dataResults = await _postDataService.loadPosts(
      causeID: causeID,
      resultsLimit: resultsLimit,
    );
    
    notifyListeners();
    //print(dataResults);
    setBusy(false);
    return dataResults;
  }

  loadAdditionalData() async {
    //check if already loading data or no more data available
    if (loadingAdditionalData || !moreDataAvailable) {
      return;
    }

    //set loading additional data status
    loadingAdditionalData = true;
    notifyListeners();

    //load additional data
    List<DocumentSnapshot> newResults =
        await _postDataService.loadAdditionalPosts(
      causeID: causeID,
      lastDocSnap: dataResults[dataResults.length - 1],
      resultsLimit: resultsLimit,
    );

    //notify if no more data available
    if (newResults.length == 0) {
      moreDataAvailable = false;
    } else {
      dataResults.addAll(newResults);
    }

    //set loading additional data status
    loadingAdditionalData = false;
    notifyListeners();
  }

  showContentOptions(dynamic content) async {
    String val =
        await customBottomSheetService.showContentOptions(content: content);
    if (val == "deleted content") {
      dataResults.removeWhere((doc) => doc.id == content.id);
      listKey = getRandomString(5);
      notifyListeners();
    }
  }

  navigateToCreatePostView(String id) async {
    if (cause != null) {
      _customNavigationService.navigateToCreateForumPostView(id, "new");
    } else {
      await _causeDataService.getCauseByID(causeID).then((GoCause cause){
        _customNavigationService.navigateToCreateForumPostView(id, "new");
      });
    }
  }

  navigateBack() {
    _navigationService.back();
  }

  initialize(String id){
    notifyListeners();
    builder = FutureBuilder(
      future: _initialize(id),
      builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> snapshot){
        print(snapshot);

        if(snapshot.hasData){
          
          return Container(
                  height: screenHeight(context),
                  color: appBackgroundColor(),
                  child: RefreshIndicator(
                    onRefresh: refreshData,
                    backgroundColor: appBackgroundColor(),
                    child: RefreshIndicator(
                      onRefresh: refreshData,
                      backgroundColor: appBackgroundColor(),
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: scrollController,
                        // key: UniqueKey(),
                        addAutomaticKeepAlives: true,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                          top: 4.0,
                          bottom: 4.0,
                        ),
                        itemCount: dataResults.length + 1,
                        itemBuilder: (context, index) {
                          if (index < dataResults.length) {
                            GoForumPost post;
                            bool displayBottomBorder = true;

                            ///GET POST OBJECT
                            post = GoForumPost.fromMap(dataResults[index].data()!);

                            ///DISPLAY BOTTOM BORDER
                            if ( dataResults.last == dataResults[index]) {
                              displayBottomBorder = false;
                            }
                            return ForumPostBlockView(
                              refreshAction: null,
                              post: post,
                              displayBottomBorder: displayBottomBorder,
                            );
                          } else {
                            if (moreDataAvailable) {
                              WidgetsBinding.instance!.addPostFrameCallback((_) {
                                loadAdditionalData();
                              });
                              return Align(
                                alignment: Alignment.center,
                                child: CustomCircleProgressIndicator(size: 10, color: appActiveColor()),
                              );
                            }
                          }
                          return Container();
                        },
                      ),
                    ),
                  ),
                );
                
        }
        //print(dataResults);
          //print(snapshot.hasError);
          //print(snapshot.data);
          return Center(
            child: CircularProgressIndicator(
              color: CustomColors.goGreen,
            ),
          );
              // model.dataResults == null || model.dataResults.isEmpty ? ZeroStateView(
              //     imageAssetName: "forum",
              //     header: "No Posts Found",
              //     subHeader: "Make the first cause post",
              //     mainActionButtonTitle: "Create Post",
              //     mainAction: () => model.navigateToCreatePostView(causeID),
              //     // secondaryActionButtonTitle: null,
              //     // secondaryAction: null,
              //   )
              // : 
              //  ),
        }
        );
  }
}
