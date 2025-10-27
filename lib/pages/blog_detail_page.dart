import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/widgets/footer_widget.dart';

import '../model/blog_model.dart';

class BlogDetailsPage extends StatefulWidget {
  final String uid;

  const BlogDetailsPage({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<BlogDetailsPage> createState() => _BlogDetailsPageState();
}

class _BlogDetailsPageState extends State<BlogDetailsPage> {
  BlogModel? blogs;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    getCategory();
  }

  getCategory() async {
    setState(() {
      isLoaded = true;
    });

    final doc = await FirebaseFirestore.instance
        .collection('Blogs')
        .doc(widget.uid)
        .get();

    setState(() {
      isLoaded = false;
      blogs = BlogModel.fromMap(doc, doc.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth >= 1100;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// 🔹 Show Shimmer while Loading
              isLoaded || blogs == null
                  ? shimmerBlogHeader(isDesktop)
                  : blogHeader(isDesktop),

              /// 🔹 Show Content or Shimmer Loader
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 900),
                  child: isLoaded || blogs == null
                      ? shimmerBlogContent()
                      : blogContent(isDesktop),
                ),
              ),
              FooterWidget()
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Blog Header (Image & Category)
  Widget blogHeader(bool isDesktop) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
          child: Image.network(
            blogs!.image,
            width: double.infinity,
            height: isDesktop ? 400 : 250,
            fit: BoxFit.fill,
            cacheWidth: isDesktop ? 1200 : 800, // Add width constraint
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: double.infinity,
                height: isDesktop ? 400 : 250,
                color: Colors.grey[300],
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// 🔹 Shimmer for Blog Header (Image Placeholder)
  Widget shimmerBlogHeader(bool isDesktop) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: isDesktop ? 400 : 250,
        color: Colors.white,
      ),
    );
  }

  /// 🔹 Blog Content (Title, Date, Full Post)
  Widget blogContent(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Category Tag
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            blogs!.category.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        SizedBox(height: 10),

        /// Blog Title
        Text(
          blogs!.title,
          style: TextStyle(
            fontSize: isDesktop ? 28 : 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),

        /// Date Published
        Text(
          "Published on ${DateFormat('MMM dd, yyyy').format(blogs!.timeCreated)}",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 20),

        /// Full Blog Post Content
        Text(
          blogs!.post,
          style: TextStyle(
            fontSize: isDesktop ? 18 : 16,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  /// 🔹 Shimmer for Blog Content (Title, Category, and Text)
  Widget shimmerBlogContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Category Placeholder
        shimmerBox(width: 100, height: 20),
        SizedBox(height: 10),

        /// Title Placeholder
        shimmerBox(width: 250, height: 30),
        SizedBox(height: 10),

        /// Date Placeholder
        shimmerBox(width: 150, height: 15),
        SizedBox(height: 20),

        /// Content Placeholder (Simulates Paragraphs)
        shimmerBox(width: double.infinity, height: 15),
        SizedBox(height: 10),
        shimmerBox(width: double.infinity, height: 15),
        SizedBox(height: 10),
        shimmerBox(width: double.infinity, height: 15),
        SizedBox(height: 10),
        shimmerBox(width: double.infinity, height: 15),
        SizedBox(height: 30),

        /// Back Button Placeholder
        Center(
          child: shimmerBox(width: 120, height: 40),
        ),
      ],
    );
  }

  /// 🔹 Helper Function for Shimmer Box
  Widget shimmerBox({double width = 100, double height = 20}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
