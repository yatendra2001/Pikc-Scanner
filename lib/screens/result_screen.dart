import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pikc_app/blocs/ocr/ocr_bloc.dart';
import 'package:pikc_app/config/extensions/extensions.dart';
import 'package:pikc_app/screens/widgets/widgets.dart';
import 'package:pikc_app/utils/theme_constants.dart';

class ResultScreen extends StatelessWidget {
  static const routeName = '/result-screen';
  const ResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OcrBloc, OcrState>(builder: (context, state) {
      if (state.ocrStatus == OcrStatus.failed) {
        return ErrorDialog(content: state.failure.message);
      } else if (state.ocrStatus == OcrStatus.completed) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: kScaffoldBackgroundColor,
            centerTitle: true,
            title:
                Text("${state.scannedChemicalsList.length} harmful chemicals"),
          ),
          body: Scaffold(
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
                        ),
                      );
                    })
                : Center(
                    child: Lottie.asset("assets/animations/lottie_success.json",
                        repeat: false),
                  ),
          ),
        );
      }
      return const Center(child: CircularProgressIndicator());
    });
  }
}
