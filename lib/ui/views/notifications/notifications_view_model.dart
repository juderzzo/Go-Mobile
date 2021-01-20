import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go/app/locator.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/notification_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NotificationsViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  // DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  SnackbarService _snackbarService = locator<SnackbarService>();
  NotificationDataService _notificationDataService = locator<NotificationDataService>();

  ///HELPER
  ScrollController notificationsScrollController = ScrollController();

  String uid;

  ///DATA RESULTS
  List<DocumentSnapshot> notifResults = [];
  DocumentSnapshot lastNotifDocSnap;

  bool loadingAdditionalNotifications = false;
  bool moreNotificationsAvailable = true;

  bool isReloading = true;
  int resultsLimit = 20;

  initialize() async {
    setBusy(true);
    notificationsScrollController.addListener(() {
      double triggerFetchMoreSize = 0.9 * notificationsScrollController.position.maxScrollExtent;
      if (notificationsScrollController.position.pixels > triggerFetchMoreSize) {
        loadAdditionalNotifications();
      }
    });
    notifyListeners();
    await loadNotifications();
    setBusy(false);
  }

  Future<void> refreshData() async {
    isReloading = true;
    notifResults = [];
    notifyListeners();
    await loadNotifications();
  }

  loadNotifications() async {
    notifResults = await _notificationDataService.loadNotifications(
      uid: uid,
      resultsLimit: resultsLimit,
    );
    isReloading = false;
    notifyListeners();
  }

  loadAdditionalNotifications() async {
    if (loadingAdditionalNotifications || !moreNotificationsAvailable) {
      return;
    }
    loadingAdditionalNotifications = true;
    notifyListeners();
    List<DocumentSnapshot> newResults = await _notificationDataService.loadAdditionalNotifications(
      lastDocSnap: notifResults[notifResults.length - 1],
      resultsLimit: resultsLimit,
      uid: uid,
    );
    if (newResults.length == 0) {
      moreNotificationsAvailable = false;
    } else {
      notifResults.addAll(newResults);
    }
    loadingAdditionalNotifications = false;
    notifyListeners();
  }

  ///NAVIGATION
  navigateBack() {
    _navigationService.back();
  }
}
