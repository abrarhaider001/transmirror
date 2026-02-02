import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/colors.dart';

class MyAppBarTheme {
  MyAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: MyColors.primaryBackground,
    iconTheme: IconThemeData(color: MyColors.textPrimary, size: 18.0),
    actionsIconTheme: IconThemeData(color: MyColors.textPrimary, size: 18.0),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
}
