import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  final String? placeId;
  final String? userId;

  const ReviewScreen({Key? key, this.placeId, this.userId}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 3.0;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadExistingReview();
  }

  void _loadExistingReview() async {
    Query ref = FirebaseDatabase.instance
        .ref('carWashReview')
        .orderByChild('placeId_userId')
        .equalTo('${widget.placeId}_${widget.userId}');

    DatabaseEvent event = await ref.once();

    if (event.snapshot.exists) {
      Map<dynamic, dynamic> reviews =
          event.snapshot.value as Map<dynamic, dynamic>;
      if (reviews.isNotEmpty) {
        Map<dynamic, dynamic> firstReviewData = reviews.values.first;
        setState(() {
          _reviewController.text = firstReviewData['review'];
          _rating = double.parse(firstReviewData['rating'].toString());
          _isLoaded = true;
        });
      } else {
        setState(() {
          _isLoaded = true;
        });
      }
    } else {
      
      setState(() {
        _isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Leave a Review!')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _reviewController,
              decoration: const InputDecoration(
                labelText: 'Review',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            Slider(
              value: _rating,
              min: 0,
              max: 5,
              divisions: 5,
              label: _rating.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _rating = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () => _submitReview(context),
              child: const Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitReview(BuildContext context) {
    final review = {
      'placeId': widget.placeId,
      'userId': widget.userId,
      'review': _reviewController.text,
      'rating': _rating,
      'placeId_userId': '${widget.placeId}_${widget.userId}',
    };

    DatabaseReference ref = FirebaseDatabase.instance.ref('carWashReview');
    ref.child('${widget.placeId}_${widget.userId}').set(review).then((_) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review: $error')),
      );
    });
  }
}
