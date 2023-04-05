part of manage_calendar_events;

class CalendarPlugin {
  static const MethodChannel _channel =
      const MethodChannel('manage_calendar_events');

  Future<void> openLocal() async {
    BaseLocalRepository.instance.initialBox();
  }

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Check your app has permissions to access the calendar events
  Future<bool?> hasPermissions() async {
    bool? hasPermission = false;
    try {
      hasPermission = await _channel.invokeMethod('hasPermissions');
    } catch (e) {}

    return hasPermission;
  }

  /// Request the app to fetch the permissions to access the calendar
  Future<void> requestPermissions() async {
    try {
      await _channel.invokeMethod('requestPermissions');
    } catch (e) {}
  }

  /// Returns the available calendars from the device
  Future<List<Calendar>?> getCalendars() async {
    List<Calendar>? calendars = [];

    try {
      String calendarsJson = await _channel.invokeMethod('getCalendars');
      calendars = json.decode(calendarsJson).map<Calendar>((decodedCalendar) {
        return Calendar.fromMap(decodedCalendar);
      }).toList();
    } catch (e) {}

    return calendars;
  }

  /// Returns all the available events in the selected calendar
  Future<List<CalendarEvent>?> getEvents({required String calendarId}) async {
    List<CalendarEvent>? events = [];

    try {
      String eventsJson = await _channel.invokeMethod(
          'getEvents', <String, Object?>{'calendarId': calendarId});
      events =
          json.decode(eventsJson).map<CalendarEvent>((decodedCalendarEvent) {
        return CalendarEvent.fromJson(decodedCalendarEvent);
      }).toList();
    } catch (e) {}

    return events;
  }

  /// Returns all the available events on the given date Range
  Future<List<CalendarEvent>?> getEventsByDateRange({
    required String calendarId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    List<CalendarEvent>? events = [];

    try {
      String eventsJson =
          await _channel.invokeMethod('getEventsByDateRange', <String, Object?>{
        'calendarId': calendarId,
        'startDate': startDate.millisecondsSinceEpoch,
        'endDate': endDate.millisecondsSinceEpoch,
      });
      events =
          json.decode(eventsJson).map<CalendarEvent>((decodedCalendarEvent) {
        return CalendarEvent.fromJson(decodedCalendarEvent);
      }).toList();
    } catch (e) {}

    return events;
  }

  /// Returns all the available events on the given date Range
  Future<List<CalendarEvent>?> getEventsByMonth({
    required String calendarId,
    required DateTime findDate,
  }) async {
    DateTime startDate = findFirstDateOfTheMonth(findDate);
    DateTime endDate = findLastDateOfTheMonth(findDate);

    return getEventsByDateRange(
        calendarId: calendarId, startDate: startDate, endDate: endDate);
  }

  /// Returns all the available events on the given date Range
  Future<List<CalendarEvent>?> getEventsByWeek({
    required String calendarId,
    required DateTime findDate,
  }) async {
    DateTime startDate = findFirstDateOfTheWeek(findDate);
    DateTime endDate = findLastDateOfTheWeek(findDate);

    return getEventsByDateRange(
        calendarId: calendarId, startDate: startDate, endDate: endDate);
  }

  /// Helps to create an event in the selected calendar
  Future<void> createEvent({
    required String title,
    required String description,
    required String offerId,
    required String userId,
    DateTime? startTime,
    DateTime? endTime,
    String? url,
    Attendees? attendees,
    Reminder? reminder,
    Function()? handleFail,
    Function()? handleExisted,
    Function()? handleSuccess,
  }) async {
    if (CalendarEventsLocal().hasCalendarEvent(
      offerId: offerId,
      userId: userId,
    )) {
      if (handleExisted != null) {
        handleExisted();
      }

      return;
    }

    final CalendarEvent newEvent = CalendarEvent(
      title: title,
      description: description,
      startDate: startTime ?? DateTime.now(),
      endDate: endTime ??
          DateTime.now().add(
            const Duration(minutes: delayHalfMinute),
          ),
      location: 'Askany App',
      url: url,
      attendees: attendees ??
          Attendees(
            attendees: [
              Attendee(name: "Askany", emailAddress: "abc@gmail.com"),
            ],
          ),
      reminder: reminder ?? Reminder(minutes: delayHalfMinute),
    );

    final List<Calendar> listCalendar = await getCalendars() ?? [];

    if (listCalendar.isEmpty ||
        listCalendar[0].id == null ||
        listCalendar[0].id!.isEmpty) return;

    try {
      final String? eventId = await _channel.invokeMethod(
        'createEvent',
        <String, Object?>{
          'calendarId': listCalendar[0].id,
          'eventId': newEvent.eventId != null ? newEvent.eventId : null,
          'title': newEvent.title,
          'description': newEvent.description,
          'startDate': newEvent.startDate!.millisecondsSinceEpoch,
          'endDate': newEvent.endDate!.millisecondsSinceEpoch,
          'location': newEvent.location,
          'isAllDay': newEvent.isAllDay != null ? newEvent.isAllDay : false,
          'hasAlarm': newEvent.hasAlarm != null ? newEvent.hasAlarm : false,
          'url': newEvent.url,
          'reminder':
              newEvent.reminder != null ? newEvent.reminder!.minutes : null,
          'attendees': newEvent.attendees != null
              ? newEvent.attendees!.attendees
                  .map((attendee) => attendee.toJson())
                  .toList()
              : null,
        },
      );

      if (eventId != null && eventId.isNotEmpty) {
        CalendarEventsLocal().putCalendarEvent(
          calendarLocalModel: CalendarLocalModel(
            offerId: offerId,
            calendarId: listCalendar[0].id ?? "",
            eventId: eventId,
          ),
          userId: userId,
        );

        if (handleSuccess != null) {
          handleSuccess();
        }
      } else {
        if (handleFail != null) {
          handleFail();
        }
      }
    } catch (e) {
      if (handleFail != null) {
        handleFail();
      }
    }
  }

  /// Helps to update the edited event
  Future<String?> updateEvent({
    required String calendarId,
    required CalendarEvent event,
  }) async {
    String? eventId;

    try {
      eventId = await _channel.invokeMethod(
        'updateEvent',
        <String, Object?>{
          'calendarId': calendarId,
          'eventId': event.eventId != null ? event.eventId : null,
          'title': event.title,
          'description': event.description,
          'startDate': event.startDate!.millisecondsSinceEpoch,
          'endDate': event.endDate!.millisecondsSinceEpoch,
          'location': event.location,
          'isAllDay': event.isAllDay != null ? event.isAllDay : false,
          'hasAlarm': event.hasAlarm != null ? event.hasAlarm : false,
          'url': event.url,
          'reminder': event.reminder != null ? event.reminder!.minutes : null,
          'attendees': event.attendees != null
              ? event.attendees!.attendees
                  .map((attendee) => attendee.toJson())
                  .toList()
              : null,
        },
      );
    } catch (e) {}

    return eventId;
  }

  /// Deletes the selected event in the selected calendar
  Future<void> deleteEvent({
    required String userId,
    required String offerId,
    Function()? handleFail,
    Function()? handleSuccess,
  }) async {
    final CalendarLocalModel? calendarEvent =
        CalendarEventsLocal().getCalendarEvent(
      offerId: offerId,
      userId: userId,
    );

    if (calendarEvent != null) {
      final List<CalendarEvent>? calendarEvents =
          await getEvents(calendarId: calendarEvent.calendarId);
      final List<String?> eventIds = (calendarEvents ?? [])
          .map((calendarEvent) => calendarEvent.eventId)
          .toList();

      if (!eventIds.contains(calendarEvent.eventId)) {
        CalendarEventsLocal().putCalendarEvent(
          calendarLocalModel: calendarEvent,
          userId: userId,
        );

        if (handleSuccess != null) {
          handleSuccess();
        }

        return;
      }

      try {
        final bool? isDeleted = await _channel.invokeMethod(
          'deleteEvent',
          <String, Object?>{
            'calendarId': calendarEvent.calendarId,
            'eventId': calendarEvent.eventId,
          },
        );
        if (isDeleted ?? false) {
          CalendarEventsLocal().putCalendarEvent(
            calendarLocalModel: calendarEvent,
            userId: userId,
          );

          if (handleSuccess != null) {
            handleSuccess();
          }

          return;
        }
      } catch (e) {}
    }

    if (handleFail != null) {
      handleFail();
    }
  }

  /// Helps to add reminder in Android [add alarms in iOS]
  Future<void> addReminder({
    required String calendarId,
    required String eventId,
    int? minutes,
  }) async {
    try {
      await _channel.invokeMethod(
        'addReminder',
        <String, Object?>{
          'calendarId': calendarId,
          'eventId': eventId,
          'minutes': minutes.toString(),
        },
      );
    } catch (e) {}
  }

  /// Helps to update the selected reminder
  Future<int?> updateReminder({
    required String calendarId,
    required String eventId,
    int? minutes,
  }) async {
    int? updateCount = 0;
    try {
      updateCount = await _channel.invokeMethod(
        'updateReminder',
        <String, Object?>{
          'calendarId': calendarId,
          'eventId': eventId,
          'minutes': minutes.toString(),
        },
      );
    } catch (e) {}
    return updateCount;
  }

  /// Helps to delete the selected event's reminder
  Future<int?> deleteReminder({required String eventId}) async {
    int? updateCount = 0;
    try {
      updateCount = await _channel.invokeMethod(
        'deleteReminder',
        <String, Object?>{
          'eventId': eventId,
        },
      );
    } catch (e) {}
    return updateCount;
  }

  /// Returns all the available Attendees on the selected event
  Future<List<Attendee>?> getAttendees({
    required String eventId,
  }) async {
    List<Attendee>? attendees;
    try {
      String attendeesJson =
          await _channel.invokeMethod('getAttendees', <String, Object?>{
        'eventId': eventId,
      });
      attendees = json.decode(attendeesJson).map<Attendee>((decodedAttendee) {
        return Attendee.fromJson(decodedAttendee);
      }).toList();
    } catch (e) {}

    return attendees;
  }

  /// Helps to add Attendees to an Event
  Future<void> addAttendees({
    required String eventId,
    required List<Attendee> newAttendees,
  }) async {
    try {
      await _channel.invokeMethod(
        'addAttendees',
        <String, Object?>{
          'eventId': eventId,
          'attendees':
              newAttendees.map((attendee) => attendee.toJson()).toList(),
        },
      );
    } catch (e) {}
  }

  /// Helps to remove an Attendee from an Event
  Future<void> deleteAttendee({
    required String eventId,
    required Attendee attendee,
  }) async {
    try {
      await _channel.invokeMethod(
        'deleteAttendee',
        <String, Object?>{
          'eventId': eventId,
          'attendee': attendee.toJson(),
        },
      );
    } catch (e) {}
  }

  /// Find the first date of the month which contains the provided date.
  DateTime findFirstDateOfTheMonth(DateTime dateTime) {
    DateTime firstDayOfMonth = DateTime.utc(dateTime.year, dateTime.month, 1);

    return firstDayOfMonth;
  }

  /// Find the last date of the month which contains the provided date.
  DateTime findLastDateOfTheMonth(DateTime dateTime) {
    DateTime lastDayOfMonth = DateTime.utc(dateTime.year, dateTime.month + 1, 1)
        .subtract(Duration(hours: 1));

    return lastDayOfMonth;
  }

  /// Find the first date of the week which contains the provided date.
  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  /// Find last date of the week which contains provided date.
  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }
}
