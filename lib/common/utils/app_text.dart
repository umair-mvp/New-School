import 'package:flutter/material.dart';
import '../data/app_language.dart';
import '../../config/l10n/app_localizations.dart';
import '../../locator.dart';

AppLocalizations get appText {
  return lookupAppLocalizations(Locale(locator<AppLanguage>().currentLanguage));
}
