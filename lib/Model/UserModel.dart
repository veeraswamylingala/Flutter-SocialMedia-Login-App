class UserModel {
  final String name;
  final String email;
  final String picture;

  UserModel({required this.name, required this.email, required this.picture});

  factory UserModel.fromJson(Map<String, dynamic> parsedJson) {
    return new UserModel(
        name: parsedJson['name'] ?? "",
        email: parsedJson['email'] ?? "",
        picture: parsedJson['picture'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "email": this.email,
      "picture": this.picture,
    };
  }
}
