class Garage {
  final String id;
  final String name;
  final String address;
  final double lat;
  final double lng;
  final double rating;
  final Map<String, double> services;
  final String imageUrl;
  final String bio;

  Garage({
    required this.lat,
    required this.lng,
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.services,
    required this.imageUrl,
    required this.bio,
  });

  factory Garage.fromJson(Map<String, dynamic> json) {
    return Garage(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      rating: json['rating'].toDouble() ?? 0,
      services: Map<String, double>.from(json['services']),
      imageUrl: json['imageUrl'],
      lat: json['latitude'],
      lng: json['longitude'],
      bio: json['bio']
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
      'latitude': lat,
      'longitude': lng,
      'bio': bio,
    };
  }

  Garage copyWith({
  String? id,
  String? name,
  String? address,
  double? rating,
  Map<String, double>? services,
  String? imageUrl,
  double? lat,
  double? lng,
  String? bio,
  }) {
    return Garage(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      rating: rating ?? this.rating,
      services: services ?? this.services,
      imageUrl: imageUrl ?? this.imageUrl,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      bio: bio?? this.bio,
    );
  }
}
