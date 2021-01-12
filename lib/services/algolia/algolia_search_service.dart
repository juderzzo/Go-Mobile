import 'package:algolia/algolia.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go/models/search_results_model.dart';

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

  Future<List<SearchResult>> queryUsers({@required String searchTerm, @required resultsLimit}) async {
    Algolia algolia = await initializeAlgolia();
    List<SearchResult> results = [];
    if (searchTerm != null && searchTerm.isNotEmpty) {
      AlgoliaQuery query = algolia.instance.index('users').setHitsPerPage(resultsLimit).search(searchTerm);
      AlgoliaQuerySnapshot eventsSnapshot = await query.getObjects();
      eventsSnapshot.hits.forEach((snapshot) {
        if (snapshot.data != null) {
          SearchResult result = SearchResult(
            id: snapshot.data['id'],
            type: snapshot.data['user'],
            name: snapshot.data['username'],
            additionalData: snapshot.data['profilePicURL'],
          );
          results.add(result);
        }
      });
    }
    return results;
  }

  Future<List<SearchResult>> queryAdditionalUsers({@required String searchTerm, @required int resultsLimit, @required int pageNum}) async {
    Algolia algolia = await initializeAlgolia();
    List<SearchResult> results = [];
    if (searchTerm != null && searchTerm.isNotEmpty) {
      AlgoliaQuery query = algolia.instance.index('users').setHitsPerPage(resultsLimit).setPage(pageNum).search(searchTerm);
      AlgoliaQuerySnapshot eventsSnapshot = await query.getObjects();
      eventsSnapshot.hits.forEach((snapshot) {
        if (snapshot.data != null) {
          SearchResult result = SearchResult(
            id: snapshot.data['id'],
            type: snapshot.data['user'],
            name: snapshot.data['username'],
            additionalData: snapshot.data['profilePicURL'],
          );
          results.add(result);
        }
      });
    }
    return results;
  }

  Future<List<SearchResult>> queryCauses({@required String searchTerm, @required resultsLimit}) async {
    Algolia algolia = await initializeAlgolia();
    List<SearchResult> results = [];
    if (searchTerm != null && searchTerm.isNotEmpty) {
      AlgoliaQuery query = algolia.instance.index('causes').setHitsPerPage(resultsLimit).search(searchTerm);
      AlgoliaQuerySnapshot eventsSnapshot = await query.getObjects();
      eventsSnapshot.hits.forEach((snapshot) {
        if (snapshot.data != null) {
          SearchResult result = SearchResult(
            id: snapshot.data['id'],
            type: snapshot.data['cause'],
            name: snapshot.data['name'],
            additionalData: null,
          );
          results.add(result);
        }
      });
    }
    return results;
  }

  Future<List<SearchResult>> queryAdditionalCauses({@required String searchTerm, @required int resultsLimit, @required int pageNum}) async {
    Algolia algolia = await initializeAlgolia();
    List<SearchResult> results = [];
    if (searchTerm != null && searchTerm.isNotEmpty) {
      AlgoliaQuery query = algolia.instance.index('causes').setHitsPerPage(resultsLimit).setPage(pageNum).search(searchTerm);
      AlgoliaQuerySnapshot eventsSnapshot = await query.getObjects();
      eventsSnapshot.hits.forEach((snapshot) {
        if (snapshot.data != null) {
          SearchResult result = SearchResult(
            id: snapshot.data['id'],
            type: snapshot.data['cause'],
            name: snapshot.data['name'],
            additionalData: null,
          );
          results.add(result);
        }
      });
    }
    return results;
  }
}
