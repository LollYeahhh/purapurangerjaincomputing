enum UserRole { mekanik, pengawas }

class User {
  final String nipp;
  final String password;
  final UserRole role;
  final bool isFirstLogin;
  final String? token;
  final String? nama;
  final String? photoUrl; // ✅ Tambahkan properti photoUrl

  User({
    required this.nipp,
    required this.password,
    required this.role,
    required this.isFirstLogin,
    this.token,
    this.nama,
    this.photoUrl, // ✅ Tambahkan di constructor
  });

  User copyWith({
    String? nipp,
    String? password,
    UserRole? role,
    bool? isFirstLogin,
    String? token,
    String? nama,
    String? photoUrl, // ✅ Tambahkan di copyWith
  }) {
    return User(
      nipp: nipp ?? this.nipp,
      password: password ?? this.password,
      role: role ?? this.role,
      isFirstLogin: isFirstLogin ?? this.isFirstLogin,
      token: token ?? this.token,
      nama: nama ?? this.nama,
      photoUrl: photoUrl ?? this.photoUrl, // ✅ Tambahkan di copyWith
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nipp: json['nipp'] ?? '',
      password: '',
      role: json['role'] == 'pengawas' ? UserRole.pengawas : UserRole.mekanik,
      isFirstLogin: json['is_first_login'] ?? false,
      token: json['token'],
      nama: json['nama'],
      photoUrl: json['photo_url'], // ✅ Tambahkan parsing photoUrl
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nipp': nipp,
      'role': role == UserRole.pengawas ? 'pengawas' : 'mekanik',
      'is_first_login': isFirstLogin,
      'token': token,
      'nama': nama,
      'photo_url': photoUrl,
    };
  }
}
