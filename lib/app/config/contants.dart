List<String> getUniqueStrings(String prayerName) {
  switch (prayerName) {
  // Fard prayers
    case 'Fajr':
      return [
        'Performed during the early hours of the morning, starting from dawn (Subh Sadiq) until just before sunrise.',
        'The 2 Sunnah Rakats are highly emphasized, with Prophet Muhammad (ﷺ) stating they are better than the world and everything in it.',
        'The recitation of the Quran during Fajr is typically longer, and it’s recommended to recite verses like Surah Al-Fil and Surah Quraysh in Sunnah prayers.',
        'Performing Fajr Prayers brings immense blessings as it signifies starting the day with submission to Allah, offering protection and divine guidance throughout the day.',
        'Offers a serene and peaceful connection with Allah during the quietest part of the day.',
        'أَقِمِ ٱلصَّلَوٰةَ لِدُلُوكِ ٱلشَّمْسِ إِلَىٰ غَسَقِ ٱلَّيْلِ وَقُرْءَانَ ٱلْفَجْرِ ۖ إِنَّ قُرْءَانَ ٱلْفَجْرِ كَانَ مَشْهُودًۭا',
        'Observe the Prayers from the decline of the sun until the darkness of the night and the dawn Prayers, for certainly the dawn Prayers is witnessed ˹by angels˺.',
        "",
      ];
    case 'Dhuhr':
      return [
        'Performing Dhuhr Prayers on time helps in maintaining discipline and strengthens ones connection with Allah',
        'Dhuhr Prayers serves as a completion of the first half of the daily prayers, setting the tone for the rest of the day.',
        'Performed after the sun reaches its zenith and starts its descent towards the west.',
        'Provides a break during the midday, offering a moment of tranquility amidst daily work.',
        'The Dhuhr Prayers can be a moment of gratitude, providing a chance to thank Allah for the previous part of the day and seek His blessings for what’s to come.',
        'حَـٰفِظُوا۟ عَلَى ٱلصَّلَوَٰتِ وَٱلصَّلَوٰةِ ٱلْوُسْطَىٰ وَقُومُوا۟ لِلَّهِ قَـٰنِتِينَ',
        'Observe the ˹five obligatory˺ prayers—especially the middle prayer1—and stand in true devotion to Allah.',
        "",
      ];
    case 'Asr':
      return [
        'It is considered a time when the angels change shifts, with the angels who were present during the morning Prayers leaving, and new angels arriving',
        'It holds great significance, as Prophet Muhammad (PBUH) mentioned that whoever misses the Asr Prayers has lost everything (Sahih Bukhari).',
        'Performing Asr Prayers on time strengthens ones discipline and commitment to regular worship.',
        'It is believed to offer protection from the punishment of the grave for those who perform it regularly.',
        'Asr Prayers has a special reward and virtue, as the time just before Maghrib is considered a time when Allah is most merciful and responsive to prayers.',
        'حَافِظُوا عَلَىٰ الصَّلَوَاتِ وَالصَّلَاةِ الْوُسْطَىٰ وَقُومُوا لِلَّهِ قَانِتِينَ',
        'Observe the ˹five obligatory˺ prayers—especially the middle prayer1—and stand in true devotion to Allah.',
        "",
      ];
    case 'Maghrib':
      return [
        'The Maghrib Prayers is performed just after sunset, marking the end of the day and the beginning of the night.',
        'It is a time when Allah’s mercy is abundant, and the Prophet Muhammad (PBUH) mentioned that the duas made after Maghrib are not rejected.',
        'Maghrib Prayers has a special reward for those who pray it regularly and on time.',
        'Performing the Maghrib Prayers serves as a reminder to be mindful of the passage of time and the fleeting nature of this world.',
        'The Maghrib Prayers has a connection to the night, a time when Allah’s mercy and blessings are abundant.',
        'وَيُصَلُّونَ لِلَّهِ وَحْدَهُۥۤ',
        'And they pray to Allah alone.',
        "",
      ];
    case 'Isha':
      return [
        'The Isha Prayers is performed after the night has fully set and is the last of the five daily prayers.',
        'It is a time of peace and serenity, providing an opportunity to reflect on the day and seek Allahs forgiveness.',
        'The Prophet Muhammad (PBUH) emphasized the importance of performing the Isha Prayers, and those who perform it are granted protection from the punishment of the grave.',
        'Isha Prayers provides an opportunity to seek closeness to Allah before sleeping, allowing the night to be filled with tranquility and spiritual peace.',
        'The Isha Prayers is often followed by additional voluntary prayers, such as the Taraweeh Prayers during Ramadan, which enhances its reward.',
        'أَقِمِ ٱلصَّلَوٰةَ لِدُلُوكِ ٱلشَّمْسِ إِلَىٰ غَسَقِ ٱلَّيْلِ وَقُرْءَانَ ٱلْفَجْرِ ۖ إِنَّ قُرْءَانَ ٱلْفَجْرِ كَانَ مَشْهُودًۭا',
        'Observe the Prayers from the decline of the sun until the darkness of the night and the dawn Prayers, for certainly the dawn Prayers is witnessed ˹by angels˺.',
        "",
      ];
    default:
      return ['No unique strings available.'];
  }
}

class AppConstants {
  static const String bismillah = '﷽';
  static const String appWelcomeTagLine = 'Discover the Beauty of the Quran';
  static const String appWelcomeHeaderLine = 'Illuminate your heart with the light of the Quran. Explore, learn, and connect with the divine words of Allah.';
  static const String appWelcomeQuranicVerse = 'طَلَبُ الْعِلْمِ فَرِيضَةٌ عَلَى كُلِّ مُسْلِمٍ وَوَاضِعُ الْعِلْمِ عِنْدَ غَيْرِ أَهْلِهِ كَمُقَلِّدِ الْخَنَازِيرِ الْجَوْهَرَ وَاللُّؤْلُؤَ وَالذَّهَبَ';
  static const String appWelcomeQuranicVerseTranslation = 'Seeking knowledge is a duty upon every Muslim, and he who imparts knowledge to those who do not deserve it, is like one who puts a necklace of jewels, pearls and gold around the neck of swines';
  static const String appWelcomeQuranicVerseReference = 'Reference: Sunan Ibn Majah 224\nIn book reference: Introduction, Hadith 224';
  static const String hasSeenOnboardingKey = 'hasSeenOnboarding';
  static const String hasCompletedPermissionsKey = 'hasCompletedPermissions';
}