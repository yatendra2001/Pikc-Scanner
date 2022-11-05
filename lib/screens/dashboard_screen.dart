import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pikc_app/blocs/app_init/app_init_bloc.dart';
import 'package:pikc_app/blocs/ocr/ocr_bloc.dart';
import 'package:pikc_app/screens/screens.dart';
import 'package:pikc_app/screens/widgets/widgets.dart';
import 'package:pikc_app/utils/assets_constants.dart';
import 'package:pikc_app/utils/image_helper.dart';
import 'package:pikc_app/utils/session_helper.dart';
import 'package:pikc_app/utils/theme_constants.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = "/dashboard-screen";
  DashboardScreen({Key? key}) : super(key: key);
  static Route route() {
    return PageTransition(
      settings: const RouteSettings(name: routeName),
      type: PageTransitionType.fade,
      child: DashboardScreen(),
    );
  }

  final List<String> greetingList = [
    "Hello, ${SessionHelper.displayName?.split(' ')[0] ?? ' '} 🙌",
    "Namaste, ${SessionHelper.displayName?.split(' ')[0] ?? ' '} 🙏",
    "Wassup, ${SessionHelper.displayName?.split(' ')[0] ?? ' '} 🤙"
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener<OcrBloc, OcrState>(
        listener: (context, state) {
          if (state.ocrStatus == OcrStatus.started) {
            const Center(
              child: CircularProgressIndicator(
                backgroundColor: kColorBlack,
              ),
            );
          }
        },
        child: Scaffold(
            backgroundColor: kColorWhite,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greetingList[Random().nextInt(3)],
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: kColorBlack,
                                  fontSize: 22.sp),
                        ),
                        SizedBox(height: 8),
                        Text("Welcome To Pikc!",
                            style: Theme.of(context).textTheme.subtitle1),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "We are working towards making Pikc more accurate. In upcoming versions, you can expect multiple features including : \n\n• Creating Customisable Allergen Lists 📝 \n\n• Product Recommendations 🚀 and \n\n• Scanning Nutrition Contents Based On Prescription And Diets🍎.",
                          // textAlign: TextAlign,.
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: kColorBlack,
                            fontSize: 10.sp,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Got any suggestion? Mail us at ",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: kColorBlack,
                                fontSize: 10.sp,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                const url = 'mailto:contact@pikc.tech';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: const Text(
                                "contact@pikc.tech",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                  color: kColorBlack,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Container(
                                height: 80.sp,
                                width: 80.sp,
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        kGradientStartingColor,
                                        kGradientEndingColor
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(7.0)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                    onPressed: () => _selectScanImage(
                                        context, ImageSource.camera),
                                    child: FaIcon(
                                      FontAwesomeIcons.camera,
                                      size: 25.sp,
                                      color: kColorWhite,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Camera",
                              style: TextStyle(color: kColorBlack),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Container(
                                height: 80.sp,
                                width: 80.sp,
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        kGradientStartingColor,
                                        kGradientEndingColor
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(7.0)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                    onPressed: () => _selectScanImage(
                                        context, ImageSource.gallery),
                                    child: FaIcon(
                                      FontAwesomeIcons.image,
                                      size: 25.sp,
                                      color: kColorWhite,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Photos",
                              style: TextStyle(color: kColorBlack),
                            )
                          ],
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: StandardButton(
                          size: MediaQuery.of(context).size,
                          child: const Text(
                            'Logout',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kColorWhite),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) => AlertDialog(
                                backgroundColor: Colors.grey[50],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                      color: kColorBlack, width: 2.0),
                                ),
                                title: Center(
                                  child: Text(
                                    "Are you sure you want to logout?",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: kColorBlack,
                                    ),
                                  ),
                                ),
                                actions: [
                                  OutlinedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        "No",
                                        style: TextStyle(
                                          color: kColorBlack,
                                          fontSize: 10.sp,
                                        ),
                                      )),
                                  OutlinedButton(
                                    onPressed: () {
                                      context
                                          .read<AppInitBloc>()
                                          .add(AuthLogoutRequested());

                                      SessionHelperEmpty();
                                    },
                                    child: Text(
                                      "Yes",
                                      style: TextStyle(
                                          color: kColorBlack, fontSize: 10.sp),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  void _selectScanImage(BuildContext context, ImageSource source) async {
    final pickedFile = await ImageHelper.pickFromSource(
        context: context,
        cropStyle: CropStyle.rectangle,
        title: 'Scan ingredients',
        source: source);
    if (pickedFile != null) {
      BlocProvider.of<OcrBloc>(context)
          .add(UserSendImageFileEvent(file: pickedFile));
      Navigator.of(context).pushNamed(ResultScreen.routeName);
    }
  }
}
