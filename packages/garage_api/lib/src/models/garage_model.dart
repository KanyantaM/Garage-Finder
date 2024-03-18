class Garage {
  final String id;
  final String name;
  final String address;
  final double rating;
  final List<String> services;
  final String imageUrl;

  Garage({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.services,
    required this.imageUrl,
  });

  factory Garage.fromJson(Map<String, dynamic> json) {
    return Garage(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      rating: json['rating'].toDouble(),
      services: List<String>.from(json['services']),
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'rating': rating,
      'services': services,
      'imageUrl': imageUrl,
    };
  }

  Garage copyWith({
  String? id,
  String? name,
  String? address,
  double? rating,
  List<String>? services,
  String? imageUrl,
  }) {
    return Garage(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      rating: rating ?? this.rating,
      services: services ?? this.services,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
