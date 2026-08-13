/// A locally registered user.
///
/// NOTE: the password is stored in plain text in SharedPreferences. This is
/// acceptable for an offline course demo only — a production app would hash
/// the password or delegate auth to a service such as Firebase Auth.
class AppUser {
  const AppUser({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    this.age,
  });

  final String name;
  final String email;
  final String phone;
  final String password;
  final int? age;

  String get initials {
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((String p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  AppUser copyWith({
    String? name,
    String? email,
    String? phone,
    String? password,
    int? age,
  }) {
    return AppUser(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      age: age ?? this.age,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'age': age,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String,
      age: json['age'] as int?,
    );
  }
}
