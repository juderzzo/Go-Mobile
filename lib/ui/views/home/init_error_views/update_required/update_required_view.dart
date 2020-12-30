import 'package:flutter/material.dart';
import 'package:go/ui/views/home/init_error_views/update_required/update_required_view_model.dart';
import 'package:stacked/stacked.dart';

class UpdateRequiredView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UpdateRequiredViewModel>.reactive(
      viewModelBuilder: () => UpdateRequiredViewModel(),
      builder: (context, model, child) => Scaffold(),
    );
  }
}
