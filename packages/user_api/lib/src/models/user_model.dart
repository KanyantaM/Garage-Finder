class Owner {
  final String id;
  final String name;
  final String imageUrl;
  final String email;
  // final Garage isGarageOwner;
  // final String bio;

  Owner({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.email,
    // required this.isGarageOwner,
    // required this.bio,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      email: json['email'],
      // isGarageOwner: json['isGarageOwner']
      // bio: json['bio']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'email' : email,
      // 'isGarageOwner': isGarageOwner
      // 'bio': bio,
    };
  }

  Owner copyWith({
  String? id,
  String? name,
  String? imageUrl,
  bool? isGarageOwner,
  String? email,
  // String? bio,
  }) {
    return Owner(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      email: email ?? this.email,
      // isGarageOwner: isGarageOwner ?? this.isGarageOwner,
      // bio: bio?? this.bio,
    );
  }
}
