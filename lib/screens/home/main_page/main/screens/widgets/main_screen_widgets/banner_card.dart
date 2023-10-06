import 'package:findovio/screens/home/main_page/main/screens/widgets/main_screen_widgets/video_background.dart';
import 'package:flutter/material.dart';

class BannerCard extends StatefulWidget {
  @override
  _BannerCardState createState() => _BannerCardState();
}

class _BannerCardState extends State<BannerCard> {
  bool _isCardVisible = true;

  @override
  Widget build(BuildContext context) {
    print('builded');
    return _isCardVisible
        ? GestureDetector(
            onTap: () {
              setState(() {
                _isCardVisible = false; // Hide the card when tapped
              });
            },
            child: Container(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: VideoPlayerScreen(
                        videoFilePath: 'assets/gifs/welcomebanner.mp4',
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 10.0,
                    right: 30.0,
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 25.0,
                    ),
                  ),
                ],
              ),
            ),
          )
        : SizedBox(); // Empty container when the card is not visible
  }
}
