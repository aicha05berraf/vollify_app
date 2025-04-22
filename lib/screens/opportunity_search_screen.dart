import 'package:flutter/material.dart';
import 'package:vollify_app/models/opportunity_model.dart'; // Add this import
import 'package:vollify_app/utils/constants.dart';

class OpportunitySearchScreen extends StatefulWidget {
  const OpportunitySearchScreen({super.key});

  @override
  State<OpportunitySearchScreen> createState() =>
      _OpportunitySearchScreenState();
}

class _OpportunitySearchScreenState extends State<OpportunitySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Opportunity> _opportunities = [];
  List<Opportunity> _filteredOpportunities = [];

  @override
  void initState() {
    super.initState();
    _loadOpportunities();
    _searchController.addListener(_filterOpportunities);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadOpportunities() {
    // Replace with your actual data loading
    setState(() {
      _opportunities = [
        Opportunity(
          title: 'Community Cleanup',
          orgName: 'Green Earth',
          location: 'Central Park',
          description: 'Help clean the park',
          skillsRequired: ['Teamwork', 'Physical'],
        ),
        Opportunity(
          title: 'Food Distribution',
          orgName: 'Food for All',
          location: 'Downtown Shelter',
          description: 'Help serve meals',
          skillsRequired: ['Communication'],
        ),
      ];
      _filteredOpportunities = List.from(_opportunities);
    });
  }

  void _filterOpportunities() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredOpportunities =
          _opportunities.where((opp) {
            return opp.title.toLowerCase().contains(query) ||
                opp.orgName.toLowerCase().contains(query) ||
                opp.location.toLowerCase().contains(query) ||
                opp.skillsRequired.any(
                  (skill) => skill.toLowerCase().contains(query),
                );
          }).toList();
    });
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
                return _OpportunityCard(opportunity: opportunity);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  final Opportunity opportunity;

  const _OpportunityCard({required this.opportunity});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              opportunity.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Organization: ${opportunity.orgName}'),
            Text('Location: ${opportunity.location}'),
            const SizedBox(height: 8),
            Text(opportunity.description),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children:
                  opportunity.skillsRequired.map((skill) {
                    return Chip(
                      label: Text(skill),
                      // ignore: deprecated_member_use
                      backgroundColor: AppColors.primaryLight.withOpacity(0.2),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _showDetails(context),
                  child: const Text(
                    'Details',
                    style: TextStyle(
                      color:
                          AppColors
                              .primaryDark, // Set text color to primaryDark
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _apply(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(
                      color: Colors.white,
                    ), // Set text color to white
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(opportunity.title),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Organization: ${opportunity.orgName}'),
                  Text('Location: ${opportunity.location}'),
                  const SizedBox(height: 16),
                  const Text(
                    'Description:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(opportunity.description),
                  const SizedBox(height: 16),
                  const Text(
                    'Required Skills:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        opportunity.skillsRequired
                            .map((skill) => Text('• $skill'))
                            .toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _apply(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Applied to ${opportunity.title}')));
  }
}
