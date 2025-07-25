import 'package:damaged303/app/common_widgets/button.dart';
import 'package:damaged303/app/common_widgets/hr_select.dart';
import 'package:damaged303/app/modules/log_in/log_in_view.dart';
import 'package:damaged303/app/modules/onboarding/onboarding_controller.dart';
import 'package:damaged303/app/utils/app_colors.dart';
import 'package:damaged303/app/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/onbordingModel.dart'; // <-- import model

class OnboardingView extends StatelessWidget {
  final HrRoleController controller = Get.put(HrRoleController());

  OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Image.asset(AppImages.splash, height: 170, ),
            const Text(
              'Customize your experience by choosing an AI HR Assistant Persona!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
                color: Color(0xFF2B2323),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.personaList.isEmpty) {
                  return const Center(child: Text("No personas found"));
                }

                return ListView.builder(
                  itemCount: controller.personaList.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    Data persona = controller.personaList[index];

                    final image = persona.avatar ?? '';

                    return Obx(
                          () => SelectableTile(
                        title: persona.title ?? 'Unknown',
                        imageUrl: image,
                        isSelected: controller.selectedIndex.value == index,
                        onTap: () => controller.select(index),
                      ),
                    );
                  },
                );
              }),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == 3
                          ? AppColors.primarycolor
                          : const Color(0xffE6ECEB),
                    ),
                  ),
                );
              }),
            ),


              Button(title: 'Next',onTap: () {
                // Example: save selected persona to memory
                final selectedPersona = controller.personaList[controller.selectedIndex.value];
                print("Selected: ${selectedPersona.title}");

                Get.to(() => LogInView());
              },),

          ],
        ),
      ),
    );
  }
}
