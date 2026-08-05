import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers_filter.dart';
import 'user_profile_page/user_profile_page.dart';
import '../../../providers/app_language_provider.dart';
import '../../../services/guest_service/providers_service.dart';
import '../../../../common/components.dart';
import '../../../../common/common.dart';
import '../../../../common/shimmer_component.dart';
import '../../../../common/utils/app_text.dart';
import '../../../../config/assets.dart';
import '../../../../locator.dart';

import '../../../../common/utils/object_instance.dart';
import '../../../../common/utils/tablet_detector.dart';
import '../../../models/user_model.dart';
import '../../../providers/providers_provider.dart';

class ProvidersPage extends StatefulWidget {
  static const String pageName = '/providers';

  const ProvidersPage({super.key});

  @override
  State<ProvidersPage> createState() => _ProvidersPageState();
}

class _ProvidersPageState extends State<ProvidersPage> {
  List<UserModel> instructorsData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    locator<ProvidersProvider>().clearFilter();
    getInstructors();
  }

  getInstructors() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    instructorsData = await ProvidersService.getInstructors(
        availableForMeetings: locator<ProvidersProvider>().availableForMeeting,
        freeMeetings: locator<ProvidersProvider>().free,
        discount: locator<ProvidersProvider>().discount,
        downloadable: locator<ProvidersProvider>().downloadable,
        sort: locator<ProvidersProvider>().sort,
        categories: locator<ProvidersProvider>().categorySelected);

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppLanguageProvider>(
        builder: (context, appLanguageProvider, _) {
      return directionality(
        child: Scaffold(
          appBar: appbar(
              title: appText.providers,
              rightIcon: AppAssets.filterSvg,
              leftIcon: AppAssets.menuSvg,
              onTapLeftIcon: () {
                drawerController.showDrawer();
              },
              onTapRightIcon: () async {
                bool? res =
                    await baseBottomSheet(child: const ProvidersFilter());

                if (res != null && res) {
                  getInstructors();
                }
              },
              rightWidth: 22),
          body: !isLoading && instructorsData.isEmpty
              ? emptyState(AppAssets.providersEmptyStateSvg,
                  appText.noInstructor, appText.noInstructorDesc)
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: TabletDetector.isTablet() ? 3 : 2,
                      mainAxisSpacing: 22,
                      crossAxisSpacing: 22,
                      mainAxisExtent: 195),
                  padding: const EdgeInsets.only(
                      right: 21, left: 21, bottom: 100, top: 20),
                  itemCount: isLoading ? 6 : instructorsData.length,
                  itemBuilder: (context, index) {
                    return isLoading
                        ? userProfileCardShimmer()
                        : userProfileCard(instructorsData[index], () {
                            nextRoute(UserProfilePage.pageName,
                                arguments: instructorsData[index].id);
                          });
                  },
                ),
        ),
      );
    });
  }
}
