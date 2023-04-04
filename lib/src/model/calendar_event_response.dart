part of manage_calendar_events;

class CalendarEventResponse {
  final String eventId;
  final String calendarId;
  CalendarEventResponse({
    required this.eventId,
    required this.calendarId,
  });

  CalendarEventResponse copyWith({
    String? eventId,
    String? calendarId,
  }) {
    return CalendarEventResponse(
      eventId: eventId ?? this.eventId,
      calendarId: calendarId ?? this.calendarId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'eventId': eventId,
      'calendarId': calendarId,
    };
  }

  factory CalendarEventResponse.fromMap(Map<String, dynamic> map) {
    return CalendarEventResponse(
      eventId: map['eventId'] as String,
      calendarId: map['calendarId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CalendarEventResponse.fromJson(String source) => CalendarEventResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CalendarEventResponse(eventId: $eventId, calendarId: $calendarId)';

  @override
  bool operator ==(covariant CalendarEventResponse other) {
    if (identical(this, other)) return true;
  
    return 
      other.eventId == eventId &&
      other.calendarId == calendarId;
  }

  @override
  int get hashCode => eventId.hashCode ^ calendarId.hashCode;
}
