import 'package:flutter/material.dart';
import '../../../../widgets/main_widget/terms_and_rules_widget/terms_and_rules_widget.dart';
import '../../../../../common/components.dart';
import '../../../../../common/utils/app_text.dart';

class TermsAndRulesPage extends StatelessWidget {
  static const String pageName = '/term-and-rules-page';
  const TermsAndRulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return // In your main screen or wherever you want to show the terms and rules
        Scaffold(
      appBar: appbar(title: "Terms and Rules"),
      body: TermsAndRulesWidget.termsAndRulesPage(),
    );
  }
}
