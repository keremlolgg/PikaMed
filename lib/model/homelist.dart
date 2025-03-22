import 'package:PikaMed/hasta menu/fitness_app_home_screen.dart';
import 'package:PikaMed/doktor menu/doktor_home_screen.dart';
import 'package:PikaMed/giris_animasyon/introduction_animation_screen.dart';
import 'package:flutter/widgets.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  Widget? navigateScreen;
  String imagePath;

  static List<HomeList> homeList = [
    HomeList(
      imagePath: 'assets/introduction_animation/introduction_animation.png',
      navigateScreen: GirisAnimasyonScreen(),
    ),
    HomeList(
      imagePath: 'assets/hotel/hotel_booking.png',
      navigateScreen: DoktorHomeScreen(),
    ),
    HomeList(
      imagePath: 'assets/fitness_app/fitness_app.png',
      navigateScreen: HastaHomeScreen(),
    ),
  ];
}
