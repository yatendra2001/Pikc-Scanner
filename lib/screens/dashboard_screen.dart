import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pikc_app/blocs/auth/auth_bloc.dart';
import 'package:pikc_app/blocs/ocr/ocr_bloc.dart';
import 'package:pikc_app/utils/image_helper.dart';
import 'package:pikc_app/utils/theme_constants.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = "/dashboard-screen";
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kScaffoldBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: kScaffoldBackgroundColor,
          actions: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: IconButton(
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
                  },
                  icon: Icon(Icons.logout)),
            )
          ],
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          onPressed: () =>
                              _selectScanImage(context, ImageSource.camera),
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
                          onPressed: () =>
                              _selectScanImage(context, ImageSource.gallery),
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
              )
            ],
          ),
        ));
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
    }
  }
}
