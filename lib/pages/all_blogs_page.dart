import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_web/widgets/footer_widget.dart';
import '../model/blog_model.dart';

class AllBlogsPage extends StatefulWidget {
  const AllBlogsPage({Key? key}) : super(key: key);

  @override
  State<AllBlogsPage> createState() => _AllBlogsPageState();
}

class _AllBlogsPageState extends State<AllBlogsPage> {
  final List<BlogModel> blogs = [];
  List<BlogModel> filteredBlogs = [];
  bool isLoaded = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDocument;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    getBlogs();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (_hasMore && !isLoaded) {
        _loadMore();
      }
    }
  }

  /// 🔹 Initial Blog Fetch
  Future<void> getBlogs() async {
    setState(() {
      isLoaded = true;
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Blogs')
          .orderBy('timeCreated', descending: true)
          .limit(10)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          blogs.clear();
          blogs.addAll(querySnapshot.docs
              .map((doc) => BlogModel.fromMap(doc, doc.id)));
          filteredBlogs = List.from(blogs);
          _lastDocument = querySnapshot.docs.last;
        });
      }
    } catch (e) {
      debugPrint('Error fetching blogs: $e');
    } finally {
      setState(() {
        isLoaded = false;
      });
    }
  }

  /// 🔹 Load More Blogs
  Future<void> _loadMore() async {
    if (_lastDocument == null) return;

    setState(() {
      isLoaded = true;
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Blogs')
          .orderBy('timeCreated', descending: true)
          .startAfterDocument(_lastDocument!)
          .limit(10)
          .get();

      if (querySnapshot.docs.isEmpty) {
        setState(() => _hasMore = false);
        return;
      }

      setState(() {
        blogs.addAll(querySnapshot.docs
            .map((doc) => BlogModel.fromMap(doc, doc.id)));
        filteredBlogs = List.from(blogs);
        _lastDocument = querySnapshot.docs.last;
      });
    } catch (e) {
      debugPrint('Error loading more blogs: $e');
    } finally {
      setState(() {
        isLoaded = false;
      });
    }
  }

  /// 🔹 Filter Blogs Based on Search
  void filterBlogs(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredBlogs = List.from(blogs);
      } else {
        filteredBlogs = blogs.where((blog) {
          return blog.title.toLowerCase().contains(query.toLowerCase()) ||
              blog.category.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth >= 1100;

    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Blog",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'DancingScript',
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(
                    width: 400,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: filterBlogs,
                      decoration: InputDecoration(
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  isLoaded && blogs.isEmpty
                      ? shimmerGrid(isDesktop)
                      : filteredBlogs.isEmpty
                          ? Center(child: Text("No blogs found."))
                          : blogGrid(isDesktop),
                  
                  if (isLoaded && blogs.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
            Gap(20),
            FooterWidget()
          ],
        ),
      ),
    );
  }

  Widget blogGrid(bool isDesktop) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 3 : 2,
        crossAxisSpacing: 30,
        mainAxisSpacing: 30,
        childAspectRatio: isDesktop ? 1.2 : .42,
      ),
      itemCount: filteredBlogs.length,
      itemBuilder: (context, index) {
        return blogCard(filteredBlogs[index]);
      },
    );
  }

  Widget blogCard(BlogModel blog) {
    return GestureDetector(
      onTap: () {
        context.go('/blog-detail/${blog.uid}');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              blog.image,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              cacheWidth: 400,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 160,
                  width: double.infinity,
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
          SizedBox(height: 10),

          Text(
            blog.category,
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 5),
          
          Text(
            DateFormat('MMM dd, yyyy').format(blog.timeCreated),
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 5),

          Text(
            blog.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),

          Text(
            blog.post.length > 100
                ? "${blog.post.substring(0, 100)}..."
                : blog.post,
            overflow: MediaQuery.of(context).size.width >= 1100
                ? null
                : TextOverflow.ellipsis,
            maxLines: MediaQuery.of(context).size.width >= 1100 ? null : 2,
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          ),

          SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              context.go('/blog-detail/${blog.uid}');
            },
            child: Row(
              children: [
                Text(
                  "read more",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Icon(Icons.arrow_right_alt, color: Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget shimmerGrid(bool isDesktop) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 3 : 2,
        crossAxisSpacing: 30,
        mainAxisSpacing: 30,
        childAspectRatio: 1.5,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return shimmerCard();
      },
    );
  }

  Widget shimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            width: double.infinity,
            color: Colors.white
          ),
          SizedBox(height: 10),
          shimmerBox(width: 100, height: 14),
          SizedBox(height: 5),
          shimmerBox(width: 180, height: 18),
          SizedBox(height: 5),
          shimmerBox(width: double.infinity, height: 14),
        ],
      ),
    );
  }

  Widget shimmerBox({double width = 100, double height = 20}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}