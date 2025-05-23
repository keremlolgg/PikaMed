import 'package:PikaMed/functions.dart';
import 'package:PikaMed/hasta menu/ui_view/wave_view.dart';
import 'package:PikaMed/hasta menu/fitness_app_theme.dart';
import 'package:PikaMed/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WaterView extends StatefulWidget {
  const WaterView(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _WaterViewState createState() => _WaterViewState();
}

class _WaterViewState extends State<WaterView> {

  void increaseWater() {
    setState(() {
      availableWater += cupSize;
      changeWaterClock = DateFormat('EEEE, HH:mm', 'tr_TR').format(DateTime.now()); // Saati güncelle
      writeToFile();
    });
  }

  void decreaseWater() {
    setState(() {
        availableWater -= cupSize;
        if (availableWater<0) {
          availableWater=0;
        }
        changeWaterClock = DateFormat('EEEE,  HH:mm', 'tr_TR').format(DateTime.now());
        writeToFile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: FitnessAppTheme.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4, bottom: 3),
                                      child: Text(
                                        availableWater.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 32,
                                          color: FitnessAppTheme.nearlyDarkBlue,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8, bottom: 8),
                                      child: Text(
                                        'ml',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          letterSpacing: -0.2,
                                          color: FitnessAppTheme.nearlyDarkBlue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4, top: 2, bottom: 14),
                                  child: Text(
                                    'Günlük hedefin ${targetWater / 1000} L',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: 0.0,
                                      color: FitnessAppTheme.darkText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 16),
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  color: FitnessAppTheme.background,
                                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.access_time, color: FitnessAppTheme.grey.withOpacity(0.5), size: 16),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                      '$changeWaterClock',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        letterSpacing: 0.0,
                                        color: FitnessAppTheme.grey.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 34,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: increaseWater, // + butonu işlevi
                              child: Container(
                                decoration: BoxDecoration(
                                  color: FitnessAppTheme.nearlyWhite,
                                  shape: BoxShape.circle,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: FitnessAppTheme.nearlyDarkBlue.withOpacity(0.4),
                                        offset: const Offset(4.0, 4.0),
                                        blurRadius: 8.0),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Icon(Icons.add, color: FitnessAppTheme.nearlyDarkBlue, size: 24),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            GestureDetector(
                              onTap: decreaseWater, // - butonu işlevi
                              child: Container(
                                decoration: BoxDecoration(
                                  color: FitnessAppTheme.nearlyWhite,
                                  shape: BoxShape.circle,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: FitnessAppTheme.nearlyDarkBlue.withOpacity(0.4),
                                        offset: const Offset(4.0, 4.0),
                                        blurRadius: 8.0),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Icon(Icons.remove, color: FitnessAppTheme.nearlyDarkBlue, size: 24),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8, top: 16),
                        child: Container(
                          width: 60,
                          height: 160,
                          decoration: BoxDecoration(
                            color: HexColor('#E8EDFE'),
                            borderRadius: const BorderRadius.all(Radius.circular(80.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(color: FitnessAppTheme.grey.withOpacity(0.4), offset: const Offset(2, 2), blurRadius: 4),
                            ],
                          ),
                          child: WaveView(percentageValue: (availableWater / targetWater) * 100),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
