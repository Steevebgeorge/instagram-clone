class UserModel {
  final String email;
  final String username;
  final String uid;

  UserModel({
    required this.email,
    required this.username,
    required this.uid,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        "uid": uid,
        "email": email,
      };
}
