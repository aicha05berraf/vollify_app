class Opportunity {
  final String title;
  final String orgName;
  final String location;
  final String description;
  final List<String> skillsRequired;

  Opportunity({
    required this.title,
    required this.orgName,
    required this.location,
    required this.description,
    required this.skillsRequired,
  });

  // Add this factory method for null safety
  factory Opportunity.empty() {
    return Opportunity(
      title: '',
      orgName: '',
      location: '',
      description: '',
      skillsRequired: [],
    );
  }
}
