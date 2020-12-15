import 'package:flutter/material.dart';
import 'package:go/ui/views/x_reusable_template/view_model.dart';
import 'package:stacked/stacked.dart';

class CheckListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<XViewModel>.reactive(
      viewModelBuilder: () => XViewModel(),
      builder: (context, model, child) => Scaffold(),
    );
  }
}
