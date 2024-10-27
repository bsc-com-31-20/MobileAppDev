import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    // Initialize the video controller
    _videoController = VideoPlayerController.asset('assets/intro.mp4')
      ..initialize().then((_) {
        setState(() {
          _videoController.setLooping(true);
          _videoController.play();
        });
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  List<Widget> _buildPages() {
    return [
      _buildPage(
        'Track Your Expenses', 
        'assets/page1.jpg', 
        'Keep a close eye on your spending habits.',
      ),
      _buildPage(
        'Create Budgets', 
        'assets/page1.jpg', 
        'Set your financial goals and stick to them.',
      ),
      _buildPage(
        'Manage Your Accounts', 
        'assets/page1.jpg', 
        'Easily track all your financial accounts in one place.',
      ),
    ];
  }

  Widget _buildPage(String title, String assetPath, String phrase) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white, // White text for better contrast with the video
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          phrase,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.white70, // Softer white for description text
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Image.asset(assetPath, height: 220), // Placeholder image
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Video background
          Positioned.fill(
            child: _videoController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  )
                : Container(
                    color: Colors.black,
                  ),
          ),
          // Page content on top of the video
          Column(
            children: [
              const SizedBox(height: 60), // Spacer for the title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Welcome to Finance Manager!',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text for contrast
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  children: _buildPages(),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomSheet: _currentIndex == 2
          ? Container(
              color: Colors.blueAccent,
              height: 70,
              child: Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Get Started',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      _pageController.jumpToPage(2);
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  
                  Row(
                    children: List.generate(
                      3,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
