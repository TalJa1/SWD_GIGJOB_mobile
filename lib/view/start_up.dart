import 'package:flutter/material.dart';
import 'package:gigjob_mobile/viewmodel/startUp_viewmodel.dart';
import 'package:scoped_model/scoped_model.dart';

class StartUpView extends StatefulWidget {
  @override
  _StartUpState createState() => _StartUpState();
}

class _StartUpState extends State<StartUpView> {

  late StartUpViewModel startUpViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startUpViewModel = StartUpViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<StartUpViewModel>(
      model: startUpViewModel,
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(startUpViewModel.loadingWelcome)
              ...[
                Center(
                  child: Image.asset(
                  'assets/images/GigJob.png',
                ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
