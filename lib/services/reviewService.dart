import 'package:firebase_database/firebase_database.dart';
import 'package:oilsavings/models/ReviewModel.dart';
import 'package:intl/intl.dart';

class ReviewService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<void> saveReview(
      String placeId,
      String placeName,
      String userId,
      String username,
      String review,
      String rating,
      String placeIduserId) async {
    try {
      String formattedDate = DateFormat("EEE MMM dd yyyy HH:mm:ss 'GMT'zzzz")
          .format(DateTime.now());

      // Crear instancia de ReviewData
      ReviewData reviewData = ReviewData(
        placeIduserId: placeIduserId,
        placeId: placeId,
        placeName: placeName,
        userId: userId,
        username: username,
        review: review,
        rating: rating,
        date: formattedDate,
      );

      // Guardar en Firebase
      await _dbRef
          .child('placeReview')
          .child(placeIduserId)
          .set(reviewData.toJson());
    } catch (e) {
      throw Exception('Error saving review: $e');
    }
  }
}
