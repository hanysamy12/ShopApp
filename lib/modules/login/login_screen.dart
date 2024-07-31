import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/home_layout/shop_layout.dart';
import 'package:shop_app/modules/register/register_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import '../../shared/style/colors.dart';
import 'login_cubit/login_cubit.dart';
import 'login_cubit/login_states.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (BuildContext context, LoginStates state) {
        if (state is LoginSuccessState) {
          if (state.loginModel.status!) {
            //print('Message is ${state.loginModel.message}');
            //print('Token is ${state.loginModel.data?.token}');
            CacheHelper.saveData(
                    key: 'token', value: state.loginModel.data?.token)
                .then((value) {
                  token=state.loginModel.data!.token!;
              navigateAndFinish(context, const HomeLayout());
            });
            showToast(
                text: state.loginModel.message ?? '',
                state: ToastStates.success);
          } else {
            //print('Message is ${state.loginModel.message}');
            showToast(
                text: state.loginModel.message ?? '', state: ToastStates.error);
          }
        }
      },
      builder: (BuildContext context, LoginStates state) {
        LoginCubit cubit = LoginCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: defaultColor,
            actions: [
              IconButton(
                onPressed: () {
                  cubit.changeAppMode();
                  // print('isDark in onBoarding = ${(cubit.isDark)}');
                },
                icon: const Icon(Icons.brightness_medium_rounded),
              ),
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Login',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        'Login now to browse our offers',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                          fieldLabel: 'Email Address',
                          kType: TextInputType.emailAddress,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Your Email Address';
                            }
                            return null;
                          },
                          fieldValue: emailController,
                          fieldPreIcon: Icons.email_outlined),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                        fieldLabel: 'Password',
                        kType: TextInputType.visiblePassword,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'Password Is too Short';
                          }
                          return null;
                        },
                        fieldValue: passwordController,
                        fieldPreIcon: Icons.lock_outline_rounded,
                        fieldSufIcon: cubit.passPreIcon,
                        suffixPressed: () {
                          cubit.changePasswordIcon();
                        },
                        isPassword: cubit.isPassword,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ConditionalBuilder(
                        condition: state is! LoginLoadingState,
                        builder: (BuildContext context) => defaultButton(
                            text: 'LOGIN',
                            func: () {
                              if (formKey.currentState!.validate()) {
                                cubit.userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            }),
                        fallback: (BuildContext context) =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Text('Don\'t have an account?'),
                          defaultTextButton(
                              function: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                           RegisterScreen()),
                                );
                              },
                              text: 'register'),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
