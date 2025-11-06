class UserData {
  final String? id;
  final String name;
  final int age;
  final double height;
  final double weight;
  final String gender;
  final String? profilePicture;

  UserData({
    this.id,
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    this.profilePicture,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'height': height,
      'weight': weight,
      'gender': gender,
      'profile_picture': profilePicture,
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'] ?? '',
      age: json['age'] ?? 25,
      height: json['height'] ?? 170.0,
      weight: json['weight'] ?? 70.0,
      gender: json['gender'] ?? 'Other',
      profilePicture: json['profile_picture'],
    );
  }

  UserData copyWith({
    String? id,
    String? name,
    int? age,
    double? height,
    double? weight,
    String? gender,
    String? profilePicture,
  }) {
    return UserData(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}
