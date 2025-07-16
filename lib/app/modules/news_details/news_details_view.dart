import 'package:damaged303/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewsDetailsView extends StatelessWidget {
  const NewsDetailsView({
    super.key,
    required this.tags,
    required this.headline,
    required this.description,
    required this.img,
  });
  final List<String> tags;
  final String headline;
  final String description;
  final String img;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Breaking HR News',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24,
            color: Color(0xFF1B1E28),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(Icons.share),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                'Summarized by your AI\n          HR Assistant',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                  color: Color(0xff1B1E28),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: Get.width * .25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.primarycolor,
                    ),
                    child: Center(
                      child: Text(
                        tags.first,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    height: 40,
                    width: Get.width * .25,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE6ECEB), width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        tags.last,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color(0xFF050505),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Image.asset(img),
              Text(
                headline,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Color(0xFF1B1E28),
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7D848D),
                  fontSize: 16,
                ),
              ),
              // Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 40,
                      width: 239,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primarycolor,
                      ),
                      child: Center(
                        child: Text(
                          'Link to the original content',
                          style: TextStyle(
                            color: Color(0xFFE6E6E6),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Get.snackbar(
                    'All news content displayed is sourced from third-party providers and publicly available RSS feeds. Article summaries and AI-generated insights are provided for informational purposes only. Full credit and copyright remain with the original publisher. HRlynx is not responsible for the accuracy, timeliness, or completeness of third-party content. For full articles, please refer directly to the source.',
                    '',
                  );
                },
                child: Text(
                  'Disclaimer',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: AppColors.primarycolor,
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
