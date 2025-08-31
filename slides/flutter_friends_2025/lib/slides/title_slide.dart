import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_2025/styles/text_styles.dart';

class TitleSlide extends FlutterDeckSlideWidget {
  const TitleSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/visualizing-algorithms',
          title: 'Visualizing Algorithms',
        ),
      );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.custom(
      builder: (context) => SizedBox.expand(
        child: ColoredBox(
          color: Colors.black,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                width: MediaQuery.sizeOf(context).width * 0.6,
                child: Opacity(
                  opacity: 0.6,
                  child: Image.asset('assets/images/maze-bg.png'),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(100),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Visualizing Algorithms on the',
                          style: TextStyles.titleXL,
                          children: <TextSpan>[
                            TextSpan(
                              text: ' Flutter',
                              style: TextStyles.titleXL.copyWith(
                                color: const Color(0xff35aee7),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: ' Canvas',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 200),
                      Text(
                        'Roaa Khaddam',
                        style: TextStyles.h1.copyWith(fontSize: 35),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
