
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/app_theme_switch_controller.dart';

class FlyingBird extends StatelessWidget {
  final Animation<double> positionAnimation; final Animation<double> opacityAnimation; final double offsetMultiplier;
  FlyingBird({required this.positionAnimation,  required this.opacityAnimation,  required this.offsetMultiplier,});
  final AppThemeSwitchController controller = AppThemeSwitchController();
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([positionAnimation, opacityAnimation]),
      builder: (context, child) {
        return Opacity(
          opacity: opacityAnimation.value,
          child: Transform.translate(
              offset: Offset(
                positionAnimation.value * MediaQuery.of(context).size.width + offsetMultiplier * MediaQuery.of(context).size.width,
                0.0,
              ),
              child: Image.asset("assets/anim/bird.gif", width: 45.h,)
          ),
        );
      },
    );
  }
}
