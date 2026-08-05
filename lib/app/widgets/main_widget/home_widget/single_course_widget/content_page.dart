import 'package:flutter/material.dart';
import '../../../../models/content_model.dart';
import '../../../../models/course_model.dart';
import '../../../../models/single_course_model.dart';
import '../../../../pages/main_page/home_page/assignments_page/assignments_page.dart';
import '../../../../pages/main_page/home_page/quizzes_page/quizzes_page.dart';
import '../../../../pages/main_page/home_page/single_course_page/single_content_page/single_content_page.dart';
import '../../../../../common/common.dart';
import '../../../../../common/components.dart';
import '../../../../../common/enums/error_enum.dart';
import '../../../../../common/utils/app_text.dart';
import '../../../../../common/utils/date_formater.dart';
import '../../../../../config/assets.dart';
import '../../../../../config/colors.dart';
import '../../../../../config/styles.dart';

class ModernExpandableContentPage extends StatefulWidget {
  final SingleCourseModel courseData;
  final List<ContentModel> contents;
  final List<CourseModel> bundleCourses;

  const ModernExpandableContentPage({
    Key? key,
    required this.courseData,
    required this.contents,
    this.bundleCourses = const [],
  }) : super(key: key);

  @override
  State<ModernExpandableContentPage> createState() =>
      _ModernExpandableContentPageState();
}

class _ModernExpandableContentPageState
    extends State<ModernExpandableContentPage> {
  late List<bool> _expandedSections;

  @override
  void initState() {
    super.initState();
    _expandedSections =
        List<bool>.generate(widget.contents.length, (index) => false);
  }

  void _toggleSection(int index) {
    setState(() {
      _expandedSections[index] = !_expandedSections[index];
    });
  }

  // Modern section header
  Widget _buildModernSectionHeader(int index, ContentModel content) {
    final isExpanded = _expandedSections[index];
    final itemCount = content.items?.length ?? 0;
    final completedItems =
        content.items?.where((item) => item.authHasRead ?? false).length ?? 0;
    final progress = itemCount > 0 ? completedItems / itemCount : 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isExpanded ? 0.1 : 0.05),
            blurRadius: isExpanded ? 20 : 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color:
              isExpanded ? green50.withOpacity(0.4) : greyA5.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _toggleSection(index),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            content.title ?? 'Untitled Section',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: grey3A,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$itemCount ${appText.lessons} • $completedItems ${appText.completed}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: grey5E,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: isExpanded
                              ? green50.withOpacity(0.15)
                              : Colors.grey.shade50,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(
                        isExpanded
                            ? Icons.expand_less_rounded
                            : Icons.expand_more_rounded,
                        color: isExpanded ? green50 : Colors.grey.shade600,
                        size: 24,
                      ),
                    ),
                  ],
                ),

                // Progress bar
                const SizedBox(height: 10),
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: MediaQuery.of(context).size.width * progress,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              green9D,
                              green9D,
                              green50,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                ),

                // Progress text
                const SizedBox(height: 8),
                Text(
                  '${(progress * 100).round()}% ${appText.completed}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: green9D,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Modern content items
  Widget _buildModernContentItems(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: List.generate(
          widget.contents[index].items?.length ?? 0,
          (i) {
            final item = widget.contents[index].items![i];
            return modernVerticalChapterItem(
              colorType(item),
              iconType(item),
              item.title ?? '',
              subTitleType(item),
              () => _handleItemTap(item, i, index),
              height: sizeType(item).toDouble(),
              isCompleted: item.authHasRead ?? false,
            );
          },
        ),
      ),
    );
  }

  void _handleItemTap(ContentItem item, int itemIndex, int sectionIndex) {
    if (item.can?.view ?? false) {
      if (item.type == 'assignment') {
        nextRoute(AssignmentsPage.pageName);
      } else if (item.type == 'quiz') {
        nextRoute(QuizzesPage.pageName);
      } else {
        int previousIndex = itemIndex - 1;
        String? previousLink;

        if (previousIndex >= 0) {
          previousLink =
              widget.contents[sectionIndex].items![previousIndex].link;
        }

        nextRoute(SingleContentPage.pageName,
            arguments: [item, widget.courseData.id, previousLink]);
      }
    } else {
      closeSnackBar();
      showSnackBar(ErrorEnum.alert, appText.notAccessContent);
    }
  }

  // Keep your existing helper methods (iconType, subTitleType, colorType, sizeType)
  String iconType(ContentItem item) {
    switch (item.type) {
      case 'quiz':
        return AppAssets.shieldSvg;
      case 'text_lesson':
      case 'assignment':
        return AppAssets.documentSvg;
      case 'file':
        return item.downloadable == 1
            ? AppAssets.paperDownloadSvg
            : AppAssets.videoSvg;
      default:
        return AppAssets.videoSvg;
    }
  }

  String subTitleType(ContentItem item) {
    switch (item.type) {
      case 'quiz':
        return '${item.questionCount ?? 0} ${appText.questions} | ${item.time ?? 0} ${appText.min}';
      case 'text_lesson':
        return item.summary ?? '';
      case 'file':
        return item.volume ?? '';
      case 'session':
        return "${timeStampToDate((item.date ?? 0) * 1000)} | ${DateTime.fromMillisecondsSinceEpoch((item.date ?? 0) * 1000).toString().split(' ').last.substring(0, 5)}";
      default:
        return item.volume ?? '';
    }
  }

  Color colorType(ContentItem item) {
    switch (item.type) {
      case 'quiz':
        return cyan50;
      case 'text_lesson':
        return yellow29;
      case 'file':
        return green50;
      case 'session':
        return blueFE;
      case 'assignment':
        return blueA4;
      default:
        return green50;
    }
  }

  int sizeType(ContentItem item) {
    switch (item.type) {
      case 'quiz':
        return 24;
      case 'text_lesson':
        return 20;
      case 'file':
        return item.downloadable == 1 ? 24 : 18;
      case 'session':
        return 18;
      case 'assignment':
        return 22;
      default:
        return 24;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appText.courseOverview,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: green63,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.contents.length} sections • ${widget.contents.fold(0, (sum, content) => sum + (content.items?.length ?? 0))} ${appText.lessons}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: grey5E,
                    ),
                  ),
                ],
              ),
            ),

            // Content sections
            ...List.generate(widget.contents.length, (index) {
              return Column(
                children: [
                  _buildModernSectionHeader(index, widget.contents[index]),
                  if (_expandedSections[index]) ...{
                    _buildModernContentItems(index),
                    const SizedBox(height: 8),
                  },
                ],
              );
            }),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
