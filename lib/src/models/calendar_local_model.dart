part of manage_calendar_events;

class CalendarLocalModel {
  final String offerId;
  final String calendarId;
  final String eventId;
  CalendarLocalModel({
    required this.offerId,
    required this.calendarId,
    required this.eventId,
  });

  CalendarLocalModel copyWith({
    String? offerId,
    String? calendarId,
    String? eventId,
  }) {
    return CalendarLocalModel(
      offerId: offerId ?? this.offerId,
      calendarId: calendarId ?? this.calendarId,
      eventId: eventId ?? this.eventId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'offerId': offerId,
      'calendarId': calendarId,
      'eventId': eventId,
    };
  }

  factory CalendarLocalModel.fromMap(Map<String, dynamic> map) {
    return CalendarLocalModel(
      offerId: map['offerId'] as String,
      calendarId: map['calendarId'] as String,
      eventId: map['eventId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CalendarLocalModel.fromJson(String source) =>
      CalendarLocalModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CalendarLocalModel(offerId: $offerId, calendarId: $calendarId, eventId: $eventId)';

  @override
  bool operator ==(covariant CalendarLocalModel other) {
    if (identical(this, other)) return true;

    return other.offerId == offerId &&
        other.calendarId == calendarId &&
        other.eventId == eventId;
  }

  @override
  int get hashCode => offerId.hashCode ^ calendarId.hashCode ^ eventId.hashCode;
}
