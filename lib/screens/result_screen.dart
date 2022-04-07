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
    return BlocConsumer<OcrBloc, OcrState>(listener: (context, state) {
      if (state.ocrStatus == OcrStatus.started ||
          state.scannedChemicalsList.isEmpty) {
        const CircularProgressIndicator();
      } else if (state.ocrStatus == OcrStatus.failed) {
        ErrorDialog(content: state.failure.message);
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: kScaffoldBackgroundColor,
          centerTitle: true,
          title: Text("${state.scannedChemicalsList.length} harmful chemicals"),
        ),
        body: SafeArea(
          child: state.scannedChemicalsList.isNotEmpty
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
                        trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.info_rounded,
                                color: kScaffoldBackgroundColor, size: 30)),
                      ),
                    );
                  })
              : Center(
                  child: Lottie.network(
                      "https://assets7.lottiefiles.com/packages/lf20_oaw8d1yt.json",
                      repeat: false),
                ),
        ),
      );
    });
  }
}