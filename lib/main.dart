import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/cubit.dart';
import 'package:shop_app/layout/home_layout/shop_layout.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/on_boarding/on_boarding.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/bloc_observer.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/style/themes.dart';
import 'modules/login/login_cubit/login_cubit.dart';
import 'modules/login/login_cubit/login_states.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getData(key: 'isDark') ?? false;
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding') ?? false;

  token = CacheHelper.getData(key: 'token') ?? '';
  Widget screenToShow;
  if (onBoarding! == true) {
    if (token.isNotEmpty) {
      //print('Token In Main=$token');
      screenToShow = const HomeLayout();
    } else {
      screenToShow = LoginScreen();
    }
  } else {
    screenToShow = OnBoardingScreen();
  }

  runApp(MyApp(isDark!, screenToShow));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget startScreen;

  const MyApp(this.isDark, this.startScreen, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
       // BlocProvider(create: (context) => ShopCubit()),
        BlocProvider(
          create: (context) => LoginCubit()..changeAppMode(fromShared: isDark),
        ),
        BlocProvider(
          create: (BuildContext context) => ShopCubit()
            ..getHomeData()
            ..getCategoriesData()
            ..getFavorites()
            ..getUserData(),
        ),
      ],
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (BuildContext context, LoginStates state) {},
        builder: (BuildContext context, LoginStates state) {
          LoginCubit cubit = LoginCubit.get(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            //////////////////////dark
            darkTheme: darkTheme,
            themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
            home:
                startScreen, //onBoarding ? LoginScreen() : OnBoardingScreen(),
          );
        },
      ),
    );
  }
}
