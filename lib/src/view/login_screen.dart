import 'package:get/get.dart';
import 'package:htlib/src/db/config_db.dart';
import 'package:htlib/src/db/htlib_db.dart';
import 'package:htlib/src/utils/regexp_pattern.dart';
import 'package:htlib/src/utils/validator.dart';
import 'package:htlib/src/view/home/home_screen.dart';
import 'package:universal_io/io.dart';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/_internal/page_break.dart';
import 'package:htlib/injection.dart';
import 'package:htlib/src/api/htlib_api.dart';
import 'package:htlib/styles.dart';

class LoginScreen extends StatefulWidget {
  static String route = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();

  void _signIn() async {
    if (_formKey.currentState!.validate() == false) return;

    if (RegExp(RegexPattern.email.toString()).hasMatch(emailController.text)) {
      FirebaseAuthException? e = await HtlibApi().login.signIn(emailController.text, passwordController.text);
      if (e != null) {
        switch (e.code) {
          case "invalid-email":
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Email không hợp lệ")),
            );
            break;
          case "user-not-found":
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Email chưa đăng kí")),
            );
            break;
          case "wrong-password":
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Sai mật khẩu")),
            );
            break;
          default:
        }
      } else {
        await cleanCacheService();
        await putService();
        if (Platform.isAndroid || Platform.isIOS) {
          Get.find<HtlibDb>().config.setFirebaseUser(FirebaseUser(emailController.text, passwordController.text));
        }
        Navigator.popAndPushNamed(context, HomeScreen.route);
      }
    } else if (RegExp(RegexPattern.numericOnly.toString()).hasMatch(emailController.text)) {
      FirebaseAuthException? e =
          await HtlibApi().login.signIn("${emailController.text}@htlib.com", passwordController.text);
      if (e != null) {
        switch (e.code) {
          case "invalid-email":
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Số điện thoại không hợp lệ")),
            );
            break;
          case "user-not-found":
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Số điện thoại chưa đăng kí")),
            );
            break;
          case "wrong-password":
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Sai mật khẩu")),
            );
            break;
          default:
        }
      } else {
        await cleanCacheService();
        await putService();
        if (Platform.isAndroid || Platform.isIOS) {
          Get.find<HtlibDb>().config.setFirebaseUser(FirebaseUser(emailController.text, passwordController.text));
        }
        Navigator.popAndPushNamed(context, HomeScreen.route);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.background),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (PageBreak.defaultPB.isDesktop(context))
            Expanded(
              child: Stack(
                children: [
                  Image(
                    image: AssetImage("assets/images/login.png"),
                    fit: BoxFit.cover,
                    height: double.maxFinite,
                    width: double.maxFinite,
                    color: Theme.of(context).colorScheme.primary,
                    colorBlendMode: BlendMode.dstATop,
                  ),
                  SizedBox(
                    height: 70,
                    child: Container(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                      alignment: Alignment.center,
                      child: Text(
                        "Thư viện Hàn Thuyên",
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Platform.isAndroid ? MediaQuery.of(context).size.width : 400),
            child: Scaffold(
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: Insets.m),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 80,
                          width: 80,
                          child: Image(
                            isAntiAlias: true,
                            image: AssetImage("assets/images/logo.png"),
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'HTLIB',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                    VSpace(Insets.l),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            focusNode: emailFocusNode,
                            validator: emailValidator,
                            onFieldSubmitted: (_) => passwordFocusNode.requestFocus(),
                            decoration: InputDecoration(
                              labelText: "Tài khoản",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          VSpace(Insets.m),
                          TextFormField(
                            controller: passwordController,
                            focusNode: passwordFocusNode,
                            validator: passwordValidator,
                            decoration: InputDecoration(
                              labelText: "Mật khẩu",
                              border: OutlineInputBorder(),
                            ),
                            onFieldSubmitted: (text) {
                              if (text.trim() == '') {
                                emailFocusNode.requestFocus();
                              } else {
                                _signIn();
                              }
                            },
                            obscureText: true,
                          ),
                        ],
                      ),
                    ),
                    VSpace(Insets.l),
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () => _signIn(),
                        child: Text("Đăng nhập"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
