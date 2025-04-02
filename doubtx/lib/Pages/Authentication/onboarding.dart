import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';
import 'package:doubtx/Utils/common_utils.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  int currentPage = 0;

  final List<String> images = [
    'assets/onboarding/1.png',
    'assets/onboarding/2.png',
    'assets/onboarding/3.png',
  ];

  final List<String> headings = [
    'Smart Study Planner',
    'Instant Doubt Solver',
    'Weak Point Identifier',
  ];

  final List<String> descriptions = [
    'Get a custom study schedule tailored to your strengths & weaknesses. Stay on track effortlessly!',
    'Ask a question and DOUBTX solves it step-by-step in seconds!',
    'DOUBTX analyses your performance & suggests targeted resources to improve faster!',
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonUtils.bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 7,
                  child: PageView.builder(
                    controller: controller,
                    itemCount: images.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          // Image
                          Expanded(
                            child: Image.asset(
                              images[index],
                              fit: BoxFit.contain,
                            ),
                          ),

                          // Title and description placeholder
                          Container(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                // Day number and title
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[800],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      headings[index],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Description
                                Text(
                                  descriptions[index],
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Bottom navigation and indicators
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Page indicator
                      SmoothPageIndicator(
                        controller: controller,
                        count: images.length,
                        effect: const ExpandingDotsEffect(
                          activeDotColor: Colors.white,
                          dotColor: Colors.grey,
                          dotHeight: 8,
                          dotWidth: 8,
                          spacing: 8,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Navigation buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Back button
                          IconButton(
                            onPressed: () {
                              if (currentPage > 0) {
                                controller.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                              padding: const EdgeInsets.all(16),
                            ),
                          ),
                          const SizedBox(width: 24),
                          // Forward button
                          IconButton(
                            onPressed: () {
                              if (currentPage < images.length - 1) {
                                controller.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                Get.offAllNamed('/loginpage');
                              }
                            },
                            icon: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                              padding: const EdgeInsets.all(16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Skip button
            Positioned(
              top: 8,
              right: 16,
              child: TextButton(
                onPressed: () {
                  Get.offAllNamed('/loginpage');
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
