import 'package:PikaMed/hasta menu/ui_view/title_view.dart';
import 'package:PikaMed/hasta menu/fitness_app_theme.dart';
import 'package:PikaMed/hasta menu/my_diary/past_vaccine.dart';
import 'package:PikaMed/hasta menu/my_diary/future_vaccine.dart';
import 'package:flutter/material.dart';
import 'package:PikaMed/model/InsulinDose.dart';
import 'package:PikaMed/functions.dart';

import '../../Menu/navigation_home_screen.dart';

class MyDiaryScreen extends StatefulWidget {
  const MyDiaryScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _MyDiaryScreenState createState() => _MyDiaryScreenState();
}

class _MyDiaryScreenState extends State<MyDiaryScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void showManageInsulinDialog(BuildContext context) {
    TextEditingController typeController = TextEditingController();
    TextEditingController doseController = TextEditingController();
    TextEditingController unitController = TextEditingController(text: 'U');

    TimeOfDay selectedTime = TimeOfDay.now();
    DateTime now = DateTime.now();

    List<InsulinListData> insulinList = InsulinListData.insulinList;
    List<InsulinListData> pastDoses = [];
    List<InsulinListData> futureDoses = [];

    // Geçmiş ve gelecek dozları ayır
    for (var dose in insulinList) {
      DateTime doseTime = DateTime(now.year, now.month, now.day, dose.hour, dose.minute);
      if (doseTime.isBefore(now)) {
        pastDoses.add(dose);
      } else {
        futureDoses.add(dose);
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("İnsülin Dozlarını Yönet"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Yeni İnsülin Dozu Ekle", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      controller: typeController,
                      decoration: InputDecoration(labelText: "İnsülin Türü"),
                    ),
                    TextField(
                      controller: doseController,
                      decoration: InputDecoration(labelText: "Doz (U)"),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: unitController,
                      decoration: InputDecoration(labelText: "Birim"),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (pickedTime != null) {
                          setState(() {
                            selectedTime = pickedTime;
                          });
                        }
                      },
                      child: Text("Saat Seç (${selectedTime.hour}:${selectedTime.minute})"),
                    ),
                    Divider(),
                    Text("Gelecek Dozlar", style: TextStyle(fontWeight: FontWeight.bold)),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: futureDoses.length,
                      itemBuilder: (context, index) {
                        InsulinListData dose = futureDoses[index];
                        return ListTile(
                          title: Text(dose.titleTxt),
                          subtitle: Text(dose.insulinDoses.map((e) => "${e.type} - ${e.dose}${e.unit}").join(", ")),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                insulinList.remove(dose);
                                pastDoses.remove(dose);
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("İnsülin dozu silindi!")),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    Divider(),
                    Text("Geçmiş Dozlar", style: TextStyle(fontWeight: FontWeight.bold)),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: pastDoses.length,
                      itemBuilder: (context, index) {
                        InsulinListData dose = pastDoses[index];
                        return ListTile(
                          title: Text(dose.titleTxt),
                          subtitle: Text(dose.insulinDoses.map((e) => "${e.type} - ${e.dose}${e.unit}").join(", ")),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                insulinList.remove(dose);
                                pastDoses.remove(dose);
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("İnsülin dozu silindi!")),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Kapat"),
                ),
                TextButton(
                  onPressed: () {
                    String type = typeController.text;
                    int dose = int.tryParse(doseController.text) ?? 0;
                    String unit = unitController.text;

                    if (type.isNotEmpty && dose > 0) {
                      setState(() {
                        insulinList.add(InsulinListData(
                          hour: selectedTime.hour,
                          minute: selectedTime.minute,
                          insulinDoses: [InsulinDose(type: type, dose: dose, unit: unit)],
                        ));
                        insulinList.sort((a, b) {
                          return (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute);
                        });
                        writeToFile();
                        InsulinListData.updateDoseLists();
                      });
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Yeni insülin dozu eklendi!")),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
                      );
                    }
                  },
                  child: Text("Ekle"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void addAllListData() {
    const int count = 9;

    listViews.add(
      TitleView(
        titleTxt: 'Yapılacak Aşıların',
        subTxt: 'Düzenle',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
        onTap: () {
          showManageInsulinDialog(context);
        },
      ),
    );
    listViews.add(
      FutureVaccine(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / count) * 3, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );

    listViews.add(
      TitleView(
        titleTxt: 'Yaptığın Aşılar',
        subTxt: 'Düzenle',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
        onTap: () {
          showManageInsulinDialog(context);
        },
      ),
    );
    listViews.add(
      PastVaccine(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / count) * 3, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: FitnessAppTheme.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: FitnessAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '    Menü',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: FitnessAppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
