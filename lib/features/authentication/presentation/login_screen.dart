import 'package:reservations_app/app_routes.dart';
import 'package:reservations_app/features/authentication/presentation/auth_controller.dart';
import 'package:reservations_app/widgets/button.dart';
import 'package:reservations_app/widgets/textfield.dart';
import 'package:reservations_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authController = AuthController();
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Spacer(),
              Text(l10n.login,
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
              const SizedBox(height: 50),
              CustomTextField(
                hint: l10n.enterEmail,
                label: l10n.email,
                controller: _email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.validationEnterEmail;
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return l10n.validationValidEmail;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: l10n.enterPassword,
                label: l10n.password,
                controller: _password,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.validationEnterPassword;
                  }
                  if (value.length < 6) {
                    return l10n.validationPasswordLength;
                  }
                  return null;
                },
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    final email = _email.text.trim();
                    if (email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.enterEmailToResetPassword)),
                      );
                      return;
                    }
                    _authController.resetPassword(context, email);
                  },
                  child: Text(
                    l10n.forgotPassword,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),

              const SizedBox(height: 30),
              CustomButton(
                label: l10n.login,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _authController.loginUser(context, _email.text, _password.text);
                  }
                },
              ),
              const SizedBox(height: 5),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("${l10n.noAccountPrompt} "),
                InkWell(
                  onTap: () => AppRoutes.navigateTo(context, AppRoutes.signup),
                  child:
                      Text(l10n.signup, style: const TextStyle(color: Colors.red)),
                )
              ]),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
