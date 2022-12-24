import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pikc_app/screens/login_screen/cubit/login_cubit.dart';
import 'package:pikc_app/screens/login_screen/phone_screen.dart';
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

  static Route route() {
    return PageTransition(
      settings: const RouteSettings(name: routeName),
      type: PageTransitionType.fade,
      child: LoginScreen(),
    );
  }

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
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage(pikcBackgroundImage),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), BlendMode.dstATop),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Image.asset(
                  pikcLogoImage,
                  filterQuality: FilterQuality.high,
                  scale: 1.8,
                ),
                SizedBox(height: 30),
                Text(
                  "Make Right Choices\n\nFor Your Health !",
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: kColorWhite, fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    SizedBox(
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(PhoneScreen.routeName);
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0)),
                            padding: const EdgeInsets.all(0.0)),
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth: size.width * 0.75, minHeight: 50.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: kColorWhite,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Continue with Phone',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(color: kGradientEndingColor),
                              ),
                              const Center(
                                child: FaIcon(
                                  FontAwesomeIcons.phone,
                                  color: kGradientEndingColor,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),
                    // const Text('or', style: TextStyle(color: kColorWhite)),
                    // const SizedBox(height: 15),
                    StandardButton(
                        size: size,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Continue with Google',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(color: kColorWhite),
                            ),
                            const Center(
                              child: FaIcon(
                                FontAwesomeIcons.google,
                                color: kColorWhite,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          BlocProvider.of<LoginCubit>(context)
                              .logInWithGoogle();
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
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
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
      ),
    );
  }
}
