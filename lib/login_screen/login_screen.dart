import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:painting_app/customers_screen/customers_screen.dart';
import 'package:painting_app/shared/cache_helper.dart';
import 'package:painting_app/shared/components.dart';

import 'login_cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginErrorState) {
            showToast(
              text: state.error,
              state: ToastStates.ERROR,
            );
          }
          if (state is LoginSuccessState) {
            CacheHelper.saveData(
              key: 'token',
              value: state.uId,
            ).then((value) {
              navigateAndFinish(
                context,
                CustomersScreen(),
              );
            });
          }
        },
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customText(
                            alignment: AlignmentDirectional.centerStart,
                            isBold: true,
                            text: 'تسجيل الدخول',
                            size: 30,
                            color: Colors.cyan,
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          defaultTextFormField(
                            text: 'اسم المستخدم',
                            prefix: Icons.email_outlined,
                            textInputType: TextInputType.emailAddress,
                            controller: emailController,
                            validate: (value) {
                              if (value.isEmpty) {
                                return 'من فضلك ادخل اسم المستخدم';
                              }
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          defaultTextFormField(
                            text: 'كلمة المرور',
                            prefix: Icons.lock_outline,
                            onSuffixPressed: () {
                              //SocialLoginCubit.get(context).changeIcon();
                            },
                            onSubmitted: (value) {
                              if (formKey.currentState!.validate()) {
                                // SocialLoginCubit.get(context).userLogin(
                                //   email: emailController.text,
                                //   password: passwordController.text,
                                // );
                              }
                            },
                            textInputType: TextInputType.visiblePassword,
                            controller: passwordController,
                            validate: (value) {
                              if (value.isEmpty) {
                                return 'من فضلك ادخل كملة المرور';
                              }
                            },
                            isPassword: true,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          ConditionalBuilder(
                            condition: true,
                            //state is! SocialLoginLoadingState,
                            builder: (context) => defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  LoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                              text: 'تسجيل الدخول',
                            ),
                            fallback: (context) => const Center(
                                child: CircularProgressIndicator()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
