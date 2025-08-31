import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_2025/styles/text_styles.dart';
import 'package:flutter_friends_2025/templates/build_template_slide.dart';

class SectionTitleSlide extends FlutterDeckSlideWidget {
  SectionTitleSlide(
    this.title, {
    super.key,
    this.subtitle,
    this.route,
    this.isSubtitle = false,
  }) : super(
         configuration: FlutterDeckSlideConfiguration(
           route: route != null
               ? '/$route'
               : '/${title.toLowerCase().replaceAll(' ', '-')}',
           title: title,
         ),
       );

  final String title;
  final String? subtitle;
  final String? route;
  final bool isSubtitle;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      title: title,
      showHeader: false,
      content: Stack(
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
              padding: const EdgeInsets.symmetric(horizontal: 200.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: isSubtitle
                          ? TextStyles.subtitle
                          : TextStyles.title,
                      textAlign: TextAlign.center,
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          subtitle!,
                          style: TextStyles.subtitleSM,
                          textAlign: TextAlign.center,
                        ),
                      ),
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
