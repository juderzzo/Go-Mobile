import 'package:flutter/material.dart';
import 'package:go/ui/views/causes/create_cause/create_cause_view_model.dart';
import 'package:stacked/stacked.dart';

class CreateCauseView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateCauseViewModel>.reactive(
      viewModelBuilder: () => CreateCauseViewModel(),
      builder: (context, model, child) => Scaffold(),
    );
  }
}
