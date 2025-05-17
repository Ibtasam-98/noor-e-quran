import 'dart:convert';

// lib/app/models/name_of_allah_model.dart
class NameOfAllah {
  final int id;
  final String arabicName;
  final String englishName;
  final String translation;
  final String description;
  final String audioUrl;
  final String detailUrl;
  final String paragraph;

  NameOfAllah({
    required this.id,
    required this.arabicName,
    required this.englishName,
    required this.translation,
    required this.description,
    required this.audioUrl,
    required this.detailUrl,
    required this.paragraph,
  });

  factory NameOfAllah.fromJson(List<dynamic> json) {
    return NameOfAllah(
      id: json[0],
      arabicName: json[1],
      englishName: json[2],
      translation: json[3],
      description: json[4],
      audioUrl: json[5],
      detailUrl: json[6],
      paragraph: json[7],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'arabicName': arabicName,
      'englishName': englishName,
      'translation': translation,
      'description': description,
      'audioUrl': audioUrl,
      'detailUrl': detailUrl,
      'paragraph': paragraph,
    };
  }
}

List<NameOfAllah> parseJson(String jsonString) {
  var decoded = jsonDecode(jsonString) as List;
  return decoded.map((item) => NameOfAllah.fromJson(item)).toList();
}



const jsonData = '''
[
    [
        1,
        "'الرَّحْمَنُ'",
        "Ar-Rahmaan",
        "The Beneficent",
        "He who wills goodness and mercy for all His creatures",
        "https://upload.wikimedia.org/wikipedia/commons/8/8a/01-ar-rahman.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/152-al-rahman",
        "Al-Rahman al-Rahim are two of the Attributes of Allah which remind people of His mercy, of the fact that His act of affecting goodness and rewards reach whomsoever He pleases, thus warding off evil from them. Al-Rahman and al- Rahim are two concurrent Attributes of His each conveying more meanings of mercy than the other. Al-Rahman is an Attribute specifically relevant to Allah; none besides Him can be called or referred to as such, whereas al-rahim can be applied to people: One may be described as rahim, merciful or kind, but a human cannot be rahman."
    ],
    [
        2,
        "'الرَّحِيمُ'",
        "Ar-Raheem",
        "The Merciful",
        "He who acts with extreme kindness",
        "https://upload.wikimedia.org/wikipedia/commons/e/e6/02-ar-rahim.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/151-al-rahim",
        "Al-Rahim is derived from rahmah, mercy or compassion. Rahmah implies the salvation of those who receive it from harm and loss, and their being blessed with guidance, forgiveness and sound conviction. Al-Rahim, i.e. the One Who grants rahmah, is a superlative. It is the highest derivative form of rahmah. Allah has said, He it is Who sends His blessings on you, and (so do) His angels, so that He may bring you out of utter darkness into the light, and He is Merciful to the believers"
    ],
    [
        3,
        "'الْمَلِكُ'",
        "Al-Malik",
        "The Eternal Lord",
        "The Sovereign Lord, The One with the complete Dominion, the One Whose Dominion is clear from imperfection",
        "https://upload.wikimedia.org/wikipedia/commons/6/62/03-al-malik.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/150-al-malik",
        "Al-Malik conveys the meaning of One Who is free, by virtue of His Own merits and characteristics; from depending on anything in existence, while everything in existence depends on Him. Nothing in existence can do without Him, whereas everything that exists derives its existence from Him or because of Him. Everything/everyone is His"
    ],
    [
        4,
        "'الْقُدُّوسُ'",
        "Al-Quddus",
        "The Most Sacred",
        "The One who is pure from any imperfection and clear from children and adversaries",
        "https://upload.wikimedia.org/wikipedia/commons/c/ce/04-al-quddus.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/149-al-qudduz",
        "Al-Qudoos means: the One Whose characteristics cannot be conceived by the senses, or can He be conceived by imagination, nor can He be realized by any mind or reason or judged by any intellect. Linguistically, it is derived from quds, purity or cleanness. Al-bayt al-muqaddas means the Purified House, the one in which people purify themselves from the filth of sins. Paradise is also called the place of quds because it is free from the ills of the life of this world. Archangel Gabriel is called in Islam al-ruh al-quds, the Holy Spirit, because he is free from any fault in delivering divine inspiration to the messengers of Allah"
    ],
    [
        5,
        "'السَّلاَمُ'",
        "As-Salam",
        "The Embodiment of Peace",
        "The One who is free from every imperfection.",
        "https://upload.wikimedia.org/wikipedia/commons/5/51/05-as-salam.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/148-al-salam",
        "Al-Salam means the One Who is free from defect and shortcoming, Whose qualities are above deficiency, Whose deeds are free from evil. Since He is as such, there can be neither peace nor security in existence without Him. Salam means peace. Allah Almighty has said, and Allah invites to the abode of peace (Quran, 10:25), meaning Paradise: anyone who abides therein will have been saved from agony and perdition. Allah has said, And if he is one of those on the right hand, then peace to you from those on the right hand (Quran, 56:90-91), that is, rest assured that they are enjoying peace and tranquility."
    ],
    [
        6,
        "'الْمُؤْمِنُ'",
        "Al-Mu’min",
        "The Infuser of Faith",
        "The One who witnessed for Himself that no one is God but Him. And He witnessed for His believers that they are truthful in their belief that no one is God but Him",
        "https://upload.wikimedia.org/wikipedia/commons/6/68/06-al-mumin.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/147-al-mumin",
        "Al-Mu'min means the One to Whom peace and security are rendered: He provides the means of their attainment, blocking all the avenues of fear.There is neither peace nor security in this life against the causes of disease and perdition, nor in the life hereafter against the torment and the Wrath, except that He provides the means to attain it."
    ],
    [
        7,
        "'الْمُهَيْمِنُ'",
        "Al-Muhaymin",
        "The Preserver of Safety",
        "The One who witnesses the saying and deeds of His creatures",
        "https://upload.wikimedia.org/wikipedia/commons/e/ef/07-al-muhaymin.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/146-al-muhaimin",
        "When applied to the Almighty, al-Muhaimin means that He is the One Who oversees His servants actions, Who provides them with sustenance, and decrees their life-spans. He does so through His knowledge, control, and protection. Anyone who oversees something is its guardian; so he has full power over it. These Attributes can never be present in their absolute meaning except in Allah."
    ],
    [
        8,
        "'الْعَزِيزُ'",
        "Al-Aziz",
        "The Mighty One",
        "The Strong, The Defeater who is not defeated",
        "https://upload.wikimedia.org/wikipedia/commons/f/f9/08-al-aziz.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/145-al-aziz",
        "Al-Aziz is the one whose might cannot be overcome. He is the most powerful, the undefeatable. No one can challenge His strength, and no force can oppose Him. His might ensures that everything in existence happens according to His will, and nothing can resist His command. This name reflects His supreme and unparalleled power over all things."
    ],
    [
        9,
        "'الْجَبَّارُ'",
        "Al-Jabbar",
        "The Omnipotent One",
        "The One that nothing happens in His Dominion except that which He willed",
        "https://upload.wikimedia.org/wikipedia/commons/e/e5/09-al-jabbar.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/144-al-jabbar",
        "Al-Jabbar is the one whose will and power are all-encompassing. Nothing happens in His realm without His permission. He is the Omnipotent One who compels all creation according to His will, and no force can oppose His decrees. This name reflects Allah's absolute authority over all things."
    ],
    [
        10,
        "'الْمُتَكَبِّرُ'",
        "Al-Mutakabbir",
        "The Dominant One",
        "The One who is clear from the attributes of the creatures and from resembling them.",
        "https://upload.wikimedia.org/wikipedia/commons/a/a9/10-al-mutakabbir.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/143-al-mutakabbir",
        "Al-Mutakabbir signifies Allah's transcendence and superiority above all creation. He is free from any comparison or likeness to His creatures. His greatness and majesty are beyond human understanding, and He stands as the sole sovereign over all existence."
    ],
    [
        11,
        "'الْخَالِقُ'",
        "Al-Khaaliq",
        "The Creator",
        "The One who brings everything from non-existence to existence",
        "https://upload.wikimedia.org/wikipedia/commons/a/a6/11-al-khaliq.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/142-al-khaliq",
        "Al-Khaaliq is the Creator of all things, bringing them into existence from the realm of non-existence. He is the originator of everything in the universe, and everything that exists is a product of His creative will. This name reflects His supreme creative power and ability to bring life to all that He desires."
    ],
    [
        12,
        "'الْبَارِئُ'",
        "Al-Baari",
        "The Evolver",
        "The Maker, The Creator who has the Power to turn the entities.",
        "https://upload.wikimedia.org/wikipedia/commons/0/0b/12-al-bari.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/141-al-bari",
        "Al-Baari is the one who brings forth and evolves creation. He not only creates but also shapes and perfects all things, each in its proper form and function. His power is not just in creation but in the continuous process of evolution and transformation of His creations."
    ],
    [
        13,
        "'الْمُصَوِّرُ'",
        "Al-Musawwir",
        "The Flawless Shaper",
        "The One who forms His creatures in different pictures.",
        "https://upload.wikimedia.org/wikipedia/commons/d/dc/13-al-musawwir.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/140-al-musawwir",
        "Al-Musawwir is the Shaper of all creatures, perfecting them in various forms and designs. Every living being and every aspect of creation is shaped by His flawless hand, according to His infinite wisdom. This name reflects His mastery over the diversity and beauty of creation."
    ],
    [
        14,
        "'الْغَفَّارُ'",
        "Al-Ghaffaar",
        "The Great Forgiver",
        "The Forgiver, The One who forgives the sins of His slaves time and time again.",
        "https://upload.wikimedia.org/wikipedia/commons/e/ea/14-al-ghaffar.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/139-al-ghaffar",
        "Al-Ghaffaar is the one who constantly forgives the sins of His servants, no matter how many times they fall short. His forgiveness is endless, and He allows His creation to turn to Him with repentance, cleansing them from their wrongdoings. This name reflects His boundless mercy and compassion."

    ],
    [
        15,
        "'الْقَهَّارُ'",
        "Al-Qahhaar",
        "The All-Prevailing One",
        "The Dominant, The One who has the perfect Power and is not unable over anything.",
        "https://upload.wikimedia.org/wikipedia/commons/d/d1/15-al-qahhar.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/138-al-qahhar",
        "Al-Qahhaar is the one who has complete dominance over all things. His power is absolute, and nothing can resist or oppose Him. He is the ultimate force who prevails over every situation, demonstrating His supreme authority and control over the universe."

    ],
    [
        16,
        "'الْوَهَّابُ'",
        "Al-Wahhab",
        "The Supreme Bestower",
        "The One who is Generous in giving plenty without any return. He is everything that benefits whether Halal or Haram.",
        "https://upload.wikimedia.org/wikipedia/commons/c/c6/16-al-wahhab.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/137-al-wahhab",
        "Al-Wahhab is the Supreme Bestower, the one who gives without limit or expectation of return. His generosity is infinite, and He grants blessings to all of His creation, regardless of their worthiness. This name highlights His endless benevolence and kindness."

    ],
    [
        17,
        "'الرَّزَّاقُ'",
        "Ar-Razzaq",
        "The Total Provider",
        "The Sustainer, The Provider.",
        "https://upload.wikimedia.org/wikipedia/commons/4/43/17-ar-razzaq.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/136-al-razzaq",
        "Ar-Razzaq is the Sustainer and Provider of all that exists. He provides for His creation, ensuring that every creature receives sustenance in accordance with His divine plan. This name reflects Allah's role as the ultimate source of all provision, both material and spiritual."

    ],
    [
        18,
        "'الْفَتَّاحُ'",
        "Al-Fattah",
        "The Supreme Solver",
        "The Opener, The Reliever, The Judge, The One who opens for His slaves the closed worldly and religious matters.",
        "https://upload.wikimedia.org/wikipedia/commons/4/4e/18-al-fattah.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/135-al-fattah",
            "Al-Fattah is the One who opens the doors to success, relief, and judgment. He is the ultimate judge who resolves disputes and opens solutions to problems that seem insurmountable. This name reflects His role as the opener of all things, bringing clarity and guidance to His creation."

    ],
    [
        19,
        "'اَلْعَلِيْمُ'",
        "Al-Alim",
        "The All-Knowing One",
        "The Knowledgeable; The One nothing is absent from His knowledge",
        "https://upload.wikimedia.org/wikipedia/commons/9/96/19-al-alim.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/134-al-aleem",
        "Al-Alim is the All-Knowing One, encompassing infinite knowledge of all things, both seen and unseen. Nothing escapes His understanding, and His wisdom governs every aspect of existence. This name highlights Allah’s omniscience and the depth of His perfect knowledge."

    ],
    [
        20,
        "'الْقَابِضُ'",
        "Al-Qaabid",
        "The Restricting One",
        "The Constrictor, The Withholder, The One who constricts the sustenance by His wisdom and expands and widens it with His Generosity and Mercy.",
        "https://upload.wikimedia.org/wikipedia/commons/2/27/20-al-qabid.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/133-al-qabid",
        "Al-Qaabid is the One who restricts and withholds sustenance when He deems necessary, and equally expands it when He wishes. His control over the provision is according to His wisdom, balancing abundance and scarcity. This name reflects His absolute control over all things and His perfect understanding of the needs of His creation."

    ],
    [
        21,
        "'الْبَاسِطُ'",
        "Al-Baasit",
        "The Extender",
        "The Englarger, The One who constricts the sustenance by His wisdom and expands and widens it with His Generosity and Mercy.",
        "https://upload.wikimedia.org/wikipedia/commons/c/c0/21-al-basit.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/132-al-basit",
        "Al-Baasit is the One who expands the provisions, opportunities, and blessings for His creation. He has the power to both widen and contract as He pleases, distributing His mercy and generosity in abundance, ensuring His creation receives what they need according to His divine wisdom."

    ],
    [
        22,
        "'الْخَافِضُ'",
        "Al-Khaafid",
        "The Reducer",
        "The Abaser, The One who lowers whoever He willed by His Destruction and raises whoever He willed by His Endowment.",
        "https://upload.wikimedia.org/wikipedia/commons/f/fa/22-al-khafid.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/131-al-khafid",
        "Al-Khaafid is the One who has the power to lower or diminish whatever He chooses, be it people, things, or situations, according to His wisdom and will. He humbles those He desires, and no one can raise them except Him. His action reflects the balance of humility and grandeur."

    ],
    [
        23,
        "'الرَّافِعُ'",
        "Ar-Rafi",
        "The Elevating One",
        "The Exalter, The Elevator, The One who lowers whoever He willed by His Destruction and raises whoever He willed by His Endowment.",
        "https://upload.wikimedia.org/wikipedia/commons/9/96/23-ar-rafi.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/130-al-rafi",
        "Ar-Rafi is the One who elevates and raises in status, wealth, or condition those He wills. His raising power is unmatched, and no one can lower those He has exalted. This name signifies the supreme authority of Allah in granting honor and distinction to whom He pleases."

    ],
    [
        24,
        "'الْمُعِزُّ'",
        "Al-Mu’izz",
        "The Honourer-Bestower",
        "He gives esteem to whoever He willed, hence there is no one to degrade Him; And He degrades whoever He willed, hence there is no one to give Him esteem.",
        "https://upload.wikimedia.org/wikipedia/commons/f/f6/24-al-muizz.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/129-al-muizz",
        "Al-Mu’izz is the One who bestows honor and status upon those He chooses. He has the ultimate control over who is elevated and who is humbled. No one can degrade Him or raise someone whom He has lowered, as His decisions are final and unchallenged."


    ],
    [
        25,
        "'المُذِلُّ'",
        "Al-Muzil",
        "The Abaser",
        "The Dishonourer, The Humiliator, He gives esteem to whoever He willed, hence there is no one to degrade Him; And He degrades whoever He willed, hence there is no one to give Him esteem.",
        "https://upload.wikimedia.org/wikipedia/commons/b/b0/25-al-mudhill.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/128-al-muthill",
        "Al-Muzil is the One who humbles and lowers whoever He wills, removing their dignity, honor, or status according to His divine wisdom. He alone has the authority to humble any being, and no one can restore their dignity without His will."

    ],
    [
        26,
        "'السَّمِيعُ'",
        "As-Sami’",
        "The All-Hearer",
        "The Hearer, The One who Hears all things that are heard by His Eternal Hearing without an ear, instrument or organ.",
        "https://upload.wikimedia.org/wikipedia/commons/f/fe/26-as-sami.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/127-al-samee",
        "As-Sami’ is the All-Hearing One, who hears everything in the universe without any limitation or need for organs. His hearing is eternal and encompasses all sounds, prayers, and whispers, providing a perfect response to His creation."

    ],
    [
        27,
        "'الْبَصِيرُ'",
        "Al-Baseer",
        "The All-Seeing",
        "The All-Noticing, The One who Sees all things that are seen by His Eternal Seeing without a pupil or any other instrument.",
        "https://upload.wikimedia.org/wikipedia/commons/2/28/27-al-basir.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/126-al-baseer",
        "Al-Baseer is the One who sees everything with His eternal and perfect vision. He does not need any physical organs to perceive the world, as His sight encompasses all things, whether visible or hidden, known or unknown."

    ],
    [
        28,
        "'الْحَكَمُ'",
        "Al-Hakam",
        "The Impartial Judge",
        "The Judge, He is the Ruler and His judgment is His Word.",
        "https://upload.wikimedia.org/wikipedia/commons/e/eb/28-al-hakam.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/125-al-hakam",
        "Al-Hakam is the Supreme Judge, whose judgment is based on ultimate justice and truth. His ruling is final, and His decisions are flawless. There is no appeal against His judgment, as He alone is the Just Arbiter of all matters."

    ],
    [
        29,
        "'الْعَدْلُ'",
        "Al-Adl",
        "The Embodiment of Justice",
        "The Just, The One who is entitled to do what He does.",
        "https://upload.wikimedia.org/wikipedia/commons/b/bd/29-al-adl.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/124-al-adl",
        "Al-Adl is the epitome of justice. Everything He does is just and fair, and His actions are beyond reproach. He is the absolute standard of equity, and His decisions ensure that justice prevails in all circumstances."

    ],
    [
        30,
        "'اللَّطِيفُ'",
        "Al-Lateef",
        "The Knower of Subtleties",
        "The Subtle One, The Gracious, The One who is kind to His slaves and endows upon them.",
        "https://upload.wikimedia.org/wikipedia/commons/2/25/30-al-latif.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/123-al-lateef",
        "Al-Lateef is the Subtle One, whose kindness and mercy are manifested in the most delicate ways. He is aware of the smallest details of His creation and acts with subtlety, bringing gentle benefits and blessings to those He loves."

    ],
    [
        31,
        "'الْخَبِيرُ'",
        "Al-Khabeer",
        "The All-Aware One",
        "The One who knows the truth of things.",
        "https://upload.wikimedia.org/wikipedia/commons/d/d2/31-al-khabir.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/122-al-khabeer",
        "Allah, Al-Khabeer, is fully aware of all things. His knowledge encompasses everything in the universe, from the smallest detail to the grandest events. His awareness is not limited by time or space, and He knows the unseen as well as the seen. Nothing escapes His perfect knowledge."

    ],
    [
        32,
        "'الْحَلِيمُ'",
        "Al-Haleem",
        "The Clement One",
        "The Forebearing, The One who delays the punishment for those who deserve it and then He might forgive them.",
        "https://upload.wikimedia.org/wikipedia/commons/a/a1/32-al-halim.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/121--al-haleem",
        "Allah is Al-Haleem, the most gentle and forbearing. He is slow to anger and delays punishment, giving people the opportunity to repent and seek forgiveness. His clemency shows His boundless mercy and love for His creation."

    ],
    [
        33,
        "'الْعَظِيمُ'",
        "Al-Azeem",
        "The Magnificent One",
        "The Great One, The Mighty, The One deserving the attributes of Exaltment, Glory, Extolement, and Purity from all imperfection.",
        "https://upload.wikimedia.org/wikipedia/commons/5/51/33-al-azim.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/120-al-azeem",
        "Al-Azeem is Allah's name that signifies His greatness and majesty. He is the Most Exalted, beyond comparison, with a stature far greater than anyone or anything. His glory and magnificence are unmatched."

    ],
    [
        34,
        "'الْغَفُورُ'",
        "Al-Ghafoor",
        "The Great Forgiver",
        "The All-Forgiving, The Forgiving, The One who forgives a lot.",
        "https://upload.wikimedia.org/wikipedia/commons/e/ec/34-al-ghafur.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/119-al-ghafur",
        "Al-Ghafoor, The Great Forgiver, is the One who continually forgives those who repent to Him. His forgiveness is abundant and encompasses all sins, provided one sincerely seeks His mercy."

    ],
    [
        35,
        "'الشَّكُورُ'",
        "Ash-Shakoor",
        "The Acknowledging One",
        "The Grateful, The Appreciative, The One who gives a lot of reward for a little obedience.",
        "https://upload.wikimedia.org/wikipedia/commons/9/9b/35-ash-shakur.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/118-al-shakur",
        "Ash-Shakoor, The Acknowledging One, rewards His servants greatly for their small acts of obedience. His appreciation is immense, and He multiplies the reward far beyond what is given."

    ],
    [
        36,
        "'الْعَلِيُّ'",
        "Al-Aliyy",
        "The Sublime One",
        "The Most High, The One who is clear from the attributes of the creatures.",
        "https://upload.wikimedia.org/wikipedia/commons/4/44/36-al-ali.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/117-al-ali",
        "Al-Aliyy is the Most High, the One who is beyond all comparison with His creation. His status is clear from the limitations of created beings, and He is above all in rank and honor."

    ],
    [
        37,
        "'الْكَبِيرُ'",
        "Al-Kabeer",
        "The Great One",
        "The Most Great, The Great, The One who is greater than everything in status.",
        "https://upload.wikimedia.org/wikipedia/commons/c/cf/37_al-kabir.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/116-al-kabeer",
        "Al-Kabeer, The Great One, refers to Allah’s unmatched greatness. His power and majesty surpass all, and there is none greater than Him in all of existence."

    ],
    [
        38,
        "'الْحَفِيظُ'",
        "Al-Hafiz",
        "The Guarding One",
        "The Preserver, The Protector, The One who protects whatever and whoever He willed to protect.",
        "https://upload.wikimedia.org/wikipedia/commons/8/88/38-al-hafiz.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/115-al-hafeez",
        "Al-Hafiz, The Guarding One, protects His creation from harm and preserves everything according to His will. Nothing escapes His protection, whether seen or unseen."

    ],
    [
        39,
        "'المُقيِت'",
        "Al-Muqeet",
        "The Sustaining One",
        "The Maintainer, The Guardian, The Feeder, The One who has the Power.",
        "https://upload.wikimedia.org/wikipedia/commons/e/e6/39-al-muqit.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/114-al-muqeet",
        "Al-Muqeet, The Sustaining One, is the One who provides sustenance to all of creation. He has the power to sustain every being, and He ensures that every creature is provided for in accordance with His will."

    ],
    [
        40,
        "'الْحسِيبُ'",
        "Al-Haseeb",
        "The Reckoning One",
        "The Reckoner, The One who gives the satisfaction.",
        "https://upload.wikimedia.org/wikipedia/commons/b/b0/40-al-hasib.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/113-al-haseeb",
        "Al-Haseeb, The Reckoning One, will hold every soul accountable for their actions. He is the One who calculates every deed and gives each individual the due reward or punishment."

    ],
    [
        41,
        "'الْجَلِيلُ'",
        "Al-Jaleel",
        "The Majestic One",
        "The Sublime One, The Beneficent, The One who is attributed with greatness of Power and Glory of status.",
        "https://upload.wikimedia.org/wikipedia/commons/1/1d/41-al-jalil.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/112-al-jaleel",
        "Al-Jaleel, The Majestic One, is the One whose power and glory are magnificent. His greatness and majesty are evident in every aspect of His creation."

    ],
    [
        42,
        "'الْكَرِيمُ'",
        "Al-Kareem",
        "The Bountiful One",
        "The Generous One, The Gracious, The One who is attributed with greatness of Power and Glory of status.",
        "https://commons.wikimedia.org/wiki/File:42_al-karim.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/111-al-kareem",
        "Al-Kareem, The Bountiful One, is the One who gives abundantly, beyond measure. His generosity and grace are limitless, offering gifts of mercy, kindness, and provision to His creation."

    ],
    [
        43,
        "'الرَّقِيبُ'",
        "Ar-Raqeeb",
        "The Watchful One",
        "The Watcher, The One that nothing is absent from Him. Hence it’s meaning is related to the attribute of Knowledge.",
        "https://upload.wikimedia.org/wikipedia/commons/2/27/43-ar-raqib.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/110-al-raqeeb",
        "Ar-Raqeeb, The Watchful One, observes all things with complete knowledge. Nothing escapes His gaze, and He is aware of every action, intention, and thought of His creation."

    ],
    [
        44,
        "'الْمُجِيبُ'",
        "Al-Mujeeb",
        "The Responding One",
        "The Responsive, The Hearkener, The One who answers the one in need if he asks Him and rescues the yearner if he calls upon Him.",
        "https://upload.wikimedia.org/wikipedia/commons/1/17/44-al-mujib.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/109-al-mujib",
        "Al-Mujeeb, The Responding One, answers the prayers of those who call upon Him. He hears the supplication of every soul and responds with mercy, guidance, and help in times of need."

    ],
    [
        45,
        "'الْوَاسِعُ'",
        "Al-Waasi’",
        "The All-Pervading One",
        "The Vast, The All-Embracing, The Knowledgeable.",
        "https://upload.wikimedia.org/wikipedia/commons/d/d0/45-al-wasi.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/108-al-wasi",
        "Al-Waasi’, The All-Pervading One, is the One whose knowledge, mercy, and power encompass all things. Nothing is beyond His vast reach, and His presence fills every part of the universe."

    ],
    [
        46,
        "'الْحَكِيمُ'",
        "Al-Hakeem",
        "The Wise One",
        "The Wise, The Judge of Judges, The One who is correct in His doings.",
        "https://upload.wikimedia.org/wikipedia/commons/6/62/46-al-hakim.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/107-al-hakeem",
        "Al-Hakeem, The Wise One, is the source of all wisdom. His decisions are always perfect, just, and correct, as He is the ultimate judge of all matters."


    ],
    [
        47,
        "'الْوَدُودُ'",
        "Al-Wadud",
        "The Loving One",
        "The One who loves His believing slaves and His believing slaves love Him. His love to His slaves is His Will to be merciful to them and praise them",
        "https://upload.wikimedia.org/wikipedia/commons/0/04/47-al-wadud.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/105-al-wadood",
        "Al-Wadud, The Loving One, is the One who loves His believers dearly. His love for His creation is vast and pure, and it encourages His believers to reciprocate with love and devotion."

    ],
    [
        48,
        "'الْمَجِيدُ'",
        "Al-Majeed",
        "The Glorious One",
        "The Most Glorious One, The One who is with perfect Power, High Status, Compassion, Generosity and Kindness.",
        "https://upload.wikimedia.org/wikipedia/commons/7/73/48-al-majid.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/104-al-majeed",
        "Al-Majeed, The Glorious One, is the One who possesses all honor, dignity, and magnificence. His glory is unparalleled, and He is full of compassion, power, and kindness."

    ],
    [
        49,
        "'الْبَاعِثُ'",
        "Al-Ba’ith",
        "The Infuser of New Life",
        "The Resurrector, The Raiser (from death), The One who resurrects His slaves after death for reward and/or punishment.",
        "https://upload.wikimedia.org/wikipedia/commons/0/08/50-ash-shahid.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/103-al-baith",
        "Al-Ba’ith, The Infuser of New Life, is the One who resurrects His creation from death, bringing them to life once again for judgment, reward, or punishment."

    ],
    [
        50,
        "'الشَّهِيدُ'",
        "Ash-Shaheed",
        "The All Observing Witness",
        "The Witness, The One who nothing is absent from Him.",
        "",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/102-al-shaheed",
        "Ash-Shaheed, The All Observing Witness, is the One who observes every action, word, and thought of His creation. There is nothing that escapes His witness, and nothing can hide from His awareness."

    ],
    [
        51,
        "'الْحَقُّ'",
        "Al-Haqq",
        "The Embodiment of Truth",
        "The Truth, The True, The One who truly exists.",
        "https://upload.wikimedia.org/wikipedia/commons/5/5e/51-al-haqq.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/101-al-haqq",
        "Al-Haqq, meaning 'The Truth,' is one of Allah's names signifying His ultimate reality and unchanging essence. It reflects His attribute as the foundation of all truth and existence, assuring believers that everything He decrees is just and real."
    ],
    [
        52,
        "'الْوَكِيلُ'",
        "Al-Wakeel",
        "The Universal Trustee",
        "The Trustee, The One who gives the satisfaction and is relied upon.",
        "https://upload.wikimedia.org/wikipedia/commons/b/b1/52-al-wakil.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/100-al-wakeel",
        "Al-Wakeel emphasizes Allah's role as the ultimate Trustee and Sustainer. It signifies that He is the one to depend upon, who manages and safeguards the affairs of all creation with perfection and reliability."
    ],
    [
        53,
        "'الْقَوِيُّ'",
        "Al-Qawwiyy",
        "The Strong One",
        "The Most Strong, The Strong, The One with the complete Power",
        "https://upload.wikimedia.org/wikipedia/commons/4/43/53-al-qawi.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/99-al-qawiyy",
        "Al-Qawwiyy, 'The Strong One,' refers to Allah's unmatched power and might. It reassures believers of His ability to support and protect them against all odds, emphasizing His supreme control over the universe."
    ],
    [
        54,
        "'الْمَتِينُ'",
        "Al-Mateen",
        "The Firm One",
        "The One with extreme Power which is un-interrupted and He does not get tired.",
        "https://upload.wikimedia.org/wikipedia/commons/8/8e/54-al-matin.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/98-al-matin",
        "Al-Mateen signifies Allah's unshakable firmness and endurance. This name highlights His eternal strength and ability to carry out His will, regardless of challenges or obstacles."
    ],
    [
        55,
        "'الْوَلِيُّ'",
        "Al-Waliyy",
        "The Protecting Associate",
        "The Protecting Friend, The Supporter.",
        "https://upload.wikimedia.org/wikipedia/commons/6/6a/55-al-wali.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/97-al-waliyy",
        "Al-Waliyy, 'The Protecting Associate,' emphasizes Allah's closeness and support to His servants. He is the guardian who lovingly protects and guides them through life's trials."
    ],
    [
        56,
        "'الْحَمِيدُ'",
        "Al-Hameed",
        "The Sole-Laudable One",
        "The Praiseworthy, The praised One who deserves to be praised.",
        "https://upload.wikimedia.org/wikipedia/commons/f/f3/56-al-hamid.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/96-al-hameed",
        "Al-Hameed represents Allah as the one who is inherently deserving of all praise. His attributes, actions, and mercy make Him worthy of being glorified by all creation."
    ],
    [
        57,
        "'الْمُحْصِي'",
        "Al-Muhsee",
        "The All-Enumerating One",
        "The Counter, The Reckoner, The One who the count of things are known to him.",
        "https://upload.wikimedia.org/wikipedia/commons/7/72/57-al-muhsi.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/95-al-muhsi",
        "Al-Muhsee, 'The All-Enumerating One,' highlights Allah's knowledge of every detail. He keeps account of all things, ensuring nothing escapes His awareness."
    ],
    [
        58,
        "'الْمُبْدِئُ'",
        "Al-Mubdi",
        "The Originator",
        "The One who started the human being. That is, He created him.",
        "https://upload.wikimedia.org/wikipedia/commons/0/06/58-al-mubdi.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/94-al-mubdi",
        "Al-Mubdi, 'The Originator,' reflects Allah's power to create without precedent. He is the source of all existence, bringing forth creation from nothingness."
    ],
    [
        59,
        "'الْمُعِيدُ'",
        "Al-Mueed",
        "The Restorer",
        "The Reproducer, The One who brings back the creatures after death",
        "https://upload.wikimedia.org/wikipedia/commons/9/9e/59-al-muid.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/93-al-mueed",
        "Al-Mueed, 'The Restorer,' highlights Allah's ability to recreate and revive. He promises resurrection and restoration, affirming life after death."
    ],
    [
        60,
        "'الْمُحْيِي'",
        "Al-Muhyi",
        "The Maintainer of life",
        "The Restorer, The Giver of Life, The One who took out a living human from semen that does not have a soul. He gives life by giving the souls back to the worn out bodies on the resurrection day and He makes the hearts alive by the light of knowledge.",
        "https://upload.wikimedia.org/wikipedia/commons/2/21/60-al-muhyi.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/92-al-muhyi",
        "Al-Muhyi, 'The Maintainer of Life,' signifies Allah's ability to grant and restore life. It encompasses both physical life and the spiritual awakening of hearts through divine guidance."
    ],
    [
        61,
        "'اَلْمُمِيتُ'",
        "Al-Mumeet",
        "The Inflictor of Death",
        "The Creator of Death, The Destroyer, The One who renders the living dead.",
        "https://upload.wikimedia.org/wikipedia/commons/7/78/61-al-mumit.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/91-al-mumeet",
        "Al-Mumeet emphasizes Allah's control over life and death. As 'The Inflictor of Death,' He alone decides when life ceases, reminding humanity of the transient nature of worldly existence."
    ],
    [
        62,
        "'الْحَيُّ'",
        "Al-Hayy",
        "The Eternally Living One",
        "The Alive, The One attributed with a life that is unlike our life and is not that of a combination of soul, flesh or blood.",
        "https://upload.wikimedia.org/wikipedia/commons/6/65/62-al-hayy.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/90-al-hayy",
        "Al-Hayy, 'The Eternally Living One,' affirms that Allah's life is eternal and self-sustaining. Unlike human life, His existence is free from dependence or limitations."

    ],
    [
        63,
        "'الْقَيُّومُ'",
        "Al-Qayyoom",
        "The Self-Subsisting One",
        "The One who remains and does not end.",
        "https://upload.wikimedia.org/wikipedia/commons/4/42/63-al-qayyum.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/89-al-qayyum",
        "Al-Qayyoom underscores Allah's self-sufficiency and eternal presence. As 'The Self-Subsisting One,' He supports all creation without reliance on anything."
    ],
    [
        64,
        "'الْوَاجِدُ'",
        "Al-Waajid",
        "The Pointing One",
        "The Perceiver, The Finder, The Rich who is never poor. Al-Wajd is Richness.",
        "https://upload.wikimedia.org/wikipedia/commons/1/16/64-al-wajid.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/88-al-wajid",
        "Al-Waajid, 'The Pointing One,' reflects Allah's ability to perceive and find everything. He is infinitely rich and lacks nothing, demonstrating His ultimate completeness."
    ],
    [
        65,
        "'الْمَاجِدُ'",
        "Al-Maajid",
        "The All-Noble One",
        "The Glorious, He who is Most Glorious.",
        "https://upload.wikimedia.org/wikipedia/commons/e/e5/65-al-majid.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/87-al-majid",
        "Al-Maajid, 'The All-Noble One,' highlights Allah's unparalleled glory and magnificence. His nobility is manifested in His attributes and actions."
    ],
    [
        66,
        "'الْواحِدُ'",
        "Al-Waahid",
        "The Only One",
        "The Unique, The One, The One without a partner",
        "https://upload.wikimedia.org/wikipedia/commons/8/8c/66-al-wahid.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/86-al-wahid",
        "Al-Waahid affirms the oneness of Allah. As 'The Only One,' He has no partner or equal, emphasizing His absolute uniqueness and divinity."
    ],
    [
        67,
        "'اَلاَحَدُ'",
        "Al-Ahad",
        "The Sole One",
        "The One",
        "https://upload.wikimedia.org/wikipedia/commons/3/38/67-al-ahad.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/85-al-ahad",
        "Al-Ahad, 'The Sole One,' emphasizes the indivisibility of Allah. This name is central to the concept of monotheism, asserting that He is singular in His essence."
    ],
    [
        68,
        "'الصَّمَدُ'",
        "As-Samad",
        "The Supreme Provider",
        "The Eternal, The Independent, The Master who is relied upon in matters and reverted to in ones needs.",
        "https://upload.wikimedia.org/wikipedia/commons/c/c5/68-as-samad.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/84-al-samad",
        "As-Samad, 'The Supreme Provider,' represents Allah as the ultimate source of sustenance and refuge. He is independent and self-sufficient, yet all depend on Him."
    ],
    [
        69,
        "'الْقَادِرُ'",
        "Al-Qaadir",
        "The Omnipotent One",
        "The Able, The Capable, The One attributed with Power.",
        "https://upload.wikimedia.org/wikipedia/commons/d/d7/69-al-qadir.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/83-al-qadir",
        "Al-Qaadir, 'The Omnipotent One,' signifies Allah's infinite power and ability to do all things. Nothing is beyond His control or capability."
    ],
    [
        70,
        "'الْمُقْتَدِرُ'",
        "Al-Muqtadir",
        "The All Authoritative One",
        "The Powerful, The Dominant, The One with the perfect Power that nothing is withheld from Him.",
        "https://upload.wikimedia.org/wikipedia/commons/4/49/70-al-muqtadir.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/82-al-muqtadir",
        "Al-Muqtadir, 'The All Authoritative One,' reflects Allah's supreme power and authority. His dominion is absolute, and He exercises His will without opposition."
    ],
    [
        71,
        "'الْمُقَدِّمُ'",
        "Al-Muqaddim",
        "The Expediting One",
        "The Expediter, The Promoter, The One who puts things in their right places. He makes ahead what He wills and delays what He wills.",
        "https://upload.wikimedia.org/wikipedia/commons/7/77/71-al-muqaddim.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/81-al-muqaddim",
        "Al-Muqaddim, 'The Expediting One,' highlights Allah's power to prioritize events and actions according to His divine wisdom. He brings forward what He wills, ensuring balance and purpose in creation."
    ],
    [
        72,
        "'الْمُؤَخِّرُ'",
        "Al-Mu’akhkhir",
        "The Procrastinator",
        "The Delayer, the Retarder, The One who puts things in their right places. He makes ahead what He wills and delays what He wills.",
        "https://upload.wikimedia.org/wikipedia/commons/f/fb/72-al-muakhkhir.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/80-al-muakhkhir",
        "Al-Mu’akhkhir, 'The Procrastinator,' reflects Allah's wisdom in delaying outcomes or actions. This attribute reassures believers of divine timing and the ultimate goodness in His plans."
    ],
    [
        73,
        "'الأوَّلُ'",
        "Al-Awwal",
        "The Very First",
        "The First, The One whose Existence is without a beginning.",
        "https://upload.wikimedia.org/wikipedia/commons/2/2e/73-al-awwal.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/78-al-awwal",
        "Al-Awwal, 'The Very First,' signifies Allah's pre-eternal existence. He is the origin of everything, existing before all creation and beyond the confines of time."
    ],
    [
        74,
        "'الآخِرُ'",
        "Al-Akhir",
        "The Infinite Last One",
        "The Last, The One whose Existence is without an end.",
        "https://upload.wikimedia.org/wikipedia/commons/8/8d/74-al-akhir.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/77-al-akhir",
        "Al-Akhir, 'The Infinite Last One,' emphasizes Allah's eternal nature. His existence continues infinitely, persisting beyond all creation and the passage of time."
    ],
    [
        75,
        "'الظَّاهِرُ'",
        "Az-Zaahir",
        "The Perceptible",
        "The Manifest, The One that nothing is above Him and nothing is underneath Him, hence He exists without a place. He, The Exalted, His Existence is obvious by proofs and He is clear from the delusions of attributes of bodies.",
        "https://upload.wikimedia.org/wikipedia/commons/8/80/75-az-zahir.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/76-al-zahir",
        ""
    ],
    [
        76,
        "'الْبَاطِنُ'",
        "Al-Baatin",
        "The Imperceptible",
        "The Hidden, The One that nothing is above Him and nothing is underneath Him, hence He exists without a place. He, The Exalted, His Existence is obvious by proofs and He is clear from the delusions of attributes of bodies.",
        "https://upload.wikimedia.org/wikipedia/commons/4/46/76-al-batin.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/75-al-batin",
        "Az-Zaahir, 'The Perceptible,' represents Allah's presence that is evident through the signs in creation. His existence is manifest and undeniable to those who reflect."
    ],
    [
        77,
        "'الْوَالِي'",
        "Al-Waali",
        "The Holder of Supreme Authority",
        "The Governor, The One who owns things and manages them.",
        "https://upload.wikimedia.org/wikipedia/commons/5/53/77-al-wali.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/74-al-wali",
        "Al-Baatin, 'The Imperceptible,' illustrates Allah's hidden essence, which cannot be grasped by human perception. Despite being unseen, His presence is evident through His actions and signs."
    ],
    [
        78,
        "'الْمُتَعَالِي'",
        "Al-Muta’ali",
        "The Extremely Exalted One",
        "The Most Exalted, The High Exalted, The One who is clear from the attributes of the creation.",
        "https://upload.wikimedia.org/wikipedia/commons/d/da/78-al-mutaali.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/73-al-mutaali",
        "Al-Waali, 'The Holder of Supreme Authority,' reflects Allah's role as the ultimate ruler. He governs all affairs, maintaining control and order in creation."
    ],
    [
        79,
        "'الْبَرُّ'",
        "Al-Barr",
        "The Fountain-Head of Truth",
        "The Source of All Goodness, The Righteous, The One who is kind to His creatures, who covered them with His sustenance and specified whoever He willed among them by His support, protection, and special mercy.",
        "https://upload.wikimedia.org/wikipedia/commons/d/d8/79-al-barr.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/72-al-barr",
        "Al-Barr, 'The Fountain-Head of Truth,' embodies Allah's kindness and mercy. He is the ultimate source of goodness, extending His care and blessings to all of creation."
    ],
    [
        80,
        "'التَّوَابُ'",
        "At-Tawwaab",
        "The Ever-Acceptor of Repentance",
        "The Relenting, The One who grants repentance to whoever He willed among His creatures and accepts his repentance.",
        "https://upload.wikimedia.org/wikipedia/commons/1/15/80-at-tawwab.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/71-al-tawwab",
        "At-Tawwaab, 'The Ever-Acceptor of Repentance,' reflects Allah's willingness to forgive those who seek His mercy sincerely. His door for repentance remains open, encouraging believers to return to Him."
    ],
    [
        81,
        "'الْمُنْتَقِمُ'",
        "Al-Muntaqim",
        "The Retaliator",
        "The Avenger, The One who victoriously prevails over His enemies and punishes them for their sins. It may mean the One who destroys them.",
        "https://upload.wikimedia.org/wikipedia/commons/c/cc/81-al-muntaqim.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/70-al-muntaqim",
        "Al-Muntaqim, 'The Retaliator,' illustrates Allah’s justice in holding wrongdoers accountable. He avenges the oppressed and ensures that no act of injustice goes unaddressed."
    ],
    [
        82,
        "'العَفُوُّ'",
        "Al-Afuww",
        "The Supreme Pardoner",
        "The Forgiver, The One with wide forgiveness.",
        "https://upload.wikimedia.org/wikipedia/commons/0/05/82-al-afuw.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/69-al-afuww",
        "Al-Afuww, 'The Supreme Pardoner,' highlights Allah's attribute of immense forgiveness. He erases the sins of those who sincerely repent, offering a clean slate."
    ],
    [
        83,
        "'الرَّؤُوفُ'",
        "Ar-Ra’oof",
        "The Benign One",
        "The Compassionate, The One with extreme Mercy. The Mercy of Allah is His will to endow upon whoever He willed among His creatures.",
        "https://upload.wikimedia.org/wikipedia/commons/d/d3/83-ar-rauf.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/67-al-raoof",
        "Ar-Ra’oof, 'The Benign One,' reflects Allah's profound compassion, which surpasses human understanding. His mercy provides comfort and relief in times of difficulty."
    ],
    [
        84,
        "'مَالِكُ الْمُلْكِ'",
        "Maalik-ul-Mulk",
        "The Eternal Possessor of Sovereignty",
        "The One who controls the Dominion and gives dominion to whoever He willed.",
        "https://upload.wikimedia.org/wikipedia/commons/0/01/84-malik-ul-mulk.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/66-al-malikul-mulk",
        "Maalik-ul-Mulk, 'The Eternal Possessor of Sovereignty,' emphasizes Allah's authority over all existence. He grants and revokes power according to His divine plan."
    ],
    [
        85,
        "'ذُوالْجَلاَلِ وَالإكْرَامِ'",
        "Zul-Jalaali-wal-Ikram",
        "The Possessor of Majesty and Honour",
        "The Lord of Majesty and Bounty, The One who deserves to be Exalted and not denied.",
        "https://upload.wikimedia.org/wikipedia/commons/3/3a/85-dhul-jalaal-wal-ikraam.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/65-thul-jalali-wal-ikram",
        "Zul-Jalaali-wal-Ikram, 'The Possessor of Majesty and Honour,' celebrates Allah's grandeur and generosity, inspiring reverence and gratitude in His creation."
    ],
    [
        86,
        "'الْمُقْسِطُ'",
        "Al-Muqsit",
        "The Just One",
        "The Equitable, The One who is Just in His judgment.",
        "https://upload.wikimedia.org/wikipedia/commons/2/29/86-al-muqsit.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/64-al-muqsit",
        "Al-Muqsit, 'The Just One,' demonstrates Allah's fairness in all His judgments. He ensures equity, granting every individual their due rights."
    ],
    [
        87,
        "'الْجَامِعُ'",
        "Al-Jaami’",
        "The Assembler of Scattered Creations",
        "The Gatherer, The One who gathers the creatures on a day that there is no doubt about, that is the Day of Judgment.",
        "https://upload.wikimedia.org/wikipedia/commons/2/27/87-al-jame.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/63-al-jami",
        "Al-Jaami’, 'The Assembler of Scattered Creations,' refers to Allah's ability to unite all beings, especially on the Day of Judgment, showcasing His supreme power."
    ],
    [
        88,
        "'الْغَنِيُّ'",
        "Al-Ghaniyy",
        "The Self-Sufficient One",
        "The One who does not need the creation.",
        "https://upload.wikimedia.org/wikipedia/commons/f/f4/88-al-ghani.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/62-al-ghaniyy",
        "Al-Ghaniyy, 'The Self-Sufficient One,' signifies Allah's independence from His creation. He is free of need, while all beings depend on Him for sustenance and support."
    ],
    [
        89,
        "'الْمُغْنِي'",
        "Al-Mughni",
        "The Bestower of Sufficiency",
        "The Enricher, The One who satisfies the necessities of the creatures.",
        "https://upload.wikimedia.org/wikipedia/commons/b/b3/89-al-mughni.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/61-al-mughni",
        "Al-Mughni, 'The Bestower of Sufficiency,' illustrates Allah’s ability to enrich His creation, fulfilling their needs and providing contentment."
    ],
    [
        90,
        "'اَلْمَانِعُ'",
        "Al-Maani’",
        "The Preventer",
        "The Withholder.",
        "https://upload.wikimedia.org/wikipedia/commons/a/ad/90-al-mani.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/59-al-mani",
        "Al-Maani’, 'The Preventer,' highlights Allah's control in withholding harm or granting blessings as He deems fit. His actions are rooted in wisdom."
    ],
    [
        91,
        "'الضَّارَّ'",
        "Ad-Daarr",
        "The Distressor",
        "The One who makes harm reach to whoever He willed and benefit to whoever He willed.",
        "https://upload.wikimedia.org/wikipedia/commons/8/86/91-ad-darr.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/58-al-darr",
        "Ad-Daarr, 'The Distressor,' illustrates Allah's power to bring adversity as a means of wisdom and divine justice. He tests and shapes His creation through challenges."
    ],
    [
        92,
        "'النَّافِعُ'",
        "An-Naafi’",
        "The Bestower of Benefits",
        "The Propitious, The One who makes harm reach to whoever He willed and benefit to whoever He willed.",
        "https://upload.wikimedia.org/wikipedia/commons/0/0e/92-an-nafi.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/57-al-nafi",
        "An-Naafi’, 'The Bestower of Benefits,' highlights Allah's mercy and generosity in granting well-being and blessings to His creation."
    ],
    [
        93,
        "'النُّورُ'",
        "An-Noor",
        "The Prime Light",
        "The Light, The One who guides.",
        "https://upload.wikimedia.org/wikipedia/commons/f/fa/93-an-nur.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/56-al-noor",
        "An-Noor, 'The Prime Light,' signifies Allah's divine guidance, illuminating the hearts and minds of those who seek His truth."
    ],
    [
        94,
        "'الْهَادِي'",
        "Al-Haadi",
        "The Provider of Guidance",
        "The Guide, The One whom with His Guidance His believers were guided, and with His Guidance the living beings have been guided to what is beneficial for them and protected from what is harmful to them.",
        "https://upload.wikimedia.org/wikipedia/commons/0/07/94-al-hadi.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/55-al-hadi",
        "Al-Haadi, 'The Provider of Guidance,' emphasizes Allah’s role in showing the straight path to His believers and leading all creation to what benefits them."
    ],
    [
        95,
       "'الْبَدِيعُ'",
       "Al-Badi'",
       "The Unique One",
        "The Incomparable, The One who created the creation and formed it without any preceding example.",
        "https://upload.wikimedia.org/wikipedia/commons/2/2b/95-al-badi.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/54-al-badee",
        "Al-Badi', 'The Unique One,' represents Allah's unmatched creativity and ability to create without precedent, showcasing His perfection and majesty."
    ],
    [
        96,
        "'اَلْبَاقِي'",
        "Al-Baaqi",
        "The Ever Surviving One",
        "The Everlasting, The One that the state of non-existence is impossible for Him.",
        "https://upload.wikimedia.org/wikipedia/commons/2/29/96-al-baqi.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/53-al-baqi",
        "Al-Baaqi, 'The Ever Surviving One,' highlights Allah's eternal nature, never ceasing to exist while all else fades away."
    ],
    [
        97,
        "'الْوَارِثُ'",
        "Al-Waaris",
        "The Eternal Inheritor",
        "The Heir, The One whose Existence remains.",
        "https://upload.wikimedia.org/wikipedia/commons/3/3f/97-al-warith.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/52-al-warith",
        "Al-Waaris, 'The Eternal Inheritor,' reminds us that everything belongs to Allah, and He alone will remain when all things perish."
    ],
    [
        98,
        "'الرَّشِيدُ'",
        "Ar-Rasheed",
        "The Guide to Path of Rectitude",
        "The Guide to the Right Path, The One who guides.",
        "https://upload.wikimedia.org/wikipedia/commons/e/e1/98-ar-rashid.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/50-al-rasheed",
        "Ar-Rasheed is the one who guides His creation to the right path of rectitude and wisdom. His guidance is perfect, directing His followers to what is best and right in every aspect of life. He is the ultimate guide who illuminates the path of truth, righteousness, and wisdom."

    ],
    [
        99,
        "'الصَّبُورُ'",
        "As-Saboor",
        "The Extensively Enduring One",
        "The Patient, The One who does not quickly punish the sinners.",
        "https://upload.wikimedia.org/wikipedia/commons/5/50/99-as-sabur.ogg",
        "http://www.qul.org.au/the-holy-QuranKareem/asma-ul-husna/49-al-saboor",
        "As-Saboor is the one who is patient and who withholds His punishment even when it is deserved. His patience is boundless, and He grants time for His creation to repent and return to righteousness. This name reflects Allah's immense tolerance and His waiting for His creatures to come to the right path."

    ]
]
''';
