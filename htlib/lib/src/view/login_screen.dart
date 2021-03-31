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
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
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
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.6),
                    alignment: Alignment.center,
                    child: Text(
                      "Thư viện Hàn Thuyên",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                )
              ],
            ),
          ),
        ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth:
                  Platform.isAndroid ? MediaQuery.of(context).size.width : 500),
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.m),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform(
                        transform: Matrix4.skewX(-.1),
                        child: SizedBox(
                          height: 70,
                          width: 70,
                          child: Image(
                            isAntiAlias: true,
                            image: AssetImage("assets/images/logo.png"),
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      HSpace(Insets.xl),
                      Text(
                        "Đăng nhập",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                  VSpace(Insets.l),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Tài khoản",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  VSpace(Insets.m),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Mật khẩu",
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  VSpace(Insets.l),
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () async {
                        FirebaseAuthException? e = await HtlibApi()
                            .login
                            .signIn(
                                emailController.text, passwordController.text);
                        if (e != null) {
                          switch (e.code) {
                            case "invalid-email":
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Email không hợp lệ"),
                                ),
                              );
                              break;
                            case "user-not-found":
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Email chưa đăng kí"),
                                ),
                              );
                              break;
                            case "wrong-password":
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Sai mật khẩu"),
                                ),
                              );
                              break;
                            default:
                          }
                        } else {
                          await putService();
                          Navigator.popAndPushNamed(context, HomeScreen.route);
                        }
                      },
                      child: Text("Đăng nhập"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
