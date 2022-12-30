import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pikc_app/blocs/app_init/app_init_bloc.dart';
import 'package:pikc_app/blocs/ocr/ocr_bloc.dart';
import 'package:pikc_app/screens/history_screen/cubit/history_cubit.dart';
import 'package:pikc_app/screens/screens.dart';
import 'package:pikc_app/screens/widgets/modal_bottom_sheet.dart';
import 'package:pikc_app/screens/widgets/widgets.dart';
import 'package:pikc_app/utils/assets_constants.dart';
import 'package:pikc_app/utils/chemicals_list_constant.dart';
import 'package:pikc_app/utils/image_helper.dart';
import 'package:pikc_app/utils/session_helper.dart';
import 'package:pikc_app/utils/theme_constants.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = "/dashboard-screen";
  DashboardScreen({Key? key}) : super(key: key);
  static Route route() {
    return PageTransition(
      settings: const RouteSettings(name: routeName),
      type: PageTransitionType.fade,
      child: DashboardScreen(),
    );
  }

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with AutomaticKeepAliveClientMixin<DashboardScreen> {
  final List<String> greetingList = [
    "Hello, ${SessionHelper.displayName?.split(' ')[0] ?? ' '} 🙌",
    "Namaste, ${SessionHelper.displayName?.split(' ')[0] ?? ' '} 🙏",
    "Wassup, ${SessionHelper.displayName?.split(' ')[0] ?? ' '} 🤙"
  ];

  @override
  void initState() {
    print(kToxicChemicalsList.toString());
    BlocProvider.of<HistoryCubit>(context).getUserHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state.status == ImageStatus.retrieving) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitWanderingCubes(
                    color: kGradientEndingColor,
                    size: 35.sp,
                  ),
                  const SizedBox(height: 16),
                  Text("Just a moment",
                      style: Theme.of(context).textTheme.subtitle2),
                ],
              ),
            );
          } else if (state.status == ImageStatus.error) {
            return ErrorDialog(content: state.failure.message);
          }
          return Scaffold(
            backgroundColor: kColorWhite,
            body: NestedScrollView(
              physics: NeverScrollableScrollPhysics(),
              // key: PageStorageKey<String>('controllerA'),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    toolbarHeight: 12.9.h,
                    backgroundColor: kGradientStartingColor,
                    elevation: 0,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greetingList[Random().nextInt(3)],
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: kColorWhite,
                                  fontSize: 17.sp),
                        ),
                        SizedBox(height: 8),
                        Text("Welcome To Pikc!",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                ?.copyWith(color: kColorWhite)),
                      ],
                    ),
                    actions: [_ActionInfoButton()],
                  )
                ];
              },
              body: SafeArea(
                child: state.imageModelsList.length != 0
                    ? ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          height: 5.h,
                          thickness: 2,
                        ),
                        shrinkWrap: true,
                        // physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.imageModelsList.length,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                          child: GestureDetector(
                            onTap: () {
                              SessionHelper.isThroughHistory = true;
                              BlocProvider.of<OcrBloc>(context)
                                      .state
                                      .scannedChemicalsList =
                                  state.imageModelsList[index]
                                      .toxicChemicalsList;
                              BlocProvider.of<OcrBloc>(context)
                                  .state
                                  .ocrStatus = OcrStatus.completed;
                              Navigator.of(context)
                                  .pushNamed(ResultScreen.routeName);
                            },
                            child: Card(
                              color: kColorWhite,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: kColorBlack),
                              ),
                              // decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(8),
                              //     border: Border.all(color: kColorBlack),),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(children: [
                                  Text(
                                      DateFormat("EEEE, MMMM d, y").format(state
                                          .imageModelsList[index].datetime
                                          .toDate()),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 16),
                                  CachedNetworkImage(
                                    imageUrl:
                                        state.imageModelsList[index].imageUrl,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: double.infinity,
                                      height: 25.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  state.imageModelsList[index]
                                              .toxicChemicalsList.length !=
                                          0
                                      ? ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: state
                                                      .imageModelsList[index]
                                                      .toxicChemicalsList
                                                      .length >=
                                                  3
                                              ? 3
                                              : state.imageModelsList[index]
                                                  .toxicChemicalsList.length,
                                          shrinkWrap: true,
                                          itemBuilder: ((context, index2) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                        color: kColorBlack)),
                                                child: ListTile(
                                                  title: Text(
                                                    state.imageModelsList[index]
                                                            .toxicChemicalsList[
                                                        index2],
                                                    style: const TextStyle(
                                                        color:
                                                            Colors.redAccent),
                                                  ),
                                                  trailing: FaIcon(
                                                    FontAwesomeIcons.infoCircle,
                                                    color: kGradientEndingColor,
                                                    size: 16.sp,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                        )
                                      : Center(
                                          child: Lottie.asset(
                                              "assets/animations/lottie_success.json",
                                              height: 20.h,
                                              // width: 20.w,
                                              repeat: false),
                                        ),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "No Scans Yet !",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Lottie.asset(
                              "assets/animations/scanning_animation.json",
                              repeat: true),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "Start Scanning ->",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            floatingActionButton: SpeedDial(
              buttonSize: Size(45.sp, 45.sp),
              childrenButtonSize: Size(40.sp, 40.sp),
              icon: Icons.document_scanner,
              activeIcon: Icons.close,
              overlayColor: Colors.black,
              iconTheme: const IconThemeData(color: kColorWhite),
              foregroundColor: Colors.black,
              backgroundColor: kGradientEndingColor,
              spacing: 4,
              children: [
                _speedDialChildMethod(
                  label: 'Camera',
                  child: const FaIcon(
                    FontAwesomeIcons.camera,
                    size: 18,
                    color: kColorWhite,
                  ),
                  onTap: () => _selectScanImage(context, ImageSource.camera),
                ),
                _speedDialChildMethod(
                  label: 'Upload',
                  child: const FaIcon(
                    FontAwesomeIcons.image,
                    size: 18,
                    color: kColorWhite,
                  ),
                  onTap: () => _selectScanImage(context, ImageSource.gallery),
                ),
                _speedDialChildMethod(
                    label: 'Hint',
                    child: const Icon(
                      Typicons.info_outline,
                      size: 18,
                      color: kColorWhite,
                    ),
                    onTap: () {
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
                          title: const Text(
                            "Photo Hint",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: kGradientEndingColor,
                            ),
                          ),
                          content: SizedBox(
                            height: 60.h,
                            width: 80.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                _PhotoHintColumnWidget(
                                  hintText: [
                                    "✅ Sharp",
                                    "✅ Flat surface",
                                    "✅ Straight and well cut",
                                    "✅ English-alphabet",
                                  ],
                                  assetImage: rightScanningImage,
                                ),
                                SizedBox(height: 32),
                                _PhotoHintColumnWidget(
                                  hintText: [
                                    "❌ Blurred",
                                    "❌ Not flat surface",
                                    "❌ Not straight",
                                    "❌ Not cut to contain ingredients only",
                                  ],
                                  assetImage: wrongScanningImage,
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Got It.",
                                  style: TextStyle(
                                    color: kColorBlack,
                                    fontSize: 10.sp,
                                  ),
                                )),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          );
        },
      ),
    );
  }

  SpeedDialChild _speedDialChildMethod(
      {required final String label,
      required final Widget child,
      required final VoidCallback onTap}) {
    return SpeedDialChild(
      label: label,
      child: child,
      backgroundColor: kGradientEndingColor,
      labelStyle: TextStyle(fontSize: 11.sp),
      onTap: onTap,
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
      SessionHelper.currentFile = pickedFile;
      SessionHelper.isThroughHistory = false;
      Navigator.of(context).pushNamed(ResultScreen.routeName);
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class _PhotoHintColumnWidget extends StatelessWidget {
  final List<String> hintText;
  final String assetImage;
  const _PhotoHintColumnWidget({
    Key? key,
    required this.hintText,
    required this.assetImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hintText[0],
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: kColorBlack,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          hintText[1],
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: kColorBlack,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          hintText[2],
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: kColorBlack,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          hintText[3],
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: kColorBlack,
          ),
        ),
        const SizedBox(height: 16),
        Image.asset(
          assetImage,
          scale: 8,
        ),
      ],
    );
  }
}

class _ActionInfoButton extends StatelessWidget {
  const _ActionInfoButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle, border: Border.all(color: kColorWhite)),
        child: IconButton(
          onPressed: () {
            customBottomSheet(
              context,
              Padding(
                padding: const EdgeInsets.only(
                    right: 16.0, left: 16.0, bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      indent: 38.w,
                      endIndent: 38.w,
                      thickness: 2,
                      color: kColorBlack,
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Upcoming Updates",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: 15.5.sp,
                            color: kColorBlack,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "We are working towards making Pikc more accurate by decreasing false positive cases. In upcoming versions, you can expect multiple features including : \n\n• Creating Customisable Allergen Lists 📝 \n\n• Product Recommendations 🚀 and \n\n• Scanning Nutrition Contents Based On Prescription And Diets🍎.",
                      // textAlign: TextAlign,.
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: kColorBlack,
                        fontSize: 10.sp,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "You can report any bug or request any feature from us using buttons below:",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: kColorBlack,
                        fontSize: 10.sp,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kGradientEndingColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Request Feature',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: kColorWhite, fontSize: 11.sp),
                          ),
                          onPressed: () async {
                            const mailUrl = 'mailto:yatendra@pikc.tech';
                            try {
                              await launchUrl(Uri.parse(mailUrl));
                            } catch (e) {
                              await Clipboard.setData(const ClipboardData(
                                  text: 'yatendra@pikc.tech'));
                            }
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kGradientEndingColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Report Bug',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: kColorWhite, fontSize: 11.sp),
                          ),
                          onPressed: () async {
                            const mailUrl = 'mailto:yatendra@pikc.tech';
                            try {
                              await launchUrl(Uri.parse(mailUrl));
                            } catch (e) {
                              await Clipboard.setData(const ClipboardData(
                                  text: 'yatendra@pikc.tech'));
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kGradientEndingColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Logout',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: kColorWhite, fontSize: 11.sp),
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
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
          style: TextButton.styleFrom(foregroundColor: kColorBlack),
          icon: const Icon(
            Typicons.info,
            color: kColorWhite,
          ),
        ),
      ),
    );
  }
}
