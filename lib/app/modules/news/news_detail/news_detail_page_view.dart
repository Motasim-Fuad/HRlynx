import 'package:damaged303/app/api_servies/repository/news_repo.dart';
import 'package:damaged303/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailsView extends StatelessWidget {
  const NewsDetailsView({
    super.key,
    required this.articleId,
  });

  final int articleId;

  Future<Map<String, dynamic>> _fetchArticleDetails() async {
    final NewsRepository newsRepo = NewsRepository();
    try {
      final response = await newsRepo.getArticleDetails(articleId);
      if (response['success'] == true && response['data'] != null) {
        return response['data'];
      }
      throw Exception('Failed to load article details');
    } catch (e) {
      print('Error fetching article details: $e');
      throw e;
    }
  }

  Future<void> _launchOriginalUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar('Error', 'Could not launch the URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Breaking HR News',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24,
            color: Color(0xFF1B1E28),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              final article = await _fetchArticleDetails();
              final url = article['original_url']?.toString() ?? '';
              // Implement share functionality
              if (url.isNotEmpty) {
                Get.snackbar('Share', 'Sharing article: ${article['ai_title']}');
                // You can use packages like share_plus for actual sharing
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchArticleDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primarycolor,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Failed to load article details',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          final article = snapshot.data!;
          final tags = article['tags'] as List<dynamic>? ?? [];
          final hasImage = article['main_image_url'] != null &&
              article['main_image_url'].toString().isNotEmpty;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Summarized by your AI\nHR Assistant',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                    color: Color(0xff1B1E28),
                  ),
                ),
                SizedBox(height: 20),

                // Tags
                if (tags.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tags.take(2).map((tag) {
                      final isFirst = tags.indexOf(tag) == 0;
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: isFirst ? AppColors.primarycolor : Colors.transparent,
                          border: isFirst ? null : Border.all(color: Color(0xFFE6ECEB)),
                        ),
                        child: Text(
                          tag['name']?.toString() ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: isFirst ? Colors.white : Color(0xFF050505),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                ],

                // Article Image
                if (hasImage)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      article['main_image_url'].toString(),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: Center(
                            child: Icon(Icons.image_not_supported, size: 50),
                          ),
                        );
                      },
                    ),
                  ),

                SizedBox(height: 20),

                // Article Title
                Text(
                  article['ai_title']?.toString() ?? 'No title available',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Color(0xFF1B1E28),
                  ),
                ),

                SizedBox(height: 16),

                // Article Summary
                Text(
                  article['ai_summary']?.toString() ?? 'No summary available',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7D848D),
                    fontSize: 16,
                  ),
                ),

                SizedBox(height: 30),

                // Original Content Button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primarycolor,
                      minimumSize: Size(239, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      final url = article['original_url']?.toString();
                      if (url != null && url.isNotEmpty) {
                        _launchOriginalUrl(url);
                      } else {
                        Get.snackbar('Error', 'No URL available for this article');
                      }
                    },
                    child: Text(
                      'Link to the original content',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Disclaimer
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Get.defaultDialog(
                        title: 'Disclaimer',
                        content: Text(
                          'All news content displayed is sourced from third-party providers and publicly available RSS feeds. Article summaries and AI-generated insights are provided for informational purposes only. Full credit and copyright remain with the original publisher. HRlynx is not responsible for the accuracy, timeliness, or completeness of third-party content. For full articles, please refer directly to the source.',
                        ),
                      );
                    },
                    child: Text(
                      'Disclaimer',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: AppColors.primarycolor,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}