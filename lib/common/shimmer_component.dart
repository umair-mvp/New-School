import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'common.dart';
import 'data/app_language.dart';
import '../config/assets.dart';
import '../config/colors.dart';
import '../locator.dart';

Widget courseItemVerticallyShimmer() {
  return Shimmer.fromColors(
    baseColor: greyE7,
    highlightColor: greyF8,
    child: Container(
      margin: const EdgeInsetsDirectional.only(bottom: 16),
      decoration: BoxDecoration(borderRadius: borderRadius()),
      padding: padding(horizontal: 8, vertical: 8),
      width: getSize().width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // image
          shimmerUi(height: 85, width: 135),

          // details
          Expanded(
            child: SizedBox(
              height: 85,
              child: Padding(
                padding: padding(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // title
                    shimmerUi(height: 8, width: getSize().width * .5),

                    // name and date and time
                    shimmerUi(height: 8, width: getSize().width * .3),

                    // price and date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        shimmerUi(height: 8, width: getSize().width * .35),
                        shimmerUi(height: 8, width: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildCartItemSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? green4B : Colors.black,
            ),
          ),
        ],
      ),
    );
  }


Widget courseItemShimmer(
    {bool isSmallSize = true,
    double width = 158.0,
    height = 200.0,
    double endCardPadding = 16.0,
    bool isShowReward = false}) {
  return Shimmer.fromColors(
    baseColor: greyE7,
    highlightColor: greyF8,
    child: Container(
      margin: EdgeInsetsDirectional.only(end: endCardPadding),
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // image
          ClipRRect(
            borderRadius: borderRadius(radius: 15),
            child: Container(
              width: width,
              height: 100,
              color: grey33,
            ),
          ),

          // details
          Expanded(
            child: Padding(
              padding: padding(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  space(12),

                  // title
                  Container(
                    width: width,
                    height: 10,
                    decoration: BoxDecoration(
                        color: grey33, borderRadius: borderRadius()),
                  ),

                  space(10),

                  Container(
                    width: width / 4,
                    height: 10,
                    decoration: BoxDecoration(
                        color: grey33, borderRadius: borderRadius()),
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: (width / 2.3),
                        height: 8,
                        decoration: BoxDecoration(
                            color: grey33, borderRadius: borderRadius()),
                      ),
                      Container(
                        width: (width / 2.3),
                        height: 8,
                        decoration: BoxDecoration(
                            color: grey33, borderRadius: borderRadius()),
                      ),
                    ],
                  ),

                  space(10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: (width / 4),
                        height: 8,
                        decoration: BoxDecoration(
                            color: grey33, borderRadius: borderRadius()),
                      ),
                      Container(
                        width: (width / 4),
                        height: 8,
                        decoration: BoxDecoration(
                            color: grey33, borderRadius: borderRadius()),
                      ),
                    ],
                  ),

                  // const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget classesCourseItemShimmer() {
  return Shimmer.fromColors(
      baseColor: greyE7,
      highlightColor: greyF8,
      child: Container(
        margin: const EdgeInsetsDirectional.only(bottom: 16),
        decoration: BoxDecoration(borderRadius: borderRadius()),
        padding: padding(horizontal: 10, vertical: 9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // course details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                shimmerUi(height: 85, width: 130),

                // details
                Expanded(
                  child: SizedBox(
                    height: 85,
                    child: Padding(
                      padding: padding(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // title
                          shimmerUi(height: 8, width: getSize().width * .4),

                          // name and date and time
                          shimmerUi(height: 8, width: 60),

                          // price and date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // date
                              shimmerUi(height: 8, width: 70),

                              // price
                              Row(
                                children: [
                                  shimmerUi(height: 8, width: 20),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            space(24),

            // category and publish date
            Row(
              children: [
                // category
                Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shimmerUi(height: 8, width: 70),
                        space(6),
                        shimmerUi(height: 8, width: 70),
                      ],
                    )),

                // Publish Date
                Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shimmerUi(height: 8, width: 70),
                        space(6),
                        shimmerUi(height: 8, width: 70),
                      ],
                    )),
              ],
            ),

            space(24),

            // progress
            shimmerUi(height: 8, width: getSize().width),

            space(12),
          ],
        ),
      ));
}

Widget blogItemShimmer() {
  return Shimmer.fromColors(
    baseColor: greyE7,
    highlightColor: greyF8,
    child: Container(
      width: getSize().width,
      padding: padding(horizontal: 10, vertical: 10),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: borderRadius(radius: 15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image
          shimmerUi(height: 200, width: getSize().width, radius: 10),

          space(16),

          // title
          shimmerUi(height: 8, width: getSize().width * .6),

          space(20),

          // desc
          shimmerUi(height: 8, width: getSize().width),

          space(8),

          // desc
          shimmerUi(height: 8, width: getSize().width),

          space(8),

          // desc
          shimmerUi(height: 8, width: getSize().width * .3),

          space(24),

          Row(
            children: [
              shimmerUi(height: 8, width: 50),
              space(0, width: 20),
              shimmerUi(height: 8, width: 50),
            ],
          )
        ],
      ),
    ),
  );
}

Widget userProfileCardShimmer() {
  return Shimmer.fromColors(
    baseColor: greyE7,
    highlightColor: greyF8,
    child: Container(
      width: 155,
      height: 195,
      padding: padding(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(borderRadius: borderRadius()),
      child: Column(
        children: [
          // meet status
          Align(
              alignment: AlignmentDirectional.centerEnd,
              child: shimmerUi(height: 22, width: 22, radius: 50)),

          Expanded(
            child: Column(
              children: [
                shimmerUi(height: 70, width: 70, radius: 100),
                const Spacer(flex: 1),
                shimmerUi(height: 8, width: getSize().width * .2),
                space(6),
                shimmerUi(height: 8, width: getSize().width * .3),
                space(12),
                shimmerUi(height: 8, width: getSize().width * .2),
                const Spacer(flex: 2),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

// Widget horizontalCategoryItemShimmer() {
//   return Shimmer.fromColors(
//     baseColor: greyE7,
//     highlightColor: greyF8,
//     child: Container(
//       width: getSize().width * .7,
//       margin: const EdgeInsetsDirectional.only(end: 16),
//       padding: padding(horizontal: 16, vertical: 16),
//       decoration: BoxDecoration(
//         borderRadius: borderRadius(radius: 15),
//       ),
//       child: Row(
//         children: [
//           shimmerUi(height: 65, width: 65, radius: 6),
//           space(0, width: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               shimmerUi(
//                 height: 8,
//                 width: 100,
//               ),
//               space(10),
//               shimmerUi(
//                 height: 8,
//                 width: 50,
//               ),
//             ],
//           )
//         ],
//       ),
//     ),
//   );
// }
Widget horizontalCategoryItemShimmer() {
  return Container(
    width: getSize().width * .7,
    margin: const EdgeInsetsDirectional.only(end: 16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.grey.shade300,
          Colors.grey.shade200,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: borderRadius(radius: 28),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 24,
          offset: const Offset(0, 12),
          spreadRadius: -8,
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: borderRadius(radius: 28),
      child: Stack(
        children: [
          // Glossy overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 80,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.25),
                    Colors.white.withOpacity(0.05),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // Geometric shapes decoration
          Positioned(
            right: -30,
            top: 10,
            child: Transform.rotate(
              angle: 0.3,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: borderRadius(radius: 16),
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
                  width: 2,
                ),
              ),
            ),
          ),
          // Content
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Padding(
              padding: padding(horizontal: 22, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Icon placeholder
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: borderRadius(radius: 16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 1.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Badge placeholder
                      Container(
                        width: 60,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: borderRadius(radius: 20),
                        ),
                      ),
                    ],
                  ),
                  space(20),
                  // Title placeholder
                  Container(
                    width: double.infinity,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: borderRadius(radius: 6),
                    ),
                  ),
                  space(8),
                  Container(
                    width: 150,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: borderRadius(radius: 6),
                    ),
                  ),
                  space(8),
                  // Subtitle row placeholder
                  Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: borderRadius(radius: 6),
                        ),
                      ),
                      space(0, width: 8),
                      Container(
                        width: 80,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: borderRadius(radius: 4),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: borderRadius(radius: 10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget categoryItemShimmer() {
  return Shimmer.fromColors(
    baseColor: greyE7,
    highlightColor: greyF8,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      child: Row(
        children: [
          shimmerUi(height: 34, width: 34, radius: 30),
          space(0, width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              shimmerUi(height: 8, width: getSize().width * .3),
              space(8),
              shimmerUi(height: 8, width: getSize().width * .2),
            ],
          ),
          const Spacer(),
          AnimatedRotation(
            turns: locator<AppLanguage>().isRtl() ? 180 / 360 : 0,
            duration: const Duration(milliseconds: 200),
            child: SvgPicture.asset(AppAssets.arrowRightSvg),
          )
        ],
      ),
    ),
  );
}

Widget shimmerUi(
    {required double height, required double width, double radius = 15}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: grey33,
      borderRadius: borderRadius(radius: radius),
    ),
  );
}
