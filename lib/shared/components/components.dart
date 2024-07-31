import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/modules/on_boarding/on_boarding.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/style/colors.dart';
import '../../modules/login/login_screen.dart';

//////On Boarding Pass START
void onBoardingPass(context) {
  CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
    navigateAndFinish(context, LoginScreen());
  });
}
///////On Boarding Pass END

//////// Sign Out START
void signOut(context) {
  //print('token in SignOut method before$token');
  CacheHelper.removeData(key: 'token').then((value) {
   // print('token in SignOut method after $token');
    if (value != null) {
      //print('Value is $value');
      navigateAndFinish(context, LoginScreen());
    }
  });
}

void clearSharedPreference(context) {
  CacheHelper.eraseAllData().then((value) {
    navigateAndFinish(
      context,
      OnBoardingScreen(),
    );
  });
}
//////// Sign Out END

/////// Navigation's START
void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false,
    );

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
//////// Navigation's END

/////// Buttons START
Widget defaultTextButton(
        {required Function() function, required String text}) =>
    TextButton(
      onPressed: function,
      child: Text(text.toUpperCase()),
    );

Widget defaultButton({
  required String text,
  Color textColor = Colors.white,
  Color backColor = Colors.cyanAccent,
  required Function() func,
}) =>
    Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            5,
          ),
          color: defaultColor,
        ),
        child: TextButton(
          onPressed: func,
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 25),
          ),
        ));
/////// Buttons END

//////// FormField START
Widget defaultFormField({
  required String fieldLabel,
  required TextEditingController fieldValue,
   IconData? fieldPreIcon,
  TextInputType? kType,
  IconData? fieldSufIcon,
  bool isPassword = false,
  bool readOnly=false,
  String? Function(String?)? onSubmit,
  String? Function(String?)? validate,
  Function()? suffixPressed,

  // required Function val
}) {
  return TextFormField(
    controller: fieldValue,
    keyboardType: kType,
    validator: validate,
    obscureText: isPassword,
    readOnly: readOnly,
    onFieldSubmitted: onSubmit,
    decoration: InputDecoration(
      labelText: fieldLabel,
      border: const OutlineInputBorder(),
      prefixIcon: Icon(fieldPreIcon),
      suffixIcon:
          IconButton(icon: Icon(fieldSufIcon), onPressed: suffixPressed),
    ),
  );
}

//////// FormField END
/////////////Toast START
void showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates { success, error, warning } //////like class

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.success:
      color = Colors.green;
      break;
    case ToastStates.error:
      color = Colors.red;
      break;
    case ToastStates.warning:
      color = Colors.amber;
      break;
  }
  return color;
}
/////////////Toast END

////////////////////////CONSTANTS
String token = '';
