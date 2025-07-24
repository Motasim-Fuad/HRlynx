
import 'package:cached_network_image/cached_network_image.dart';
import 'package:damaged303/app/utils/my%20spech.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common_widgets/customtooltip.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../modules/news/news_view.dart';

import 'chat_al_ai_persona_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatAllAiPersona());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: CircleAvatar(
            backgroundImage: AssetImage(AppImages.profie),
          ),
        ),
        title: const Text(
          'HRlynx Home',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24,
            color: Color(0xFF1B1E28),
          ),
        ),
        centerTitle: true,
        actions: [


        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Breaking HR News Card ---
                Container(
                  height: size.height * 0.25,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            AppImages.home_container,
                            fit: BoxFit.cover,
                            color: Colors.black.withOpacity(0.6),
                            colorBlendMode: BlendMode.darken,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Breaking HR News',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Stay updated with the latest HR insights, trends and policy changes.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () => Get.to(() => const NewsView()),
                                child: Container(
                                  width: 120,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF013D3B),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'View Feed',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'Chat with your AI HR Assistants:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: isTablet ? 28 : 24,
                    color: AppColors.primarycolor,
                  ),
                ),
                const SizedBox(height: 10),

                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.personaList.isEmpty) {
                    return const Center(child: Text('No personas available'));
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isTablet ? 3 : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: controller.personaList.length,
                    itemBuilder: (context, index) {
                      final persona = controller.personaList[index];
                      return GestureDetector(


                        onTap: () async {
                          await controller.startChatSession(persona);
                        },
                        // use web socket
                        // onTap: () async {
                        //   final sessionId = await controller.authRepo.createSession();
                        //   final token = await TokenStorage.getLoginAccessToken();
                        //
                        //   if (sessionId != null && token != null) {
                        //     final wsService = WebSocketService();
                        //     wsService.connect(sessionId, token);
                        //
                        //     Get.put(ChatController(wsService: wsService));
                        //
                        //     Get.to(() => ChatView(
                        //       sessionId: sessionId,
                        //       token: token,
                        //       webSocketService: wsService,
                        //     ));
                        //   } else {
                        //     Get.snackbar("Error", "Could not create session");
                        //   }
                        // },



                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: AspectRatio(
                                  aspectRatio: 1, // Keeps image square like in screenshot
                                  child:CachedNetworkImage(
                                    imageUrl: "${persona.avatar}",
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                                  ),

                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                                child: Text(
                                  persona.title ?? 'No Title',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );

                    },

                  );
                }),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
