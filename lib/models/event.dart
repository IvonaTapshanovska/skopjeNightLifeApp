import 'package:cloud_firestore/cloud_firestore.dart';

class EventInfo {
  final String clubName;
  final String eventName;
  final String location;
  final DateTime dateTime;
  final int minAge;
  final String pictureUrl;
  final double lon;
  final double lat;

  EventInfo({
    required this.clubName,
    required this.eventName,
    required this.location,
    required this.dateTime,
    required this.minAge,
    required this.pictureUrl,
    required this.lon,
    required this.lat,
  });

  factory EventInfo.fromMap(Map<String, dynamic> map) {
    return EventInfo(
      clubName: map['clubName'] ?? '',
      eventName: map['eventName'] ?? '',
      location: map['location'] ?? '',
      dateTime: map['dateTime'] is Timestamp
          ? (map['dateTime'] as Timestamp).toDate()
          : DateTime.parse(map['dateTime'] ?? ''),
      minAge: map['minAge'] ?? 0,
      pictureUrl: map['pictureUrl'] ?? '',
      lon: map['lon'] ?? 0.0,
      lat: map['lat'] ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clubName': clubName,
      'eventName': eventName,
      'location': location,
      'dateTime': Timestamp.fromDate(dateTime),
      'minAge': minAge,
      'pictureUrl': pictureUrl,
      'lon': lon,
      'lat': lat,
    };
  }

}