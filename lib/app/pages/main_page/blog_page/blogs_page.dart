import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/blog_model.dart';
import 'details_blog_page.dart';
import '../../../providers/drawer_provider.dart';
import '../../../../common/components.dart';
import '../../../widgets/main_widget/blog_widget/blog_widget.dart';
import '../../../../common/common.dart';
import '../../../../common/shimmer_component.dart';
import '../../../../common/utils/app_text.dart';
import '../../../../common/utils/object_instance.dart';
import '../../../../config/assets.dart';

import '../../../models/basic_model.dart';
import '../../../services/user_service/blog_service.dart';

class BlogsPage extends StatefulWidget {
  const BlogsPage({super.key});

  @override
  State<BlogsPage> createState() => _BlogsPageState();
}

class _BlogsPageState extends State<BlogsPage> {
  List<BlogModel> blogData = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  List<BasicModel> categories = [];
  BasicModel? selectedCategory;

  @override
  void initState() {
    super.initState();
    getCategories();
    getData();
  }

  Future<void> getCategories() async {
    if (!mounted) return;
    try {
      final fetchedCategories = await BlogService.categories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          hasError = true;
          errorMessage = "Error fetching categories";
        });
      }
    }
  }

  Future<void> getData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = '';
    });

    try {
      final newBlogData = await BlogService.getBlog(blogData.length,
          category: selectedCategory?.id);

      if (mounted) {
        setState(() {
          blogData.addAll(newBlogData);
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

  Widget _buildBlogItem(BlogModel? blog) {
    if (blog == null) {
      return const SizedBox.shrink();
    }

    try {
      return blogItem(blog, () {
        nextRoute(DetailsBlogPage.pageName, arguments: blog);
      });
    } catch (e) {
      return const Text("Error loading blog item");
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
                  title: appText.blog,
                  leftIcon: AppAssets.menuSvg,
                  onTapLeftIcon: () {
                    drawerController.showDrawer();
                  },
                  rightIcon: AppAssets.filterSvg,
                  onTapRightIcon: () async {
                    BasicModel? cat = await BlogWidget.showCategoriesDialog(
                        selectedCategory, categories);

                    if (cat != null && cat.id != selectedCategory?.id) {
                      setState(() {
                        selectedCategory = cat;
                        blogData.clear();
                      });
                      await getData();
                    }
                  },
                  rightWidth: 22),
              body: RefreshIndicator(
                onRefresh: () async {
                  blogData.clear();
                  await getData();
                },
                child: _buildBody(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    if (isLoading && blogData.isEmpty) {
      return ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) => blogItemShimmer(),
      );
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage),
            ElevatedButton(
              onPressed: getData,
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (blogData.isEmpty) {
      return Center(
        child: emptyState(AppAssets.blogEmptyStateSvg, appText.noBlogPosts,
            appText.noBlogPostsDesc),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!isLoading &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          getData();
        }
        return true;
      },
      child: ListView.builder(
        padding: padding(vertical: 10),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: blogData.length + 1,
        itemBuilder: (context, index) {
          if (index == blogData.length) {
            return isLoading ? blogItemShimmer() : const SizedBox(height: 100);
          }
          return _buildBlogItem(blogData[index]);
        },
      ),
    );
  }
}
