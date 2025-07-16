/*import 'package:damaged303/app/common_widgets/button.dart';
import 'package:damaged303/app/common_widgets/plan_card.dart';
import 'package:damaged303/app/common_widgets/premium_basic_text.dart';
import 'package:damaged303/app/modules/payment/payment_view.dart';
import 'package:damaged303/app/modules/subscription_screen/subscription_controller.dart';
import 'package:damaged303/app/utils/app_colors.dart';
import 'package:damaged303/app/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Subscription extends StatelessWidget {
  Subscription({super.key});
  final viewModel = Get.put(SubscriptionViewModel());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(AppImages.splash, height: 150, fit: BoxFit.fitHeight),
          Text(
            "Upgrade to Premium",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 32,
              color: AppColors.primarycolor,
            ),
          ),
          SizedBox(height: 30),
          PremiumBasicText(tittle: 'Unlimited Persona access'),
          SizedBox(height: 6),
          PremiumBasicText(tittle: 'Bookmark Favorite Prompts'),
          SizedBox(height: 6),
          PremiumBasicText(tittle: 'Save conversations'),
          SizedBox(height: 30),
          PlanOptionCard(
            index: 0,
            title: 'Start Free Trial',
            price: '\$0',
            note: 'Save 0%',
          ),
          PlanOptionCard(
            index: 1,
            title: 'Monthly',
            price: '\$25',
            note: 'Save 25%',
          ),
          PlanOptionCard(
            index: 2,
            title: 'Yearly',
            price: '\$40',
            note: 'Save 50%',
            isPopular: true,
          ),
          GestureDetector(
            onTap: () {
              Get.to(PaymentView());
            },
            child: Button(title: 'Subscribe Now'),
          ),
        ],
      ),
    );
  }
}*/
