import 'package:algolia/algolia.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:go/models/search_results_model.dart';

class AlgoliaSearchService {
  final DocumentReference algoliaDocRef = FirebaseFirestore.instance.collection("app_info").doc("algolia");
  final CollectionReference userDocRef = FirebaseFirestore.instance.collection("users");

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

  Future<List<SearchResult>> searchUsers({@required String searchTerm, @required resultsLimit}) async {
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

  Future<List<GoUser>> queryUsers({@required String searchTerm, @required resultsLimit}) async {
    Algolia algolia = await initializeAlgolia();
    List<GoUser> results = [];
    if (searchTerm != null && searchTerm.isNotEmpty) {
      AlgoliaQuery query = algolia.instance.index('users').setHitsPerPage(resultsLimit).search(searchTerm);
      AlgoliaQuerySnapshot eventsSnapshot = await query.getObjects();
      eventsSnapshot.hits.forEach((snapshot) {
        if (snapshot.data != null) {
          GoUser result = GoUser.fromMap(snapshot.data);
          results.add(result);
        }
      });
    }
    return results;
  }

  Future<List<GoUser>> queryAdditionalUsers({@required String searchTerm, @required int resultsLimit, @required int pageNum}) async {
    Algolia algolia = await initializeAlgolia();
    List<GoUser> results = [];
    if (searchTerm != null && searchTerm.isNotEmpty) {
      AlgoliaQuery query = algolia.instance.index('users').setHitsPerPage(resultsLimit).setPage(pageNum).search(searchTerm);
      AlgoliaQuerySnapshot eventsSnapshot = await query.getObjects();
      eventsSnapshot.hits.forEach((snapshot) {
        if (snapshot.data != null) {
          GoUser result = GoUser.fromMap(snapshot.data);
          results.add(result);
        }
      });
    }
    return results;
  }

  Future<List<SearchResult>> searchCauses({@required String searchTerm, @required resultsLimit}) async {
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

  Future<List<GoCause>> queryCauses({@required String searchTerm, @required resultsLimit}) async {
    Algolia algolia = await initializeAlgolia();
    List<GoCause> results = [];
    if (searchTerm != null && searchTerm.isNotEmpty) {
      AlgoliaQuery query = algolia.instance.index('causes').setHitsPerPage(resultsLimit).search(searchTerm);
      AlgoliaQuerySnapshot eventsSnapshot = await query.getObjects();
      eventsSnapshot.hits.forEach((snapshot) {
        if (snapshot.data != null) {
          GoCause result = GoCause.fromMap(snapshot.data);
          results.add(result);
        }
      });
    }
    return results;
  }

  Future<List<GoCause>> queryAdditionalCauses({@required String searchTerm, @required int resultsLimit, @required int pageNum}) async {
    Algolia algolia = await initializeAlgolia();
    List<GoCause> results = [];
    if (searchTerm != null && searchTerm.isNotEmpty) {
      AlgoliaQuery query = algolia.instance.index('causes').setHitsPerPage(resultsLimit).setPage(pageNum).search(searchTerm);
      AlgoliaQuerySnapshot eventsSnapshot = await query.getObjects();
      eventsSnapshot.hits.forEach((snapshot) {
        if (snapshot.data != null) {
          GoCause result = GoCause.fromMap(snapshot.data);
          results.add(result);
        }
      });
    }
    return results;
  }

  Future<List> getRecentSearchTerms({@required String uid}) async {
    List recentSearchTerms = [];
    DocumentSnapshot snapshot = await userDocRef.doc(uid).get();
    if (snapshot.exists) {
      if (snapshot.data()['recentSearchTerms'] != null) {
        recentSearchTerms = snapshot.data()['recentSearchTerms'].toList(growable: true);
      }
    }
    return recentSearchTerms;
  }

  storeSearchTerm({@required String uid, @required String searchTerm}) async {
    List recentSearchTerms = [];
    DocumentSnapshot snapshot = await userDocRef.doc(uid).get();
    if (snapshot.exists) {
      if (snapshot.data()['recentSearchTerms'] != null) {
        recentSearchTerms = snapshot.data()['recentSearchTerms'].toList(growable: true);
        recentSearchTerms.insert(0, searchTerm);
        if (recentSearchTerms.length > 5) {
          recentSearchTerms.removeLast();
        }
      } else {
        recentSearchTerms.add(searchTerm);
      }
      userDocRef.doc(uid).update({'recentSearchTerms': recentSearchTerms});
    }
  }
}
