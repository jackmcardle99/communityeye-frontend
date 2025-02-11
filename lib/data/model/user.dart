class User {
  final String firstName;
  final String lastName;
  final String email;
  final String mobileNumber;
  final String city;
  final String password;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobileNumber,
    required this.city,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email_address'],
      mobileNumber: json['mobile_number'],
      city: json['city'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email_address': email,
      'mobile_number': mobileNumber,
      'city': city,
      'password': password,
    };
  }
}
