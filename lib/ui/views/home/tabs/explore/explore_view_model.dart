import 'package:go/app/app.locator.dart';
import 'package:go/services/bottom_sheets/custom_bottom_sheet_service.dart';
import 'package:go/services/navigation/custom_navigation_service.dart';
import 'package:stacked/stacked.dart';

class ExploreViewModel extends BaseViewModel {
  CustomNavigationService customNavigationService = locator<CustomNavigationService>();
  CustomBottomSheetService customBottomSheetService = locator<CustomBottomSheetService>();
}
