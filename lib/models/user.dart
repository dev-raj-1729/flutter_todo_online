class User {
  String name;
  String email;
  String username;
  User({required this.name, required this.email, required this.username});
  User.fromMap(Map<String, dynamic> map)
      : this.name = map['name'],
        this.email = map['email'],
        this.username = map['username'];
}
