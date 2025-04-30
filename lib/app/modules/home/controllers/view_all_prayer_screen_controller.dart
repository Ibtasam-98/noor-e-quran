// view_all_prayer_controller.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';

class ViewAllPrayerController extends GetxController {
  final _storage = GetStorage();
  final RxMap<String, RxBool> reminderSet = <String, RxBool>{}.obs;
  final List<String> namazTimes;
  final Map<String, String> namazTimings;
  final List<String> icons;

  ViewAllPrayerController({
    required this.namazTimes,
    required this.namazTimings,
    required this.icons,
  });

  @override
  void onInit() {
    super.onInit();
    _loadReminderStatusFromStorage();
  }

  Future<void> _loadReminderStatusFromStorage() async {
    print("Loading reminder status from GetStorage (Controller)...");
    for (var namaz in namazTimes) {
      final savedStatus = _storage.read<bool>('reminder_$namaz');
      print("Reminder status for $namaz: $savedStatus (Controller)");
      reminderSet[namaz] = RxBool(savedStatus ?? false);
    }
    print("Reminder status loaded (Controller).");
  }

  Future<void> saveReminderStatus(String namazName, bool isSet) async {
    print("Saving reminder status for $namazName to GetStorage: $isSet (Controller)");
    await _storage.write('reminder_$namazName', isSet);
    print("Reminder status saved (Controller).");
  }

  DateTime _parsePrayerTime(String namazTime) {
    final now = DateTime.now();
    final format = DateFormat("HH:mm");
    try {
      final parsedTime = format.parse(namazTime);
      return DateTime(now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);
    } catch (e) {
      print("Error parsing time: $e (Controller)");
      return now;
    }
  }

  Future<void> addToCalendar(String namazName, String namazTime) async {
    DateTime prayerDateTime = _parsePrayerTime(namazTime);

    final Event event = Event(
      title: 'Time for $namazName',
      description: 'Prayer time for $namazName',
      startDate: prayerDateTime,
      endDate: prayerDateTime.add(const Duration(minutes: 5)),
      allDay: false,
      iosParams: const IOSParams(
        reminder: Duration(minutes: 0),
      ),
      androidParams: const AndroidParams(),
    );

    final bool? success = await Add2Calendar.addEvent2Cal(event);

    print('Add to calendar success: $success for $namazName (Controller)');

    if (success == true) {
      Get.snackbar(
        'Reminder Added',
        'A reminder for $namazName at ${DateFormat('hh:mm a').format(prayerDateTime)} has been added to your calendar.',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Setting reminderSet[$namazName].value to true (Controller)');
      reminderSet[namazName]!.value = true;
      await saveReminderStatus(namazName, true);
      final savedValue = _storage.read<bool>('reminder_$namazName');
      print('Value of reminder_$namazName after saving: $savedValue (Controller)');
    } else {
      if (success != null && !success) {
        Get.snackbar(
          'Error',
          'Failed to add reminder to calendar.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  String formattedHijriDate() {
    HijriCalendar hijri = HijriCalendar.now();
    String monthName = hijri.longMonthName;
    int day = hijri.hDay;
    int year = hijri.hYear;
    return "$monthName, $day. $year";
  }
}