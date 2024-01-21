import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../util/responsive.dart';
import 'login_mv.dart';
import 'widgets/button.dart';
import 'widgets/field.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<LoginMV>(
          builder: (context, data, child) => Form(
            key: data.formKey,
            child: Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (Responsive.isDesktop(context))
                    Expanded(
                      flex: 2,
                      child: Image.asset(
                        "assets/images/takaful_logo.png",
                      ),
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            "assets/images/takaful_logo.png",
                            width: 300,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              'مرحبا بك \n قم بتسجيل الدخول',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          CustomFormField(
                            labelText: data.userText,
                            validator: (value) {
                              return data.emailValidator(value);
                            },
                            onSaved: (value) {
                              data.onSavedEmail(value);
                            },
                          ),
                          CustomFormField(
                            labelText: data.passwordText,
                            validator: (value) {
                              return data.passwordValidator(value);
                            },
                            onSaved: (value) {
                              data.onSavedPassword(value);
                            },
                          ),
                          CustomButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text("  مرحبا بك ",
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold));
  }
}
