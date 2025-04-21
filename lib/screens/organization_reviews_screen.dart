import 'package:flutter/material.dart';
import 'package:vollify_app/utils/constants.dart';

class OrganizationReviewsScreen extends StatelessWidget {
  const OrganizationReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Reviews'),
        backgroundColor: AppColors.primaryDark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const _ReviewSummaryCard(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: _reviews.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final review = _reviews[index];
                  return _ReviewCard(review: review);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewSummaryCard extends StatelessWidget {
  const _ReviewSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Overall Rating',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 32),
                SizedBox(width: 4),
                Text(
                  '4.8',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text('/5', style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.8,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              // ignore: deprecated_member_use
              backgroundColor: Colors.amber.withOpacity(0.2),
            ),
            const SizedBox(height: 8),
            const Text('Based on 24 reviews'),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.volunteerName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(review.rating.toString()),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              review.opportunity,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(review.comment),
            const SizedBox(height: 8),
            Text(
              review.date,
              style: TextStyle(color: Colors.grey[500], fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

// Data models
class Review {
  final String volunteerName;
  final String opportunity;
  final int rating;
  final String comment;
  final String date;

  Review({
    required this.volunteerName,
    required this.opportunity,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

final List<Review> _reviews = [
  Review(
    volunteerName: 'Sarah Johnson',
    opportunity: 'Community Cleanup',
    rating: 5,
    comment: 'Great organization with meaningful opportunities!',
    date: '2 weeks ago',
  ),
  // Add more reviews...
];
