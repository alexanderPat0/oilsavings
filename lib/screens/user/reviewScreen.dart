// ignore_for_file: sort_child_properties_last

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:oilsavings/models/ReviewModel.dart';
import 'package:oilsavings/services/reviewService.dart';

class ReviewScreen extends StatefulWidget {
  final String? placeId;
  final String? userId;
  final String? placeName;
  final String? username;

  const ReviewScreen(
      {Key? key, this.placeId, this.userId, this.placeName, this.username})
      : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();
  final ReviewService _reviewService = ReviewService();
  bool _sliderChanged = false;
  double _rating = 3.0;
  bool _isUserReviewLoaded = false;
  bool _isReviewsLoaded = false;
  List<ReviewData> _reviews = [];

  @override
  void initState() {
    super.initState();
    _loadExistingReview();
    _loadReviews(); // Asegúrate de cargar todas las reviews también.
  }

  void _loadReviews() async {
    Query ref = FirebaseDatabase.instance
        .ref('placeReview')
        .orderByChild('placeId')
        .equalTo(widget.placeId);

    DatabaseEvent event = await ref.once();

    if (event.snapshot.exists) {
      Map<dynamic, dynamic> data =
          event.snapshot.value as Map<dynamic, dynamic>;
      List<ReviewData> reviews = [];
      data.forEach((key, value) {
        reviews.add(ReviewData.fromJson(Map<String, dynamic>.from(value)));
      });
      setState(() {
        _reviews = reviews; // Asegúrate de que tienes esta lista en tu estado
        _isReviewsLoaded = true;
      });
    } else {
      setState(() {
        _isReviewsLoaded = true;
      });
    }
  }

  void _loadExistingReview() async {
    Query ref = FirebaseDatabase.instance
        .ref('placeReview')
        .orderByChild('placeIduserId')
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
          _isUserReviewLoaded = true;
        });
      } else {
        setState(() {
          _isUserReviewLoaded = true;
        });
      }
    } else {
      setState(() {
        _isUserReviewLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isUserReviewLoaded || !_isReviewsLoaded) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: Center(
          child: LoadingAnimationWidget.fourRotatingDots(
            color: Colors.orange,
            size: 150,
          ),
        ),
      );
    }

    List<ReviewData> otherReviews =
        _reviews.where((review) => review.userId != widget.userId).toList();

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
                  _sliderChanged = true;
                });
              },
            ),
            ElevatedButton(
              onPressed: _submitReview,
              child: const Text('Submit Review'),
            ),
            otherReviews.isNotEmpty
                ? Expanded(
                    child: CarouselSlider.builder(
                      itemCount: otherReviews.length,
                      itemBuilder: (context, index, realIndex) {
                        final review = otherReviews[index];
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ExpansionTile(
                            title: Text(review.username ?? 'Anonymous',
                                style: const TextStyle(color: Colors.black)),
                            subtitle: Text('Rating: ${review.rating}',
                                style:
                                    const TextStyle(color: Colors.deepPurple)),
                            children: <Widget>[
                              Container(
                                height:
                                    150, // Máxima altura para el contenido expandido
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                        review.review ??
                                            'No review text available.',
                                        style: const TextStyle(
                                            color: Colors.black54)),
                                  ),
                                ),
                              )
                            ],
                            initiallyExpanded:
                                false, // Comienza con el tile colapsado
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 400,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.vertical,
                        autoPlay: false,
                        enableInfiniteScroll: otherReviews.length > 1,
                        scrollPhysics: otherReviews.length > 1
                            ? const ScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                      ),
                    ),
                  )
                : const Expanded(
                    child: Center(child: Text('Not reviewed yet')),
                  ),
          ],
        ),
      ),
    );
  }

  void _submitReview() async {
    String reviewText =
        _reviewController.text.isEmpty ? '' : _reviewController.text;
    var reviewRating;
    if (_sliderChanged) {
      reviewRating = _rating;
    } else {
      reviewRating = '';
    }
    try {
      await _reviewService.saveReview(
        widget.placeId!,
        widget.placeName!,
        widget.userId!,
        widget.username!,
        reviewText,
        reviewRating.toString(),
        '${widget.placeId}${widget.userId}',
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review: $e')),
      );
    }
  }
}

  // void _submitReview(BuildContext context) {
  //   final review = {
  //     'placeId': widget.placeId,
  //     'placeName': widget.placeName,
  //     'userId': widget.userId,
  //     'username': widget.username,
  //     'review': _reviewController.text,
  //     'rating': _rating,
  //     'placeIduserId': '${widget.placeId}${widget.userId}',
  //   };

  //   DatabaseReference ref = FirebaseDatabase.instance.ref('placeReview');
  //   ref.child('${widget.placeId}_${widget.userId}').set(review).then((_) {
  //     Navigator.pop(context);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Review submitted successfully')),
  //     );
  //   }).catchError((error) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to submit review: $error')),
  //     );
  //   });
  // }

