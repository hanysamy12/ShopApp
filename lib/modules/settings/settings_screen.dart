import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/cubit.dart';
import 'package:shop_app/cubit/states.dart';
import 'package:shop_app/modules/login/login_cubit/login_cubit.dart';
import '../../shared/components/components.dart';
import '../login/login_cubit/login_states.dart';

class SettingsScreen extends StatelessWidget {
   SettingsScreen({super.key});
var formKey= GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var emailController = TextEditingController();
    var phoneController = TextEditingController();
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        if (cubit.usrDataModel != null) {
          nameController.text = cubit.usrDataModel!.data!.name!;
          emailController.text = cubit.usrDataModel!.data!.email!;
          phoneController.text = cubit.usrDataModel!.data!.phone!;
        }
        return SingleChildScrollView(
          child: ConditionalBuilder(
            condition: cubit.usrDataModel != null,
            fallback: (BuildContext context) =>
                const Center(child: CircularProgressIndicator()),
            builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(state is ShopLoadingUpdateState)
                      const LinearProgressIndicator(),
                    const SizedBox(height: 20,),
                    defaultFormField(
                      fieldLabel: 'Name',
                      fieldValue: nameController,
                      fieldPreIcon: Icons.person,
                      validate: (String? value){
                        if(value!.isEmpty)
                          {return 'Enter Your Name';}
                        else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    defaultFormField(
                      fieldLabel: 'Email Address',
                      fieldValue: emailController,
                      fieldPreIcon: Icons.mail,
                      validate: (String? value){
                        if(value!.isEmpty)
                        {return 'Enter Your Email';}
                        else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    defaultFormField(
                      fieldLabel: 'Phone',
                      fieldValue: phoneController,
                      fieldPreIcon: Icons.phone,
                      validate: (String? value){
                        if(value!.isEmpty)
                        {return 'Enter Your Phone No.';}
                        else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: defaultButton(
          
                            text: 'Update',
                            func: () {
                              if(formKey.currentState!.validate()){
                              cubit.updateUser(
                                  name: nameController.text,
                                  email: emailController.text,
                                  phone: phoneController.text);}
                            },
                            backColor: Colors.red)),
          
          
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Mode',
                          style: TextStyle(fontSize: 30),
                        ),
                        const Spacer(),
                        BlocConsumer<LoginCubit, LoginStates>(
                          listener: (context, state) {},
                          builder: (context, state) {
                            LoginCubit cubit = LoginCubit.get(context);
                            return IconButton(
                              onPressed: () {
                                cubit.changeAppMode();
                                // print('isDark in onBoarding = ${(cubit.isDark)}');
                              },
                              icon: const Icon(Icons.brightness_medium_rounded),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                        width: double.infinity,
                        child: defaultButton(
                            text: 'Log Out',
                            func: () {
                              signOut(context);
                            },
                            backColor: Colors.red)),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: defaultButton(
                            text: 'REMOVE ALL DATA',
                            func: () {
                              clearSharedPreference(context);
                            },
                            backColor: Colors.red)),

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
