
import 'dart:async';
import 'dart:math' show pi, sin, cos, atan2;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:vector_math/vector_math.dart' show radians, degrees;
import 'package:get/get.dart';

import '../../../config/app_colors.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../controllers/user_location_premission_controller.dart';
import '../../../widgets/custom_text.dart';
import '../controllers/app_home_screen_controller.dart';

const double kaabaLatitude = 21.422487;
const double kaabaLongitude = 39.826206;

class QiblaScreen extends StatefulWidget {
  String city;
  QiblaScreen({required this.city});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  double? _heading;
  double? _qiblaAngle;
  String _locationStatus = 'Getting location...';
  String _qiblaDirectionFrom = 'North';

  StreamSubscription? _compassSubscription;
  StreamSubscription<Position>? _positionSubscription;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndSetupStreams();
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    _positionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkPermissionsAndSetupStreams() async {
    setState(() {
      _locationStatus = 'Checking location permissions...';
    });
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationStatus = 'Location permissions are permanently denied.';
      });
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        setState(() {
          _locationStatus = 'Location permissions are denied.';
        });
        return;
      }
    }

    setState(() {
      _locationStatus = 'Getting current location...';
    });
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100, // Increased distance filter to reduce frequent updates
    );

    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
          if (mounted) {
            final newQiblaAngle = _calculateQiblaAngle(position);
            if (newQiblaAngle != _qiblaAngle) {
              setState(() {
                _locationStatus =
                'Location: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
                _qiblaAngle = newQiblaAngle;
                _updateQiblaDirectionFrom(_qiblaAngle);
              });
            }
          }
        }, onError: (e) {
          print("Error listening to location: $e");
          if (mounted) {
            setState(() {
              _locationStatus = 'Error getting location: $e';
            });
          }
        });

    _startCompassStream();
  }

  void _startCompassStream() {
    _compassSubscription = FlutterCompass.events?.listen((CompassEvent event) {
      if (mounted) {
        setState(() {
          _heading = event.heading;
        });
      }
    }, onError: (e) {
      print("Error listening to compass: $e");
      if (mounted) {
        setState(() {
          _locationStatus = 'Could not get compass data.';
        });
      }
    });
  }

  double _calculateQiblaAngle(Position userPosition) {
    double userLatRad = radians(userPosition.latitude);
    double userLonRad = radians(userPosition.longitude);
    double kaabaLatRad = radians(kaabaLatitude);
    double kaabaLonRad = radians(kaabaLongitude);

    double deltaLon = kaabaLonRad - userLonRad;

    double y = sin(deltaLon) * cos(kaabaLatRad);
    double x = cos(userLatRad) * sin(kaabaLatRad) -
        sin(userLatRad) * cos(kaabaLatRad) * cos(deltaLon);

    double bearingRad = atan2(y, x);
    return (degrees(bearingRad) + 360) % 360;
  }

  void _updateQiblaDirectionFrom(double? qiblaAngle) {
    if (qiblaAngle != null) {
      if (qiblaAngle >= 337.5 || qiblaAngle < 22.5) {
        _qiblaDirectionFrom = 'North';
      } else if (qiblaAngle >= 22.5 && qiblaAngle < 67.5) {
        _qiblaDirectionFrom = 'North-East';
      } else if (qiblaAngle >= 67.5 && qiblaAngle < 112.5) {
        _qiblaDirectionFrom = 'East';
      } else if (qiblaAngle >= 112.5 && qiblaAngle < 157.5) {
        _qiblaDirectionFrom = 'South-East';
      } else if (qiblaAngle >= 157.5 && qiblaAngle < 202.5) {
        _qiblaDirectionFrom = 'South';
      } else if (qiblaAngle >= 202.5 && qiblaAngle < 247.5) {
        _qiblaDirectionFrom = 'South-West';
      } else if (qiblaAngle >= 247.5 && qiblaAngle < 292.5) {
        _qiblaDirectionFrom = 'West';
      } else {
        _qiblaDirectionFrom = 'North-West';
      }
    } else {
      _qiblaDirectionFrom = '...';
    }
  }

  double _getRotationAngle() {
    if (_heading == null || _qiblaAngle == null) {
      return 0.0;
    }
    double angleDiff = _qiblaAngle! - _heading!;
    if (angleDiff > 180) {
      angleDiff -= 360;
    } else if (angleDiff <= -180) {
      angleDiff += 360;
    }
    return radians(angleDiff);
  }

  String _getDirection(double heading) {
    if (heading >= 337.5 || heading < 22.5) {
      return 'N';
    } else if (heading >= 22.5 && heading < 67.5) {
      return 'NE';
    } else if (heading >= 67.5 && heading < 112.5) {
      return 'E';
    } else if (heading >= 112.5 && heading < 157.5) {
      return 'SE';
    } else if (heading >= 157.5 && heading < 202.5) {
      return 'S';
    } else if (heading >= 202.5 && heading < 247.5) {
      return 'SW';
    } else if (heading >= 247.5 && heading < 292.5) {
      return 'W';
    } else {
      return 'NW';
    }
  }

  final AppHomeScreenController homeScreenController = Get.put(AppHomeScreenController());
  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();
  final UserPermissionController locationPermissionScreenController = Get.find<UserPermissionController>();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeController.isDarkMode.value;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;
    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        title:  CustomText(
          firstText: "Qibla",
          secondText: " Direction",
          fontSize: 18.sp,
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
        ),
        centerTitle: false,
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.west,
            color: iconColor,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left:10.w,right: 10.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  Stack(
                      children: [
                        Container(
                          height: 90.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: AssetImage(isDarkMode
                                  ? 'assets/images/sajdah_bg_dark.jpg'
                                  : 'assets/images/sajdah_bg_light.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Obx(() =>
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.black.withOpacity(0.5),
                                      AppColors.transparent,
                                      AppColors.black.withOpacity(0.5),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomText(
                                        title: widget.city,
                                        textColor: AppColors.white,
                                        fontSize: 16.sp,
                                        maxLines: 2,
                                      ),
                                      locationPermissionScreenController.locationAccessed.value
                                          ? CustomText(
                                        title: homeScreenController.nextNamazName.value.isNotEmpty &&
                                            homeScreenController.nextNamazTime.value != null
                                            ? '${homeScreenController.nextNamazName.value} '
                                            '${DateFormat('h:mm a').format(
                                            homeScreenController.nextNamazTime.value!)}'
                                            : '--/--/--',
                                        textColor: AppColors.white,
                                        fontSize: 18.sp,
                                        maxLines: 2,
                                      )
                                          : CustomText(
                                        title: "--/--",
                                        textColor: AppColors.white,
                                        fontSize: 18.sp,
                                        maxLines: 2,
                                      ),
                                      CustomText(
                                        title: homeScreenController.timeRemaining.value,
                                        textColor: AppColors.white,
                                        fontSize: 24.sp,
                                        fontFamily: 'grenda',
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      ]
                  ),
                  AppSizedBox.space25h,
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        // Prayer Mat
                        Transform.rotate(
                          angle: _getRotationAngle(),
                          child: Image.asset(
                            'assets/images/prayer_mat.png', // Replace with your prayer mat image path
                            fit: BoxFit.contain,
                            height: 250, // Adjust as needed
                            width: 250, // Adjust as needed
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Column(
                    children: [
                      CustomText(
                        title:_heading != null
                            ? 'Your Heading: ${_heading!.toStringAsFixed(2)}° (${_getDirection(_heading!)})'
                            : 'Calibrating Compass...',
                        fontSize: 14.sp,
                        textAlign: TextAlign.center,
                        textColor: textColor,
                      ),
                      AppSizedBox.space10h,
                      CustomText(
                        title:_qiblaAngle != null
                            ? 'Qibla Angle is ${_qiblaAngle!.toStringAsFixed(2)}° from $_qiblaDirectionFrom'
                            : 'Calculating Qibla Angle...',
                        fontSize: 14.sp,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.bold,
                        textColor: AppColors.primary,
                      ),
                    ],
                  ),
                  AppSizedBox.space25h,
                  CustomText(
                    title:'Rotate your device until the prayer \nmat points towards the top of the screen.',
                    textAlign: TextAlign.center,
                    fontSize: 15.sp,
                    textColor: AppColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
              SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
