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
import 'package:pikc_app/utils/image_helper.dart';
import 'package:pikc_app/utils/session_helper.dart';
import 'package:pikc_app/utils/theme_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = "/dashboard-screen";
  const DashboardScreen({Key? key}) : super(key: key);
  static Route route() {
    return PageTransition(
      settings: const RouteSettings(name: routeName),
      type: PageTransitionType.fade,
      child: DashboardScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener<OcrBloc, OcrState>(
        listener: (context, state) {
          if (state.ocrStatus == OcrStatus.started) {
            const Center(
              child: CircularProgressIndicator(
                backgroundColor: kColorWhite,
              ),
            );
          }
        },
        child: Scaffold(
            backgroundColor: kScaffoldBackgroundColor,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi, ${SessionHelper.displayName?.split(' ')[0] ?? ' '}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: kColorWhite,
                        fontSize: 30,
                      ),
                    ),
                    Column(
                      children: [
                        const Text(
                          "We are working towards making Pikc more accurate. In upcoming versions, you can expect multiple features including creating customisable lists 📝 , product recommendations 🚀 and scanning nutrition contents based on prescription and diets🍎.",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: kColorWhite,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Got any idea or suggestion? Mail us at ",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: kColorWhite,
                                fontSize: 12,
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
                                  color: kColorWhite,
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
                                height: 90,
                                width: 90,
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
                                    child: const FaIcon(
                                      FontAwesomeIcons.camera,
                                      color: kColorWhite,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Camera",
                              style: TextStyle(color: kColorWhite),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Container(
                                height: 90,
                                width: 90,
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
                                    child: const FaIcon(
                                      FontAwesomeIcons.image,
                                      color: kColorWhite,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Photos",
                              style: TextStyle(color: kColorWhite),
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
                            context
                                .read<AppInitBloc>()
                                .add(AuthLogoutRequested());
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
