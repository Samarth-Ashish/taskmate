import 'package:flutter/material.dart';

class Alarm {
  int? id;
  String? title;
  TimeOfDay? alarmTime;
  bool? isEnabled;
  List<int>? alarmWeekdays;

  Alarm({
    this.id,
    this.title,
    this.alarmTime,
    this.isEnabled,
    this.alarmWeekdays,
  });

  factory Alarm.fromMap(Map<String, dynamic> json) => Alarm(
    id: json["id"],
    title: json["title"],
    alarmTime: TimeOfDay.fromDateTime(DateTime.parse(json["alarmTime"])),
    isEnabled: json["isEnabled"],
    alarmWeekdays: json["alarmWeekdays"],
  );

  // Map<String, dynamic> toMap() => {
  //   "id": id,
  //   "title": title,
  //   "alarmTime": alarmTime,
  //   "isEnabled": isEnabled,
  //   "alarmWeekdays": alarmWeekdays,
  // };
  // Add toJson and fromJson methods to Alarm class
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'alarmTime': alarmTime != null
          ? '${alarmTime!.hour}:${alarmTime!.minute}'
          : null,
      'isEnabled': isEnabled ?? true,
      'alarmWeekdays': alarmWeekdays,
    };
  }

  factory Alarm.fromJson(Map<String, dynamic> json) {
    TimeOfDay? time;
    if (json['alarmTime'] != null) {
      final timeParts = (json['alarmTime'] as String).split(':');
      time = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      );
    }

    return Alarm(
      id: json['id'],
      title: json['title'],
      alarmTime: time,
      isEnabled: json['isEnabled'] ?? true,
      alarmWeekdays: json['alarmWeekdays'] != null
          ? List<int>.from(json['alarmWeekdays'])
          : null,
    );
  }

  String getAlarmTime() {
    return '${alarmTime!.hour}:${alarmTime!.minute}';
  }

  String getAlarmWeekdays() {
    return alarmWeekdays!.join(', ');
  }

  String getAlarmWeekdaysString() {
    return alarmWeekdays!.join(', ');
  }
}
