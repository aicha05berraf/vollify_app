import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vollify_app/models/opportunity_model.dart'; // Add this import
import 'package:vollify_app/utils/constants.dart';
import 'package:vollify_app/services/api_service.dart';

class OpportunitySearchScreen extends StatefulWidget {
  const OpportunitySearchScreen({super.key});

  @override
  State<OpportunitySearchScreen> createState() =>
      _OpportunitySearchScreenState();
}

class _OpportunitySearchScreenState extends State<OpportunitySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  List<dynamic> _opportunities = [];
  List<dynamic> _filteredOpportunities = [];

  @override
  void initState() {
    super.initState();
    _fetchOpportunities();
    _searchController.addListener(_filterOpportunities);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchOpportunities() async {
    try {
      final response = await _apiService.getAllOpportunities();

      if (response.statusCode == 200) {
        setState(() {
          _opportunities = jsonDecode(response.body);
          _filteredOpportunities = List.from(_opportunities);
        });
      } else {
        final responseData = jsonDecode(response.body);
        _showError(responseData['message'] ?? 'Failed to fetch opportunities.');
      }
    } catch (e) {
      _showError('An error occurred: $e');
    }
  }

  void _filterOpportunities() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredOpportunities =
          _opportunities.where((opp) {
            return opp['title'].toLowerCase().contains(query) ||
                opp['orgName'].toLowerCase().contains(query) ||
                opp['location'].toLowerCase().contains(query) ||
                (opp['skillsRequired'] as List<dynamic>).any(
                  (skill) => skill.toLowerCase().contains(query),
                );
          }).toList();
    });
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
        title: const Text('Search Opportunities'),
        backgroundColor: AppColors.primaryDark,
        titleTextStyle: const TextStyle(
          color: Colors.white, // Set text color to white
          fontSize: 20, // Optional: Adjust font size if needed
          fontWeight: FontWeight.bold, // Optional: Adjust font weight if needed
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search opportunities...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredOpportunities.length,
              itemBuilder: (context, index) {
                final opportunity = _filteredOpportunities[index];
                return ListTile(
                  title: Text(opportunity['title']),
                  subtitle: Text(opportunity['location']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
