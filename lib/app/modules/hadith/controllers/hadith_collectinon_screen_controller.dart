
import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:hadith/classes.dart';
import 'package:hadith/hadith.dart';

class HadithCollectionController extends GetxController {
  late Timer _timer;
  late Hadith _currentHadith;
  final Random random = Random();
  bool _isLoadingHadith = false;

  @override
  void onInit() {
    super.onInit();
    _loadRandomHadith();
    _startTimer();
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }

  void _loadRandomHadith() async {
    if (_isLoadingHadith) return;
    _isLoadingHadith = true;

    final collections = getCollections();
    final randomCollection = collections[random.nextInt(collections.length)];
    final books = getBooks(Collections.values.firstWhere((c) => c.name == randomCollection.name));
    if (books.isNotEmpty) {
      final randomBook = books[random.nextInt(books.length)];
      final bookNumber = randomBook.bookNumber;

      if (bookNumber != null && bookNumber.isNotEmpty) {
        final parsedBookNumber = int.tryParse(bookNumber);
        if (parsedBookNumber != null) {
          final hadiths = getHadiths(Collections.values.firstWhere((c) => c.name == randomCollection.name), parsedBookNumber);
          if (hadiths.isNotEmpty) {
            _currentHadith = hadiths[random.nextInt(hadiths.length)];
            update(); // Notify listeners of the state change
          }
        } else {
          // Handle the case where bookNumber could not be parsed.
          print('Error: bookNumber "${bookNumber}" could not be parsed as an integer.');
        }
      } else {
        // Handle the case where bookNumber is null or empty.
        print('Error: bookNumber is null or empty.');
      }
    }
    _isLoadingHadith = false;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 60), (timer) {
      _loadRandomHadith();
    });
  }

  Hadith get currentHadith => _currentHadith;
  bool get isLoadingHadith => _isLoadingHadith;
}