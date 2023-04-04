// Package imports:
import 'package:hive/hive.dart';

// Project imports:
import 'package:manage_calendar_events/src/constants/local_key.dart';
import 'package:manage_calendar_events/src/model/local_calendar_model.dart';

class CalendarEventsLocal {
  var box = Hive.box(LocalKeys.boxCalendar);

  bool hasCalendarEvent({
    required String userId,
    required String offerId,
  }) =>
      listCalendarEvent(userId: userId).indexWhere(
        (calendar) => calendar.offerId == offerId,
      ) !=
      -1;

  // Getter
  List<CalendarLocalModel> listCalendarEvent({required String userId}) {
    final List? calenderEvents = box.get("${LocalKeys.calendarEvents}/$userId");

    return (calenderEvents ?? <CalendarLocalModel>[])
        .map((calendar) => CalendarLocalModel.fromJson(calendar))
        .toList();
  }

  CalendarLocalModel? getCalendarEvent(
      {required String userId, required String offerId}) {
    final List<CalendarLocalModel> calendarEvents = listCalendarEvent(
      userId: userId,
    );

    final int index =
        calendarEvents.indexWhere((calendar) => calendar.offerId == offerId);

    if (index == -1) return null;

    return calendarEvents[index];
  }

  // Setter
  void putCalendarEvent({
    required CalendarLocalModel calendarLocalModel,
    required String userId,
  }) {
    final List<CalendarLocalModel> calendarEvents = listCalendarEvent(
      userId: userId,
    );

    final int indexOfCalendarEvent = calendarEvents.indexWhere(
      (value) => value == calendarLocalModel,
    );

    if (indexOfCalendarEvent != -1) {
      calendarEvents.removeAt(indexOfCalendarEvent);
    } else {
      calendarEvents.add(calendarLocalModel);
    }

    box.put(
      '${LocalKeys.calendarEvents}/$userId',
      calendarEvents.map((calendar) => calendar.toJson()).toList(),
    );
  }

  void clearCalendarEvent({
    required String userId,
  }) {
    box.put('${LocalKeys.calendarEvents}/$userId', []);
    box.clear();
  }
}
