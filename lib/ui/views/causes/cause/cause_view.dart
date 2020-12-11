import 'package:flutter/material.dart';
import 'package:go/ui/views/causes/cause/cause_view_model.dart';
import 'package:stacked/stacked.dart';

class CauseView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CauseViewModel>.reactive(
      viewModelBuilder: () => CauseViewModel(),
      builder: (context, model, child) => Scaffold(),
    );
  }
}
