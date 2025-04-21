abstract class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? imageUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.imageUrl,
  });
}

class Volunteer extends User {
  final String lastName;
  final List<String> skills;
  final String experience;

  Volunteer({
    required String id,
    required String name,
    required this.lastName,
    required String email,
    required String phone,
    required this.skills,
    required this.experience,
    String? imageUrl,
  }) : super(
         id: id,
         name: name,
         email: email,
         phone: phone,
         imageUrl: imageUrl,
       );
}

class Organization extends User {
  final String location;
  final List<String> socialMedia;

  Organization({
    required String id,
    required String name,
    required String email,
    required String phone,
    required this.location,
    required this.socialMedia,
    String? imageUrl,
  }) : super(
         id: id,
         name: name,
         email: email,
         phone: phone,
         imageUrl: imageUrl,
       );
}
