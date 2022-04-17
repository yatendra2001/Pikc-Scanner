import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pikc_app/blocs/app_init/app_init_bloc.dart';
import 'package:pikc_app/blocs/ocr/ocr_bloc.dart';
import 'package:pikc_app/screens/screens.dart';
import 'package:pikc_app/screens/widgets/widgets.dart';
import 'package:pikc_app/utils/image_helper.dart';
import 'package:pikc_app/utils/session_helper.dart';
import 'package:pikc_app/utils/theme_constants.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = "/dashboard-screen";
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
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
                  const Text(
                    "We are working towards making Pikc more accurate, and customisable where you can verify if a product is per your diet or not through the nutritional value given behind it. \n\nUntil then keep yourself safe and healthy. 🥳",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: kColorWhite,
                      fontSize: 12,
                    ),
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
