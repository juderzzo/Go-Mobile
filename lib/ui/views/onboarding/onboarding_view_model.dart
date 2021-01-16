import 'dart:io';
import 'package:go/app/locator.dart';
import 'package:go/app/router.gr.dart';
import 'package:go/services/auth/auth_service.dart';
import 'package:go/services/firestore/user_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go/models/go_user_model.dart';

class OnboardingViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  UserDataService _userDataService = locator<UserDataService>();
  final picker = ImagePicker();
  File _selectedImage;

  completeOnboarding(image, bio, interests, inspirations, site) async {
    busy(true);
    String uid = await _authService.getCurrentUserID();
    GoUser user = await _userDataService.getGoUserByID(uid);
    if (image != null) {
      _userDataService.updateProfilePic(uid, image);
    }
    _userDataService.updateGoUser(user);
    // GoUser user = new GoUser(
    //   id: uid,
    //   bio: bio,
    //   interests: interests,

    // );

    //var res = await _userDataService.generateDummyUserFromID(uid);
    busy(false);
    //print(res);
    replaceWithHomeNavView();
  }

  ///NAVIGATION
  replaceWithHomeNavView() {
    _navigationService.replaceWith(Routes.HomeNavViewRoute);
  }
//
// navigateToPage() {
//   _navigationService.navigateTo(PageRouteName);
// }

  //images for getting the profile pic
  Future<void> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    //print(pickedFile);
    _selectedImage = File(pickedFile.path);
    //return _selectedImage;
    notifyListeners();
  }

  File selectedImage() {
    return _selectedImage;
  }
}
