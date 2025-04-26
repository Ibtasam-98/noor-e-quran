
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/app_theme_switch_controller.dart';

import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_text.dart';
import '../../common/views/dua_details_screen.dart';

class SixKalimaScreen extends StatelessWidget {
  final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());

  final List<Map<String, dynamic>> kalimas = [
    {
      "index": 1,
      "englishTitle": "Tayyab",
      "arabicTitle": "طیب (پاکیزگی)",
      "arabicText": "لَا إِلَٰهَ إِلَّا ٱللَّٰهُ مُحَمَّدٌ رَّسُولُ ٱللَّٰهِ",
      "translation": "There is no God but Allah Muhammad is the messenger of Allah.",
      "urduTranslation": "اللہ کے سوا کوئی معبود نہیں محمد اللہ کے رسول ہیں۔",
      "audio": "audios/1Kalima.mp3",
    },
    {
      "index": 2,
      "englishTitle": "Shahadat",
      "arabicTitle": "شہادت (گواہی)",
      "arabicText": "اَشْهَدُ اَنْ لَّآ اِلٰهَ اِلَّا اللهُ وَحْدَہٗ لَاشَرِيْكَ لَہٗ وَاَشْهَدُ اَنَّ مُحَمَّدًا عَبْدُهٗ وَرَسُولُہ",
      "translation": "I bear witness that no one is worthy of worship but Allah, the One alone, without a partner, and I bear witness that Muhammad is His servant and Messenger.",
      "urduTranslation":"میں گواہی دیتا ہوں کہ اللہ کے سوا کوئی عبادت کے لائق نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں، اور میں گواہی دیتا ہوں کہ محمد صلی اللہ علیہ وسلم اس کے بندے اور رسول ہیں۔",
      "audio": "audios/2Kalima.mp3",
    },
    {
      "index": 3,
      "englishTitle": "Tamjeed",
      "arabicTitle": "تمجید (تسبیح)",
      "arabicText": "سُبْحَانَ ٱللَّٰهِ وَٱلْحَمْدُ لِلَّٰهِ وَلَا إِلَٰهَ إِلَّا ٱللَّٰهُ وَٱللَّٰهُ أَكْبَرُ وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِٱللَّٰهِ ٱلْعَلِيِّ ٱلْعَظِيمِ",
      "translation": "Glory be to Allah and Praise to Allah, and there is no God but Allah, and Allah is the Greatest. And there is no Might or Power except with Allah",
      "urduTranslation":"اللہ پاک ہے اور حمد اللہ کے لیے ہے اور اللہ کے سوا کوئی معبود نہیں اور اللہ سب سے بڑا ہے۔ اور اللہ کے سوا کوئی طاقت اور طاقت نہیں ہے۔",
      "audio": "audios/3Kalima.mp3",
    },
    {
      "index": 4,
      "englishTitle": "Tauheed ",
      "arabicTitle": "توحید (اتحاد)",
      "arabicText": "لَا إِلَٰهَ إِلَّا ٱللَّٰهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ ٱلْمُلْكُ وَلَهُ ٱلْحَمْدُ، يُحْيِي وَيُمِيتُ وَهُوَ حَيٌّ لَا يَمُوتُ أَبَدًا أَبَدًا، ذُو ٱلْجَلَالِ وَٱلْإِكْرَامِ بِيَدِهِ ٱلْخَيْرُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ",
      "translation": "There is none worthy of worship except Allah. He is the only One. There is no partners for Him. For Him (is) the kingdom. And for Through Him is the Praise. He gives life and causes death. And He is Alive. He will not die, never, ever. Possessor of Majesty and Reverence. In His hand is the goodness. And He is the goodness. And He is on everything powerful",
      "urduTranslation":"اللہ کے سوا کوئی عبادت کے لائق نہیں۔ وہ واحد ہے۔ اس کا کوئی شریک نہیں۔ اسی کے لیے بادشاہی ہے۔ اور اسی کے ذریعے سے حمد ہے۔ وہی زندگی دیتا ہے اور موت دیتا ہے۔ اور وہ زندہ ہے۔ وہ نہیں مرے گا، کبھی نہیں، کبھی نہیں۔ عظمت اور تعظیم کا مالک۔ نیکی اسی کے ہاتھ میں ہے۔ اور وہی خیر ہے۔ اور وہ ہر چیز پر قادر ہے۔",
      "audio": "audios/4Kalima.mp3",
    },
    {
      "index": 5,
      "englishTitle": "Astaghfar",
      "arabicTitle": "استغفار (توبہ)",
      "arabicText": "اَسْتَغْفِرُ اللهِ رَبِّىْ مِنْ كُلِِّ ذَنْۢبٍ اَذْنَبْتُهٗ عَمَدًا اَوْ خَطَا ًٔ سِرًّا اَوْ عَلَانِيَةً وَّاَتُوْبُ اِلَيْهِ مِنَ الذَّنْۢبِ الَّذِیْٓ اَعْلَمُ وَ مِنَ الذَّنْۢبِ الَّذِىْ لَآ اَعْلَمُ اِنَّكَ اَنْتَ عَلَّامُ الْغُيُوْبِ وَ سَتَّارُ الْعُيُوْبِ و َغَفَّارُ الذُّنُوْبِ وَ لَا حَوْلَ وَلَا قُوَّةَ اِلَّا بِاللهِ الْعَلِىِ الْعَظِيْمُِؕ",
      "translation": "I seek forgiveness from Allah, my lord, from every sin I committed knowingly or unknowingly, secretly or openly, and I turn towards Him from the sin that I know and from the sin that I do not know. Certainly You, You (are) the knower of the hidden things and the Concealer (of) the mistakes and the Forgiver (of) the sins. And (there is) no power and no strength except from Allah, the Most High, the Most Great.",
      "urduTranslation":"میں اللہ سے معافی مانگتا ہوں جو میرے رب ہے، میں نے دانستہ یا نادانستہ، چھپے یا کھلے ہر اس گناہ سے جو میں نے سرزد کیا ہو، اور اس کی طرف رجوع کرتا ہوں اس گناہ سے جو میں جانتا ہوں اور اس گناہ سے جو میں نہیں جانتا۔ بے شک تو ہی پوشیدہ باتوں کا جاننے والا اور خطاؤں کو چھپانے والا اور گناہوں کو بخشنے والا ہے۔ اور نہ کوئی طاقت ہے اور نہ کوئی طاقت سوائے اللہ کی طرف سے جو سب سے بلند اور عظیم ہے۔",
      "audio": "audios/5Kalima.mp3",
    },
    {
      "index": 6,
      "englishTitle": "Radde Kufr",
      "arabicTitle": "ردّ کفر",
      "arabicText": "اَللَّٰهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ أَنْ أُشْرِكَ بِكَ شَيْءً وَأَنَا أَعْلَمُ بِهِ وَأَسْتَغْفِرُكَ لِمَا لَا أَعْلَمُ بِهِ تُبْتُ عَنْهُ وَتَبَرَّأَتُ مِنَ ٱلْكُفْر وَٱلشِّرْكِ وَٱلْكِذْبِ وَٱلْغِيبَةِ وَٱلْبِدْعَةِ وَٱلنَّمِيمَةِ وَٱلْفَوَاحِشِ وَٱلْبُهْتَانِ وَٱلْمَعَاصِي كُلِّهَا وَأَسْلَمْتُ وَأَقُولُ لَا إِلَٰهَ إِلَّا ٱللَّٰهُ مُحَمَّدٌ رَسُولُ ٱللَّٰهَِ",
      "translation": "O Allah! Certainly, I seek protection with You from, that I associate partner with You anything and I know it. And I seek forgiveness from You for that I do not know it. I repented from it and I made myself free from disbelief and polytheism and the falsehood and the back-biting and the innovation and the tell-tales and the bad deeds and the blame and the disobedience, all of them. And I submit and I say (there is) none worthy of worship except Allah, Muhammad is the Messenger of Allah.",
      "urduTranslation":"اے اللہ! بے شک میں تجھ سے اس بات سے پناہ مانگتا ہوں کہ میں تیرے ساتھ کسی چیز کو شریک کروں اور میں اسے جانتا ہوں۔ اور میں تجھ سے اس بات کی معافی چاہتا ہوں کہ میں اسے نہیں جانتا۔ میں نے اس سے توبہ کی اور میں نے اپنے آپ کو کفر و شرک اور جھوٹ اور غیبت اور بدعت اور قصہ گوئی اور برے کاموں اور الزام و نافرمانی ان سب سے بری کر لیا۔ اور میں عرض کرتا ہوں اور کہتا ہوں کہ اللہ کے سوا کوئی عبادت کے لائق نہیں، محمد اللہ کے رسول ہیں۔",
      "audio": "audios/6Kalima.mp3",
    },
  ];

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeController.isDarkMode.value;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        title: CustomText(
          firstText: "Six",
          secondText: " Kalima",
          fontSize: 18.sp,
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
        ),
        centerTitle: false,
        leading: InkWell(
          splashColor: AppColors.transparent,
          highlightColor: AppColors.transparent,
          onTap: () { Get.back(); },
          child: Icon(
            Icons.west,
            color: iconColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 15.h),
            child: CustomCard(
              title: "Essential Kalimas",
              subtitle: "The core declarations of faith in Islam for every believer.",
              imageUrl: 'assets/images/kalima_bg.jpg',
              mergeWithGradientImage: true,
              titleFontSize: 18.sp,
              subtitleFontSize: 12.sp,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: kalimas.length,
              itemBuilder: (context, index) {
                final kalima = kalimas[index];
                return InkWell(
                  splashColor: AppColors.transparent,
                  hoverColor: AppColors.transparent,
                  highlightColor: AppColors.transparent,
                  onTap: () {

                    Get.to( DuaDetailCommonScreen(
                      isComingFromAllahNameScreen: false,
                      arabicDua:  kalima['arabicText'] ,
                      audioUrl: kalima['audio'],
                      duaTranslation: kalima['translation'],
                      duaUrduTranslation: kalima['urduTranslation'],
                      engFirstTitle:  "Kalima ",
                      engSecondTitle: kalima['englishTitle'],
                      showAudiotWidgets: true,
                      latinTitle: kalima['arabicTitle'],
                    ));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10.w,right: 10.w,bottom: 5,top: 5.h),
                    padding: EdgeInsets.only(right: 10.w, top: 10.h, bottom: 10.h,left: 10.w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: (index % 2 == 1)
                          ? AppColors.primary.withOpacity(0.29)
                          : AppColors.primary.withOpacity(0.1),
                    ),
                    child: ListTile(
                      leading: CustomText(
                        title:kalima['index'].toString(),
                        fontSize: 15.sp,
                        textColor: isDarkMode ? AppColors.white : AppColors.black,
                      ),
                      title: CustomText(
                        title: kalima['englishTitle'],
                        textColor: isDarkMode ? AppColors.white : AppColors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        textOverflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                      ),

                      trailing: CustomText(
                        title: kalima['arabicTitle'],
                        textColor: AppColors.primary,
                        fontSize: 20.sp,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
