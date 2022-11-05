import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pikc_app/blocs/ocr/ocr_bloc.dart';
import 'package:pikc_app/config/extensions/extensions.dart';
import 'package:pikc_app/screens/widgets/widgets.dart';
import 'package:pikc_app/utils/theme_constants.dart';
import 'package:sizer/sizer.dart';

class ResultScreen extends StatelessWidget {
  static const routeName = '/result-screen';
  const ResultScreen({Key? key}) : super(key: key);
  static Route route() {
    return PageTransition(
      settings: const RouteSettings(name: routeName),
      type: PageTransitionType.rightToLeft,
      child: ResultScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OcrBloc, OcrState>(builder: (context, state) {
      if (state.ocrStatus == OcrStatus.failed) {
        return ErrorDialog(content: state.failure.message);
      } else if (state.ocrStatus == OcrStatus.completed) {
        return Scaffold(
          backgroundColor: kColorWhite,
          appBar: AppBar(
            backgroundColor: kGradientEndingColor,
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Center(
                child: FaIcon(Icons.arrow_back_ios_new,
                    size: 13.sp, color: kColorWhite),
              ),
            ),
            title: Text(
              "${state.scannedChemicalsList.length} harmful chemicals",
              style: TextStyle(color: kColorWhite),
            ),
          ),
          body: state.scannedChemicalsList.isNotEmpty
              ? ListView.builder(
                  itemCount: state.scannedChemicalsList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      child: ListTile(
                        title: Text(
                          state.scannedChemicalsList[index].capitalize(),
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                        trailing: FaIcon(
                          FontAwesomeIcons.infoCircle,
                          color: kGradientEndingColor,
                          size: 16.sp,
                        ),
                      ),
                    );
                  })
              : Center(
                  child: Lottie.asset("assets/animations/lottie_success.json",
                      height: 60.h, width: 60.w, repeat: false),
                ),
        );
      }
      return const Center(child: CircularProgressIndicator());
    });
  }
}
