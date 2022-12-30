import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pikc_app/screens/login_screen/cubit/login_cubit.dart';
import 'package:pikc_app/screens/login_screen/otp_screen.dart';
import 'package:pikc_app/utils/session_helper.dart';
import 'package:pikc_app/utils/theme_constants.dart';
import 'package:sizer/sizer.dart';

class PhoneScreen extends StatefulWidget {
  static const routeName = '/phone-screen';
  const PhoneScreen({Key? key}) : super(key: key);
  static Route route() {
    return PageTransition(
      settings: const RouteSettings(name: routeName),
      type: PageTransitionType.rightToLeft,
      child: const PhoneScreen(),
    );
  }

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final TextEditingController _phoneTextController = TextEditingController();
  String countryIsoCode = "+91";

  @override
  void initState() {
    _phoneTextController.addListener(() {
      setState(() {
        _phoneTextController.selection = _phoneTextController.selection
            .copyWith(extentOffset: _phoneTextController.text.length);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    "Welcome to Pikc!",
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: kColorBlack, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 2.5.h),
                  Text(
                    "Insert your phone number to continue",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.grey[800]),
                  ),
                  SizedBox(height: 6.5.h),
                  _phoneField(context),
                  SizedBox(height: 7.5.h),
                  _continueButton(context),
                ],
              ),
            ),
          ),
          Container(
            height: 45.h,
            width: double.infinity,
            color: Colors.grey[100],
            child: _phoneKeypad(),
          )
        ],
      ),
    );
  }

  Padding _phoneKeypad() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: GridView.count(
          childAspectRatio: 2,
          crossAxisCount: 3,
          mainAxisSpacing: 1.5.h,
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
                      if (_phoneTextController.text.isNotEmpty) {
                        _phoneTextController.text =
                            _phoneTextController.text.substring(0, 0);
                      }
                    },
                    onPressed: () {
                      setState(() {
                        _phoneTextController.selection =
                            _phoneTextController.selection.copyWith(
                                extentOffset: _phoneTextController.text.length);
                        if (_phoneTextController.text.isNotEmpty) {
                          _phoneTextController.text = _phoneTextController.text
                              .substring(
                                  0, _phoneTextController.text.length - 1);
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
                        _phoneTextController.selection =
                            _phoneTextController.selection.copyWith(
                                extentOffset: _phoneTextController.text.length);
                        _phoneTextController.text =
                            _phoneTextController.text + "0";
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
                        _phoneTextController.selection =
                            _phoneTextController.selection.copyWith(
                                extentOffset: _phoneTextController.text.length);
                        _phoneTextController.text =
                            _phoneTextController.text + i.toString();
                      });
                    }),
            ]
          ]),
    );
  }

  IntlPhoneField _phoneField(BuildContext context) {
    return IntlPhoneField(
      showCursor: false,
      readOnly: true,
      controller: _phoneTextController,
      cursorColor: Colors.grey[800],
      style: TextStyle(
          color: kColorBlack, fontSize: 12.sp, fontWeight: FontWeight.w600),
      dropdownTextStyle: TextStyle(color: Colors.grey[800], fontSize: 11.sp),
      dropdownIcon: Icon(
        Icons.arrow_drop_down,
        color: Colors.grey[800],
      ),
      initialCountryCode: 'IN',
      disableLengthCheck: true,
      onSaved: (newValue) => countryIsoCode = newValue!.countryISOCode,
      onChanged: (value) {
        if (value.number.length == 10) {
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() {
            countryIsoCode = value.countryISOCode;
          });
        }
      },
      decoration: InputDecoration(
        fillColor: kColorWhite,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[800]!,
            style: BorderStyle.solid,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[800]!,
            style: BorderStyle.solid,
          ),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[800]!,
            style: BorderStyle.solid,
          ),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[800]!,
            style: BorderStyle.solid,
          ),
        ),
        filled: true,
        hintText: "Phone Number",
        hintStyle: TextStyle(color: Colors.grey[800], fontSize: 15.0),
      ),
    );
  }

  Align _continueButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: 7.h,
        child: ElevatedButton(
          onPressed: () {
            SessionHelper.phone = countryIsoCode + _phoneTextController.text;
            BlocProvider.of<LoginCubit>(context)
                .sendOtpOnPhone(phone: SessionHelper.phone!);
            Navigator.of(context).pushNamed(OtpScreen.routeName);
            log(SessionHelper.phone!);
          },
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
  }
}
