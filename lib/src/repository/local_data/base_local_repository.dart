part of manage_calendar_events;

class BaseLocalRepository {

  Future<void> initialBox() async {
    final Directory directory = await getApplicationDocumentsDirectory();

    Hive.init("${directory.path}/calendar-event");
    await Hive.openBox(LocalKeys.boxCalendar);
  }

  /// Singleton factory
  static final BaseLocalRepository instance = BaseLocalRepository._internal();

  factory BaseLocalRepository() {
    return instance;
  }

  BaseLocalRepository._internal();
}
