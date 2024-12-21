class Location {
  final int id;
  final String name;
  final List<double> coordinates;

  Location({required this.id, required this.name, required this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      coordinates: List<double>.from(json['locationPoint']['coordinates']),
    );
  }
}