import 'package:flutter/material.dart';
import 'package:PikaMed/functions.dart';
class MoodDiaryView extends StatefulWidget {
  final AnimationController animationController;

  const MoodDiaryView({Key? key, required this.animationController})
      : super(key: key);

  @override
  _MoodDiaryViewState createState() => _MoodDiaryViewState();
}

class _MoodDiaryViewState extends State<MoodDiaryView> {
  final TextEditingController _boyController = TextEditingController();
  final TextEditingController _kiloController = TextEditingController();

  void _kaydet() {
    size = int.parse(_boyController.text);
    weight = int.parse(_kiloController.text);
    if (size > 0 && weight > 0) {
      debugPrint("Boy: $size cm, Kilo: $weight kg - Otomatik kaydedildi.");
      writeToFile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _firstHalfAnimation =
    Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
        .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(0.4, 0.6, curve: Curves.fastOutSlowIn),
    ));
    final _secondHalfAnimation =
    Tween<Offset>(begin: Offset(0, 0), end: Offset(-1, 0))
        .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(0.6, 0.8, curve: Curves.fastOutSlowIn),
    ));

    final _moodFirstHalfAnimation =
    Tween<Offset>(begin: Offset(2, 0), end: Offset(0, 0))
        .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(0.4, 0.6, curve: Curves.fastOutSlowIn),
    ));
    final _moodSecondHalfAnimation =
    Tween<Offset>(begin: Offset(0, 0), end: Offset(-2, 0))
        .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(0.6, 0.8, curve: Curves.fastOutSlowIn),
    ));

    return SlideTransition(
      position: _firstHalfAnimation,
      child: SlideTransition(
        position: _secondHalfAnimation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Kişisel Bilgilerinizi Girin",
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              ),
              SlideTransition(
                position: _moodFirstHalfAnimation,
                child: SlideTransition(
                  position: _moodSecondHalfAnimation,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    child: Column(
                      children: [
                        Text(
                          "Size en uygun insülin hesaplamalarını yapabilmemiz için lütfen aşağıdaki bilgileri doldurun.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        // Boy giriş alanı
                        TextField(
                          controller: _boyController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Boy (cm)",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.height),
                          ),
                          onChanged: (value) => _kaydet(),
                        ),
                        SizedBox(height: 16),
                        // Kilo giriş alanı
                        TextField(
                          controller: _kiloController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Kilo (kg)",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.fitness_center),
                          ),
                          onChanged: (value) => _kaydet(),
                        ),
                      ],
                    ),
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
