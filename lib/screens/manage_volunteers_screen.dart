import 'package:flutter/material.dart';
import 'package:vollify_app/utils/constants.dart';

class ManageVolunteersScreen extends StatefulWidget {
  const ManageVolunteersScreen({super.key});

  @override
  State<ManageVolunteersScreen> createState() => _ManageVolunteersScreenState();
}

class _ManageVolunteersScreenState extends State<ManageVolunteersScreen> {
  final List<VolunteerApplication> _applications = [
    VolunteerApplication(
      name: 'John Doe',
      opportunity: 'Community Cleanup',
      status: ApplicationStatus.pending,
      skills: ['Teamwork', 'Physical ability'],
    ),
    // Add more applications...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Volunteers'),
        backgroundColor: AppColors.primaryDark,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _applications.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final application = _applications[index];
          return Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        application.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(application.status),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          application.status.name.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'For: ${application.opportunity}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children:
                        application.skills
                            .map(
                              (skill) => Chip(
                                label: Text(skill),
                                backgroundColor: AppColors.accent.withOpacity(
                                  0.2,
                                ),
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 12),
                  if (application.status == ApplicationStatus.pending)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed:
                                () => _updateApplication(
                                  context,
                                  index,
                                  ApplicationStatus.rejected,
                                ),
                            child: const Text('Reject'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                () => _updateApplication(
                                  context,
                                  index,
                                  ApplicationStatus.accepted,
                                ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            child: const Text('Accept'),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.accepted:
        return Colors.green;
      case ApplicationStatus.rejected:
        return Colors.red;
      case ApplicationStatus.pending:
        return Colors.orange;
    }
  }

  void _updateApplication(
    BuildContext context,
    int index,
    ApplicationStatus newStatus,
  ) {
    setState(() {
      _applications[index].status = newStatus;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Application ${newStatus.name} for ${_applications[index].name}',
        ),
      ),
    );
  }
}

// Data models
enum ApplicationStatus { pending, accepted, rejected }

class VolunteerApplication {
  final String name;
  final String opportunity;
  ApplicationStatus status;
  final List<String> skills;

  VolunteerApplication({
    required this.name,
    required this.opportunity,
    this.status = ApplicationStatus.pending,
    required this.skills,
  });
}
