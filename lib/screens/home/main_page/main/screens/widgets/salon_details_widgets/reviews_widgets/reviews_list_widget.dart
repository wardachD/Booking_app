import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:findovio/models/salon_reviews_model.dart';
import 'package:findovio/screens/home/main_page/main/screens/widgets/salon_details_widgets/reviews_widgets/reviews_card.dart';
import '../commands/reviews_functions.dart';

class ReviewsWidget extends StatelessWidget {
  final List<Review> reviews;

  const ReviewsWidget({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return Image.asset('assets/gifs/empty.gif');
    }

    List<int> reviewCounts = getReviewCounts(reviews);
    double averageReview = getAverageReviews(reviews);
    int totalReviews = reviewCounts.reduce((a, b) => a + b);

    return ListView(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(averageReview.toStringAsFixed(1),
                  style: GoogleFonts.notoSerif(
                    fontWeight: FontWeight.w900,
                    fontSize: 48,
                  )),
              const SizedBox(width: 10),
              RatingBar.builder(
                ignoreGestures: true,
                initialRating: getAverageReviews(reviews),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 20.0,
                itemBuilder: (context, _) => const Icon(
                  Icons.star_outlined,
                  color: Color.fromARGB(255, 255, 201, 41),
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
              const SizedBox(width: 15),
              Text(reviews.length.toString(),
                  style: const TextStyle(fontSize: 16)),
              const Text(' reviews', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        ...List.generate(
          5,
          (index) => Row(
            children: [
              const SizedBox(width: 16),
              Text('${5 - index}', style: const TextStyle(fontSize: 16)),
              const Icon(
                size: 16,
                Icons.star_outlined,
                color: Color.fromARGB(255, 255, 201, 41),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LinearProgressIndicator(
                    value:
                        reviewCounts[5 - index - 1] / totalReviews.toDouble(),
                    color: const Color.fromARGB(255, 245, 123, 115),
                    backgroundColor: Colors.grey[300],
                  ),
                ),
              ),
              Text('${reviewCounts[5 - index - 1]}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 16),
            ],
          ),
        ),
        const Divider(),
        ...reviews.map((review) => reviewsCard(context, review)).toList(),
      ],
    );
  }
}
