import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:go/app/app.locator.dart';
import 'package:go/app/app.router.dart';
import 'package:go/models/go_cause_model.dart';
import 'package:go/models/go_forum_post_model.dart';
import 'package:go/models/go_user_model.dart';
import 'package:stacked_services/stacked_services.dart';

class DynamicLinkService {
  SnackbarService? _snackbarService = locator<SnackbarService>();
  NavigationService? _navigationService = locator<NavigationService>();

  String shareContentPrefix = 'https://appgo.page.link';
  String androidPackageName = 'com.takeoff.Goapp';
  String iosBundleID = 'com.takeoff.Goapp';
  String iosAppStoreID = '1543627114';

  Future<String> createProfileLink({required GoUser user}) async {
    //set uri
    Uri postURI = Uri.parse('https://appgo.page.link/profile?id=${user.id}');

    //set dynamic link params
    final DynamicLinkParameters params = DynamicLinkParameters(
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      uriPrefix: shareContentPrefix,
      link: postURI,
      androidParameters: AndroidParameters(
        packageName: androidPackageName,
      ),
      iosParameters: IosParameters(
        bundleId: iosBundleID,
        appStoreId: iosAppStoreID,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: "Checkout ${user.username}'s account on Go!",
        description: user.bio != null ? user.bio : null,
        imageUrl: user.profilePicURL != null ? Uri.parse(user.profilePicURL!) : null,
      ),
    );

    ShortDynamicLink shortDynamicLink = await params.buildShortLink();
    Uri dynamicURL = shortDynamicLink.shortUrl;

    return dynamicURL.toString();
  }

  Future<String> createPostLink({required String postAuthorUsername, required GoForumPost post}) async {
    //set post uri

    Uri postURI = Uri.parse('https://appgo.page.link/post?id=${post.id}');

    //set dynamic link params
    final DynamicLinkParameters params = DynamicLinkParameters(
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short),
      uriPrefix: shareContentPrefix,
      link: postURI,
      androidParameters: AndroidParameters(
        packageName: androidPackageName,
      ),
      iosParameters: IosParameters(
        bundleId: iosBundleID,
        appStoreId: iosAppStoreID,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: "Checkout $postAuthorUsername's post on Go!",
        description: post.body!.length > 200 ? post.body!.substring(0, 190) + "..." : post.body,
        imageUrl: null,
        //imageUrl: post.imageURL != null ? Uri.parse(post.imageURL) : null,
      ),
    );

    ShortDynamicLink shortDynamicLink = await params.buildShortLink();
    Uri dynamicURL = shortDynamicLink.shortUrl;
    print(dynamicURL);
    return dynamicURL.toString();
  }

  Future<String> createCauseLink({required GoCause cause}) async {
    //set uri
    Uri uri = Uri.parse('https://appgo.page.link/cause?id=${cause.id}');

    //set dynamic link params
    final DynamicLinkParameters params = DynamicLinkParameters(
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short),
      uriPrefix: shareContentPrefix,
      link: uri,
      androidParameters: AndroidParameters(
        packageName: androidPackageName,
      ),
      iosParameters: IosParameters(
        bundleId: iosBundleID,
        appStoreId: iosAppStoreID,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: "Checkout the cause ${cause.name} on Go!",
        description: null,
        imageUrl: Uri.parse(cause.imageURLs!.first),
        //imageUrl: post.imageURL != null ? Uri.parse(post.imageURL) : null,
      ),
    );

    ShortDynamicLink shortDynamicLink = await params.buildShortLink();
    Uri dynamicURL = shortDynamicLink.shortUrl;

    return dynamicURL.toString();
  }

  Future handleDynamicLinks() async {
    // get dynamic link on app open
    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDynamicLink(data);

    // get dynamic link if app already running
    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData? linkData) async {
      _handleDynamicLink(linkData);
    }, onError: (OnLinkErrorException err) async {
      _snackbarService!.showSnackbar(
        title: 'App Link Error',
        message: err.message!,
        duration: Duration(seconds: 5),
      );
    });
  }

  void _handleDynamicLink(PendingDynamicLinkData? linkData) {
    final Uri? link = linkData?.link;
    if (link != null) {
      String? id = link.queryParameters['id'];

      if (link.pathSegments.contains('post')) {
        _navigationService!.navigateTo(Routes.ForumPostViewRoute(id: id));
      }
      if (link.pathSegments.contains('cause')) {
        _navigationService!.navigateTo(Routes.CauseViewRoute(id: id));
      } else {
        _snackbarService!.showSnackbar(
          title: 'App Link Error',
          message: 'There was an issues loading the desired link',
          duration: Duration(seconds: 5),
        );
      }
    }
  }
}
