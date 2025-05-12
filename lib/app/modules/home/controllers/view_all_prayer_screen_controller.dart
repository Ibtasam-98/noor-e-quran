import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';

import '../../../controllers/user_location_premission_controller.dart';

class NamazController extends GetxController with GetSingleTickerProviderStateMixin {
  final GetStorage _box = GetStorage();
  final RxMap<String, RxBool> reminderSet = <String, RxBool>{}.obs;
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  final RxString selectedMethodName = "".obs;

  var isNamazLoading = false.obs;
  var namazTimings = <String, String>{}.obs;
  var namazTimes = <String>[
    "Fajr",
    "Sunrise",
    "Dhuhr",
    "Asr",
    "Sunset",
    "Maghrib",
    "Isha",
    "Imsak",
    "Midnight",
    "Firstthird",
    "Lastthird"
  ].obs;
  var icons = <String>[
    "fajr.svg",
    "fajr.svg",
    "dhuhr.svg",
    "asr.svg",
    "asr.svg",
    "maghrib.svg",
    "isha.svg",
    "isha.svg",
    "isha.svg",
    "isha.svg",
    "isha.svg"
  ].obs;

  var nextNamazTime = Rx<DateTime?>(null);
  var nextNamazName = "".obs;
  RxString timeRemaining = "".obs;
  Timer? _namazTimer;

  RxList<Map<String, dynamic>> calculationMethods = <Map<String, dynamic>>[].obs;
  Rx<int?> selectedCalculationMethod = Rx<int?>(null);

  Completer<void>? _methodsFetchedCompleter;

  @override
  void onInit() {
    super.onInit();
    print("NamazController initialized");
    _methodsFetchedCompleter = Completer<void>();
    fetchCalculationMethods().then((_) {
      _methodsFetchedCompleter?.complete();
    });
    _loadReminderStatusFromStorage();
    _startRemainingTimeTimer();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
    animationController.forward();
  }

  @override
  void onClose() {
    _namazTimer?.cancel();
    animationController.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
    _methodsFetchedCompleter?.future.then((_) {
      loadSelectedMethodAndRefresh();
    });
  }

  Future<void> saveSelectedMethod(int methodId) async {
    await _box.write('selected_calculation_method', methodId);
    selectedCalculationMethod.value = methodId;

    final method = calculationMethods.firstWhere((m) => m['id'] == methodId,
        orElse: () => calculationMethods.firstWhere(
                (m) => m['id'] == 3,
            orElse: () => calculationMethods.first
        )
    );
    selectedMethodName.value = method['name'] ?? "MWL (Muslim World League)";

    final locationController = Get.find<UserPermissionController>();
    if (locationController.locationAccessed.value) {
      await getNamazTimings(
        locationController.latitude.value,
        locationController.longitude.value,
        method: methodId,
      );
    }

    update();
  }

  Future<void> getNamazTimings(double latitude, double longitude, {int? method}) async {
    isNamazLoading.value = true;

    String apiUrl = 'http://api.aladhan.com/v1/timings?latitude=$latitude&longitude=$longitude';
    if (method != null) apiUrl += '&method=$method';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data']['timings'];
        namazTimings.value = {
          'Fajr': data['Fajr'] ?? "--",
          'Sunrise': data['Sunrise'] ?? "--",
          'Dhuhr': data['Dhuhr'] ?? "--",
          'Asr': data['Asr'] ?? "--",
          'Sunset': data['Sunset'] ?? "--",
          'Maghrib': data['Maghrib'] ?? "--",
          'Isha': data['Isha'] ?? "--",
          'Imsak': data['Imsak'] ?? "--",
          'Midnight': data['Midnight'] ?? "--",
          'Firstthird': data['Firstthird'] ?? "--",
          'Lastthird': data['Lastthird'] ?? "--",
        };
        _calculateNextNamaz();
      } else {
        print("Failed to get timings: ${response.statusCode}");
      }
    } catch (e) {
      print("Error getting namaz timings: $e");
    } finally {
      isNamazLoading.value = false;
      update();
    }
  }


  Future<void> fetchCalculationMethods() async {
    try {
      final response = await http.get(
        Uri.parse('http://api.aladhan.com/v1/methods'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          final methodsData = data['data'] as Map<String, dynamic>;
          final methodIdMapping = {
            'MWL': 3,
            'ISNA': 2,
            'EGYPT': 5,
            'MAKKAH': 4,
            'KARACHI': 1,
            'TEHRAN': 7,
            'JAFARI': 0,
            'GULF': 8,
            'KUWAIT': 9,
            'QATAR': 10,
            'SINGAPORE': 11,
            'FRANCE': 12,
            'TURKEY': 13,
            'RUSSIA': 14,
            'MOONSIGHTING': 15,
            'DUBAI': 16,
            'JAKIM': 17,
            'TUNISIA': 18,
            'ALGERIA': 19,
            'KEMENAG': 20,
            'MOROCCO': 21,
            'PORTUGAL': 22,
            'JORDAN': 23,
          };

          calculationMethods.value = methodsData.entries.where((entry) => entry.key != 'CUSTOM' && methodIdMapping.containsKey(entry.key)).map((entry) {
            final methodCode = entry.key;
            final numericId = methodIdMapping[methodCode]!;
            final methodName = entry.value['name']?.toString() ?? methodCode;
            return {
              'id': numericId,
              'name': methodName,
              'params': entry.value['params'],
              'code': methodCode,
            };
          }).toList();
          if (selectedCalculationMethod.value == null && calculationMethods.isNotEmpty) {
            selectedCalculationMethod.value = 3;
            selectedMethodName.value = calculationMethods.firstWhere(
                    (m) => m['id'] == 3,
                orElse: () => calculationMethods.first
            )['name'];
          }
        }
      }
    } on TimeoutException {
      print("Request timed out");
    } on SocketException {
      print("No internet connection");
    } catch (e) {
      print("Error fetching calculation methods: $e");
      if (e is Error) {
        print("Stack trace: ${e.stackTrace}");
      }
    }
  }

  Future<void> _loadSelectedMethod() async {
    final savedMethodId = _box.read<int>('selected_calculation_method');
    if (savedMethodId != null) {
      selectedCalculationMethod.value = savedMethodId;
      final method = calculationMethods.firstWhere((m) => m['id'] == savedMethodId,
          orElse: () => calculationMethods.firstWhere((m) => m['id'] == 3,
              orElse: () => calculationMethods.first
          )
      );
      selectedMethodName.value = method['name'] ?? "MWL (Muslim World League)";
    }
  }


  Future<void> loadSelectedMethodAndRefresh() async {
    await _loadSelectedMethod();
    final locationController = Get.find<UserPermissionController>();
    if (locationController.locationAccessed.value) {
      await getNamazTimings(
        locationController.latitude.value,
        locationController.longitude.value,
        method: selectedCalculationMethod.value,
      );
    }
  }


  void _calculateNextNamaz() {
    DateTime currentTime = DateTime.now();
    Map<String, DateTime> namazTimes = {};
    namazTimings.forEach((namazName, timeStr) {
      if (timeStr != "--") {
        try {
          DateTime prayerTime = DateFormat("HH:mm").parse(timeStr);
          namazTimes[namazName] = DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            prayerTime.hour,
            prayerTime.minute,
          );
        } catch (e) {
          print('Error parsing $namazName time: $e');
        }
      }
    });

    DateTime? nextTime;
    String nextNamaz = "";
    namazTimes.forEach((namazName, namazTime) {
      if (namazTime.isAfter(currentTime) && (nextTime == null || namazTime.isBefore(nextTime!))) {
        nextTime = namazTime;
        nextNamaz = namazName;
      }
    });

    nextNamazTime.value = nextTime;
    nextNamazName.value = nextNamaz.isNotEmpty ? nextNamaz : "None Today";
  }

  void _startRemainingTimeTimer() {
    _namazTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (nextNamazTime.value != null) {
        final remaining = nextNamazTime.value!.difference(DateTime.now());
        if (remaining.isNegative) {
          timeRemaining.value = "Namaz Started";
          _calculateNextNamaz();
        } else {
          final hours = remaining.inHours.toString().padLeft(2, '0');
          final minutes = (remaining.inMinutes % 60).toString().padLeft(2, '0');
          final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');
          timeRemaining.value = "$hours:$minutes:$seconds";
        }
      } else {
        timeRemaining.value = "No Namaz Today";
      }
    });
  }

  String formatTime(String timeStr, bool is24HourFormat) {
    if (timeStr == null || timeStr.isEmpty || timeStr == "--" || timeStr == "--/--") {
      return "--:--";
    }
    try {
      if (timeStr.contains("min")) {
        return timeStr;
      }

      DateTime prayerTime = DateFormat("HH:mm").parse(timeStr);
      return is24HourFormat ? DateFormat("HH:mm").format(prayerTime) : DateFormat("h:mm a").format(prayerTime);
    } catch (e) {
      return timeStr;
    }
  }

  Future<void> _loadReminderStatusFromStorage() async {
    for (var namaz in namazTimes) {
      final savedStatus = _box.read<bool>('reminder_$namaz');
      reminderSet[namaz] = RxBool(savedStatus ?? false);
    }
  }

  Future<void> saveReminderStatus(String namazName, bool isSet) async {
    await _box.write('reminder_$namazName', isSet);
    update();
  }

  void onCalculationMethodChanged(int? methodId) {
    selectedCalculationMethod.value = methodId;
    update();
  }

  Future<void> addToCalendar(String namazName, String namazTime) async {
    DateTime prayerDateTime = _parsePrayerTime(namazTime);
    try {
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
      if (success != null && success) {
        await saveReminderStatus(namazName, true);
        reminderSet[namazName]?.value = true; // Update the observable
        CustomSnackbar.show(
          title: "Success",
          subtitle: '$namazName prayer time added to calendar',
          icon: const Icon(Icons.check),
          backgroundColor: AppColors.green,
        );
      } else {
        CustomSnackbar.show(
          title: "Info",
          subtitle: 'Could not add $namazName prayer time to calendar (user might have cancelled)',
          icon: const Icon(Icons.info_outline),
          backgroundColor: AppColors.orange,
        );
      }
    } catch (e) {
      print('Error adding to calendar: $e');
      CustomSnackbar.show(
        title: "Error",
        subtitle: 'Could not add $namazName prayer time to calendar',
        icon: const Icon(Icons.error_outline),
        backgroundColor: AppColors.red,
      );
    }
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
  String formattedHijriDate() {
    HijriCalendar hijri = HijriCalendar.now();
    String monthName = hijri.longMonthName;
    int day = hijri.hDay;
    int year = hijri.hYear;
    return "$monthName, $day. $year";
  }
}

