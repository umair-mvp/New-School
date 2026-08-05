import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/category_model.dart';
import '../../../models/course_model.dart';
import '../../../models/filter_model.dart';
import '../categories_page/filter_category_page/dynamiclly_filter.dart';
import '../categories_page/filter_category_page/options_filter.dart';
import 'details_course_page.dart';
import '../../../providers/drawer_provider.dart';
import '../../../providers/filter_course_provider.dart';
import '../../../services/guest_service/categories_service.dart';
import '../../../services/guest_service/course_service.dart';
import '../../../widgets/main_widget/home_widget/home_widget.dart';
import '../../../../common/components.dart';
import '../../../../common/common.dart';
import '../../../../common/shimmer_component.dart';
import '../../../../common/utils/app_text.dart';
import '../../../../common/utils/object_instance.dart';
import '../../../../common/utils/tablet_detector.dart';
import '../../../../config/assets.dart';
import '../../../../config/colors.dart';
import '../../../../locator.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<CourseModel> courseData = [];
  List<CourseModel> featuredListData = [];
  bool isLoading = true;
  bool isGrid = true;
  bool hasError = false;
  String errorMessage = '';

  ScrollController scrollController = ScrollController();
  PageController sliderPageController = PageController();
  int currentSliderIndex = 0;

  CategoryModel? category;

  List<CourseModel> data = [];
  List<FilterModel> filters = [];
  @override
  void initState() {
    super.initState();
    getData();
    getFeatured();

    scrollController.addListener(() {
      var min = scrollController.position.pixels;
      var max = scrollController.position.maxScrollExtent;

      if ((max - min) < 300) {
        if (!isLoading) {
          getData();
        }
      }
    });
  }

  Future<void> getData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = '';
    });

    try {
      final newCourseData = await CourseService.getAll(
        offset: courseData.length,
        filterOption: locator<FilterCourseProvider>().filterSelected,
        upcoming: locator<FilterCourseProvider>().upcoming,
        free: locator<FilterCourseProvider>().free,
        discount: locator<FilterCourseProvider>().discount,
        downloadable: locator<FilterCourseProvider>().downloadable,
        sort: locator<FilterCourseProvider>().sort,
        bundle: locator<FilterCourseProvider>().bundleCourse,
        reward: locator<FilterCourseProvider>().rewardCourse,
      );

      if (mounted) {
        setState(() {
          courseData.addAll(newCourseData);
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          hasError = true;
          errorMessage = "An error occurred: $e";
        });
      }
    }
  }

  Future<void> getFeatured() async {
    try {
      final featuredData = await CourseService.featuredCourse();
      if (mounted) {
        setState(() {
          featuredListData = featuredData;
        });
      }
    } catch (e) {
      // Handle error silently for featured courses
    }
  }

  getFilters() async {
    if (category != null) {
      filters = await CategoriesService.getFilters(category!.id!);

      locator<FilterCourseProvider>().filters = filters;

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawerProvider>(
      builder: (context, drawerProvider, _) {
        return directionality(
          child: ClipRRect(
            borderRadius:
                borderRadius(radius: drawerProvider.isOpenDrawer ? 20 : 0),
            child: Scaffold(
              appBar: appbar(
                title: appText.courses,
                leftIcon: AppAssets.menuSvg,
                onTapLeftIcon: () {
                  drawerController.showDrawer();
                },
                isBasket: true,
              ),
              body: _buildBody(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        space(20),

        // Filter buttons section
        Padding(
          padding: padding(),
          child: Row(
            children: [
              // Options button
              Expanded(
                child: button(
                    onTap: () async {
                      var res =
                          await baseBottomSheet(child: const OptionsFilter());

                      if (res != null && res) {
                        data.clear();
                        getData();
                      }
                    },
                    width: getSize().width,
                    height: 48,
                    text: appText.options,
                    bgColor: Colors.transparent,
                    textColor: green77(),
                    borderColor: green77(),
                    iconPath: AppAssets.optionSvg,
                    iconColor: green77(),
                    raduis: 15),
              ),

              space(0, width: 18),

              // Filters button
              Expanded(
                child: button(
                    onTap: () async {
                      if (filters.isNotEmpty) {
                        var res = await baseBottomSheet(
                            child: const DynamicllyFilter());

                        if (res != null && res) {
                          data.clear();
                          getData();
                        }
                      }
                    },
                    width: getSize().width,
                    height: 48,
                    text: appText.filters,
                    bgColor: Colors.transparent,
                    textColor: filters.isEmpty
                        ? green77().withOpacity(.35)
                        : green77(),
                    borderColor: filters.isEmpty
                        ? green77().withOpacity(.35)
                        : green77(),
                    iconColor: filters.isEmpty
                        ? green77().withOpacity(.35)
                        : green77(),
                    iconPath: AppAssets.filterSvg,
                    raduis: 15),
              ),

              space(0, width: 18),

              // Grid/List toggle button
              button(
                onTap: () {
                  setState(() {
                    isGrid = !isGrid;
                  });
                },
                width: 48,
                height: 48,
                text: '',
                iconColor: green77(),
                bgColor: Colors.transparent,
                textColor: Colors.white,
                borderColor: green77(),
                iconPath: isGrid ? AppAssets.gridSvg : AppAssets.listSvg,
                raduis: 15,
              ),
            ],
          ),
        ),

        space(8),

        // Content section
        Expanded(
          child: courseData.isEmpty && featuredListData.isEmpty && !isLoading
              ? emptyState(
                  AppAssets.filterEmptyStateSvg,
                  appText.dataNotFound,
                  appText.dataNotFoundDesc,
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    courseData.clear();
                    featuredListData.clear();
                    await getData();
                    await getFeatured();
                  },
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Featured Courses Section
                        if (featuredListData.isNotEmpty) ...{
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HomeWidget.titleAndMore(
                                appText.featuredClasses,
                                isViewAll: false,
                              ),

                              SizedBox(
                                width: getSize().width,
                                height: 215,
                                child: PageView(
                                  controller: sliderPageController,
                                  onPageChanged: (value) async {
                                    await Future.delayed(
                                        const Duration(milliseconds: 500));
                                    setState(() {
                                      currentSliderIndex = value;
                                    });
                                  },
                                  physics: const BouncingScrollPhysics(),
                                  children: List.generate(
                                    featuredListData.length,
                                    (index) {
                                      return courseSliderItem(
                                          featuredListData[index]);
                                    },
                                  ),
                                ),
                              ),

                              space(18),

                              // Page indicator
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ...List.generate(featuredListData.length,
                                      (index) {
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      width:
                                          currentSliderIndex == index ? 16 : 7,
                                      height: 7,
                                      margin: padding(horizontal: 2),
                                      decoration: BoxDecoration(
                                        color: green77(),
                                        borderRadius: borderRadius(),
                                      ),
                                    );
                                  }),
                                ],
                              ),

                              space(14),
                            ],
                          ),
                        },

                        space(14),

                        // Courses List/Grid
                        SizedBox(
                          width: getSize().width,
                          child: isGrid
                              ? GridView(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    bottom: 40,
                                  ),
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        TabletDetector.isTablet() ? 3 : 2,
                                    mainAxisExtent: 190,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                                  children: List.generate(
                                    (isLoading && courseData.isEmpty)
                                        ? 8
                                        : courseData.length,
                                    (index) {
                                      return (isLoading && courseData.isEmpty)
                                          ? courseItemShimmer()
                                          : courseItem(
                                              courseData[index],
                                              width: getSize().width / 2,
                                              endCardPadding: 0.0,
                                              height: 200.0,
                                              isShowReward: locator<
                                                      FilterCourseProvider>()
                                                  .rewardCourse,
                                            );
                                    },
                                  ),
                                )
                              : ListView(
                                  shrinkWrap: true,
                                  padding: padding(),
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: List.generate(
                                    (isLoading && courseData.isEmpty)
                                        ? 8
                                        : courseData.length,
                                    (index) {
                                      return (isLoading && courseData.isEmpty)
                                          ? courseItemVerticallyShimmer()
                                          : courseItemVertically(
                                              courseData[index],
                                              isShowReward: locator<
                                                      FilterCourseProvider>()
                                                  .rewardCourse,
                                            );
                                    },
                                  ),
                                ),
                        ),

                        // Loading indicator for pagination
                        if (isLoading && courseData.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: green77(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    sliderPageController.dispose();
    super.dispose();
  }
}
