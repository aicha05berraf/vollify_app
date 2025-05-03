import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vollify_app/utils/constants.dart';
import 'package:vollify_app/services/api_service.dart';

class OrganizationReviewsScreen extends StatefulWidget {
  const OrganizationReviewsScreen({super.key});

  @override
  State<OrganizationReviewsScreen> createState() =>
      _OrganizationReviewsScreenState();
}

class _OrganizationReviewsScreenState extends State<OrganizationReviewsScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _reviews = [];
  final String _organizationId = '123'; // Example organization ID

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  void _fetchReviews() async {
    try {
      final response = await _apiService.getReviews(int.parse(_organizationId));

      if (response.statusCode == 200) {
        setState(() {
          _reviews = jsonDecode(response.body);
        });
      } else {
        final responseData = jsonDecode(response.body);
        _showError(responseData['message'] ?? 'Failed to fetch reviews.');
      }
    } catch (e) {
      _showError('An error occurred: $e');
    }
  }

  void _submitReview(String reviewText, int rating) async {
    if (reviewText.isEmpty || rating <= 0) {
      _showError('Please provide a valid review and rating.');
      return;
    }

    try {
      final response = await _apiService.postReview(
        reviewerId: 5,
        reviewedOrgId: int.parse(_organizationId),
        rating: rating,
        comment: reviewText,
      );

      if (response.statusCode == 201) {
        _fetchReviews(); // Refresh the reviews list
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review submitted successfully!')),
        );
      } else {
        final responseData = jsonDecode(response.body);
        _showError(responseData['message'] ?? 'Failed to submit review.');
      }
    } catch (e) {
      _showError('An error occurred: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Organization Reviews',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryDark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const _ReviewSummaryCard(),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Write your review',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (reviewText) {
                // Example: Submit a review with a rating of 5
                _submitReview(reviewText, 5);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: _reviews.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final review = _reviews[index];
                  return _ReviewCard(
                    review: Review(
                      volunteerName: review['volunteerName'],
                      opportunity: review['opportunity'],
                      rating: review['rating'],
                      comment: review['comment'],
                      date: review['date'],
                    ),
                  );
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
