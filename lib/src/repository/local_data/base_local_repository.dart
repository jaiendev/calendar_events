part of manage_calendar_events;

class BaseLocalRepository {
  static Future<String> get localStoreDirAskany async =>
      '${(await getApplicationSupportDirectory()).path}/hive';

  Future<void> initialBox() async {
    final String path = await localStoreDirAskany;

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
