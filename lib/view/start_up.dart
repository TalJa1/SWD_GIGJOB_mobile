

import 'package:flutter/material.dart';
import 'package:gigjob_mobile/viewmodel/startUp_viewmodel.dart';
import 'package:scoped_model/scoped_model.dart';

class StartUpView extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return ScopedModel<StartUpViewModel>(
      model: StartUpViewModel(context: context),
      child: Scaffold(
        body: Container(),
      ),
    );
  }
}