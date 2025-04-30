


import '../../modules/additional/views/daily_goal_screen.dart';
import '../../modules/additional/views/donation_screen.dart';
import '../../modules/additional/views/islamic_design_studio.dart';
import 'grid_item_model.dart';

final List<GridItem> additionalCategoryMenu = [
  GridItem(
    title: "Daily",
    subtitle: "Goals",
    destination: DailyGoalScreen(),
  ),
  GridItem(
    title: "Donation",
    subtitle: "Give Now",
    destination: DonationScreen(),
  ),
  GridItem(
    title: "Islamic",
    subtitle: "Design Studio",
    destination: IslamicDesignStudio(),
  ),
];