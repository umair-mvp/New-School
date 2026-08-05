import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/course_model.dart';
import '../categories_page/filter_category_page/dynamiclly_filter.dart';
import '../categories_page/filter_category_page/options_filter.dart';
import '../../../providers/filter_course_provider.dart';
import '../../../services/guest_service/course_service.dart';
import '../../../widgets/main_widget/home_widget/home_widget.dart';
import '../../../../common/common.dart';
import '../../../../common/components.dart';
import '../../../../common/shimmer_component.dart';
import '../../../../common/utils/app_text.dart';
import '../../../../common/utils/tablet_detector.dart';
import '../../../../config/assets.dart';
import '../../../../config/colors.dart';
import '../../../../locator.dart';

class DetailsCoursePage extends StatefulWidget {
  static const String pageName = 'details_course_page';

  final CourseModel course;

  const DetailsCoursePage({super.key, required this.course});

  @override
  State<DetailsCoursePage> createState() => _DetailsCoursePageState();
}

class _DetailsCoursePageState extends State<DetailsCoursePage> {
  bool isLoading = false;
  bool isGrid = true;

  List<CourseModel> relatedCourses = [];
  List<CourseModel> featuredListData = [];

  ScrollController scrollController = ScrollController();
  PageController sliderPageController = PageController();
  int currentSliderIndex = 0;

  @override
  void initState() {
    super.initState();
    getRelatedCourses();
    getFeaturedCourses();

    scrollController.addListener(() {
      var min = scrollController.position.pixels;
      var max = scrollController.position.maxScrollExtent;

      if ((max - min) < 300) {
        if (!isLoading) {
          getRelatedCourses();
        }
      }
    });
  }

  getRelatedCourses() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    // Fetch related courses based on current course category
    relatedCourses += await CourseService.getAll(
      offset: relatedCourses.length,
      cat: widget.course.category,
    );

    setState(() {
      isLoading = false;
    });
  }

  getFeaturedCourses() async {
    // Fetch featured courses in the same category
    CourseService.featuredCourse(cat: widget.course.category?.toString())
        .then((value) {
      setState(() {
        featuredListData = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return directionality(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appbar(
          title: widget.course.title ?? appText.courseDetails,
          leftIcon: AppAssets.backSvg,
          onTapLeftIcon: () {
            Navigator.pop(context);
          },
          rightIcon: AppAssets.shareSvg,
          onTapRightIcon: _shareCourse,
          isBasket: true,
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        space(20),

        // Course Details Header Section
        _buildCourseHeader(),

        space(20),

        // Filter buttons (matching filter category page)
        _buildFilterButtons(),

        space(8),

        // Course content and related courses
        Expanded(
          child: _buildCourseContent(),
        ),
      ],
    );
  }

  Widget _buildCourseHeader() {
    return Padding(
      padding: padding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course Image
          _buildCourseImage(),
          space(16),

          // Course Title and Basic Info
          _buildCourseBasicInfo(),
          space(16),

          // Instructor Section
          _buildInstructorSection(),
        ],
      ),
    );
  }

  Widget _buildCourseImage() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: widget.course.image != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.course.image!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage();
                },
              ),
            )
          : _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[300],
      ),
      child: Icon(Icons.video_library, size: 64, color: Colors.grey[500]),
    );
  }

  Widget _buildCourseBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.course.title ?? 'No Title',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        space(12),
        _buildCourseMeta(),
        space(12),
        Text(
          widget.course.description ?? 'No description available',
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Colors.grey[700],
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildCourseMeta() {
    return Row(
      children: [
        _buildMetaItem(Icons.star, '${widget.course.rate ?? 'N/A'}'),
        SizedBox(width: 16),
        _buildMetaItem(Icons.people, '${widget.course.studentsCount ?? 0}'),
        SizedBox(width: 16),
        _buildMetaItem(Icons.access_time, '${widget.course.duration ?? 'N/A'}'),
        if (widget.course.price == 0) ...{
          SizedBox(width: 16),
          _buildMetaItem(Icons.money_off, 'Free'),
        },
      ],
    );
  }

  Widget _buildMetaItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildInstructorSection() {
    return Container(
      padding: padding(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey[300],
            backgroundImage: widget.course.teacher?.avatar != null
                ? NetworkImage(widget.course.teacher!.avatar!)
                : null,
            child: widget.course.teacher?.avatar == null
                ? Icon(Icons.person, color: Colors.grey[500])
                : null,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Instructor',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.course.teacher?.fullName ?? 'Unknown Instructor',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildPriceSection(),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    final bool hasDiscount = widget.course.price != null &&
        widget.course.discountAmount != null &&
        widget.course.discountAmount! > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (hasDiscount)
          Text(
            '\$${widget.course.price}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              decoration: TextDecoration.lineThrough,
            ),
          ),
        Text(
          _getPriceText(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: green50,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButtons() {
    return Padding(
      padding: padding(),
      child: Row(
        children: [
          // Options button
          Expanded(
            child: button(
                onTap: () async {
                  var res = await baseBottomSheet(child: const OptionsFilter());
                  if (res != null && res) {
                    // Refresh related courses if filters changed
                    relatedCourses.clear();
                    getRelatedCourses();
                  }
                },
                width: getSize().width,
                height: 48,
                text: appText.options,
                bgColor: Colors.transparent,
                textColor: green77(),
                borderColor: green77(),
                iconPath: AppAssets.optionSvg,
                raduis: 15),
          ),

          space(0, width: 18),

          // Filters button
          Expanded(
            child: button(
                onTap: () async {
                  var res =
                      await baseBottomSheet(child: const DynamicllyFilter());
                  if (res != null && res) {
                    relatedCourses.clear();
                    getRelatedCourses();
                  }
                },
                width: getSize().width,
                height: 48,
                text: appText.filters,
                bgColor: Colors.transparent,
                textColor: green77(),
                borderColor: green77(),
                iconColor: green77(),
                iconPath: AppAssets.filterSvg,
                raduis: 15),
          ),

          space(0, width: 18),

          // Grid/List toggle
          button(
              onTap: () {
                setState(() {
                  isGrid = !isGrid;
                });
              },
              width: 48,
              height: 48,
              text: '',
              bgColor: Colors.transparent,
              textColor: Colors.white,
              borderColor: green77(),
              iconPath: isGrid ? AppAssets.gridSvg : AppAssets.listSvg,
              raduis: 15)
        ],
      ),
    );
  }

  Widget _buildCourseContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      controller: scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured Courses in same category
          if (featuredListData.isNotEmpty) ...{
            _buildFeaturedSection(),
          },

          // Related Courses
          if (relatedCourses.isNotEmpty || isLoading) ...{
            Padding(
              padding: padding(),
              child:
                  HomeWidget.titleAndMore('Related Courses', isViewAll: false),
            ),
            space(14),
            _buildRelatedCourses(),
          },

          space(110), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding(),
          child: HomeWidget.titleAndMore(appText.featuredClasses,
              isViewAll: false),
        ),

        SizedBox(
          width: getSize().width,
          height: 215,
          child: PageView(
            controller: sliderPageController,
            onPageChanged: (value) async {
              await Future.delayed(const Duration(milliseconds: 500));
              setState(() {
                currentSliderIndex = value;
              });
            },
            physics: const BouncingScrollPhysics(),
            children: List.generate(featuredListData.length, (index) {
              return courseSliderItem(featuredListData[index]);
            }),
          ),
        ),

        space(18),

        // Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(featuredListData.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: currentSliderIndex == index ? 16 : 7,
                height: 7,
                margin: padding(horizontal: 2),
                decoration: BoxDecoration(
                    color: green77(), borderRadius: borderRadius()),
              );
            }),
          ],
        ),

        space(14),
      ],
    );
  }

  Widget _buildRelatedCourses() {
    return SizedBox(
      width: getSize().width,
      child: isGrid
          ? GridView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: TabletDetector.isTablet() ? 3 : 2,
                  mainAxisExtent: 190,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16),
              children: List.generate(
                  (isLoading && relatedCourses.isEmpty)
                      ? 8
                      : relatedCourses.length, (index) {
                return (isLoading && relatedCourses.isEmpty)
                    ? courseItemShimmer()
                    : courseItem(relatedCourses[index],
                        width: getSize().width / 2,
                        endCardPadding: 0.0,
                        height: 200.0,
                        isShowReward: false);
              }),
            )
          : ListView(
              shrinkWrap: true,
              padding: padding(),
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                  (isLoading && relatedCourses.isEmpty)
                      ? 8
                      : relatedCourses.length, (index) {
                return (isLoading && relatedCourses.isEmpty)
                    ? courseItemVerticallyShimmer()
                    : courseItemVertically(relatedCourses[index],
                        isShowReward: false);
              }),
            ),
    );
  }

  String _getPriceText() {
    if (widget.course.price == 0) {
      return 'Free';
    }

    if (widget.course.discountAmount != null &&
        widget.course.discountAmount! > 0) {
      final discountedPrice =
          (widget.course.price ?? 0) - (widget.course.discountAmount ?? 0);
      return '\$$discountedPrice';
    }

    return '\$${widget.course.price ?? '0'}';
  }

  void _shareCourse() {
    // Implement share functionality
    // Share.share('Check out this course: ${widget.course.title}');
  }

  @override
  void dispose() {
    scrollController.dispose();
    sliderPageController.dispose();
    super.dispose();
  }
}
