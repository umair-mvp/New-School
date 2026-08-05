import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../common/common.dart';
import '../../../../common/components.dart';
import '../../../../common/utils/app_text.dart';
import '../../../../config/assets.dart';
import '../../../../config/colors.dart';
import '../../../../config/styles.dart';

class TermsAndRulesWidget {
  static Widget termsAndRulesPage() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            margin: padding(),
            width: getSize().width,
            padding: padding(horizontal: 10, vertical: 18),
            child: Column(
              children: [
                SvgPicture.asset(AppAssets.logoLineSvg, width: 80, height: 80),
                space(20),
                Text(
                  'New School Platform Legal Procedures',
                  style: style16Bold().copyWith(color: green77()),
                  textAlign: TextAlign.center,
                ),
                space(8),
                Text(
                  'Please read our terms and conditions carefully',
                  style: style14Regular().copyWith(color: greyA5),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          space(25),

          // Terms and Rules Content
          Padding(
            padding: padding(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection('1. User Agreement',
                    'By registering or using the New School platform, users (students, trainers, teachers, and other personnel) agree to abide by the following terms and conditions. Users are responsible for regularly reviewing these terms, which are subject to change at the discretion of New School.'),

                space(20),

                _buildSection('2. Account Registration and Usage',
                    '• Students, trainers, and teachers must provide accurate and complete information during registration.\n• Users are responsible for maintaining the confidentiality of their account credentials.\n• Sharing login credentials with third parties is strictly prohibited.\n• Any activity conducted under a user\'s account will be considered as performed by the registered user.\n• Misuse of the platform may result in immediate suspension or termination.'),

                space(20),

                _buildSection('3. Privacy and Data Protection',
                    '• Data Security: The platform ensures security through encryption and secure storage.\n• Data Collection: Information such as names, email addresses, and course progress may be collected.\n• Data Usage: We do not sell, rent, or share personal data with third parties.\n• Data Retention: Users can request deletion of their personal data.'),

                space(20),

                _buildSection('4. Content and Intellectual Property',
                    '• All educational materials are intellectual property of the platform and/or creators.\n• Teachers and trainers may not distribute or copy content without permission.\n• Uploading content grants New School a non-exclusive license for educational purposes.'),

                space(20),

                _buildSection('5. Account Suspension or Termination',
                    '• Violation of terms may result in account suspension/termination.\n• Legal action may be taken against data theft or unauthorized distribution.\n• Users causing harm will be required to compensate for damages.\n• Appeals must be submitted within 30 days of suspension notice.'),

                space(20),

                _buildSection('6. Responsibilities',
                    '• Students: Must engage respectfully and complete coursework with integrity.\n• Trainers: Must provide high-quality, accurate, and appropriate content.\n• Teachers: Must maintain professional environment and ensure quality materials.\n• All users should report inappropriate content.'),

                space(20),

                _buildSection('7. Payment Terms',
                    '• Payment Methods: Review available payment methods before enrollment.\n• Price Disclosure: All course prices will be clearly stated.\n• No Refunds: Once payment is made, no refunds will be provided.'),

                space(20),

                _buildSection('8. Limitation of Liability',
                    'New School shall not be held liable for any indirect, incidental, or consequential damages arising from platform use. While we take security measures, we cannot guarantee uninterrupted access.'),

                space(20),

                _buildSection('9. Governing Law',
                    'These terms are governed by applicable laws. Any disputes will be subject to the exclusive jurisdiction of the courts in the relevant region.'),

                space(30),

                // Closing Statement
                Container(
                  width: getSize().width,
                  padding: padding(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                    color: green77().withOpacity(0.1),
                    borderRadius: borderRadius(),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Our Commitment',
                        style: style16Bold().copyWith(color: green77()),
                        textAlign: TextAlign.center,
                      ),
                      space(10),
                      Text(
                        'In the New School, we are committed to protecting legal standards and professional ethics, ensuring a respectful learning environment. Thank you for choosing us!',
                        style: style14Regular().copyWith(color: greyA5),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                space(40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: style14Bold().copyWith(color: green77()),
        ),
        space(8),
        Text(
          content,
          style: style14Regular().copyWith(color: greyA5, height: 1.5),
        ),
      ],
    );
  }
}
