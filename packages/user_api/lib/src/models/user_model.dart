class Owner {
  final String id;
  final String name;
  final String imageUrl;
  final String bio;

  Owner({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.bio,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      bio: json['bio']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'bio': bio,
    };
  }

  Owner copyWith({
  String? id,
  String? name,
  String? imageUrl,
  String? bio,
  }) {
    return Owner(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      bio: bio?? this.bio,
    );
  }
}
