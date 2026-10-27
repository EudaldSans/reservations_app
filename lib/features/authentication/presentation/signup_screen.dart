import 'package:reservations_app/app_routes.dart';
import 'package:reservations_app/features/authentication/presentation/auth_controller.dart';
import 'package:reservations_app/widgets/button.dart';
import 'package:reservations_app/widgets/textfield.dart';
import 'package:reservations_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _authController = AuthController();
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
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
              Text(l10n.signup,
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 50,
              ),
              CustomTextField(
                hint: l10n.enterName,
                label: l10n.name,
                controller: _name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.validationEnterName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
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
                isPassword: true,
                controller: _password,
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
              const SizedBox(height: 30),
              CustomButton(
                label: l10n.signup,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _authController.signupUser(
                        context, _name.text, _email.text, _password.text);
                  }
                },
              ),
              const SizedBox(height: 5),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("${l10n.haveAccountPrompt} "),
                InkWell(
                  onTap: () =>
                      AppRoutes.navigateToAndReplace(context, AppRoutes.login),
                  child:
                      Text(l10n.login, style: const TextStyle(color: Colors.red)),
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
