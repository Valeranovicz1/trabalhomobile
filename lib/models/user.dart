class User {
  final String id;
  final String name;
  final String email;
  final String? imageUrl;
  final String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      imageUrl: json['imageUri'] ?? json['image_url'],
    );
  }
}
