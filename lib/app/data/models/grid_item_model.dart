import 'package:flutter/cupertino.dart';
import '../../modules/additional/views/goals/daily_goal_screen.dart';
import '../../modules/additional/views/islamic_design_studio.dart';
import '../../modules/common/views/dua_details_screen.dart';
import '../../modules/ibadat/views/99_names_of_Allah_screen.dart';
import '../../modules/ibadat/views/fasting_menu_screen.dart';
import '../../modules/ibadat/views/five_pillars_of_islam_screen.dart';
import '../../modules/ibadat/views/six_kalima_screen.dart';
import '../../widgets/pdf_viewer.dart';

class GridItem {
  final String title;
  final String subtitle;
  final Widget destination;

  GridItem({
    required this.title,
    required this.subtitle,
     required this.destination, // Optional now
  });
}


final List<GridItem> historyCategoryMenu = [
  GridItem(
    title: "Prophet Muhammad",
    subtitle: "Biography",
    destination: PdfViewer(
      assetPath: 'assets/pdf/seerah.pdf',
      firstTitle: 'Prophet Muhammad',
      secondTitle: ' Seerah',
    ),
  ),
  GridItem(
    title: "Four Caliphs",
    subtitle: "Khulafa e Rashideen",
    destination: Placeholder(),
  ),
];


final List<GridItem> SalahCategoryenu = [
  GridItem(
    title: "Opligatory",
    subtitle: "Prayers",
    destination: SizedBox(),
  ),
  GridItem(
    title: "Sunnah",
    subtitle: "Nafl Prayers",
    destination: SizedBox(),
  ),
  GridItem(
    title: "Friday",
    subtitle: "Jumma Prayer",
    destination: SizedBox(),
  ),
  GridItem(
    title: "Eid",
    subtitle: "Prayers",
    destination: SizedBox(),
  ),
  GridItem(
    title: "Taraweeh",
    subtitle: "Qiyam-ul-Layl",
    destination: SizedBox(),
  ),
  GridItem(
    title: "Funeral",
    subtitle: "Prayer",
    destination: SizedBox(),
  ),
  GridItem(
    title: "Salatul",
    subtitle: "Istikhara",
    destination: SizedBox(),
  ),
  GridItem(
    title: "Salatul",
    subtitle: "Hajat",
    destination: SizedBox(),
  ),
  GridItem(
    title: "Prayer",
    subtitle: "Tracker",
    destination: SizedBox(),
  ),
  GridItem(
    title: "Prayer",
    subtitle: "Guide",
    destination: SizedBox(),
  ),
];



final List<GridItem> IbadatCategoryMenu = [
  GridItem(
    title: "Asma Ul Husna",
    subtitle: "Divine Names",
    destination: NameOfAllahScreen(),
  ),
  GridItem(
    title: "Fasting",
    subtitle: "Discipline",
    destination: FastingMenuScreen(),
  ),
  GridItem(
    title: "Six Kalima",
    subtitle: "Essentials",
    destination: SixKalimaScreen(),
  ),
  GridItem(
    title: "Five Pillar",
    subtitle: "Islam",
    destination: FivePillarIslamScreen(),
  ),
  GridItem(
    title: "Darood e Ibrahim",
    subtitle: " Divine Mercy",
    destination: DuaDetailCommonScreen(
      arabicDua: 'للَّهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ وَعَلَىٰ آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَىٰ إِبْرَاهِيمَ وَعَلَىٰ آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ اللَّهُمَّ بَارِكْ عَلَىٰ مُحَمَّدٍ وَعَلَىٰ آلِ مُحَمَّدٍ كَمَا بَارَكْتَ عَلَىٰ إِبْرَاهِيمَ وَعَلَىٰ آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ',
      latinTitle: 'درودِ ابراہیم',
      audioUrl: 'audios/durood.mp3',
      duaTranslation: 'O Allah, send prayers upon Muhammad and upon the family of Muhammad just as You have sent prayers upon Ibrahim and upon the family of Ibrahim, verily You are the Praiseworthy, the Glorious. O Allah, bless Muhammad and the family of Muhammad just as You have blessed Ibrahim and the family of Ibrahim, verily You are the Praiseworthy, the Glorious.',
      duaUrduTranslation: 'اے اللہ محمد اور آل محمد پر درود بھیج جس طرح تو نے ابراہیم اور آل ابراہیم پر درود بھیجے، بے شک تو قابل تعریف اور بزرگی والا ہے۔ اے اللہ رحمت نازل فرما محمد اور آل محمد پر جس طرح تو نے رحمت نازل فرمائی ابراہیم اور آل ابراہیم پر، بے شک تو قابل تعریف اور بزرگی والا ہے۔',
      engFirstTitle: 'Darood e ',
      engSecondTitle: 'Ibrahim',
      isComingFromAllahNameScreen: false,
      showAudiotWidgets: true,
    ),
  ),
  GridItem(
    title: "Dua e Qanoot",
    subtitle: "Witr Prayer",
      destination: DuaDetailCommonScreen(
        arabicDua: 'اَللَّهُمَّ إنا نَسْتَعِينُكَ وَنَسْتَغْفِرُكَ وَنُؤْمِنُ بِكَ وَنَتَوَكَّلُ عَلَيْكَ وَنُثْنِئْ عَلَيْكَ الخَيْرَ وَنَشْكُرُكَ وَلَا نَكْفُرُكَ وَنَخْلَعُ وَنَتْرُكُ مَنْ ئَّفْجُرُكَ اَللَّهُمَّ إِيَّاكَ نَعْبُدُ وَلَكَ نُصَلِّئ وَنَسْجُدُ وَإِلَيْكَ نَسْعئ وَنَحْفِدُ وَنَرْجُو رَحْمَتَكَ وَنَخْشآئ عَذَابَكَ إِنَّ عَذَابَكَ بِالكُفَّارِ مُلْحَقٌ ❁ ',
        audioUrl: 'audios/duaQunoot.mp3',
        duaTranslation: 'O Allah! We implore You for help and beg forgiveness of You and believe in You and rely on You and extol You and we are thankful to You and are not ungrateful to You and we alienate and forsake those who disobey You. O Allah! You alone do we worship and for You do we pray and prostrate and we betake to please You and present ourselves for the service in Your cause and we hope for Your mercy and fear Your chastisement. Undoubtedly, Your torment is going to overtake infidels O Allah!',
        duaUrduTranslation: 'اے اللہ! ہم آپ سے مدد مانگتے ہیں اور آپ سے معافی طلب کرتے ہیں اور آپ پر ایمان رکھتے ہیں اور آپ پر بھروسہ کرتے ہیں اور آپ کی تسبیح کرتے ہیں اور آپ کا شکر ادا کرتے ہیں اور آپ کے انکار نہیں کرتے اور ہم ان لوگوں سے علیحدہ ہو جاتے ہیں جو آپ کی نافرمانی کرتے ہیں۔ اے اللہ! ہم آپ کی عبادت کرتے ہیں اور آپ کے لیے ہم نماز پڑھتے ہیں اور سجدہ کرتے ہیں اور آپ کی رضا کی تلاش کرتے ہیں اور اپنے آپ کو آپ کے لیے پیش کرتے ہیں اور ہم آپ کی رحمت کی امید رکھتے ہیں اور آپ کے عذاب سے ڈرتے ہیں۔ بے شک، آپ کا عذاب کفار کے لیے ہو کر رہے گا، اے اللہ',
        engFirstTitle: 'Due e',
        engSecondTitle: 'Qunoot',
        showAudiotWidgets: true,
        latinTitle: 'دعاء قنوت',
        isComingFromAllahNameScreen: false,
      )
  ),
];



final List<GridItem> additionalCategoryMenu = [
  GridItem(
    title: "Daily",
    subtitle: "Goals",
    destination: DailyGoalScreen(),
  ),
  GridItem(
    title: "Islamic",
    subtitle: "Design Studio",
    destination: IslamicDesignStudio(),
  ),

  GridItem(
    title: "Hajj",
    subtitle: "Pilgrimage",
    destination: PdfViewer(
      assetPath: 'assets/pdf/hajj_guide.pdf',
      firstTitle: 'Hajj',
      secondTitle: ' Pilgrimage',
    ),
  ),
  GridItem(
    title: "Umrah",
    subtitle: "Devotion", // Unique subtitle for Umrah
    destination: PdfViewer(
      assetPath: 'assets/pdf/umrah_guide.pdf',
      firstTitle: 'Umrah',
      secondTitle: ' Devotion',
    ),
  ),
];

