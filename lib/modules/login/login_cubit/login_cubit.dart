import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/modules/login/login_cubit/login_states.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/network/remote/end_points.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);
  UserModel? loginModel;

////// Password Start
  IconData passPreIcon = Icons.remove_red_eye;
  bool isPassword = true;

  void changePasswordIcon() {
    passPreIcon = isPassword ? Icons.visibility_off : Icons.remove_red_eye;
    isPassword = !isPassword;
    emit(ChangePasswordIconState());
  }

////// Password end

///// change theme start
  bool isDark = false;

  void changeAppMode({bool? fromShared}) {
    print('fromShared first = $fromShared');
    if (fromShared != null) {
      isDark = fromShared;
      emit(ChangeAppThemeState());
    } else {
      isDark = !isDark;
      CacheHelper.saveData(key: 'isDark', value: isDark).then((value) {
        emit(ChangeAppThemeState());
        print('fromShared After PUT = ${CacheHelper.getData(key: 'isDark')}');
      });
    }
  }

///// change theme end

///////User Login Start
  void userLogin({required String email, required String password}) {
    emit(
        LoginLoadingState()); //// to make condition in conditionalBuilder is false
    DioHelper.postData(url: loginUrl, data: {'email': email, 'password': password})
        .then((value) {
      loginModel = UserModel.fromJson(value.data);
      emit(LoginSuccessState(loginModel!));
    }).catchError((error) {
      print(error.toString());
      emit(LoginErrorState(error.toString()));
    });
  }
///////User Login End
}
