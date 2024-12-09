import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/vs.dart';
import '../../models/course.dart';

class CourseDetailPage extends StatefulWidget {
  final Course course;

  const CourseDetailPage({super.key, required this.course});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  late PageController _pageController;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _progress =
            (_pageController.page ?? 0) / (widget.course.modules.length - 1);
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Ensure course has modules
    if (widget.course.modules.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.course.title),
        ),
        body: const Center(
          child: Text("No modules available for this course."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.course.title,
          style: const TextStyle(color: Colors.white, fontSize: 20),
          maxLines: 2,
          overflow:
              TextOverflow.ellipsis,
        ),
        backgroundColor: const Color.fromARGB(255, 36, 209, 42),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Progress: ${(100 * _progress).toInt()}%",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.grey[300],
                    color: const Color.fromARGB(255, 36, 209, 42),
                    minHeight: 8.0,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: screenWidth < 600 ? screenWidth : screenWidth * 0.6,
                  height: screenHeight * 0.6,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.course.modules.length,
                    itemBuilder: (context, index) {
                      final module = widget.course.modules[index];
                      return _buildModule(module);
                    },
                  ),
                ),
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  // Method to build individual module details
  Widget _buildModule(Module module) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            module.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            module.content,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          HighlightView(
            module.codeExample,
            language: 'java',
            theme: vsTheme,
            padding: const EdgeInsets.all(12),
            textStyle: const TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    );
  }

  // Navigation buttons for Back and Next
  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          Flexible(
            flex: 1,
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_pageController.page! > 0) {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  } else {
                    Navigator.pop(context); // Go back if at the first page
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Back button color
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: Color.fromARGB(255, 36, 209, 42),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 36, 209, 42),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16), // Space between buttons
          // Next Button
          Flexible(
            flex: 1,
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_pageController.page!.toInt() <
                      widget.course.modules.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  } else {
                    Navigator.pop(context); // Close if on the last page
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 36, 209, 42),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _pageController.hasClients &&
                              _pageController.page!.toInt() ==
                                  widget.course.modules.length - 1
                          ? 'Finish'
                          : 'Next',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward,
                        size: 20, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
