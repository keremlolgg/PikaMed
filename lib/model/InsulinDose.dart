class InsulinListData {
  InsulinListData({
    required this.hour,
    required this.minute,
    required this.insulinDoses,
    this.notificationSend = false,
  })  : startColor = _getColorForTime(hour),
        endColor = _getColorForTime(hour, isEnd: true),
        titleTxt = _formatTime(hour, minute);

  int hour;
  int minute;
  List<InsulinDose> insulinDoses;
  String titleTxt;
  String startColor;
  String endColor;
  bool notificationSend= false;

  /// **JSON formatına dönüştürme metodu**
  Map<String, dynamic> toJson() {
    return {
      'hour': hour,
      'minute': minute,
      'insulinDoses': insulinDoses.map((dose) => dose.toJson()).toList(),
      'titleTxt': titleTxt,
      'startColor': startColor,
      'endColor': endColor,
      'notificationSend': notificationSend,
    };
  }

  /// **JSON'dan nesneye çevirme metodu**
  factory InsulinListData.fromJson(Map<String, dynamic> json) {
    return InsulinListData(
      hour: json['hour'] ?? 0,
      minute: json['minute'] ?? 0,
      notificationSend: json['notificationSend']?? false,
      insulinDoses: (json['insulinDoses'] as List<dynamic>?)
          ?.map((e) => InsulinDose.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
  /// **Mevcut saate göre dozları ayırma**
  static void updateDoseLists() {
    DateTime now = DateTime.now();
    pastInsulinList.clear();
    futureInsulinList.clear();

    for (var dose in insulinList) {
      DateTime doseTime = DateTime(now.year, now.month, now.day, dose.hour, dose.minute);
      if (doseTime.isBefore(now)) {
        pastInsulinList.add(dose);
      } else {
        futureInsulinList.add(dose);

      }
    }
  }

  /// **İnsülin dozu ekleme fonksiyonu**
  static void addDose(int hour, int minute, InsulinDose dose) {
    var existingEntry = insulinList.firstWhere(
          (entry) => entry.hour == hour && entry.minute == minute,
      orElse: () => InsulinListData(hour: hour, minute: minute, insulinDoses: []),
    );

    if (!insulinList.contains(existingEntry)) {
      insulinList.add(existingEntry);
    }

    existingEntry.insulinDoses.add(dose);
    insulinList.sort((a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute));
    updateDoseLists();
  }

  /// **İnsülin dozu silme fonksiyonu**
  static void removeDose(int index) {
    if (index >= 0 && index < insulinList.length) {
      insulinList.removeAt(index);
      updateDoseLists();
    }
  }

  static String _getColorForTime(int hour, {bool isEnd = false}) {
    if (hour >= 6 && hour < 12) {
      return isEnd ? '#FFA726' : '#FFCC80';
    } else if (hour >= 12 && hour < 18) {
      return isEnd ? '#66BB6A' : '#A5D6A7';
    } else if (hour >= 18 && hour < 21) {
      return isEnd ? '#42A5F5' : '#90CAF9';
    } else {
      return isEnd ? '#8E24AA' : '#CE93D8';
    }
  }

  static String _formatTime(int hour, int minute) {
    String period;
    if (hour >= 6 && hour < 12) {
      period = "Sabah";
    } else if (hour >= 12 && hour < 18) {
      period = "Öğle";
    } else if (hour >= 18 && hour < 21) {
      period = "Akşam";
    } else {
      period = "Gece";
    }
    return '$period (${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')})';
  }

  /// **Ana liste**
  static List<InsulinListData> insulinList = [];

  static List<InsulinListData> pastInsulinList = [];
  static List<InsulinListData> futureInsulinList = [];
}

class InsulinDose {
  InsulinDose({required this.type, required this.dose, required this.unit});

  String type;
  int dose;
  String unit;

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'dose': dose,
      'unit': unit,
    };
  }

  factory InsulinDose.fromJson(Map<String, dynamic> json) {
    return InsulinDose(
      type: json['type'] ?? '',
      dose: json['dose'] ?? 0,
      unit: json['unit'] ?? 'U',
    );
  }
}

