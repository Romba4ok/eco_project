import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() {
  runApp(MaterialApp(home: WeatherCarousel(),));
}

class WeatherCarousel extends StatefulWidget {
  @override
  _WeatherCarouselState createState() => _WeatherCarouselState();
}

class _WeatherCarouselState extends State<WeatherCarousel> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            height: 80,
            child: PageView(
              controller: _controller,
              children: [
                _buildPage("Ожидается солнечный день",
                    "Ожидается, что Завтра будет тоже солнечным"),
                _buildPage("Возможен дождь", "Во второй половине дня возможен ливень"),
                _buildPage("Сильный ветер", "Ожидается порывистый ветер до 20 м/с"),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        SmoothPageIndicator(
          controller: _controller,
          count: 3,
          effect: ExpandingDotsEffect(
            activeDotColor: Colors.white,
            dotColor: Colors.grey,
            dotHeight: 6,
            dotWidth: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildPage(String title, String subtitle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
