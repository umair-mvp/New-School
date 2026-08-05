import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:newschool/app/pages/authentication_page/login_page.dart';
import 'package:newschool/app/providers/drawer_provider.dart';
import 'package:newschool/app/providers/page_provider.dart';
import 'package:newschool/app/services/guest_service/course_service.dart';
import 'package:newschool/app/services/user_service/cart_service.dart';
import 'package:newschool/app/services/user_service/rewards_service.dart';
import 'package:newschool/app/services/user_service/user_service.dart';
import 'package:newschool/app/widgets/main_widget/main_drawer.dart';
import 'package:newschool/app/widgets/main_widget/main_widget.dart';
import 'package:newschool/common/common.dart';
import 'package:newschool/common/data/app_data.dart';
import 'package:newschool/common/data/app_language.dart';
import 'package:newschool/common/database/app_database.dart';
import 'package:newschool/common/utils/app_text.dart';
import 'package:newschool/config/colors.dart';
import 'package:newschool/locator.dart';

import '../../../common/enums/page_name_enum.dart';
import '../../../common/utils/object_instance.dart';
import '../../../config/assets.dart';
import '../../providers/app_language_provider.dart';

class MainPage extends StatefulWidget {
  static const String pageName = '/main';
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late Future<int> future;
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    future = Future<int>(() {
      return 0;
    });

    FlutterNativeSplash.remove();
    locator<DrawerProvider>().isOpenDrawer = false;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      AppDataBase.getCoursesAndSaveInDB();

      addListener();

      try {
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          print('token : $token');
          UserService.sendFirebaseToken(token);
        }
      } catch (e) {
        // APNS token not available on iOS simulators - this is expected
        print('Firebase token error (expected on simulator): $e');
      }
    });

    getData();
  }

  getData() {
    CourseService.getReasons();

    AppData.getAccessToken().then((String value) {
      if (value.isNotEmpty) {
        RewardsService.getRewards();
        CartService.getCart();
        UserService.getAllNotification();
      }
    });
  }

  @override
  void dispose() {
    drawerController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  addListener() {
    drawerController.addListener(() {
      if (locator<DrawerProvider>().isOpenDrawer !=
          drawerController.value.visible) {
        Future.delayed(const Duration(milliseconds: 300)).then((value) {
          if (mounted) {
            locator<DrawerProvider>()
                .setDrawerState(drawerController.value.visible);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      if (Platform.isIOS) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: [SystemUiOverlay.top]);
      }
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (v) {
        if (locator<PageProvider>().page == PageNames.home) {
          MainWidget.showExitDialog();
        } else {
          locator<PageProvider>().setPage(PageNames.home);
        }
      },
      child: Consumer<AppLanguageProvider>(
          builder: (context, languageProvider, _) {
        drawerController = AdvancedDrawerController();
        if (locator<DrawerProvider>().isOpenDrawer) {
          drawerController.showDrawer();
        } else {
          drawerController.hideDrawer();
        }

        addListener();

        return directionality(
            child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: green77(),
          body: AdvancedDrawer(
              key: UniqueKey(),
              backdropColor: Colors.transparent,
              drawer: const MainDrawer(),
              openRatio: .6,
              openScale: .75,
              animationDuration: const Duration(milliseconds: 150),
              animateChildDecoration: false,
              animationCurve: Curves.linear,
              controller: drawerController,
              childDecoration:
                  BoxDecoration(color: Colors.transparent, boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.12),
                    blurRadius: 30,
                    offset: const Offset(0, 10))
              ]),
              rtlOpening: locator<AppLanguage>().isRtl(),

              // background
              backdrop: Container(
                width: getSize().width,
                height: getSize().height,
                color: green63,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    space(60),
                    Image.asset(
                      AppAssets.worldPng,
                      width: getSize().width * .8,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              child:
                  Consumer<PageProvider>(builder: (context, pageProvider, _) {
                return SafeArea(
                  bottom: !kIsWeb && Platform.isAndroid,
                  top: false,
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    resizeToAvoidBottomInset: false,
                    extendBody: true,
                    body: pageProvider.pages[pageProvider.page],
                    bottomNavigationBar: ModernBottomNav(
                      currentPage: pageProvider.page,
                      onPageChanged: (page) {
                        pageProvider.setPage(page);
                      },
                    ),
                  ),
                );
              })),
        ));
      }),
    );
  }
}

class ModernBottomNav extends StatelessWidget {
  final PageNames currentPage;
  final Function(PageNames) onPageChanged;

  const ModernBottomNav({
    Key? key,
    required this.currentPage,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawerProvider>(
      builder: (context, drawerProvider, _) {
        return Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [green77(), green4B],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  PageNames.categories,
                  appText.categories,
                  AppAssets.categorySvg,
                ),
                _buildNavItem(
                  PageNames.providers,
                  appText.instrcutors,
                  AppAssets.instructorsSvg,
                ),
                _buildHomeNavItem(),
                _buildNavItem(
                  PageNames.courses,
                  appText.courses,
                  AppAssets.coursesSvg,
                ),
                _buildNavItem(
                  PageNames.myClasses,
                  appText.myClassess,
                  AppAssets.classesSvg,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(PageNames page, String label, String iconPath) {
    final isSelected = currentPage == page;

    return Expanded(
      child: InkWell(
        onTap: () => onPageChanged(page),
        splashColor: Colors.white.withOpacity(0.1),
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIconData(iconPath),
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.6),
                    size: 24,
                  ),
                ),
              ),
              SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color:
                      isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                  fontSize: isSelected ? 11 : 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeNavItem() {
    final isSelected = currentPage == PageNames.home;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: isSelected ? 1 : 0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -20 * value),
          child: InkWell(
            onTap: () => onPageChanged(PageNames.home),
            customBorder: const CircleBorder(),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isSelected
                      ? [Colors.white, Colors.white.withOpacity(0.9)]
                      : [green77(), green4B],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? Colors.white.withOpacity(0.4)
                        : Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    spreadRadius: isSelected ? 2 : 0,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: isSelected
                      ? Colors.white.withOpacity(0.5)
                      : Colors.white.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.home_rounded,
                color: isSelected ? green77() : Colors.white,
                size: 28,
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getIconData(String iconPath) {
    // Map your SVG paths to Material icons
    // Adjust based on your actual icon assets
    if (iconPath.contains('category')) return Icons.grid_view_rounded;
    if (iconPath.contains('instructors')) return Icons.person_4_rounded;
    if (iconPath.contains('courses')) return Icons.slow_motion_video;
    if (iconPath.contains('classes')) return Icons.school_rounded;
    return Icons.circle;
  }
}
