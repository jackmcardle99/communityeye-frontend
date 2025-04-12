class User {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? mobileNumber;
  final String? city;
  final String? password;

  User({
    this.firstName,
    this.lastName,
    this.email,
    this.mobileNumber,
    this.city,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email_address'],
      mobileNumber: json['mobile_number'],
      city: json['city'],
      password: json['password']
          as String?, // nullable, since password shouldn't returned in API call
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

  User copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? mobileNumber,
    String? city,
    String? password
  }) {
    return User(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      city: city ?? this.city,
      password: password ?? this.password
    );
  }
}
