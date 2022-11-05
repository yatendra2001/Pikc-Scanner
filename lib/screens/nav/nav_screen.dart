import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pikc_app/screens/screens.dart';
import 'package:pikc_app/screens/nav/bottom_nav_item.dart';
import 'package:pikc_app/screens/widgets/flutter_toast.dart';
import 'package:sizer/sizer.dart';
import 'package:pikc_app/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:pikc_app/utils/theme_constants.dart';

class NavScreen extends StatelessWidget {
  static const String routeName = '/nav';

  NavScreen({Key? key}) : super(key: key);

  static Route route() {
    return PageTransition(
      settings: const RouteSettings(name: routeName),
      type: PageTransitionType.fade,
      child: NavScreen(),
    );
  }

  final Map<BottomNavItem, dynamic> items = {
    BottomNavItem.history: Container(
      height: 42,
      width: 42,
      decoration: BoxDecoration(
          border: Border.all(color: kColorBlack),
          borderRadius: BorderRadius.circular(10)),
      child: const Icon(
        Icons.home_outlined,
        size: 23,
        color: kColorBlack,
      ),
    ),
    BottomNavItem.scan: Container(
      height: 42,
      width: 42,
      decoration: BoxDecoration(
          border: Border.all(color: kColorBlack),
          borderRadius: BorderRadius.circular(10)),
      child: const Icon(
        Icons.add,
        color: kColorBlack,
        size: 23,
      ),
    ),
    BottomNavItem.search: Container(
      height: 42,
      width: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(color: kColorBlack),
          borderRadius: BorderRadius.circular(10)),
      child: const Icon(
        Icons.notifications_none_outlined,
        size: 23,
        color: kColorBlack,
      ),
    )
  };

  final Map<BottomNavItem, dynamic> screens = {
    BottomNavItem.history: HistoryScreen(),
    BottomNavItem.scan: DashboardScreen(),
    BottomNavItem.search: SearchScreen(),
  };
  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      flutterToast(msg: 'press again to exit app');
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xffE5E5E5),
            resizeToAvoidBottomInset: false,
            extendBody: true,
            body: screens[context.read<BottomNavBarCubit>().state.selectedItem],
            bottomNavigationBar: _customisedGoogleBottomNavBar(context, state),
          );
        },
      ),
    );
  }

  _customisedGoogleBottomNavBar(context, BottomNavBarState state) {
    return Container(
      height: 9.4.h,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 0,
            blurRadius: 2,
          ),
        ],
        color: Color(0xffFFFFFF),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.3.w, vertical: 1.h),
        child: GNav(
          haptic: true, // haptic feedback
          tabBorderRadius: 10,
          tabActiveBorder:
              Border.all(color: kColorWhite, width: 1), // tab button border
          tabBorder:
              Border.all(color: Colors.grey, width: 1), // tab button border
          curve: Curves.easeOutExpo, // tab animation curves
          duration: Duration(milliseconds: 300), // tab animation duration
          gap: 16, // the tab button gap between icon and text
          color: Colors.grey[800], // unselected icon color
          activeColor: kColorWhite, // selected icon and text color
          iconSize: 24, // tab button icon size
          textSize: 32.sp,
          tabBackgroundColor:
              kGradientEndingColor, // selected tab background color
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
          selectedIndex: state.selectedItem == BottomNavItem.scan
              ? 0
              : state.selectedItem == BottomNavItem.history
                  ? 1
                  : 2,
          tabs: const [
            GButton(
              icon: Icons.document_scanner_sharp,
              gap: 4,
              text: 'Scan',
              textStyle: TextStyle(color: kColorWhite),
            ),
            GButton(
              icon: Icons.history,
              text: 'History',
              gap: 4,
              textStyle: TextStyle(color: kColorWhite),
            ),
            GButton(
              icon: Icons.search,
              gap: 4,
              text: 'Search',
              textStyle: TextStyle(color: kColorWhite),
            ),
          ],
          onTabChange: (index) {
            if (index == 0) {
              BlocProvider.of<BottomNavBarCubit>(context)
                  .updateSelectedItem(BottomNavItem.scan);
            } else if (index == 1) {
              BlocProvider.of<BottomNavBarCubit>(context)
                  .updateSelectedItem(BottomNavItem.history);
            } else if (index == 2) {
              BlocProvider.of<BottomNavBarCubit>(context)
                  .updateSelectedItem(BottomNavItem.search);
            }
          },
        ),
      ),
    );
  }
}
