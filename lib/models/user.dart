class AppUser {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? image;
  final String? phone;
  final String? gender;
  final String token;
  String? address;

  AppUser({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.image,
    this.phone,
    this.gender,
    required this.token,
    this.address,
  });

  String get fullName => '$firstName $lastName';

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      image: json['image'] as String?,
      phone: json['phone'] as String?,
      gender: json['gender'] as String?,
      token: json['accessToken'] as String? ??
          json['token'] as String? ??
          '',
      address: null,
    );
  }
}
