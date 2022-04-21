import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pikc_app/screens/login_screen/cubit/login_cubit.dart';
import 'package:pikc_app/screens/widgets/widgets.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:pikc_app/utils/assets_constants.dart';
import 'package:pikc_app/utils/session_helper.dart';
import 'package:pikc_app/utils/theme_constants.dart';
import 'package:timer_button/timer_button.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? mobileNumber;
  String? otp;

  @override
  void initState() {
    SmsAutoFill().listenForCode();
    super.initState();
  }

  void _otpBottomSheet(context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: kScaffoldBackgroundColor,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state.status == LoginStatus.submitting) {
                const Center(child: CircularProgressIndicator());
              }
            },
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: PinFieldAutoFill(
                      autoFocus: true,
                      keyboardType: TextInputType.number,
                      decoration: const UnderlineDecoration(
                        textStyle: TextStyle(fontSize: 20, color: Colors.white),
                        colorBuilder: FixedColorBuilder(Colors.white),
                        lineStrokeCap: StrokeCap.square,
                      ),
                      currentCode: otp,
                      onCodeSubmitted: (code) {},
                      onCodeChanged: (code) {
                        if (code!.length == 6) {
                          otp = code;
                          BlocProvider.of<LoginCubit>(context)
                              .verifyOtp(otp: otp!);
                          FocusScope.of(context).requestFocus(FocusNode());
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: TimerButton(
                      label: 'Resend',
                      onPressed: () {
                        BlocProvider.of<LoginCubit>(context)
                            .sendOtpOnPhone(phone: mobileNumber!);
                      },
                      buttonType: ButtonType.RaisedButton,
                      timeOutInSeconds: 30,
                      activeTextStyle: TextStyle(color: Color(0xFF3A424D)),
                      disabledTextStyle: TextStyle(color: kColorWhite),
                      color: kColorWhite,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) => Scaffold(
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
                  if (value.number.length == 10) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    setState(() {
                      mobileNumber = value.completeNumber;
                    });
                  }
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
              const SizedBox(height: 10),
              Column(
                children: [
                  StandardButton(
                    size: size,
                    child: const Text(
                      'Continue',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kColorWhite),
                    ),
                    onPressed: () {
                      BlocProvider.of<LoginCubit>(context)
                          .sendOtpOnPhone(phone: mobileNumber!);

                      _otpBottomSheet(context);
                    },
                  ),
                  const SizedBox(height: 15),
                  const Text('or', style: TextStyle(color: kColorWhite)),
                  const SizedBox(height: 15),
                  StandardButton(
                      size: size,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            'Continue with google',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kColorWhite),
                          ),
                          Center(
                            child: FaIcon(
                              FontAwesomeIcons.google,
                              color: kColorWhite,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        BlocProvider.of<LoginCubit>(context).logInWithGoogle();
                      }),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "By continuing you agree to our ",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        color: kColorWhite.withOpacity(0.8)),
                  ),
                  GestureDetector(
                    onTap: () async {
                      const url =
                          'https://github.com/yatendra2001/Pikc-Scanner/blob/master/Privacy-Policy.md';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Text(
                      "Privacy Policy",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          color: kColorWhite.withOpacity(0.9)),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
