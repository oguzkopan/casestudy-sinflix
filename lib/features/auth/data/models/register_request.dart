class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String birthDate;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.birthDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'birthDate': birthDate,
    };
  }
}