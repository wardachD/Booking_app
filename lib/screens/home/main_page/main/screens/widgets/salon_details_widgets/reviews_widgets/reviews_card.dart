import 'package:findovio/models/salon_reviews_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../commands/reviews_functions.dart';

Widget reviewsCard(context, Review review) {
  return Card(
    margin: const EdgeInsets.all(16),
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height * 0.07,
                width: MediaQuery.sizeOf(context).height * 0.07,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 145, 247, 148),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.userId,
                        style: GoogleFonts.anybody(
                            letterSpacing: 0.1,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                    Text(DateFormat('MMM dd, yyyy').format(review.createdAt),
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 163, 163, 163))),
                  ],
                ),
              ),
              RatingBar.builder(
                ignoreGestures: true,
                initialRating: review.rating.toDouble(),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 24.0,
                unratedColor: const Color.fromARGB(0, 255, 255, 255),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Color.fromARGB(255, 250, 207, 77),
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(review.comment),
          const SizedBox(height: 16),
          getImageIfExists(review.imageUrl)
        ],
      ),
    ),
  );
}
