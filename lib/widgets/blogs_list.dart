import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../model/blog_model.dart';

class BlogList extends StatefulWidget {
  @override
  _BlogListState createState() => _BlogListState();
}

class _BlogListState extends State<BlogList> {
  List<BlogModel> blogs = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    getCategory();
  }

  getCategory() {
    setState(() {
      isLoaded = true;
    });

    FirebaseFirestore.instance.collection('Blogs').snapshots().listen((event) {
      setState(() {
        isLoaded = false;
      });
      blogs.clear();
      for (var element in event.docs) {
        var blog = BlogModel.fromMap(element, element.id);
        blogs.add(blog);
      }

      // Sort by date (newest first)
      blogs.sort((a, b) => b.timeCreated.compareTo(a.timeCreated));

      // Limit to 3
      if (blogs.length > 3) {
        blogs = blogs.take(3).toList();
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth >= 1100;

    return blogs.isEmpty
        ? SizedBox.shrink()
        : Column(
            children: [
              Padding(
                padding: MediaQuery.of(context).size.width >= 1100
                    ? const EdgeInsets.only(left: 50, right: 50)
                    : const EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Posts',
                        style: TextStyle(
                            // color: Colors.white,
                            fontFamily: 'LilitaOne',
                            // fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width >= 1100
                                ? 30
                                : 20),
                      ).tr(),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: CountdownTimer(
                    //     textStyle: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: MediaQuery.of(context).size.width >= 1100
                    //             ? 18
                    //             : 15),
                    //     endTime:
                    //         DateTime.parse(flashSales).millisecondsSinceEpoch,
                    //     onEnd: () {
                    //       // FirebaseFirestore.instance
                    //       //     .collection('Flash Sales Products')
                    //       //     .doc(productModel.uid)
                    //       //     .delete();
                    //       deleteAllDocumentsInCollection('Flash Sales');
                    //     },
                    //   ),
                    // ),
                    Padding(
                      padding: MediaQuery.of(context).size.width >= 1100
                          ? const EdgeInsets.all(0)
                          : const EdgeInsets.all(8.0),
                      child: Center(
                        child: OutlinedButton(
                          onPressed: () {
                            context.go('/all-blogs');
                          },
                          child: Text(
                            'See All',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AdaptiveTheme.of(context).mode.isDark ==
                                        true
                                    ? Colors.white
                                    : Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width >= 1100
                                        ? 15
                                        : 12),
                          ).tr(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              isLoaded
                  ? shimmerLoading(isDesktop)
                  : isDesktop
                      ? desktopLayout()
                      : mobileLayout(),
            ],
          );
  }

  /// 🔹 **Shimmer Loading Skeleton**
  Widget shimmerLoading(bool isDesktop) {
    return isDesktop
        ? Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) => shimmerCard()),
            ),
          )
        : SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (_, index) => shimmerCard(),
            ),
          );
  }

  /// 🔹 **Shimmer Placeholder Card**
  Widget shimmerCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: 250,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              shimmerBox(width: double.infinity, height: 150),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerBox(width: 80, height: 15),
                    SizedBox(height: 5),
                    shimmerBox(width: 150, height: 20),
                    SizedBox(height: 5),
                    shimmerBox(width: double.infinity, height: 40),
                    SizedBox(height: 10),
                    shimmerBox(width: 80, height: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 **Desktop Layout (Row)**
  Widget desktopLayout() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: blogCards(250),
      ),
    );
  }

  /// 🔹 **Mobile Layout (Horizontal ListView)**
  Widget mobileLayout() {
    return SizedBox(
      height: 400, // Adjust height for cards
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: blogs.length,
        itemBuilder: (context, index) => blogCards(250)[index],
      ),
    );
  }

  /// 🔹 **Generate Blog Cards**
  List<Widget> blogCards(double height) {
    return blogs.map((blog) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          width: height,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    blog.image,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        blog.category.toUpperCase(),
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        blog.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Published on ${DateFormat('MMM dd, yyyy').format(blog.timeCreated)}",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        blog.post,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          context.go('/blog-detail/${blog.uid}');
                          // Navigate to full blog post screen
                        },
                        child: Text("Read More"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  /// 🔹 **Helper Method for Shimmer Box**
  Widget shimmerBox({double width = 100, double height = 20}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
    );
  }
}
