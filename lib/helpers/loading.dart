import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'app_colors.dart';

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  LoadingDialog({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Container(
          // color: Colors.transparent,
          width: 65,
          height: 65,
          padding: EdgeInsets.all(12.0),
          child: LoadingIndicator(
            indicatorType: Indicator.circleStrokeSpin,
            color: jagoRed,
          ),
        ),
      ),
    );
  }
}
