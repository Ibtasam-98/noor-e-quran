class AppConstants {
  static const String bismillah = '﷽';

  // App Title
  static const String appPrimaryTitle = 'Noor e';
  static const String appSecondryTitle = 'Quran';
  static const String exploreAppHeading = 'Explore Noor e Quran';

  // Onboarding Screen Content
  static const String onboardingTitle = 'Embracing the Light of the Quran';
  static const String onboardingSubtitle = 'Discover the Quran’s wisdom, lighting your path with peace and guidance.';

  // App Welcome Screen Content
  static const String appWelcomeTagLine = 'Discover the Beauty of the Quran';
  static const String appWelcomeHeaderLine = 'Illuminate your heart with the light of the Quran. Explore, learn, and connect with the divine words of Allah.';
  static const String appWelcomeQuranicVerseArabic = 'طَلَبُ الْعِلْمِ فَرِيضَةٌ عَلَى كُلِّ مُسْلِمٍ وَوَاضِعُ الْعِلْمِ عِنْدَ غَيْرِ أَهْلِهِ كَمُقَلِّدِ الْخَنَازِيرِ الْجَوْهَرَ وَاللُّؤْلُؤَ وَالذَّهَبَ';
  static const String appWelcomeQuranicVerseTranslation = 'Seeking knowledge is a duty upon every Muslim, and he who imparts knowledge to those who do not deserve it, is like one who puts a necklace of jewels, pearls and gold around the neck of swines';
  static const String appWelcomeQuranicVerseReference = 'Reference: Sunan Ibn Majah 224\nIn book reference: Introduction, Hadith 224';

  // Local Storage Keys
  static const String hasSeenOnboardingKey = 'hasSeenOnboarding';
  static const String hasCompletedPermissionsKey = 'hasCompletedPermissions';

  // Prayer Calculation Methods Full Names
  static const Map<String, String> prayerCalculationMethodsFullNames = {
    'MWL': 'Muslim World League',
    'ISNA': 'Islamic Society of North America',
    'EGYPT': 'Egyptian General Authority of Survey',
    'MAKKAH': 'Umm Al-Qura University, Makkah',
    'KARACHI': 'University of Islamic Sciences, Karachi',
    'TEHRAN': 'Institute of Geophysics, University of Tehran',
    'JAFARI': 'Shia Ithna Ashari, Leva Institute, Qum',
    'GULF': 'Gulf Region',
    'KUWAIT': 'Kuwait',
    'QATAR': 'Qatar',
    'SINGAPORE': 'Majlis Ugama Islam Singapura, Singapore',
    'FRANCE': 'Union Organization Islamic de France',
    'TURKEY': 'Diyanet İşleri Başkanlığı, Turkey',
    'RUSSIA': 'Spiritual Administration of Muslims of Russia',
    'MOONSIGHTING': 'Moonsighting Committee Worldwide ',
    'DUBAI': 'Dubai',
    'JAKIM': 'Jabatan Kemajuan Islam Malaysia ',
    'TUNISIA': 'Tunisia',
    'ALGERIA': 'Algeria',
    'KEMENAG': 'Kementerian Agama Republik Indonesia',
    'MOROCCO': 'Morocco',
    'PORTUGAL': 'Comunidade Islamica de Lisboa',
    'JORDAN': 'Ministry of Awqaf, Islamic Affairs and Holy Places, Jordan',
  };

  static const List<Map<String, String>> sliderItems = [
    {
      'image': 'assets/images/sadaqah.jpg',
      'title': 'Give Sadaqah',
      'subtitle': 'Charity does not decrease wealth, no one forgives another except that Allah increases his honor, and no one humbles himself for the sake of Allah except that Allah raises his status.',
      'reference': 'Sahih Muslim 2588 Book 45 Hadith 90'
    },
    {
      'image': 'assets/images/orphan.png',
      'title': 'Support Orphans',
      'subtitle': 'The Prophet (ﷺ) said, "I and the person who looks after an orphan and provides for him, will be in Paradise like this," putting his index and middle fingers together.',
      'reference': 'Sahih Al Bukhari 6005 Book 78 Hadith 36'
    },
    {
      'image': 'assets/images/hungry.png',
      'title': 'Feed the Hungry',
      'subtitle': 'The Prophet (ﷺ) said, "Feed the hungry, visit the sick, and set free the captives."',
      'reference': 'Sahih Al Bukhari 5649 Book 75, Hadith 9'
    },
  ];
}