import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlgoliaSearchService {
  final DocumentReference algoliaDocRef = FirebaseFirestore.instance.collection("app_info").doc("algolia");

  Future<Algolia> initializeAlgolia() async {
    Algolia algolia;
    String appID;
    String apiKey;
    DocumentSnapshot snapshot = await algoliaDocRef.get();
    appID = snapshot.data()['appID'];
    apiKey = snapshot.data()['apiKey'];
    algolia = Algolia.init(applicationId: appID, apiKey: apiKey);
    return algolia;
  }

  Future<List<Map<String, dynamic>>> queryUsers(String searchTerm) async {
    Algolia algolia = await initializeAlgolia();
    List<Map<String, dynamic>> results = [];
    if (searchTerm != null && searchTerm.isNotEmpty) {
      AlgoliaQuery query = algolia.instance.index('users').search(searchTerm);
      AlgoliaQuerySnapshot eventsSnapshot = await query.getObjects();
      eventsSnapshot.hits.forEach((snapshot) {
        if (snapshot.data['d'] != null) {
          Map<String, dynamic> dataMap = {};
          dataMap['resultType'] = 'user';
          dataMap['resultHeader'] = "@" + snapshot.data['username'];
          dataMap['imageData'] = snapshot.data['profilePicURL'];
          dataMap['key'] = snapshot.data['d']['uid'];
          results.add(dataMap);
        }
      });
    }
    return results;
  }

  Future<List<Map<String, dynamic>>> queryCauses(String searchTerm) async {
    Algolia algolia = await initializeAlgolia();
    List<Map<String, dynamic>> results = [];
    if (searchTerm != null && searchTerm.isNotEmpty) {
      AlgoliaQuery query = algolia.instance.index('events').search(searchTerm);
      AlgoliaQuerySnapshot eventsSnapshot = await query.getObjects();
      eventsSnapshot.hits.forEach((snapshot) {
        if (snapshot.data != null) {
          Map<String, dynamic> dataMap = {};
          dataMap['resultType'] = 'cause';
          dataMap['resultHeader'] = snapshot.data['name'];
          dataMap['key'] = snapshot.data['id'];
          results.add(dataMap);
        }
      });
    }
    return results;
  }
}
