import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:communicast/constants.dart';
import 'package:communicast/utils/colors.dart';
import 'package:communicast/utils/global_variable.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: PageView(
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: Container(
        //margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 15),
        decoration: const BoxDecoration(
          color: AppColors.white,
          // borderRadius: BorderRadius.all(
          //   Radius.circular(18),
          // ),
          border: Border(
            top: BorderSide(
              color: AppColors.greyAccentLine,
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: GNav(
              rippleColor: AppColors.grey[300]!,
              hoverColor: AppColors.grey[100]!,
              gap: 8,
              activeColor: AppColors.white,
              iconSize: 20,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: AppColors.blueAccent,
              color: AppColors.blueAccent,
              textStyle: AppTextStyles.body.copyWith(
                color: AppColors.white,
              ),
              tabBorderRadius: 13,
              tabs: const [
                GButton(
                  icon: Icons.home_rounded,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.location_on_rounded,
                  text: 'iMap',
                ),
                GButton(
                  icon: Icons.person_rounded,
                  text: 'Profile',
                ),
              ],
              selectedIndex: _page,
              onTabChange: navigationTapped,
            ),
          ),
        ),
      ),
      // Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: CupertinoTabBar(
      //     backgroundColor: AppColors.blueAccent,
      //     items: <BottomNavigationBarItem>[
      //       BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.home,
      //           color: (_page == 0) ? primaryColor : secondaryColor,
      //         ),
      //         label: '',
      //         backgroundColor: primaryColor,
      //       ),
      //       // BottomNavigationBarItem(
      //       //     icon: Icon(
      //       //       Icons.search,
      //       //       color: (_page == 1) ? primaryColor : secondaryColor,
      //       //     ),
      //       //     label: '',
      //       //     backgroundColor: primaryColor),
      //       BottomNavigationBarItem(
      //           icon: Icon(
      //             Icons.add_circle,
      //             color: (_page == 1) ? primaryColor : secondaryColor,
      //           ),
      //           label: '',
      //           backgroundColor: primaryColor),
      //       // BottomNavigationBarItem(
      //       //   icon: Icon(
      //       //     Icons.favorite,
      //       //     color: (_page == 3) ? primaryColor : secondaryColor,
      //       //   ),
      //       //   label: '',
      //       //   backgroundColor: primaryColor,
      //       // ),
      //       BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.person,
      //           color: (_page == 2) ? primaryColor : secondaryColor,
      //         ),
      //         label: '',
      //         backgroundColor: primaryColor,
      //       ),
      //     ],
      //     onTap: navigationTapped,
      //     currentIndex: _page,
      //   ),
      // ),
    );
  }
}
