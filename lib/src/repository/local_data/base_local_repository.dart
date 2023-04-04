part of manage_calendar_events;

class BaseLocalRepository {

  Future<void> initialBox() async {
    final String path = '${(await getApplicationSupportDirectory()).path}/hive';

    Hive.init(path);
    await Hive.openBox(LocalKeys.boxCalendar);
  }

  /// Singleton factory
  static final BaseLocalRepository instance = BaseLocalRepository._internal();

  factory BaseLocalRepository() {
    return instance;
  }

  BaseLocalRepository._internal();
}
