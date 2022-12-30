import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pikc_app/screens/login_screen/cubit/login_cubit.dart';
import 'package:pikc_app/screens/widgets/timer_button_widget.dart';
import 'package:pikc_app/utils/session_helper.dart';
import 'package:pikc_app/utils/theme_constants.dart';
import 'package:sizer/sizer.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_button/timer_button.dart';

class OtpScreen extends StatefulWidget {
  static const routeName = '/otp-screen';
  const OtpScreen({Key? key}) : super(key: key);
  static Route route() {
    return PageTransition(
      settings: const RouteSettings(name: routeName),
      type: PageTransitionType.rightToLeft,
      child: const OtpScreen(),
    );
  }

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpTextController = TextEditingController();
  _initSmsRetriever() async {
    await SmsAutoFill().listenForCode();
  }

  @override
  void initState() {
    _initSmsRetriever();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginCubit>().state;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 55.h,
            width: double.infinity,
            color: kColorWhite,
            child: Padding(
              padding: EdgeInsets.fromLTRB(6.w, 7.h, 6.w, 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: CircleAvatar(
                      radius: 13.sp,
                      backgroundColor: Colors.grey[100],
                      child: FaIcon(Icons.arrow_back_ios_new,
                          size: 13.sp, color: Colors.grey[700]),
                    ),
                  ),
                  SizedBox(height: 4.5.h),
                  Text(
                    "check your texts 💬",
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: kColorBlack, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 1.5.h),
                  Text(
                    "we've sent you a security code at ${SessionHelper.phone}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.grey[800]),
                  ),
                  SizedBox(height: 6.5.h),
                  _otpField(context),
                  SizedBox(height: 3.h),
                  _didntReceiveCodeMethod(),
                  SizedBox(height: 1.h),
                  state.status == LoginStatus.otpVerifying ||
                          state.status == LoginStatus.success
                      ? Center(
                          child: (Platform.isIOS)
                              ? const CupertinoActivityIndicator(
                                  color: kColorBlack)
                              : const CircularProgressIndicator(
                                  strokeWidth: 2.5, color: kColorBlack),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
          Container(
            height: 45.h,
            width: double.infinity,
            color: Colors.grey[100],
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: GridView.count(
                  childAspectRatio: 2,
                  crossAxisCount: 3,
                  mainAxisSpacing: 2.5.h,
                  crossAxisSpacing: 5.w,
                  children: [
                    for (int i = 1; i < 13; i++) ...[
                      if (i == 10) SizedBox.shrink(),
                      if (i == 12)
                        NumberWidget(
                            numberTile: const Icon(
                              Icons.backspace,
                              color: kColorBlack,
                            ),
                            onLongPress: () {
                              if (_otpTextController.text.isNotEmpty) {
                                _otpTextController.text =
                                    _otpTextController.text.substring(0, 0);
                              }
                            },
                            onPressed: () {
                              setState(() {
                                _otpTextController.selection =
                                    _otpTextController.selection.copyWith(
                                        extentOffset:
                                            _otpTextController.text.length);
                                if (_otpTextController.text.isNotEmpty) {
                                  _otpTextController.text =
                                      _otpTextController.text.substring(0,
                                          _otpTextController.text.length - 1);
                                }
                              });
                            }),
                      if (i == 11)
                        NumberWidget(
                            numberTile: Text(
                              "0",
                              style: TextStyle(
                                  color: kColorBlack,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
                              setState(() {
                                _otpTextController.selection =
                                    _otpTextController.selection.copyWith(
                                        extentOffset:
                                            _otpTextController.text.length);
                                _otpTextController.text =
                                    _otpTextController.text + "0";
                              });
                            }),
                      if (i != 10 && i != 12 && i != 11)
                        NumberWidget(
                            numberTile: Text(
                              i.toString(),
                              style: TextStyle(
                                  color: kColorBlack,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
                              setState(() {
                                _otpTextController.selection =
                                    _otpTextController.selection.copyWith(
                                        extentOffset:
                                            _otpTextController.text.length);
                                _otpTextController.text =
                                    _otpTextController.text + i.toString();
                              });
                            }),
                    ]
                  ]),
            ),
          )
        ],
      ),
    );
  }

  Widget _otpField(BuildContext context) {
    return PinFieldAutoFill(
      controller: _otpTextController,
      decoration: UnderlineDecoration(
        textStyle: TextStyle(fontSize: 10.sp, color: kColorBlack),
        colorBuilder: FixedColorBuilder(kColorBlack.withOpacity(0.6)),
        lineStrokeCap: StrokeCap.round,
      ),
      currentCode: _otpTextController.text,
      onCodeSubmitted: (code) {},
      onCodeChanged: (code) {
        if (_otpTextController.text.length == 6) {
          BlocProvider.of<LoginCubit>(context)
              .verifyOtp(otp: _otpTextController.text);
          FocusScope.of(context).requestFocus(FocusNode());
        }
      },
    );
  }

  Align _continueButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: 7.h,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: const EdgeInsets.all(0.0)),
          child: Container(
            constraints: BoxConstraints(maxWidth: 75.5.w, minHeight: 45),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [kGradientStartingColor, kGradientEndingColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "continue".toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: kColorWhite, letterSpacing: 1),
                  ),
                  CircleAvatar(
                    radius: 13.sp,
                    backgroundColor: kGradientStartingColor,
                    child: FaIcon(Icons.arrow_forward_ios,
                        size: 15.sp, color: kColorWhite),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _didntReceiveCodeMethod() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't get the code? ",
          style: TextStyle(
            fontSize: 10.sp,
          ),
        ),
        // TimerButtonWidget(
        //   onTimerFinished: () {
        //     BlocProvider.of<LoginCubit>(context)
        //         .sendOtpOnPhone(phone: context.read<LoginCubit>().phone);
        //   },
        // ),
        TimerButton(
          label: 'Resend',
          onPressed: () {
            BlocProvider.of<LoginCubit>(context)
                .sendOtpOnPhone(phone: context.read<LoginCubit>().phone);
          },
          timeOutInSeconds: 30,
          disabledColor: kColorWhite,
          color: kColorWhite,
          buttonType: ButtonType.TextButton,
          disabledTextStyle:
              TextStyle(color: kColorBlack.withOpacity(0.8), fontSize: 10.sp),
          activeTextStyle: TextStyle(
            color: kColorBlack,
            fontWeight: FontWeight.w600,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }
}

class NumberWidget extends StatelessWidget {
  final Widget numberTile;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  const NumberWidget({
    Key? key,
    required this.numberTile,
    required this.onPressed,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: kColorBlack),
                borderRadius: BorderRadius.circular(16))),
        onLongPress: onLongPress,
        onPressed: onPressed,
        child: numberTile);
    ;
  }
}
