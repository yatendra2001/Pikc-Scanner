import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pikc_app/utils/assets_constants.dart';
import 'package:pikc_app/utils/theme_constants.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '\login-screen';
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? mobileNumber;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kScaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Image.asset(
              pikcLogoImage,
              scale: 2.5,
            ),
            SizedBox(height: 10),
            IntlPhoneField(
              style: TextStyle(color: kColorWhite, fontSize: 14.0),
              dropdownTextStyle: TextStyle(color: kColorWhite),
              dropdownIcon: const Icon(
                Icons.arrow_drop_down,
                color: kColorWhite,
              ),
              initialCountryCode: 'IN',
              disableLengthCheck: true,
              onChanged: (value) {
                setState(() {
                  mobileNumber = value.completeNumber;
                });
              },
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: kTextFieldBorderColor,
                    style: BorderStyle.solid,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: kTextFieldBorderColor,
                    style: BorderStyle.solid,
                  ),
                ),
                filled: true,
                labelText: "Phone Number",
                labelStyle: TextStyle(color: kColorWhite, fontSize: 15.0),
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                SizedBox(
                  height: 45.0,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        padding: EdgeInsets.all(0.0)),
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: size.width * 0.65, minHeight: 50.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              kGradientStartingColor,
                              kGradientEndingColor
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0)),
                      child: const Text(
                        'Continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: kColorWhite),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text('or', style: TextStyle(color: kColorWhite)),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _socialLoginButton(
                      faIcon: FontAwesomeIcons.google,
                      onPressed: () {
                        print('google button');
                      },
                    ),
                    _socialLoginButton(
                      faIcon: FontAwesomeIcons.apple,
                      onPressed: () {
                        print('apple button');
                      },
                    ),
                    _socialLoginButton(
                      faIcon: FontAwesomeIcons.facebookF,
                      onPressed: () {
                        print('facebook button');
                      },
                    ),
                    _socialLoginButton(
                      faIcon: FontAwesomeIcons.solidEnvelope,
                      onPressed: () {
                        print('mail button');
                      },
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Divider(
                  indent: size.width * 0.2,
                  endIndent: size.width * 0.2,
                  color: kPhoneNumberTextColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: kColorWhite),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text('SIGN UP',
                            style: TextStyle(color: kTextFieldBorderColor)))
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextButton _socialLoginButton(
      {required IconData faIcon, required VoidCallback onPressed}) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        height: 40.0,
        width: 40.0,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          gradient: LinearGradient(
            colors: [kGradientStartingColor, kGradientEndingColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FaIcon(
            faIcon,
            color: kColorWhite,
            size: 20,
          ),
        ),
      ),
    );
  }
}
