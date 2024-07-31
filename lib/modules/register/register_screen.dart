import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/cubit.dart';
import 'package:shop_app/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var phoneController = TextEditingController();
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, state) {
          ShopCubit cubit = ShopCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const Text(
                        'REGISTER',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                          fieldLabel: 'Name',
                          fieldValue: nameController,
                          fieldPreIcon: Icons.person,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Name Is Required';
                            } else {
                              return null;
                            }
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                          fieldLabel: 'Email Address',
                          fieldValue: emailController,
                          fieldPreIcon: Icons.email,
                          kType: TextInputType.emailAddress,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'You Must Add Your Email';
                            } else {
                              return null;
                            }
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                          fieldLabel: 'Password',
                          fieldValue: passwordController,
                          fieldPreIcon: Icons.lock_outline_rounded,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Password Is Too Short';
                            } else {
                              return null;
                            }
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                          fieldLabel: 'Phone',
                          fieldValue: phoneController,
                          fieldPreIcon: Icons.phone,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Phone Number Is Required';
                            } else {
                              return null;
                            }
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      ConditionalBuilder(
                          condition: state is! ShopLoadingRegisterState,
                          fallback: (BuildContext context) =>
                          const Center(child: CircularProgressIndicator()),
                          builder: (BuildContext context) {
                            return defaultButton(
                                text: 'Sign Up',
                                func: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.addNewUser(
                                        name: nameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        phone: phoneController.text);
                                  }
                                });
                          }),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
