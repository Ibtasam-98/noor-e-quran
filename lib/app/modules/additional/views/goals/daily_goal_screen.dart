import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noor_e_quran/app/widgets/custom_button.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:intl/intl.dart';
import 'package:get_storage/get_storage.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:convert';

import '../../../../config/app_colors.dart';
import '../../../../config/app_sizedbox.dart';
import '../../../../controllers/app_theme_switch_controller.dart';
import '../../../../widgets/custom_snackbar.dart';
import '../../../../widgets/custom_text.dart';
import 'all_goals_screen.dart';

class DailyGoalScreen extends StatefulWidget {
  @override
  _DailyGoalScreenState createState() => _DailyGoalScreenState();
}

class _DailyGoalScreenState extends State<DailyGoalScreen> {
  final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());

  int currentYear = DateTime.now().year;
  int currentMonth = DateTime.now().month;
  DateTime selectedDate = DateTime.now();
  List<DateTime> dates = [];
  Map<DateTime, double> dateProgress = {};
  ScrollController scrollController = ScrollController();
  List<String> dailyGoals = [
    "Praying on time",
    "Removing harm from a path",
    "Reciting Quran",
    "Saying Subhanallah",
    "Made someone smile",
    "Making dua for others",
    "Giving charity",
    "Visiting the sick",
    "Helping a neighbor",
    "Speaking kind words",
    "Forgiving someone",
    "Planting a tree",
    "Feeding the hungry",
    "Seeking knowledge",
    "Honoring parents",
    "Maintaining family ties",
    "Attending a religious lecture",
    "Avoiding backbiting",
    "Controlling anger",
    "Offering sincere advice",
    "Remembering Allah (Dhikr)",
  ];
  List<int> selectedGoalIndices = [];
  bool showSaveButton = false;
  final box = GetStorage();
  bool showGoalList = false;
  final TextEditingController _goalController = TextEditingController();
  String? selectedMonth;
  List<String> monthList = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];

  Map<DateTime, List<String>> savedGoals = {};

  @override
  void initState() {
    super.initState();
    selectedMonth = monthList[currentMonth - 1];
    _loadDailyGoals();
    _generateDates();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentDate();
    });
    _loadSavedGoals();
    _printSavedData();
  }

  void _printSavedData() {
    print("--- Saved Data in GetStorage ---");
    final data = box.read('dailyGoals');
    print("dailyGoals: $data");
    print("--- End of Saved Data ---");
  }

  void _loadDailyGoals() {
    String? savedGoalsData = box.read('dailyGoals');
    if (savedGoalsData != null) {
      List<dynamic> decodedList = json.decode(savedGoalsData);
      dailyGoals = decodedList.map((item) => item.toString()).toList();
    }
  }

  void _saveDailyGoals() {
    box.write('dailyGoals', json.encode(dailyGoals));
  }

  void _loadSavedData() {
    String? savedData = box.read('dailyGoal_${selectedDate.toIso8601String()}');
    if (savedData != null) {
      List<String> parts = savedData.split('|');
      if (parts.length == 2) {
        List<int> savedIndices = parts[1].split(',').where((element) => element.isNotEmpty).map(int.parse).toList();
        setState(() {
          selectedGoalIndices = savedIndices;
          showSaveButton = true;
          showGoalList = true;
        });
      } else {
        setState(() {
          selectedGoalIndices.clear();
          showSaveButton = false;
          showGoalList = true;
        });
      }
    } else {
      setState(() {
        selectedGoalIndices.clear();
        showSaveButton = false;
        showGoalList = true;
      });
    }
  }

  void _loadSavedGoals() {
    savedGoals.clear();
    for (var date in dates) {
      String? savedData = box.read('dailyGoal_${date.toIso8601String()}');
      if (savedData != null) {
        List<String> parts = savedData.split('|');
        if (parts.length == 2) {
          List<int> savedIndices = parts[1].split(',').where((element) => element.isNotEmpty).map(int.parse).toList();
          savedGoals[date] = savedIndices.map((index) => dailyGoals[index]).toList();
        }
      }
    }
    setState(() {});
  }

  void _generateDates() {
    dates.clear();
    dateProgress.clear();
    final firstDayOfMonth = DateTime(currentYear, currentMonth, 1);
    final lastDayOfMonth = DateTime(currentYear, currentMonth + 1, 0);

    for (var date = firstDayOfMonth;
    date.isBefore(lastDayOfMonth.add(Duration(days: 1)));
    date = date.add(Duration(days: 1))) {
      dates.add(date);
      dateProgress[date] = 0.0;
    }
    setState(() {});
  }

  void _scrollToCurrentDate() {
    int currentDateIndex = dates.indexWhere((date) =>
    date.day == selectedDate.day &&
        date.month == selectedDate.month &&
        date.year == selectedDate.year);

    if (currentDateIndex != -1) {
      double itemWidth = 50.0;
      double offset = currentDateIndex * itemWidth;
      scrollController.animateTo(
        offset,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showGoalBottomSheet(DateTime date) {
    List<String>? goals = savedGoals[date];
    if (goals != null && goals.isNotEmpty) {
      showModalBottomSheet(
        backgroundColor: AppColors.white,
        context: context,
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSizedBox.space5h,
              Padding(
                padding: EdgeInsets.only(left: 12.w, top: 15.h),
                child: CustomText(
                  textColor: AppColors.primary,
                  fontSize: 20.sp,
                  title: "Daily Goals for ${DateFormat('yyyy-MM-dd').format(date)}",
                  textAlign: TextAlign.start,
                  fontFamily: 'grenda',
                ),
              ),
              AppSizedBox.space10h,
              Expanded(
                child: ListView.builder(
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 8.h, top: 8.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: (index % 2 == 0)
                            ? AppColors.primary.withOpacity(0.29)
                            : AppColors.primary.withOpacity(0.1),
                      ),
                      child: ListTile(
                        leading: CustomText(
                          title: (index + 1).toString(),
                          fontSize: 16.sp,
                          textColor: AppColors.black,
                          fontWeight: FontWeight.w600,
                          textOverflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                        ),
                        title: CustomText(
                          title: goals[index],
                          fontSize: 16.sp,
                          textColor: AppColors.black,
                          fontWeight: FontWeight.w500,
                          textOverflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                        ),
                        trailing: Icon(
                          LineIcons.heart,
                          color: AppColors.red.withOpacity(0.5),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          );
        },
      );
    }
  }

  void _showAddGoalBottomSheet() {
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title: 'Add your Goal',
                fontSize: 20.sp,
                textColor: AppColors.primary,
                textAlign: TextAlign.start,
                fontFamily: 'grenda',
              ),
              AppSizedBox.space10h,
              TextField(
                controller: _goalController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Enter Goal Name',
                  fillColor: themeController.isDarkMode.value
                      ? AppColors.grey.withOpacity(0.1)
                      : AppColors.grey.withOpacity(0.2),
                  filled: true,
                  hintStyle: GoogleFonts.quicksand(
                    color: AppColors.black,
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              AppSizedBox.space20h,
              CustomButton(
                haveBgColor: true,
                btnTitle: "Add",
                btnTitleColor: AppColors.white,
                borderRadius: 45.r,
                height: 45.h,
                bgColor: AppColors.primary,
                useGradient: true,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.secondry.withOpacity(0.9),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                onTap: () {
                  final newGoal = _goalController.text.trim();
                  if (newGoal.isNotEmpty && RegExp(r'^[a-zA-Z ]+$').hasMatch(newGoal)) {
                    setState(() {
                      dailyGoals.insert(0, newGoal);
                      _goalController.clear();
                      _saveDailyGoals();
                    });
                    Navigator.pop(context);
                  } else {
                    CustomSnackbar.show(
                      backgroundColor: Colors.red,
                      title: "Invalid Goal",
                      subtitle: "Only alphabets and spaces are allowed.",
                      icon: Icon(Icons.error_outline),
                    );
                  }
                },
              ),
              AppSizedBox.space20h,
            ],
          ),
        );
      },
    );
  }

  void _saveSelectedGoals() {
    String goalsString = selectedGoalIndices.join(',');
    box.write(
        'dailyGoal_${selectedDate.toIso8601String()}',
        '${selectedDate.toIso8601String()}|$goalsString');
    setState(() {
      showSaveButton = false;
      showGoalList = false;
      _loadSavedGoals();
    });
    CustomSnackbar.show(
      backgroundColor: AppColors.red,
      title: "Ma Sha Allah",
      subtitle: "Your Goal is Added!",
      icon: Icon(LineIcons.heart),
    );
  }

  void _showAllGoalsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllGoalsScreen(savedGoals: savedGoals, dailyGoals: dailyGoals, themeController: themeController),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeController.isDarkMode.value;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;

    double progressBarRatio = selectedDate != DateTime.now()
        ? selectedGoalIndices.isNotEmpty
        ? selectedGoalIndices.length / dailyGoals.length
        : 0.0
        : 0.0;

    return Scaffold(
      backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.west,
            color: textColor,
          ),
        ),
        centerTitle: false,
        title: CustomText(
          firstText: "Daily ",
          secondText: "Goals",
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
          fontSize: 18.sp,
        ),
        actions: [
          IconButton(
            icon: Icon(LineIcons.plus, size: 16.h,color: themeController.isDarkMode.value ? AppColors.white : AppColors.black,),
            onPressed: _showAddGoalBottomSheet,
          ),
          IconButton(
            icon: Icon(LineIcons.list, size: 16.h,color: themeController.isDarkMode.value ? AppColors.white : AppColors.black,),
            onPressed: _showAllGoalsScreen,
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              height: 45.0,
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: isDarkMode
                      ? AppColors.grey.withOpacity(0.1)
                      : AppColors.grey.withOpacity(0.2),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: DropdownButton<String>(
                          value: selectedMonth,
                          items: monthList.map((String month) {
                            return DropdownMenuItem<String>(
                              value: month,
                              child: CustomText(
                                title: month,
                                fontSize: 14.sp,
                                textColor: AppColors.primary,
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedMonth = newValue;
                                currentMonth = monthList.indexOf(newValue) + 1;
                                _generateDates();
                                selectedDate = dates.isNotEmpty ? dates.first : DateTime.now();
                                _loadSavedData();
                                _loadSavedGoals();
                              });
                            }
                          },
                          isExpanded: true,
                          style: TextStyle(color: AppColors.white),
                          dropdownColor: AppColors.white,
                          underline: Container(),
                          icon: SizedBox.shrink(),
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 200,
            child: Center(
              child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: dates.length,
                itemBuilder: (context, index) {
                  final date = dates[index];
                  final isSelected = selectedDate.day == date.day &&
                      selectedDate.month == date.month &&
                      selectedDate.year == date.year;

                  final isCurrentDate = DateTime.now().day == date.day &&
                      DateTime.now().month == date.month &&
                      DateTime.now().year == date.year;

                  return GestureDetector(
                    onTap: () {
                      if (date.isAfter(DateTime.now())) {
                        CustomSnackbar.show(
                          backgroundColor: AppColors.red,
                          title: "Future Date",
                          subtitle: "You cannot add goals for future dates.",
                          icon: Icon(Icons.error_outline),
                        );
                      } else {
                        setState(() {
                          selectedDate = date;
                          _loadSavedData();
                          if (date == DateTime.now()) {
                            showGoalList = true;
                          } else {
                            _showGoalBottomSheet(date);
                          }
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (date.isAfter(DateTime.now())) {
                                CustomSnackbar.show(
                                  backgroundColor: AppColors.red,
                                  title: "Future Date",
                                  subtitle: "You cannot add goals for future dates.",
                                  icon: Icon(Icons.info_outline),
                                );
                              } else {
                                setState(() {
                                  selectedDate = date;
                                  _loadSavedData();
                                  if (date == DateTime.now()) {
                                    showGoalList = true;
                                  } else {
                                    _showGoalBottomSheet(date);
                                  }
                                });
                              }
                            },
                            child: SizedBox(
                              height: 100.h,
                              width: 30,
                              child: SimpleAnimationProgressBar(
                                height: 100.h,
                                width: 15,
                                backgroundColor: isDarkMode ? AppColors.grey.withOpacity(0.1) : AppColors.black.withOpacity(0.1),
                                foregrondColor: Colors.purple,
                                ratio: savedGoals[date] != null ? savedGoals[date]!.length / dailyGoals.length : 0.0,
                                direction: Axis.vertical,
                                curve: Curves.fastLinearToSlowEaseIn,
                                duration: const Duration(seconds: 3),
                                borderRadius: BorderRadius.circular(20),
                                gradientColor: const LinearGradient(
                                    colors: [
                                      AppColors.primary,
                                      AppColors.secondry,
                                      AppColors.dayColor,
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter),
                                reverseAlignment: true,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: isSelected
                                ? BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: isCurrentDate ? Colors.green : Colors.orange, width: 2),
                            )
                                : null,
                            child: Column(
                              children: [
                                CustomText(
                                  title:DateFormat('dd').format(date),
                                  fontSize: 12.sp,
                                  textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                                ),
                                CustomText(
                                  title:DateFormat('E').format(date),
                                  fontSize: 12.sp,
                                  textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: selectedDate == DateTime.now()
                  ? CustomText(
                title: 'To add a daily goal, select a date.',
                fontSize: 13.sp,
                textAlign: TextAlign.start,
              )
                  : CustomText(
                title: 'Selected: ${DateFormat('EEEE, MMM d, y').format(selectedDate)}',
                fontSize: 13.sp,
                textAlign: TextAlign.start,
                textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
              ),
            ),
          ),
          AppSizedBox.space15h,
          if (showGoalList)
            Expanded(
              child: ListView.builder(
                itemCount: dailyGoals.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedGoalIndices.contains(index);
                  return Container(
                    margin: EdgeInsets.only(
                        left: 10.w, right: 10.w, bottom: 5, top: 5.h),
                    padding: EdgeInsets.only(
                        right: 10.w, top: 10.h, bottom: 10.h, left: 10.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: (index % 2 == 1)
                          ? AppColors.primary.withOpacity(0.29)
                          : AppColors.primary.withOpacity(0.1),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              if (!selectedGoalIndices.contains(index)) {
                                selectedGoalIndices.add(index);
                                showSaveButton = true;
                              }
                            } else {
                              selectedGoalIndices.remove(index);
                              if (selectedGoalIndices.isEmpty) {
                                showSaveButton = false;
                              }
                            }
                          });
                        },
                        activeColor: AppColors.primary,
                        checkColor: AppColors.white,
                      ),
                      title: CustomText(
                        title: dailyGoals[index],
                        fontSize: 13.sp,
                        textAlign: TextAlign.start,
                        textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
          if (showSaveButton)
            Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 25.h),
              child: CustomButton(
                haveBgColor: true,
                btnTitle: "Save Goals",
                btnTitleColor: AppColors.white,
                bgColor: AppColors.primary,
                useGradient: true,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.secondry.withOpacity(0.9),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: 45.r,
                height: 45.h,
                onTap: () {
                  _saveSelectedGoals();
                },
              ),
            ),
        ],
      ),
    );
  }
}