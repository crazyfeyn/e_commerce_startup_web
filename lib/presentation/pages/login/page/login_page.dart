import 'package:e_commerce_startup_web/config/router/navigation_service.dart';
import 'package:e_commerce_startup_web/core/utils/app_enums.dart';
import 'package:e_commerce_startup_web/core/utils/app_styles.dart';
import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:e_commerce_startup_web/presentation/pages/login/viewmodel/login_viewmodel.dart';
import 'package:e_commerce_startup_web/presentation/pages/orders/page/orders_page.dart';
import 'package:e_commerce_startup_web/presentation/widgets/custom_elevated_button.dart';
import 'package:e_commerce_startup_web/presentation/widgets/custom_phone_field.dart';
import 'package:e_commerce_startup_web/presentation/widgets/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const String path = "/login_page";

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();


  void onNavigation(bool value) {
    if(value == false) return;
    NavigationService.go(context, OrdersPage.path);
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => LoginViewmodel(),
      child: Consumer<LoginViewmodel>(
          builder: (_, viewmodel, __) {
            final widget = Container(
              constraints: BoxConstraints(maxWidth: 400),
              alignment: Alignment.center,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      context.tr(LocaleKeys.login_to_admin),
                      style: AppStyles.titleXLSemibold,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    CustomPhoneField(
                      controller: _phoneController,
                      title: context.tr(LocaleKeys.phone_number),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      title: context.tr(LocaleKeys.password_title_field),
                      hintText: context.tr(LocaleKeys.password_hint_field),
                      suffixIcon: viewmodel.obscureText
                          ? CupertinoIcons.eye_slash
                          : CupertinoIcons.eye,
                      onSuffix: viewmodel.changeObscureText,
                      obscureText: viewmodel.obscureText,
                      ctr: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.tr(LocaleKeys.password_error_field_empty);
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    CustomElevatedButton(
                      isLoading: viewmodel.formzStatus.isInProgress,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          final phone = _phoneController.text.trim();
                          final password = _passwordController.text.trim();
                          viewmodel.login(phone, password).then(onNavigation);
                        }
                      },
                      title: context.tr(LocaleKeys.login_btn),
                    ),
                  ],
                ),
              ),
            );

            return Scaffold(
              body: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 600) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [widget],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                      top: 100,
                      left: 16,
                      right: 16,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 32),
                          widget,
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
      ),
    );
  }
}
