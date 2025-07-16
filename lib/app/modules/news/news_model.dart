import 'package:damaged303/app/utils/app_images.dart';

class NewsCategory {
  final String category;

  NewsCategory({required this.category});
}

class NewsModel {
  final List<NewsCategory> newsCategories = [
    NewsCategory(category: 'HR Strategy & Leadership'),
    NewsCategory(category: 'Workforce Compliance & Regulation'),
    NewsCategory(category: 'Talent Acquisition & Labor Trends'),
    NewsCategory(category: 'Compensation, Benefits & Rewards'),
    NewsCategory(category: 'People Development & Culture'),
  ];
}

class newsdetailsmodel {
  final List<String> tags;
  final String headline;
  final String description;
  final String image; // Add this for image path or URL

  newsdetailsmodel({
    required this.tags,
    required this.headline,
    required this.description,
    required this.image,
  });
}

class newsdescritiondetail {
  final List<newsdetailsmodel> newsdescriptions = [
    newsdetailsmodel(
      tags: ['Strategy', 'SHRM'],
      headline: 'CHROS Driving Business Transfomutioo at Sumtfiit',
      description:
          'Internal mobility refers to the movement of employees within an organization, whether through promotions, lateral moves, project-based assignments, or role changes across departments. It plays a critical role in talent retention, employee engagement, and organizational agility. By prioritizing internal mobility, companies can unlock hidden talent, reduce hiring costs, and build a more adaptable workforce. However, successful implementation requires transparent career paths, skills-based development programs, and supportive leadership. As the future of work demands faster adaptation, internal mobility is no longer optional—it’s a strategic necessity.   ',
      image: AppImages.news1,
    ),
    newsdetailsmodel(
      tags: ['Cmplance', 'HR Drive'],
      headline: 'California Workplace Violence Rules Now in Effect',
      description:
          'New California workplace violence prevention rules took effect July 1, 2024, requiring most employers to implement comprehensive safety plans. These regulations mandate risk assessments, employee training, and incident reporting procedures to address growing concerns about workplace violence. Employers must identify hazards, develop prevention strategies, and provide clear response protocols. The rules apply to nearly all industries, with stricter requirements for high-risk sectors like healthcare and retail. Non-compliance may result in penalties. California follows federal OSHA guidelines while expanding protections, reflecting rising national attention on employee safety. Experts recommend immediate action to update policies, train staff, and document compliance efforts to avoid fines and foster safer work environments.',
      image: AppImages.news2,
    ),
    newsdetailsmodel(
      tags: ['Talent', 'Forbes'],
      headline: 'A Deep Dive into internal Mobility',
      description:
          'Internal mobility empowers employees to grow within an organization through promotions, lateral moves, or cross-departmental transfers. It boosts retention, engagement, and agility while reducing hiring costs. By leveraging existing talent, companies foster career development and adaptability. Success depends on transparent career paths, skills training, and leadership support. As workplaces evolve, internal mobility shifts from perk to necessity—helping businesses stay competitive and employees thrive. A well-structured program aligns organizational goals with individual aspirations, creating a dynamic, future-ready workforce.',
      image: AppImages.news3,
    ),
    newsdetailsmodel(
      tags: ['Talent', 'Forbes'],
      headline: 'California Workplace Violence Rules Now in Effect',
      description:
          'Internal mobility empowers employees to grow within an organization through promotions, lateral moves, or cross-departmental transfers. It boosts retention, engagement, and agility while reducing hiring costs. By leveraging existing talent, companies foster career development and adaptability. Success depends on transparent career paths, skills training, and leadership support. As workplaces evolve, internal mobility shifts from perk to necessity—helping businesses stay competitive and employees thrive. A well-structured program aligns organizational goals with individual aspirations, creating a dynamic, future-ready workforce.',
      image: AppImages.news4,
    ),
  ];
}
