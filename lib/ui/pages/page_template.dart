import 'package:flutter/material.dart';
import 'package:go/page_models/base_model.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

class PageTemplate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BaseModel>.withConsumer(
      viewModelBuilder: () => BaseModel(),
      builder: (context, model, child) => Scaffold(),
    );
  }
}
