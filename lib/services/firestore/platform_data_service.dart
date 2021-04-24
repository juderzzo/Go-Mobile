import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class PlatformDataService {
  CollectionReference appReleaseRef = FirebaseFirestore.instance.collection("app_info");

  Future<bool> isUpdateAvailable() async {
    bool updateAvailable = false;
    String currentVersion = "1.0.0";
    DocumentSnapshot docSnapshot = await appReleaseRef.doc("release_info").get();
    String? releasedVersion = docSnapshot.data()!["versionNumber"];
    bool? versionIsRequired = docSnapshot.data()!["versionIsRequired"];
    if (currentVersion != releasedVersion && versionIsRequired!) {
      updateAvailable = true;
    }
    return updateAvailable;
  }

  Future<String?> getGoogleApiKey() async {
    String? key;
    DocumentSnapshot snapshot = await appReleaseRef.doc('google').get();
    key = Platform.isAndroid ? snapshot.data()!['androidKey'] : snapshot.data()!['iosKey'];
    return key;
  }
}
