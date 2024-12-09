import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_itelective/auth/login.dart';
import 'package:flutter_itelective/auth/sign_up.dart';

class CourseIntroSlider extends StatefulWidget {
  const CourseIntroSlider({super.key});

  @override
  _CourseIntroSliderState createState() => _CourseIntroSliderState();
}

class _CourseIntroSliderState extends State<CourseIntroSlider> {
  int _currentSlideIndex = 0;

  Color _backgroundColor = Color(0xFFDEAA79);

  final List<Color> _slideColors = [
    Color(0xFFDEAA79),
    Color(0xFF9EDF9C),
    Color(0xFFB1C29E),
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Define the break point for mobile and desktop screens
    bool isMobile = screenWidth < 800;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                SizedBox(
                  height: screenHeight - 250,
                  width: screenWidth,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: false,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentSlideIndex = index;
                          _backgroundColor = _slideColors[index];
                        });
                      },
                    ),
                    items: [
                      _buildSlide(
                        context,
                        imageUrl:
                            'https://images.pexels.com/photos/574070/pexels-photo-574070.jpeg',
                        color: Color(0xFFDEAA79),
                        title: "Welcome to the Java Programming Course!",
                        description:
                            "Learn Java from scratch and start building amazing applications!",
                      ),
                      _buildSlide(
                        context,
                        imageUrl:
                            'https://images.pexels.com/photos/574070/pexels-photo-574070.jpeg',
                        color: Color(0xFF9EDF9C),
                        title: "Comprehensive Course Material",
                        description:
                            "From fundamentals to advanced concepts, we've got you covered.",
                      ),
                      _buildSlide(
                        context,
                        imageUrl:
                            'https://images.pexels.com/photos/574070/pexels-photo-574070.jpeg',
                        color: Color(0xFFB1C29E),
                        title: "Start Coding Today!",
                        description:
                            "Enroll now and begin your journey to becoming a Java expert.",
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05, vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF22177A),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Enroll Now!",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 10,
            child: SizedBox(
              height: 40,
              width: 80,
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.pop(context);

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 28, 153, 255),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Log In",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(
    BuildContext context, {
    required String imageUrl,
    required Color color,
    required String title,
    required String description,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double imageHeight = screenHeight * 0.6;
    double titleFontSize = screenWidth > 600 ? 24 : 18;
    double descriptionFontSize = screenWidth > 600 ? 18 : 14;

    return Container(
      color: color,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRect(
                child: Stack(
                  children: [
                    Image.network(
                      imageUrl,
                      width: screenWidth,
                      height: imageHeight * 0.5,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05),
                        color: Colors.black.withOpacity(0.5),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.05),
                              child: Text(
                                description,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: descriptionFontSize,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
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
    );
  }
}
